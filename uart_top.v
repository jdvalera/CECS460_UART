`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: CECS 460                                               //
//  Project name: UART		                                       //
//  File name: uart_top.v                                         //
//                                                                //
//  Created by John Valera on 10/17/16 based on John Tramel's     //
//  design.                                                       //
//  Copyright © 2016 John Valera. All rights reserved.            //
//                                                                //
//  Abstract: UART module that receives message and echos it back.//
//                                                                //
//  Edit history: 10/31/16                                        //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else.                                               //
//                                                                //
//  In the event other code sources are utilized I will           //
//  document which portion of code and who is the author          //
//                                                                //
// In submitting this code I acknowledge that plagiarism          //
// in student project work is subject to dismissal from the class //
//****************************************************************//
module uart_top(
		input wire clk, reset, rx, eight, pen, ohel,
		input wire [3:0]baud,
		output wire tx,
		output wire [7:0] LEDS
    );
	 
	 wire [15:0] port_id, out_port;
	 reg [15:0] in_port;
	 wire [7:0] data, status, rx_status;
	 wire write_strobe, read_strobe;
	 reg [18:0] k;
	 wire load, clr, txrdy, rxrdy, ferr, perr, ovf;
	 wire int_ack, uart_int, data_stat_sel, int_pulse;
	 reg interrupt, dff1, dff2, dff3, dff4, dff5, dff6, dff7, dff8;
	 wire rxrdy_pulse, txrdy_pulse, rst_sync;

	 
	 //==================================================================
	 // Baud rate
	 //==================================================================
		always @*
			begin
				case (baud)
					0: k = 333_333;
					1: k = 83_333;
					2: k = 41_667;
					3: k = 20_833;
					4: k = 10_417;
					5: k = 5_208;
					6: k = 2_604;
					7: k = 1_736;
					8: k = 868;
					9: k = 434;
					10: k = 217;
					11: k = 109;
					default: k = 10_417;
				endcase
			end
		
		//==================================================================
		// load
		//==================================================================
		assign load = (port_id == 0) & write_strobe;
		
		//==================================================================
		// clr
		//==================================================================
		assign clr = (port_id == 0) & read_strobe;
		
		//==================================================================
		// status
		//==================================================================
		assign rx_status = {3'b0, ovf, ferr, perr, txrdy, rxrdy};
		assign status = rx_status;
		
		//==================================================================
		// DATA_STATUS_SELECT
		//==================================================================
		
		assign data_stat_sel = (port_id == 16'h0001) ? 1 : 0;
		
		always @*
			begin
				if(data_stat_sel)
					in_port = {8'b0, status};
				else
					in_port = {8'b0, data};
			end
		

		tx_engine tx_engine(.clk(clk), .reset(rst_sync), .eight(eight), .pen(pen),
								  .ohel(ohel), .load(load), .k(k), .out_port(out_port[7:0]),
								  .tx(tx), .txrdy(txrdy));
								  
		
		rx_engine rx_engine(.clk(clk), .rst(rst_sync), .rx(rx), .eight(eight), .pen(pen),
								  .clr(clr), .even(~ohel), .k(k), .data(data), .RXRDY(rxrdy),
								  .FERR(ferr), .PERR(perr), .OVF(ovf));
								  
		//==================================================================
		// AISO
		//==================================================================
			always @(posedge clk, posedge reset)
				begin
					if(reset)
						begin
							dff7 <= 0;
							dff8 <= 0;
						end
					else
						begin
							dff7 <= 1'b1;
							dff8 <= dff7;
						end
				end
				
			assign rst_sync = ~dff8;

		
		//==================================================================
		// INTERRUPT
		// If txrdy or rxrdy is 1
		// Use pulse edge detector to create interrupt pulse
		// Feed interrupt pulse into SR Flop
		//==================================================================
		assign rxrdy_pulse = dff3 & ~dff4;
		assign txrdy_pulse = dff5 & ~dff6;
		assign uart_int = txrdy_pulse | rxrdy_pulse;
		
		always @(posedge clk, posedge rst_sync)
			begin
				if(rst_sync)
					begin
						dff1 <= 0;
						dff2 <= 0;
						dff3 <= 0;
						dff4 <= 0;
						dff5 <= 0;
						dff6 <= 0;
					end
				else
					begin
						dff1 <= uart_int;
						dff2 <= dff1;
						dff3 <= rxrdy;
						dff4 <= dff3;
						dff5 <= txrdy;
						dff6 <= dff5;
					end
			end


		assign int_pulse = dff1 & ~dff2;
	 
		always @*
				begin
					if(rst_sync)
						interrupt <= 0; else
					if(int_pulse)
						interrupt <= 1; else
					if(int_ack)
						interrupt <= 0;
					else
						interrupt <= interrupt;
				end

		tramelblaze_top	tramelblaze_top(.CLK(clk), .RESET(rst_sync), .IN_PORT(in_port),
													 .INTERRUPT(interrupt), .OUT_PORT(out_port),
													 .PORT_ID(port_id), .READ_STROBE(read_strobe),
													 .WRITE_STROBE(write_strobe), .INTERRUPT_ACK(int_ack));
													 
		assign LEDS = out_port[7:0];

endmodule
