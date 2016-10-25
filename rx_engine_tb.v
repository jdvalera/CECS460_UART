`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:52:53 10/24/2016
// Design Name:   rx_engine
// Module Name:   C:/Users/John/Dropbox/CECS460/CECS460_proj3/proj3/rx_engine_tb.v
// Project Name:  proj3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: rx_engine
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module rx_engine_tb;

	// Inputs
	reg clk;
	reg rst;
	reg read_strobe;
	reg rx;
	reg eight;
	reg pen;
	reg clr;
	reg even;
	reg [3:0] baud;
	reg [15:0] port_id;

	// Outputs
	wire [7:0] data;
	wire [7:0] status;
	wire RXRDY;
	wire FERR;
	wire PERR;
	wire OVF;

	// Instantiate the Unit Under Test (UUT)
	rx_engine uut (
		.clk(clk), 
		.rst(rst), 
		.read_strobe(read_strobe), 
		.rx(rx), 
		.eight(eight), 
		.pen(pen), 
		.clr(clr), 
		.even(even), 
		.baud(baud), 
		.port_id(port_id), 
		.data(data), 
		.status(status), 
		.RXRDY(RXRDY), 
		.FERR(FERR), 
		.PERR(PERR), 
		.OVF(OVF)
	);
	
	always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 1;
		rst = 1;
		read_strobe = 0;
		rx = 0;
		eight = 0;
		pen = 0;
		clr = 0;
		even = 0;
		baud = 11;
		port_id = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
		#20;
		rx = 1;
		#20;
		rx = 0;
		#20;
		rx = 1;
		
        
		// Add stimulus here

	end
      
endmodule

