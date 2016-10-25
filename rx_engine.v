`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:07 10/17/2016 
// Design Name: 
// Module Name:    rx_engine 
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
module rx_engine(
		input wire clk, rst, rx, eight, pen, clr, even,
		input wire [18:0] k,
		output wire [7:0] data,
		output reg RXRDY, FERR, PERR, OVF
    );
	 
	 reg [1:0] state_reg, next_state;
	 reg start, doit;
	 wire btu, sh, done;
	 reg [3:0] bc, bit_count, num_bits;
	 reg [18:0] bt, btc, bit_time;
	 reg [9:0] shq, d;
	 reg p_gen_sel, p_bit_sel, gen_p, rec_p, parity;
	 reg stop_bit_sel, stop_b;
	 wire overflow;
	 
	 //==================================================================
	 // State machine
	 //==================================================================
	 always @(posedge clk, posedge rst)
		begin
			if(rst)
				state_reg <= 0;
			else
				state_reg <= next_state;
		end
		
	 always @*
		begin
			case (state_reg)
			0:
			begin
				start = 0;
				doit = 0;
				if(~rx)
					next_state = 1;
				else
					next_state = 0;
			end
			1:
			begin
				start = 1;
				doit = 1;
				if(rx)
					next_state = 1; else
				if(~rx && btu)
					next_state = 1; else
				if(~rx && ~btu)
					next_state = 2;
				else
					next_state = 1;
			end
			2:
			begin
				start = 0;
				doit = 1;
				if(~done)
					next_state = 2;
				else
					next_state = 0;
			end
			default:
			begin
				next_state = 0;
				start = 0;
				doit = 0;
			end
			endcase
		end
		
		//==================================================================
		// DONE
		//==================================================================
		
		always @*
			begin
				case ({eight, pen})
				0: num_bits = 8;
				1: num_bits = 9;
				2: num_bits = 9;
				3: num_bits = 10;
				default: num_bits = 8;
				endcase
			end
			
		always @(posedge clk, posedge rst)
			begin
				if(rst)
					bit_count <= 0;
				else
					bit_count <= bc;
			end
			
		always @*
			begin
				case ({doit, btu})
				0: bc = 0;
				1: bc = 0;
				2: bc = bit_count;
				3: bc = bit_count+1;
				endcase
			end
			
		assign done = (bit_count == num_bits);
		
		//==================================================================
		// BTU
		//==================================================================
			
			always @*
				begin
					if(start)
						bit_time = k>>1;
					else
						bit_time = k;
				end
		
		always @(posedge clk, posedge rst)
			begin
				if(rst)
					btc <= 0;
				else
					btc <= bt;
			end
			
		always @*
			begin
				case ({doit, btu})
				0: bt = 0;
				1: bt = 0;
				2: bt = btc + 1;
				3: bt = 0;
				endcase
			end
			
		assign btu = (btc == bit_time);
		
		assign sh = btu & ~start;
		
		//==================================================================
		// shift register
		//==================================================================
		
		always @(posedge clk, posedge rst)
			begin
				if(rst)
					shq <= 10'b0; else
				if(sh)
					shq <= {rx, shq[9:1]};
			end
		

			
		always @*
			begin
				case ({eight, pen})
				0:
				begin
				d = shq >> 2;
				d[7] = 1'b1; // stop bit
				end
				1: d = shq >> 1;
				2: d = shq >> 1;
				3: d = shq;
				endcase
			end
		
		//==================================================================
		// RXRDY
		//==================================================================
		
		always @(posedge clk, posedge rst)
			begin
				if(rst)
					RXRDY = 0; else
				if(done)
					RXRDY = 1; else
				if(clr)
					RXRDY = 0;
			end
		
		//==================================================================
		// PERR
		//==================================================================
		
		always @*
			begin
				if(eight)
					begin
						p_gen_sel = ^shq[7:0];
						rec_p = shq[8];
					end
				else
					begin
						p_gen_sel = ^shq[6:0];
						rec_p = shq[7];
					end
					
				
				if(even)
					gen_p = p_gen_sel;
				else
					gen_p = ~p_gen_sel;
					
				parity = (gen_p ^ rec_p) & done & pen;
			end
			
		always @(posedge clk, posedge rst)
			begin
				if(rst)
					PERR <= 0; else
				if(parity)
					PERR <= 1; else
				if(clr)
					PERR <= 0;
			end
		
		//==================================================================
		// FERR
		//==================================================================
		
		always @*
			begin
				case ({eight, pen})
				0: stop_bit_sel = shq[7];
				1: stop_bit_sel = shq[8];
				2: stop_bit_sel = shq[8];
				3: stop_bit_sel = shq[9];
				endcase
				
				stop_b = done & stop_bit_sel;
			end
			
		always @(posedge clk, posedge rst)
			begin
				if(rst)
					FERR <= 0; else
				if(stop_b)
					FERR <= 1; else
				if(clr)
					FERR <= 0;
			end
			
		assign overflow = RXRDY & done;
		//==================================================================
		// OVF
		//==================================================================
		
		always @(posedge clk, posedge rst)
			begin
				if(rst)
					OVF <= 0; else
				if(overflow)
					OVF <= 1; else
				if(clr)
					OVF <= 0;
			end
			
		//==================================================================
		// Output
		//==================================================================
		
//		assign status[4] = OVF;
//		assign status[3] = FERR;
//		assign status[2] = PERR;
//		assign status[0] = RXRDY;
		
		assign data = d[7:0];
		
		

endmodule
