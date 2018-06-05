`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:16:48 05/24/2018
// Design Name:   ksablockingv1
// Module Name:   E:/ksablocking/blocking_tb.v
// Project Name:  ksablocking
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ksablockingv1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module blocking_tb;

	// Inputs
	reg clock;
	reg write_en;
	reg reset;
	reg [31:0] fp_input;

	// Outputs
	wire [31:0] intc;
	wire [31:0] intt;
	wire [31:0] inty;
	
	wire av1; 
	wire av2;
	wire av3;
   wire av4;
	wire bv1; 
	wire bv2;
	wire bv3;
   wire bv4;
	wire ar1;
	wire ar2;
	wire ar3;
	wire ar4;
	wire br1; 
	wire br2;
	wire br3;
   wire br4;
	wire rv1;
   wire rv2;
   wire rv3;
   wire rv4;
   wire rr1;
   wire rr2; 
   wire rr3;
	wire rr4;
	
	wire [31:0] sum;
	wire [31:0] y;
	wire [31:0] c;
   wire [31:0] t;
	wire [4:0] state;

	// Instantiate the Unit Under Test (UUT)
	ksablockingv1 uut (
		.clock(clock), 
		.write_en(write_en), 
		.reset(reset), 
		.fp_input(fp_input), 
		.intc(intc),
		.intt(intt),
		.inty(inty),
		.av1(av1),
		.av2(av2),
		.av3(av3),
		.av4(av4),
		.bv1(bv1),
		.bv2(bv2),
		.bv3(bv3),
		.bv4(bv4),
		.ar1(ar1),
		.ar2(ar2),
		.ar3(ar3),
		.ar4(ar4),
		.br1(br1),
		.br2(br2),
		.br3(br3),
		.br4(br4),
		.rv1(rv1),
		.rv2(rv2),
		.rv3(rv3),
		.rv4(rv4),
		.rr1(rr1),
		.rr2(rr2),
		.rr3(rr3),
		.rr4(rr4),
      .y(y), 
		.t(t), 
		.c(c), 
		.state(state), 
		.sum(sum)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		write_en = 1;
		reset = 0;
		fp_input = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		write_en = 0;
      #100000;		
		// Add stimulus here
      $finish;
	end
      
		
		always #10
		    clock = ~clock;
endmodule

