`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:24:49 10/25/2016
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
	reg eight;
	reg pen;
	reg ohel;
	reg write_strobe;
	reg read_strobe;
	reg [3:0] baud;
	reg [7:0] out_port;
	reg [15:0] port_id;

	// Outputs
	wire [7:0] data;

	// Instantiate the Unit Under Test (UUT)
	uart_top uut (
		.clk(clk), 
		.reset(reset), 
		.eight(eight), 
		.pen(pen), 
		.ohel(ohel), 
		.write_strobe(write_strobe), 
		.read_strobe(read_strobe), 
		.baud(baud), 
		.out_port(out_port), 
		.port_id(port_id), 
		.data(data)
	);
	
	always #10 clk=~clk;

	initial begin
		// Initialize Inputs
		clk = 1;
		reset = 1;
		eight = 0;
		pen = 0;
		ohel = 0;
		write_strobe = 0;
		read_strobe = 0;
		baud = 11;
		out_port = 8'hAA;
		port_id = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
		#20;
		write_strobe = 1;
		#20;
		write_strobe = 0;
		#200;
        
		// Add stimulus here

	end
      
endmodule

