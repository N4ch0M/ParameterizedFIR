//! @title Testbench FIR filter
//! @author J. I. Morales (morales.juan.ignacio@gmail.com)
//! @version 1.0
//! @date Testbench for the FIR filter with parameterized number of coefficients 

`timescale 1ns / 1ps

module fir_param_tb;

    // --------------------------------------------------------------- //
    //******************* Parameter Declarations **********************//
    // --------------------------------------------------------------- //    
    parameter   NBits           = 16;
    parameter   NCoeff          = 4;
    parameter   CLK_PERIOD      = 20;  

    // --------------------------------------------------------------- //
    //******************** Register Declarations **********************//
    // --------------------------------------------------------------- //
    reg                 rst;            //! Reset
    reg                 clk;            //! Clock
    reg [NBits-1:0]     data_in;        //! Input data
    
    // --------------------------------------------------------------- //
    //*********************** Wire Declarations ***********************//
    // --------------------------------------------------------------- // 
    wire [NBits-1:0]    data_out;       //! Output data


    // --------------------------------------------------------------- //
    //*********************** DUT Instantiation ***********************//
    // --------------------------------------------------------------- // 

    fir_param #(
        // Parameters
        .NBits      (NBits),
        .NCoeff     (NCoeff)
    ) fir_param_i (
        // Data Signals
        .data_out   (data_out),
        .data_in    (data_in),
        // Control Signals
        .rst        (rst),
        .clk        (clk)
    );

    initial begin

        // Initialize Inputs
        rst         = 1'b0;
        data_in     = {NBits{1'b0}};
    
        // Apply reset
        #(10*CLK_PERIOD);
        rst         = 1'b1;
        #(10*CLK_PERIOD);
        rst         = 1'b0;
        #(20*CLK_PERIOD);

        // Introduce a sequence of unit pulses (pulse in data_in every 100 ns)
        #CLK_PERIOD data_in = {{NBits-1{1'b0}}, 1'b1};  // Impulse
        #CLK_PERIOD data_in = {NBits{1'b0}};            // 0
        #CLK_PERIOD data_in = {NBits{1'b0}};            // 0
        #CLK_PERIOD data_in = {NBits{1'b0}};            // 0
        
        #(10*CLK_PERIOD);

        #CLK_PERIOD data_in = {{NBits-1{1'b0}}, 1'b1};  // Impulse
        #CLK_PERIOD data_in = {NBits{1'b0}};            // 0
        #CLK_PERIOD data_in = {NBits{1'b0}};            // 0
        #CLK_PERIOD data_in = {NBits{1'b0}};            // 0

        #(10*CLK_PERIOD);
        
        $finish;
    end

    //-------------------------- Generate Clock ------------------------------
    initial 
        clk = 1'b1;

    always  
        #(CLK_PERIOD/2) clk = !clk;

    //-------------------------- Signal Monitor ------------------------------
    initial begin
        $monitor("Time = %0t | data_in = %h | data_out = %h | rst = %b", $time, data_in, data_out, rst);
    end

endmodule
