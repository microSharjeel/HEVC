`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2025 02:32:34 PM
// Design Name: 
// Module Name: forward_transform_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module forward_transform_tb;
logic clk;
logic reset;
logic signed [15:0] residual_block[4][4];
logic signed [15:0] output_matrix [4][4];
logic signed [15:0] residue_block [4][4];
logic signed [63:0] sum;
logic signed [63:0] sum1;

forward_transform ft(.residual_block(residual_block), .clk(clk), .reset(reset), .output_matrix(output_matrix), .sum(sum));
inverse_transform it(.coeff_matrix(output_matrix), .clk(clk), .reset(reset), .residue_block(residue_block), .sum1(sum1));


always #5 clk = ~ clk;

initial
begin
    clk = 0;
    reset = 0;
    #10;
    reset = 1;
    
   residual_block =  '{ '{25, 29, 10, 0},
                       '{24, 28, 7, -3},
                       '{10, 12, 3, 8},
                       '{15, 16, 0, 9}   
                     };
                     
    #500;
    
    $display (  "4x4 Residual_Block");
    
    for (int i=0; i<4; i++)
    begin
        $display("%d %d %d %d", residual_block[i][0], residual_block[i][1], residual_block[i][2], residual_block[i][3]);
    end               
 
    
    $display (  "4x4 Output_Matrix");
    
    for (int i=0; i<4; i++)
    begin
        $display("%d %d %d %d", output_matrix[i][0], output_matrix[i][1], output_matrix[i][2], output_matrix[i][3]);
    end  
     
    
    $display (  "4x4 Residue_Matrix");
    
    for (int i=0; i<4; i++)
    begin
        $display("%d %d %d %d", residue_block[i][0], residue_block[i][1], residue_block[i][2], residue_block[i][3]);
    end  

     
end
endmodule
