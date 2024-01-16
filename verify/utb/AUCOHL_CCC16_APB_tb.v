/*
	Copyright 2024 AUCOHL

	Author: Mohamed Shalan (mshalan@aucegypt.edu)

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	    http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

*/

/* THIS FILE IS GENERATED, edit it to complete the testbench */

`timescale		1ns/1ps

`default_nettype	none

`define			APB_AW			16
`define			MS_TB_SIMTIME		1_000_000

`include		"tb_macros.vh"

module AUCOHL_CCC16_APB_tb;

	// Change the following parameters as desired
	parameter real CLOCK_PERIOD = 100.0;
	parameter real RESET_DURATION = 999.0;

	// DON NOT Change the following parameters
	localparam [`APB_AW-1:0]
			PR_REG_OFFSET =	`APB_AW'h0000,
			CCMP_REG_OFFSET =	`APB_AW'h0004,
			CAP_REG_OFFSET =	`APB_AW'h0008,
			CTRL_REG_OFFSET =	`APB_AW'h000c,
			CFG_REG_OFFSET =	`APB_AW'h0010,
			IM_REG_OFFSET =		`APB_AW'h0f00,
			IC_REG_OFFSET =		`APB_AW'h0f0c,
			RIS_REG_OFFSET =	`APB_AW'h0f08,
			MIS_REG_OFFSET =	`APB_AW'h0f04;

	`TB_APB_SIG

	reg	[0:0]	ext_in;

	`TB_CLK(PCLK, CLOCK_PERIOD)
	`TB_ESRST(PRESETn, 1'b0, PCLK, RESET_DURATION)
	`TB_DUMP("APB_AUCOHL_CCC16_tb.vcd", AUCOHL_CCC16_APB_tb, 0)
	`TB_FINISH(`MS_TB_SIMTIME)

	AUCOHL_CCC16_APB DUV (
		`TB_APB_SLAVE_CONN,
		.ext_in(ext_in)
	);

	`include "apb_tasks.vh"

	`TB_TEST_EVENT(test1)
	`TB_TEST_EVENT(test2)

	// Input generation
	reg flag = 0;
	event e_start_input;
	event e_stop_input;
	initial @(e_start_input) flag = 1;
	initial @(e_stop_input) flag = 0;
	
	initial begin
		ext_in = 0;
		forever begin
			while(flag) begin
				#30_333;
				ext_in = 1;
				#40_444;
				ext_in = 0;
			end
			#999;
		end
	end

	initial begin
		#999 -> e_assert_reset;
		@(e_reset_done);

		// Start the input
		->e_start_input;

		// Perform Test 1
		#1000 -> e_test1_start;
		@(e_test1_done);

		// Perform Test 2
		#1000 -> e_test2_start;
		@(e_test2_done);


		// Stop the input
		->e_stop_input;

		// Perform other tests

		// Finish the simulation
		#1000 $finish();
	end

	reg [31:0] rdata;
	
	// Test 1
	`TB_TEST_BEGIN(test1)
		// Test 1 code goes here
		// Capture Compare is 10
		APB_W_WRITE(PR_REG_OFFSET, 32'd10);
		// Set the prescaler to 4 (divide the clock by 5)
		APB_W_WRITE(PR_REG_OFFSET, 32'd4);
		// Set the Counter Compare to 5
		APB_W_WRITE(CCMP_REG_OFFSET, 32'd5);
		// Count the rising edges and set the glitch filter length to 4
		APB_W_WRITE(CFG_REG_OFFSET, 10'b00_00_01_0100);
		// Enable the counter and the glitch filter
		APB_W_WRITE(CTRL_REG_OFFSET, 4'b0_1_1_0);
		// Wait for some time to allow at least 5 positive edges
		#500_000;
		// Read the RIS register
		APB_W_READ(RIS_REG_OFFSET, rdata);
		#100;
		if(rdata & 1) $display("Test 1 - Passed");
		else $display("Test 1 - Failed");
	`TB_TEST_END(test1)
	
	// Test 2
	// Measure the high pulse wisth
	`TB_TEST_BEGIN(test2)
		// Test 1 code goes here
		// Capture Compare is 10
		APB_W_WRITE(PR_REG_OFFSET, 32'd10);
		// Set the prescaler to 4 (divide the clock by 5)
		APB_W_WRITE(PR_REG_OFFSET, 32'd4);
		// Set the Counter Compare to 5
		APB_W_WRITE(CCMP_REG_OFFSET, 32'd5);
		// capture positive edge to positive edge time and set the glitch filter length to 4
		APB_W_WRITE(CFG_REG_OFFSET, 10'b10_01_00_0100);
		// Enable the timer and the glitch filter
		APB_W_WRITE(CTRL_REG_OFFSET, 4'b0_1_0_1);
		// Wait for some time to allow at least one high pulse
		#100_000;
		// Read the RIS register
		APB_W_READ(RIS_REG_OFFSET, rdata);
		#100;
		if(rdata & 2) $display("Test 2 - Passed");
		else $display("Test 2 - Failed");
	`TB_TEST_END(test2)

endmodule
