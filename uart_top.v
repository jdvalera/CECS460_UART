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
		input wire clk, reset, eight, pen, ohel, write_strobe, read_strobe,
		input wire [3:0]baud,
		input wire [7:0] out_port,
		input wire [15:0] port_id,
		output wire [7:0] data
    );
	 
	 //wire [15:0] port_id;
	 //wire [7:0] out_port, data;
	 //wire write_strobe, read_strobe;
	 reg [18:0] k;
	 wire load, clr, txrdy, rxrdy, ferr, perr, ovr, tx;
	 
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
		
		
//		module tx_engine(
//		input wire clk, reset, eight, pen, ohel, load,
//		input wire [18:0] k,
//		input wire [7:0] out_port,
//		output reg tx, txrdy
//    );

		tx_engine tx_engine(.clk(clk), .reset(reset), .eight(eight), .pen(pen),
								  .ohel(ohel), .load(load), .k(k), .out_port(out_port),
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


endmodule
