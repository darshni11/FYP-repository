`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:15:46 04/02/2018 
// Design Name: 
// Module Name:    ksablockingv1 
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
module ksablockingv1(
    input clock,
    input write_en,
    input reset,
    input [31:0] fp_input,
	 output [31:0] y,
	 output [31:0] t,
	 output [31:0] c,
	 output av1, 
	 output av2,
	 output av3,
	 output av4,
	 output bv1,
	 output bv2,
	 output bv3,
	 output bv4,
	 output ar1,
	 output ar2,
	 output ar3,
	 output ar4,
	 output br1,
	 output br2,
	 output br3,
	 output br4,
	 output rv1,
	 output rv2,
	 output rv3,
	 output rv4,
	 output rr1,
	 output rr2, 
	 output rr3,
	 output rr4,
	 output [31:0] intc,
	 output [31:0] intt,
	 output [31:0] inty,
	 output [4:0] state,
    output [31:0] sum
    );




	 
	reg [31:0] memory [1:0];
   integer i = 0;
	
	
   always @(posedge clock) // assuming that the input is sent synchronously to the clock
	begin
		if(reset)
		begin
			for(i = 0; i<2;i = i+1)
				memory[i] <= 0;
			i = 0;
		end
		
		else if(write_en)
		begin
		 memory[0] <= 32'b00111101110011001100110011001101; //0.1
		 memory[1] <= 32'b00111101111000010100011110101110; //0.11
		end
		//else if((i<1)&& write_en)
		//begin
		//	memory [i] <= fp_input;
		//	i = i +1;
		//end
	end
	
//----------------------------------writing the input floating point numbers to the internal memory-------------------------------------------
	
	reg [31:0]c_in = 0, t_in = 0, y_in = 0, x_in = 0 ,temp_sum = 0;
	wire [31:0] c_out, t_out, y_out, x_out;
	reg j = 0; // or integer
	wire s1_avalid, s1_aready, s1_bvalid, s1_bready, s1_resultvalid, s1_resultready;
	wire a1_avalid, a1_aready, a1_bvalid, a1_bready, a1_resultvalid, a1_resultready;
	wire s2_avalid, s2_aready, s2_bvalid, s2_bready, s2_resultvalid, s2_resultready;
	wire s3_avalid, s3_aready, s3_bvalid, s3_bready, s3_resultvalid, s3_resultready;
   reg [4:0]x = 0;


//-----------------------------------------------------instantiations-----------------------------------------------------------------------
		fpsub32BLOCKING sub1 
		 (
			.aclk(clock),
			.s_axis_a_tvalid(s1_avalid),.s_axis_a_tready(s1_aready),.s_axis_a_tdata(memory[j]),
			.s_axis_b_tvalid(s1_bvalid),.s_axis_b_tready(s1_bready),.s_axis_b_tdata(c_in), 
			.m_axis_result_tvalid(s1_resultvalid),.m_axis_result_tready(s1_resultready),.m_axis_result_tdata(y_out)
		 );
		 
		 fpadd32BLOCKING add
		 (
			.aclk(clock),
			.s_axis_a_tvalid(a1_avalid),.s_axis_a_tready(a1_aready),.s_axis_a_tdata(temp_sum), 
			.s_axis_b_tvalid(a1_bvalid),.s_axis_b_tready(a1_bready),.s_axis_b_tdata(y_in), 
			.m_axis_result_tvalid(a1_resultvalid),.m_axis_result_tready(a1_resultready),.m_axis_result_tdata(t_out)
		 );

		fpsub32BLOCKING sub2
		 (
			.aclk(clock),
			.s_axis_a_tvalid(s2_avalid),.s_axis_a_tready(s2_aready),.s_axis_a_tdata(t_in), 
			.s_axis_b_tvalid(s2_bvalid),.s_axis_b_tready(s2_bready),.s_axis_b_tdata(temp_sum), 
			.m_axis_result_tvalid(s2_resultvalid),.m_axis_result_tready(s2_resultready),.m_axis_result_tdata(x_out)
		 );

		fpsub32BLOCKING sub3
		 (
			.aclk(clock),
			.s_axis_a_tvalid(s3_avalid),.s_axis_a_tready(s3_aready),.s_axis_a_tdata(x_in), 
			.s_axis_b_tvalid(s3_bvalid),.s_axis_b_tready(s3_bready),.s_axis_b_tdata(y_out), 
			.m_axis_result_tvalid(s3_resultvalid),.m_axis_result_tready(s3_resultready),.m_axis_result_tdata(c_out)
		 );
		
//-----------------------------------------------------------------------------------------------------------------------------------------
	
//	for(j = 0; j<32;j=j+1)
//	begin
//		if(!write_en)
//		begin
//		assign s1_avalid = 1; 
//		assign s1_bvalid = 1; 
//		assign s1_resultready =1; 
//		if(s1_resultvalid == 1)
//		begin
//			assign a1_avalid = 1; 
//		   assign a1_bvalid = 1; 
//		   assign a1_resultready =1; 
//		   if(a1_resultvalid == 1)
//			begin
//				assign s2_avalid = 1; 
//				assign s2_bvalid = 1; 
//				assign s2_resultready =1; 
//				if(s2_resultvalid == 1)
//				begin
//					assign s3_avalid = 1; 
//					assign s3_bvalid = 1; 
//					assign s3_resultready =1; 
//					if(s3_resultvalid == 1)
//					begin
//						assign t = tempsum;
//					end
//				end
//			end
//		end
//		end
//		
//	end
	
	assign s1_avalid = (!write_en & (x == 0))? 1'b1: 1'b0;
	assign s1_bvalid = (!write_en & (x == 0))? 1'b1: 1'b0;
	assign s1_resultready = s1_aready && s2_bready;
	
	assign a1_avalid = (!write_en & (x == 1))? 1'b1: 1'b0;
	assign a1_bvalid = (!write_en & (x == 1))? 1'b1: 1'b0;
	assign a1_resultready = (!write_en & (x == 1))? 1'b1: 1'b0;
	
	assign s2_avalid = (!write_en & (x == 2))? 1'b1: 1'b0;
	assign s2_bvalid = (!write_en & (x == 2))? 1'b1: 1'b0;
	assign s2_resultready = (!write_en & (x == 2))? 1'b1: 1'b0;
	
	assign s3_avalid = (!write_en & (x == 3))? 1'b1: 1'b0;
	assign s3_bvalid = (!write_en & (x == 3))? 1'b1: 1'b0;
	assign s3_resultready = (!write_en & (x == 3))? 1'b1: 1'b0;
	

	
	always @ (posedge clock)
	begin
		if(!write_en && j<2)
		begin
			case(x)
			0: begin	
				if(s1_resultvalid == 1'b1)
					begin
					y_in = y_out;
					x = 1;
					end
				end
			1: begin
				if(a1_resultvalid == 1'b1)
					begin
					t_in = t_out;
					x = 2;
					end
				end
			2: begin
				if(s2_resultvalid == 1'b1)
					begin
					x_in = x_out;
					x = 3;
					end
				end
			3: begin
				if(s3_resultvalid == 1'b1)
					begin
					c_in = c_out;
					x = 4;
					end
				end
			4: begin
				temp_sum = t_in;
			   j = j +1;
				x = 0;
				end
			default : x = 0;
			endcase
		 end
	   end
		

      assign sum = temp_sum;
		assign intt = t_in;
		assign intc = c_in;
		assign inty = y_in;
		assign y = y_out;
		assign t = t_out;
		assign state = x;
		assign c = c_out;
		 
		assign av1 = s1_avalid;
		assign av2 = a1_avalid;
		assign av3 = s2_avalid;
		assign av4 = s3_avalid;
		
		assign bv1 = s1_bvalid;
		assign bv2 = a1_bvalid;
		assign bv3 = s2_bvalid;
		assign bv4 = s3_bvalid;
		
		assign ar1 = s1_aready;
		assign ar2 = a1_aready;
		assign ar3 = s2_aready;
		assign ar4 = s3_aready;
		
		assign br1 = s1_bready;
		assign br2 = a1_bready;
		assign br3 = s2_bready;
		assign br4 = s3_bready;
		
		assign rv1 = s1_resultvalid;
		assign rv2 = a1_resultvalid;
		assign rv3 = s2_resultvalid;
		assign rv4 = s3_resultvalid;
		
		assign rr1 = s1_resultready;
		assign rr2 = a1_resultready;
		assign rr3 = s2_resultready;
		assign rr4 = s3_resultready;
		
endmodule
