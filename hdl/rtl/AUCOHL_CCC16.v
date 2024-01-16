`include "aucohl_rtl.vh"
`include "aucohl_lib.v"

module AUCOHL_CCC16 #(parameter NSS=2)
(
    input   wire            clk,
    input   wire            rst_n,

    input   wire [15:0]     prescaler,
    input   wire [ 3:0]     gf_len,
    input   wire            gf_en,
    input   wire            cntr_en,
    input   wire            cntr_clr,
    input   wire            tmr_en,
    input   wire [ 1:0]     cntr_event,
    input   wire [15:0]     cntr_cmp,
    input   wire [ 1:0]     cap_start_event,
    input   wire [ 1:0]     cap_stop_event,
    
    output  wire            cntr_match,
    output  wire            cap_done,
    output  reg  [15:0]     capture,

    input   wire            in
);
    wire        in_sync;
    reg         in_gf;
    wire        tick;
    reg [7:0]   gf_shifter;
    reg [15:0]  cntr;
    reg [15:0]  tmr;
    //reg [15:0]  capture;
    
    // Syncronize the input
    aucohl_sync #(.NUM_STAGES(NSS)) IN_SYNC (
        .clk(clk),
        .in(in),
        .out(in_sync)
    );

    // 16-bit Prescaler
    aucohl_ticker #(.W(16)) PRESCALER (
        .clk(clk), 
        .rst_n(rst_n),
        .en(tmr_en),
        .clk_div(prescaler),
        .tick(tick)
    );

    // Programmable glitch filter
    always @(posedge clk, negedge rst_n)
        if(!rst_n)
            gf_shifter = 'b0;
        else if(tick)
            gf_shifter <= {gf_shifter[6:0], in_sync};

    wire [8:4] gf_shifter_ones;
    assign gf_shifter_ones[4] = & gf_shifter[3:0];
    assign gf_shifter_ones[5] = & gf_shifter[4:0];
    assign gf_shifter_ones[6] = & gf_shifter[5:0];
    assign gf_shifter_ones[7] = & gf_shifter[6:0];
    assign gf_shifter_ones[8] = & gf_shifter[7:0];
    
    wire [8:4] gf_shifter_zeros;
    assign gf_shifter_zeros[4] = ~| gf_shifter[3:0];
    assign gf_shifter_zeros[5] = ~| gf_shifter[4:0];
    assign gf_shifter_zeros[6] = ~| gf_shifter[5:0];
    assign gf_shifter_zeros[7] = ~| gf_shifter[6:0];
    assign gf_shifter_zeros[8] = ~| gf_shifter[7:0];
    
    wire gf_all_ones   =    gf_shifter_ones[gf_len];
    wire gf_all_zeros  =    gf_shifter_zeros[gf_len];

    always @(posedge clk, negedge rst_n)
        if(!rst_n)
            in_gf <= 1'b0;
        else
            if(gf_all_ones) 
                in_gf <= 1'b1;
            else if(gf_all_zeros) 
                in_gf <= 1'b0;

    // Events Detection
    wire    cntr_in = gf_en ? in_gf : in_sync;
    wire    in_pe, in_ne;
    wire    in_pne = in_pe | in_ne;
    
    aucohl_ped PED (
        .clk(clk),
        .in(cntr_in),
        .out(in_pe)
    );

    aucohl_ned NED (
        .clk(clk),
        .in(cntr_in),
        .out(in_ne)
    );
    
    wire in_pulse = (cntr_event == 2'b11) ? in_pne  :
                    (cntr_event == 2'b01) ? in_pe   :
                    (cntr_event == 2'b10) ? in_ne   : 1'b0;

    // Count and Compare
    always @(posedge clk, negedge rst_n)
        if(!rst_n)
            cntr <= 0;
        else if(cntr_clr)
            cntr <= 0;
        else if(cntr_en & in_pulse)
            cntr <= cntr + 1;

    assign cntr_match = cntr == cntr_cmp;

    // The timer 
    wire tmr_start  =   (cap_start_event == 2'b11) ? in_pne  :
                        (cap_start_event == 2'b01) ? in_pe   :
                        (cap_start_event == 2'b10) ? in_ne   : 1'b0;
    wire tmr_stop   =   (cap_stop_event  == 2'b11) ? in_pne  :
                        (cap_stop_event  == 2'b01) ? in_pe   :
                        (cap_stop_event  == 2'b10) ? in_ne   : 1'b0;
                        
    always @(posedge clk, negedge rst_n)
        if(!rst_n)
            tmr <= 0;
        else if(tmr_start)
            tmr <= 0;
        else if(tick)
            tmr <= tmr + 1;
    
    always @(posedge clk, negedge rst_n)
        if(!rst_n)
            capture <= 0;
        else
            if(tmr_stop)
                capture <= tmr;

    assign cap_done = tmr_stop;

endmodule