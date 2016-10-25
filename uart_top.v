`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:51:30 10/24/2016 
// Design Name: 
// Module Name:    uart_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module uart_top(
		input wire clk, reset, rx, eight, pen, ohel,
		input wire [3:0]baud,
		output wire tx
    );
	 
	 wire [15:0] port_id, out_port;
	 reg [15:0] in_port;
	 wire [7:0] data;
	 wire write_strobe, read_strobe;
	 reg [18:0] k;
	 wire load, clr, txrdy, rxrdy, ferr, perr, ovf;
	 wire int_ack, uart_int, data_stat_sel, int_pulse, dff1, dff2;
	 reg interrupt;
	 
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
		// DATA_STATUS_SELECT
		//==================================================================
		
		assign data_stat_sel = (port_id == 16'h0001) ? 1 : 0;
		
		always @*
			begin
				if(data_stat_sel)
					in_port = {11'b0, ovf, ferr, perr, txrdy, rxrdy};
				else
					in_port = {8'b0, data};
			end
		
		
//		module tx_engine(
//		input wire clk, reset, eight, pen, ohel, load,
//		input wire [18:0] k,
//		input wire [7:0] out_port,
//		output reg tx, txrdy
//    );

		tx_engine tx_engine(.clk(clk), .reset(reset), .eight(eight), .pen(pen),
								  .ohel(ohel), .load(load), .k(k), .out_port(out_port[7:0]),
								  .tx(tx), .txrdy(txrdy));

//module rx_engine(
//		input wire clk, rst, rx, eight, pen, clr, even,
//		input wire [18:0] k,
//		output wire [7:0] data,
//		output reg RXRDY, FERR, PERR, OVF
//    );
		
		rx_engine rx_engine(.clk(clk), .rst(reset), .rx(rx), .eight(eight), .pen(pen),
								  .clr(clr), .even(~ohel), .k(k), .data(data), .RXRDY(rxrdy),
								  .FERR(ferr), .PERR(perr), .OVF(ovf));

//input         CLK;
//input         RESET;
//input  [15:0] IN_PORT;
//input         INTERRUPT;
//
//output [15:0] OUT_PORT;
//output [15:0] PORT_ID;
//output        READ_STROBE;
//output        WRITE_STROBE;
//output        INTERRUPT_ACK;
//output        MEMHIOL;

//module tramelblaze_top (CLK, RESET, IN_PORT, INTERRUPT, 
//                        OUT_PORT, PORT_ID, READ_STROBE, WRITE_STROBE, INTERRUPT_ACK);
		
		//==================================================================
		// INTERRUPT
		// If txrdy or rxrdy is 1
		// Use pulse edge detector to create interrupt pulse
		// Feed interrupt pulse into SR Flop
		//==================================================================
		assign uart_int = txrdy | txrdy;
		
		always @(posedge clk, posedge reset)
			begin
				if(reset)
					begin
						dff1 <= 0;
						dff2 <= 0;
					end
				else
					begin
						dff1 <= uart_int;
						dff2 <= dff1;
					end
			end

		assign int_pulse = dff1 & ~dff2;
	 
		always @*
				begin
					if(reset)
						interrupt <= 0; else
					if(int_pulse)
						interrupt <= 1; else
					if(int_ack)
						interrupt <= 0;
				end

		tramelblaze_top	tramelblaze_top(.CLK(clk), .RESET(reset), .IN_PORT(in_port), .INTERRUPT(interrupt),
													 .OUT_PORT(out_port), .PORT_ID(port_id), .READ_STROBE(read_strobe),
													 .WRITE_STROBE(write_strobe), .INTERRUPT_ACK(int_ack));

endmodule
