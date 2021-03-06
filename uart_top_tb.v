`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:31:13 10/25/2016
// Design Name:   uart_top
// Module Name:   E:/Users/John/Desktop/Dropbox/CECS460/CECS460_proj3/proj3/uart_top_tb.v
// Project Name:  proj3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module uart_top_tb;

	// Inputs
	reg clk;
	reg reset;
	reg rx;
	reg eight;
	reg pen;
	reg ohel;
	reg [3:0] baud;

	// Outputs
	wire tx;
	wire [7:0] LEDS;

	// Instantiate the Unit Under Test (UUT)
	uart_top uut (
		.clk(clk), 
		.reset(reset), 
		.rx(rx), 
		.eight(eight), 
		.pen(pen), 
		.ohel(ohel), 
		.baud(baud), 
		.tx(tx),
		.LEDS(LEDS)
	);

	always #10 clk=~clk;

	initial begin
		// Initialize Inputs
		clk = 1;
		reset = 1;
		rx = 0;
		eight = 0;
		pen = 0;
		ohel = 0;
		baud = 11;

		// Wait 100 ns for global reset to finish
		#1000;
		reset = 0;
        
		// Add stimulus here

	end
      
endmodule

