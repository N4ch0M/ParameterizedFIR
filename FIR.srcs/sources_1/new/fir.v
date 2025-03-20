//! @title FIR filter
//! @author J. I. Morales (morales.juan.ignacio@gmail.com)
//! @version 1.0
//! @date Simple FIR filter with preloaded coefficients (unsigned data)

module fir
 #(
    parameter NBits  = 16                   //! Number of Bits
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
    reg     [NBits-1:0]    register [3:0];  //! Matrix for Registers
    reg     [NBits-1:0]    coeff  [3:0];    //! Matrix for Coefficients
    reg     [NBits-1:0]    sum;             //! Matrix for Registers

    // --------------------------------------------------------------- //
    //*********************** Wire Declarations ***********************//
    // --------------------------------------------------------------- // 
    wire  [NBits*2-1:0]    prod   [3:0];    //! Partial Products

    // --------------------------------------------------------------- //
    // ************************ Main Code  *************************** //
    // --------------------------------------------------------------- //

    //! Pre-loaded Coefficients 
    initial begin
        coeff[0] = 16'h04F0;  //  1264 en hexadecimal               
        coeff[1] = 16'h3B10;  // 15120 en hexadecimal             
        coeff[2] = 16'h3B10;  // 15120 en hexadecimal            
        coeff[3] = 16'h04F0;  //  1264 en hexadecimal             
    end

    //! Shift Register model
    always @(posedge clk) 
        begin
        if (rst) 
            begin
            register[0] <= {NBits{1'b0}};
            register[1] <= {NBits{1'b0}};
            register[2] <= {NBits{1'b0}};
            register[3] <= {NBits{1'b0}};
            end 
        else 
            begin
            register[0] <= data_in;
            register[1] <= register[0];
            register[2] <= register[1];
            register[3] <= register[2];
            end
        end

    //! Partial Products
    assign  prod[0] = coeff[0] * register[0];
    assign  prod[1] = coeff[1] * register[1];
    assign  prod[2] = coeff[2] * register[2];
    assign  prod[3] = coeff[3] * register[3];
    
    //! Output Adder
    assign  data_out = prod[0] + prod[1] + prod[2] + prod[3];

endmodule
