`timescale 1ns / 1ps

module Binary_to_BCD
  #(parameter INPUT_WIDTH = 8,
    parameter DECIMAL_DIGITS = 3)
  (
   input                         i_Clock,
   input [INPUT_WIDTH-1:0]       i_Binary,
   input                         i_Start,
   //
   output [DECIMAL_DIGITS*4-1:0] o_BCD,
   output                        o_DV
   );
   
  parameter s_IDLE              = 3'b000;
  parameter s_SHIFT             = 3'b001;
  parameter s_CHECK_SHIFT_INDEX = 3'b010;
  parameter s_ADD               = 3'b011;
  parameter s_CHECK_DIGIT_INDEX = 3'b100;
  parameter s_BCD_DONE          = 3'b101;
   
  reg [2:0] r_SM_Main = s_IDLE;
   
  // The vector that contains the output BCD
  reg [DECIMAL_DIGITS*4-1:0] r_BCD = 0;
    
  // The vector that contains the input binary value being shifted.
  reg [INPUT_WIDTH-1:0]      r_Binary = 0;
      
  // Keeps track of which Decimal Digit we are indexing
  reg [DECIMAL_DIGITS-1:0]   r_Digit_Index = 0;
    
  // Keeps track of which loop iteration we are on.
  // Number of loops performed = INPUT_WIDTH
  reg [7:0]                  r_Loop_Count = 0;
 
  wire [3:0]                 w_BCD_Digit;
  reg                        r_DV = 1'b0;                       
    
  always @(posedge i_Clock) begin
      case (r_SM_Main)
        // Stay in this state until i_Start comes along
        s_IDLE :
          begin
            r_DV <= 1'b0;
             
            if (i_Start == 1'b1)
              begin
                r_Binary  <= i_Binary;
                r_SM_Main <= s_SHIFT;
                r_BCD     <= 0;
              end
            else
              r_SM_Main <= s_IDLE;
          end
                 
  
        // Always shift the BCD Vector until we have shifted all bits through
        // Shift the most significant bit of r_Binary into r_BCD lowest bit.
        s_SHIFT :
          begin
            r_BCD     <= r_BCD << 1;
            r_BCD[0]  <= r_Binary[INPUT_WIDTH-1];
            r_Binary  <= r_Binary << 1;
            r_SM_Main <= s_CHECK_SHIFT_INDEX;
          end          
         
  
        // Check if we are done with shifting in r_Binary vector
        s_CHECK_SHIFT_INDEX :
            begin
              if (r_Loop_Count == INPUT_WIDTH-1)
                begin
                  r_Loop_Count <= 0;
                  r_SM_Main    <= s_BCD_DONE;
                end
              else
                begin
                  r_Loop_Count <= r_Loop_Count + 1;
                  r_SM_Main    <= s_ADD; 
                end
              // Break down each BCD Digit individually. Check them one-by-one to // see if they are greater than 4. If they are, increment by 3. // Put the result back into r_BCD Vector. 
            end 
            
        s_ADD : 
            begin 
              if (w_BCD_Digit > 4)
                begin                                     
                  r_BCD[(r_Digit_Index*4)+:4] <= w_BCD_Digit + 3;  
                end

              r_SM_Main <= s_CHECK_DIGIT_INDEX; 
            end       
         
        // Check if we are done incrementing all of the BCD Digits
        s_CHECK_DIGIT_INDEX :
          begin
            if (r_Digit_Index == DECIMAL_DIGITS-1)
              begin
                r_Digit_Index <= 0;
                r_SM_Main     <= s_SHIFT;
              end
            else
              begin
                r_Digit_Index <= r_Digit_Index + 1;
                r_SM_Main     <= s_ADD;
              end
          end
  
        s_BCD_DONE :
          begin
            r_DV      <= 1'b1;
            r_SM_Main <= s_IDLE;
          end
         
        default :
          r_SM_Main <= s_IDLE;
            
      endcase
    end // always @ (posedge i_Clock)  

  assign w_BCD_Digit = r_BCD[r_Digit_Index*4+:4];
       
  assign o_BCD = r_BCD;
  assign o_DV  = r_DV;
      
endmodule // Binary_to_BCD

// module BinBcdConverter(
//     input [13:0] A,
//     output [3:0] Thousands,
//     output [3:0] Hundreds,
//     output [3:0] Tens,
//     output [3:0] Ones
//     );
    
//     wire [3:0] c1, c2, c3, c4, c5, c6, c7;
//     wire [3:0] d1, d2, d3, d4, d5, d6, d7;
    
//     assign d1 = {1'b0, A[7:5]};
//     assign d2 = {c1[2:0], A[4]};
//     assign d3 = {c2[2:0], A[3]};
//     assign d4 = {c3[2:0], A[2]};
//     assign d5 = {c4[2:0], A[1]};
//     assign d6 = {1'b0, c1[3], c2[3], c3[3]};
//     assign d7 = {c6[2:0], c4[3]};
    
//     Shift_Add3_ALG M1(d1, c1);
//     Shift_Add3_ALG M2(d2, c2);
//     Shift_Add3_ALG M3(d3, c3);
//     Shift_Add3_ALG M4(d4, c4);
//     Shift_Add3_ALG M5(d5, c5);
//     Shift_Add3_ALG M6(d6, c6);
//     Shift_Add3_ALG M7(d7, c7);
    
//     assign Ones = {c5[2:0], A[0]};
//     assign Tens = {c7[2:0], c5[3]};
//     assign Hundreds = {c6[3], c7[3]};
// endmodule


// module Shift_Add3_ALG(
//     input [3:0] In, 
//     output reg [3:0] Out
//     );
    
//     always @(In) begin
//         case(In)
//             4'b0000: Out <= 4'b0000;
//             4'b0001: Out <= 4'b0001;
//             4'b0010: Out <= 4'b0010;
//             4'b0011: Out <= 4'b0011;
//             4'b0100: Out <= 4'b0100;
//             4'b0101: Out <= 4'b1000;
//             4'b0110: Out <= 4'b1001;
//             4'b0111: Out <= 4'b1010;
//             4'b1000: Out <= 4'b1011;
//             4'b1001: Out <= 4'b1100;
//             default: Out <= 4'b0000;
//         endcase
//     end
// endmodule