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

/* THIS FILE IS GENERATED, DO NOT EDIT */

`timescale			1ns/1ps
`default_nettype	none

`define				AHBL_AW			16

`include			"ahbl_wrapper.vh"

module AUCOHL_CCC16_AHBL#( 
	parameter	
				NSS = 2
) (
	`AHBL_SLAVE_PORTS,
	input	[0:0]	ext_in
);

	localparam	PR_REG_OFFSET = `AHBL_AW'd0;
	localparam	CCMP_REG_OFFSET = `AHBL_AW'd4;
	localparam	CAP_REG_OFFSET = `AHBL_AW'd8;
	localparam	CTRL_REG_OFFSET = `AHBL_AW'd12;
	localparam	CFG_REG_OFFSET = `AHBL_AW'd16;
	localparam	IM_REG_OFFSET = `AHBL_AW'd3840;
	localparam	MIS_REG_OFFSET = `AHBL_AW'd3844;
	localparam	RIS_REG_OFFSET = `AHBL_AW'd3848;
	localparam	IC_REG_OFFSET = `AHBL_AW'd3852;

	wire		clk = HCLK;
	wire		rst_n = HRESETn;


	`AHBL_CTRL_SIGNALS

	wire [16-1:0]	prescaler;
	wire [4-1:0]	gf_len;
	wire [1-1:0]	gf_en;
	wire [1-1:0]	cntr_en;
	wire [1-1:0]	cntr_clr;
	wire [1-1:0]	tmr_en;
	wire [2-1:0]	cntr_event;
	wire [16-1:0]	cntr_cmp;
	wire [2-1:0]	cap_start_event;
	wire [2-1:0]	cap_stop_event;
	wire [1-1:0]	cntr_match;
	wire [1-1:0]	cap_done;
	wire [16-1:0]	capture;


	reg [16-1:0]	PR_REG;
	assign	prescaler = PR_REG;
	`AHBL_REG(PR_REG, 0, 16)

	reg [16-1:0]	CCMP_REG;
	assign	cntr_cmp = CCMP_REG;
	`AHBL_REG(CCMP_REG, 0, 16)

	wire [16-1:0]	CAP_WIRE;
	assign	CAP_WIRE = capture;

	reg [4-1:0]	CTRL_REG;
	assign	tmr_en	=	CTRL_REG[0 : 0];
	assign	cntr_en	=	CTRL_REG[1 : 1];
	assign	gf_en	=	CTRL_REG[2 : 2];
	assign	cntr_clr	=	CTRL_REG[3 : 3];
	`AHBL_REG(CTRL_REG, 0, 4)

	reg [10-1:0]	CFG_REG;
	assign	gf_len	=	CFG_REG[3 : 0];
	assign	cntr_event	=	CFG_REG[5 : 4];
	assign	cap_start_event	=	CFG_REG[7 : 6];
	assign	cap_stop_event	=	CFG_REG[9 : 8];
	`AHBL_REG(CFG_REG, 0, 10)

	reg [1:0] IM_REG;
	reg [1:0] IC_REG;
	reg [1:0] RIS_REG;

	`AHBL_MIS_REG(2)
	`AHBL_REG(IM_REG, 0, 2)
	`AHBL_IC_REG(2)

	wire [0:0] CM = cntr_match;
	wire [0:0] CAP = cap_done;


	integer _i_;
	`AHBL_BLOCK(RIS_REG, 0) else begin
		for(_i_ = 0; _i_ < 1; _i_ = _i_ + 1) begin
			if(IC_REG[_i_]) RIS_REG[_i_] <= 1'b0; else if(CM[_i_ - 0] == 1'b1) RIS_REG[_i_] <= 1'b1;
		end
		for(_i_ = 1; _i_ < 2; _i_ = _i_ + 1) begin
			if(IC_REG[_i_]) RIS_REG[_i_] <= 1'b0; else if(CAP[_i_ - 1] == 1'b1) RIS_REG[_i_] <= 1'b1;
		end
	end

	assign IRQ = |MIS_REG;

	AUCOHL_CCC16 #(
		.NSS(NSS)
	) instance_to_wrap (
		.clk(clk),
		.rst_n(rst_n),
		.prescaler(prescaler),
		.gf_len(gf_len),
		.gf_en(gf_en),
		.cntr_en(cntr_en),
		.cntr_clr(cntr_clr),
		.tmr_en(tmr_en),
		.cntr_event(cntr_event),
		.cntr_cmp(cntr_cmp),
		.cap_start_event(cap_start_event),
		.cap_stop_event(cap_stop_event),
		.cntr_match(cntr_match),
		.cap_done(cap_done),
		.capture(capture),
		.in(ext_in)
	);

	assign	HRDATA = 
			(last_HADDR[`AHBL_AW-1:0] == PR_REG_OFFSET)	? PR_REG :
			(last_HADDR[`AHBL_AW-1:0] == CCMP_REG_OFFSET)	? CCMP_REG :
			(last_HADDR[`AHBL_AW-1:0] == CAP_REG_OFFSET)	? CAP_WIRE :
			(last_HADDR[`AHBL_AW-1:0] == CTRL_REG_OFFSET)	? CTRL_REG :
			(last_HADDR[`AHBL_AW-1:0] == CFG_REG_OFFSET)	? CFG_REG :
			(last_HADDR[`AHBL_AW-1:0] == IM_REG_OFFSET)	? IM_REG :
			(last_HADDR[`AHBL_AW-1:0] == MIS_REG_OFFSET)	? MIS_REG :
			(last_HADDR[`AHBL_AW-1:0] == RIS_REG_OFFSET)	? RIS_REG :
			(last_HADDR[`AHBL_AW-1:0] == IC_REG_OFFSET)	? IC_REG :
			32'hDEADBEEF;

	assign	HREADYOUT = 1'b1;

endmodule
