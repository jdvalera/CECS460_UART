`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: CECS 460                                               //
//  Project name: UART                                            //
//  File name: uart_sim_tb.v                                      //
//                                                                //
//  Created by John Valera on 11/06/16                            //
//  Copyright © 2016 John Valera. All rights reserved.            //
//                                                                //
//  Abstract: Top level testbench simulation of UART engine.      //
//                                                                //
//  Edit history: 11/07/16                                        //
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

module uart_sim_tb;

	// Inputs
	reg clk;
	reg reset;
	reg eight;
	reg pen;
	reg ohel;
	reg load;
	reg clr;
	reg [7:0] out_port;
	reg [18:0] k;

	// Outputs
	wire rxrdy;
	wire ferr;
	wire perr;
	wire ovf;
	wire tx;
	wire txrdy;
	wire [7:0] data;

	// Instantiate the Unit Under Test (UUT)
	uart_sim uut (
		.clk(clk), 
		.reset(reset), 
		.eight(eight), 
		.pen(pen), 
		.ohel(ohel), 
		.load(load), 
		.clr(clr), 
		.out_port(out_port), 
		.k(k), 
		.rxrdy(rxrdy), 
		.ferr(ferr), 
		.perr(perr), 
		.ovf(ovf), 
		.tx(tx), 
		.txrdy(txrdy), 
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
		load = 0;
		clr = 0;
		out_port = 8'hAA;
		k = 109;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
		#20 load=1;
		#20 load=0;
        
		// Add stimulus here

	end
      
endmodule

