`timescale 1ns / 1ps
//****************************************************************//
//  This document contains information proprietary to the         //
//  CSULB student that created the file - any reuse without       //
//  adequate approval and documentation is prohibited             //
//                                                                //
//  Class: CECS 460                                               //
//  Project name: PROJECT 2                                       //
//  File name: tx_engine.v                                        //
//                                                                //
//  Created by John Valera on 09/27/16 based on John Tramel's     //
//  design.                                                       //
//  Copyright © 2016 John Valera. All rights reserved.            //
//                                                                //
//  Abstract: Send out characters from tramelblaze serially.      //
//                                                                //
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
module tx_engine(
		input wire clk, reset, eight, pen, ohel, load,
		input wire [18:0] k,
		input wire [7:0] out_port,
		output reg tx, txrdy
    );
	 
	 wire [10:0] q_11b;
	 wire ep, op, btu, done;
	 reg  doit, load_d1, sdo;
	 reg [7:0] q;
	 reg [1:0] b10_b9;
	 reg [3:0] bit_count, bc;
	 reg [10:0] shq;
	 reg [18:0] bit_time_count, btc;
	 
	 //==================================================================
	 // txrdy
	 //==================================================================
	 always @(posedge clk, posedge reset)
		 begin
			if(reset)
				txrdy <= 1; else
			if(done==1 && load==1)
				txrdy <= txrdy; else
			if(done)
				txrdy <= 1; else
			if(load)
				txrdy <= 0;
			else
				txrdy <= txrdy;
		 end
		 
	//==================================================================
	// doit
	//==================================================================
	always @(posedge clk, posedge reset)
		begin
			if(reset)
				load_d1 <= 0;
			else
				load_d1 <= load;
		end
	 
	always @(posedge clk, posedge reset)
		 begin
			if(reset)
				doit <= 0; else
			if(done==1 && load_d1==1)
				doit <= doit; else
			if(done)
				doit <= 0; else
			if(load_d1)
				doit <= 1;
			else
				doit <= doit;
		 end
	
	//==================================================================
	// load register
	//==================================================================
	always @(posedge clk, posedge reset)
		begin
			if(reset)
				q <= 0;
			else
				q <= out_port;
		end
	
	//==================================================================
	// bit/parity decoder
	//==================================================================
	assign ep = ^q;
	assign op = ~^q;
	 
	always @*
	 begin
		case ({eight,pen,ohel})
			0: b10_b9 = 2'b11;
			1: b10_b9 = 2'b11;
			2: b10_b9 = {1'b1, ep};
			3: b10_b9 = {1'b1, op};
			4: b10_b9 = {1'b1, q[7]};
			5: b10_b9 = {1'b1, q[7]};
			6: b10_b9 = {ep, q[7]};
			7: b10_b9 = {op, q[7]};
			default b10_b9 = 2'b00;
		endcase
	 end
	 
	 assign q_11b = {b10_b9, q[6:0], 1'b0, 1'b1};
	 
	//==================================================================
	// shift register
	//==================================================================
	always @(posedge clk, posedge reset)
	 begin
		if(reset)
			shq <= 11'b1; else
		if(load_d1)
			shq <= q_11b; else
		if(btu)
			shq <= {1'b1, shq[10:1]};
	 end
	 
	 //assign sdo = shq[0];
	 
	//==================================================================
	//Bit time counter
	//==================================================================
	always @*
		begin
			case ({doit,btu})
				0: btc = 0;
				1: btc = 0;
				2: btc = bit_time_count + 1;
				3: btc = 0;
			endcase
		end
		
	always @(posedge clk, posedge reset)
		begin
			if(reset)
				bit_time_count <= 0;
			else
				bit_time_count <= btc;
		end
		
	assign btu = (bit_time_count == k);
	
	//==================================================================
	//Bit Count
	//==================================================================
	always @*
		begin
			case ({doit,btu})
				0: bc = 0;
				1: bc = 0;
				2: bc = bit_count;
				3: bc = bit_count + 1;
			endcase
		end
		
	always @(posedge clk, posedge reset)
		begin
			if(reset)
				bit_count <= 0;
			else
				bit_count <= bc;
		end
	
	assign done = (bit_count == 11);
	
	
	always @*
	begin
		sdo = shq[0];
		tx = sdo;
	end
	

endmodule
