//! @title Parameterized FIR filter
//! @author J. I. NCoefforales (morales.juan.ignacio@gmail.com)
//! @version 1.0
//! @date Simple FIR filter with parameterized number of coefficients (unsigned data)

module fir_param
 #(
    parameter NBits  = 16,      //! Number of Bits
    parameter NCoeff = 8        //! Number of Coefficients
  ) 
  (
    data_out, 
    data_in,
    rst,      
    clk       
  );

    output  [NBits-1:0]   data_out;         //! Output data
    input   [NBits-1:0]   data_in;          //! Input data
    input                     rst;          //! Reset
    input                     clk;          //! Clock


    // --------------------------------------------------------------- //
    //******************** Register Declarations **********************//
    // --------------------------------------------------------------- //
    reg     [NBits-1:0]     register [NCoeff-1:0];  //! Matrix for Registers
    reg     [NBits-1:0]     coeff    [NCoeff-1:0];  //! Matrix for Coefficients
    reg     [NBits*2-1:0]   prod     [NCoeff-1:0];  //! Partial Products
    reg     [NBits*2-1:0]   sum;                    //! Output sum

    // --------------------------------------------------------------- //
    integer i;

    // --------------------------------------------------------------- //
    // ************************ Main Code  *************************** //
    // --------------------------------------------------------------- //

    // Coefficients init from file
    initial begin
        $readmemh("M8_coefficients.dat",coeff,0,NCoeff-1);  
    end

    //! Shift Register and accumulation model
    always @(posedge clk) 
        begin
        if (rst) 
            begin
            for (i = 0; i < NCoeff; i = i + 1)
                begin
                register[i] <= {NBits{1'b0}};
                end
            sum <= {NBits*2{1'b0}};
            end  
        else 
            begin
            // Shift the input samples in the delay line
            for (i = NCoeff-1; i > 0; i = i - 1) 
                begin
                register[i] <= register[i-1];  
                end
            register[0] <= data_in; 
            
            // Perform the accumulation of products (blocking assignment)
            sum = {NBits*2{1'b0}}; 
            for (i = 0; i < NCoeff; i = i + 1) 
                begin
                sum = sum + (coeff[i] * register[i]);  
                end
            end
        end

    //! Output Adder
    assign  data_out = sum; 

    endmodule
