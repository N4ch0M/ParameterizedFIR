//! @title Testbench FIR filter
//! @author J. I. Morales (morales.juan.ignacio@gmail.com)
//! @version 1.1
//! @date Testbench for the FIR filter with parameterized number of coefficients, noisy input data 

`timescale 1ns / 1ps

module fir_param_tb;

    // --------------------------------------------------------------- //
    //******************* Parameter Declarations **********************//
    // --------------------------------------------------------------- //    
    parameter   NBits           = 16;
    parameter   NCoeff          = 14;
    parameter   NData           = 1000;
    parameter   CLK_PERIOD      = 20;  

    // --------------------------------------------------------------- //
    //******************** Register Declarations **********************//
    // --------------------------------------------------------------- //
    reg                 rst;                    //! Reset
    reg                 clk;                    //! Clock
    reg [NBits-1:0]     data_mem[NData-1:0];    //! Input data
    reg [9:0]           idx;                    //! Index to read the data

    // --------------------------------------------------------------- //
    //*********************** Wire Declarations ***********************//
    // --------------------------------------------------------------- // 
    wire [NBits-1:0]    data_out;       //! Output data
    wire [NBits-1:0]    data_in;

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

        // Read the data from the file
        $readmemh("input_signal.dat",data_mem,0,NData-1);  

        // Initialize Inputs
        rst         = 1'b0;
        idx         = 1'b0;
    
        // Apply reset
        #(10*CLK_PERIOD);
        rst         = 1'b1;
        #(10*CLK_PERIOD);
        rst         = 1'b0;
        #(20*CLK_PERIOD);

        // Recorrer el vector `data_in` y alimentar el filtro
        for (idx = 0; idx < NData; idx = idx + 1) 
            begin
            #CLK_PERIOD; 
            end

        // Introduce a sequence of unit pulses (pulse in data_in every 100 ns)
        // #CLK_PERIOD data_in = {{NBits-1{1'b0}}, 1'b1};  // Impulse
        // #CLK_PERIOD data_in = {NBits{1'b0}};            // 0
        // #CLK_PERIOD data_in = {NBits{1'b0}};            // 0
        // #CLK_PERIOD data_in = {NBits{1'b0}};            // 0
        
        // #(10*CLK_PERIOD);

        // #CLK_PERIOD data_in = {{NBits-1{1'b0}}, 1'b1};  // Impulse
        // #CLK_PERIOD data_in = {NBits{1'b0}};            // 0
        // #CLK_PERIOD data_in = {NBits{1'b0}};            // 0
        // #CLK_PERIOD data_in = {NBits{1'b0}};            // 0

        // #(10*CLK_PERIOD);
        
        $finish;
    end

    assign data_in = data_mem[idx];

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
