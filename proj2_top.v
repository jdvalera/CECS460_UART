`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: CECS 460                                               //
//  Project name: PROJECT 2                                       //
//  File name: proj2_tob.v                                        //
//                                                                //
//  Created by John Valera on 09/27/16.                           //
//  Copyright © 2016 John Valera. All rights reserved.            //
//                                                                //
//  Abstract: Transmit engine connected with the tramelblaze,     //
//				  AISO and interrupt controller.								//
//  Edit history: 10/11/16                                        //
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
module proj2_top(
		input clk, reset, eight, pen, ohel,
		input [3:0] baud,
		output wire tx,
		output wire [7:0] outport
    );
	 
	 wire rst_sync, interrupt, int_ack, txrdy, pulse;
	 wire read_strobe, write_strobe;
	 wire [15:0] out_port, port_id, in_port;
	 
	 AISO AISO(.clk(clk), .reset(reset), .rst_sync(rst_sync));
	 tramelblaze_top tblz_top(.CLK(clk), .RESET(rst_sync), .IN_PORT(in_port),
										.INTERRUPT(interrupt), .OUT_PORT(out_port),
										.PORT_ID(port_id), .READ_STROBE(read_strobe),
										.WRITE_STROBE(write_strobe), .INTERRUPT_ACK(int_ack));
	 tx_engine tx_engine(.clk(clk), .reset(rst_sync), .write_strobe(write_strobe),
								.eight(eight), .pen(pen), .ohel(ohel),.baud(baud), 
								.port_id(port_id), .out_port(out_port[7:0]),
								.tx(tx), .txrdy(txrdy));
	 pulse_maker pulse_maker(.clk(clk), .reset(rst_sync), .sig(txrdy), .pulse(pulse));
	 SRFF SRFF(.clk(clk), .reset(rst_sync), .s(pulse), .r(int_ack), .q(interrupt));
	 
	 assign outport = out_port[7:0];


endmodule
