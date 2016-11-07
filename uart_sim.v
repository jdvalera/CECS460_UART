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
//  Abstract: Top level of UART engine used for simulating.       //
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
module uart_sim(
			input wire clk, reset, eight, pen, ohel, load, clr,
			input wire [7:0] out_port,
			input wire [18:0] k,
			output wire rxrdy, ferr, perr, ovf, tx, txrdy,
			output wire [7:0] data
    );

	 
	 tx_engine tx_engine(.clk(clk), .reset(reset), .eight(eight), .pen(pen),
								  .ohel(ohel), .load(load), .k(k), .out_port(out_port[7:0]),
								  .tx(tx), .txrdy(txrdy));
								  
		
	rx_engine rx_engine(.clk(clk), .rst(reset), .rx(tx), .eight(eight), .pen(pen),
								  .clr(clr), .even(~ohel), .k(k), .data(data), .RXRDY(rxrdy),
								  .FERR(ferr), .PERR(perr), .OVF(ovf));


endmodule
