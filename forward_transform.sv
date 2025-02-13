`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2025 11:43:28 AM
// Design Name: 
// Module Name: forward_transform
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


module forward_transform(input logic signed [15:0] residual_block[4][4], input logic clk, input logic reset, output logic signed [15:0] output_matrix[4][4], output logic signed [63:0] sum);
logic signed [15:0] dct_matrix  [4][4] = '{ '{64, 64, 64, 64},
                                         '{83, 36, -36, -83},
                                         '{64, -64, -64, 64},
                                         '{36, -83, 83, -36}   
                                          }; 
   
logic signed [15:0] dct_matrix_inverse [4][4] = '{ '{64, 83, 64, 36},
                                                '{64, 36, -64, -83},
                                                '{64, -36, -64, 83},
                                                '{64, -83, 64, -36}   
                                                 }; 
logic signed [15:0] temp_matrix [4][4];
logic signed [5:0]  QP = 26;         
   
//1-D Transform on Columns                                    
always_ff @ (posedge clk or negedge reset)
begin
    if(!reset)
    begin
        temp_matrix <= '{default: 16'h0000};
        sum <= 0;
    end

    else
    begin
        for (int i=0; i<4; i++)  begin // for DCT rows
        for (int j=0; j<4; j++)  begin //for input matrix columns
            temp_matrix[i][j] = 0;
            sum = 0;
        for (int k=0; k<4; k++)  begin
            sum += dct_matrix[i][k] * residual_block[k][j]; 
        end
            temp_matrix[i][j] <= (sum) >>> 1; 
        end
        end
        end
    end


always_ff @ (negedge clk or negedge reset)
begin
    if(!reset)
    begin
        output_matrix <= '{default: 16'h0000};
        sum <= 0;
    end

    else
    begin
    for (int i=0; i<4; i++) begin
    for (int j=0; j<4; j++) begin
        output_matrix[i][j] = 0;
        sum = 0;
    for (int k=0; k<4; k++) begin
        sum += temp_matrix[i][k] * dct_matrix[j][k];  
       // sum += temp_matrix[i][k] * dct_matrix_inverse[k][j];        
    end
        output_matrix[i][j] <= (((sum)>>>8)*(1285))>>>17;   
    end
    
    end
    end
end
endmodule




module inverse_transform #(parameter int w = 16)(input logic signed [15:0] coeff_matrix[4][4], input logic clk, input logic reset, output logic signed [15:0] residue_block[4][4], output logic signed [63:0] sum1);
logic signed [15:0] dct_matrix  [4][4] = '{ '{64, 64, 64, 64},
                                         '{83, 36, -36, -83},
                                         '{64, -64, -64, 64},
                                         '{36, -83, 83, -36}   
                                          }; 

logic signed [15:0] temp1_matrix[4][4];
logic signed [15:0] temp2_matrix[4][4];

//1-D Inverse Transform on Columns                                      
always_ff @ (posedge clk or negedge reset)
begin
    if(!reset)
    begin
        temp1_matrix <= '{default: 16'h0000};
        temp2_matrix <= '{default: 16'h0000};      
        sum1 <= 0;
    end
    
    else
    begin
    for (int i=0; i<4; i++) begin
    for (int j=0; j<4; j++) begin
        temp2_matrix[i][j] = 0;
        sum1 = 0;
        temp1_matrix[i][j] <= (((coeff_matrix[i][j]*816*w)+2))>>7;
    for (int k=0; k<4; k++)  begin
        sum1 +=   dct_matrix[k][i] * temp1_matrix[k][j]; 
    end
        temp2_matrix[i][j] <= (sum1) >>> 7; 
    end
    end   
    end

end

//1-D Inverse Transform on Rows 
always_ff @ (negedge clk or negedge reset)
begin
    if(!reset)
    begin
        residue_block <= '{default: 16'h0000};
        sum1 <= 0;
    end
    
    else
    begin
    for (int i=0; i<4; i++) begin
    for (int j=0; j<4; j++) begin
        residue_block[i][j] = 0;
        sum1 = 0;
    for (int k=0; k<4; k++)  begin
        sum1 +=   temp2_matrix[i][k] * dct_matrix[k][j]; 
    end
        residue_block[i][j] <= (sum1) >>> 12; 
    end
    end 
    end

end
endmodule



        


