`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2025 14:19:54
// Design Name: 
// Module Name: Coordic
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


module Coordic(angle, clk, reset, done, Sin_value, Cos_value);
input signed[31:0] angle;
input clk;
input reset;
output done;
output signed[15:0] Sin_value;
output signed[15:0] Cos_value;

parameter Scaling_factor_K = 16'b0010011011100100; // After 16 iterations, K = 0.607252935

reg signed[15:0] X_in;
reg signed[15:0] Y_in;
reg signed[31:0] Z_in;
reg[3:0] i; //iterations
reg busy;
reg signed[15:0] X_shr;
reg signed[15:0] Y_shr;

// Angle table
 wire signed [31:0] atan_table [0:15];
                          
  assign atan_table[00] = 'b00100000000000000000000000000000; // 45.000 degrees -> atan(2^0)
  assign atan_table[01] = 'b00010010111001000000010100011101; // 26.565 degrees -> atan(2^-1)
  assign atan_table[02] = 'b00001001111110110011100001011011; // 14.036 degrees -> atan(2^-2)
  assign atan_table[03] = 'b00000101000100010001000111010100; // atan(2^-3)
  assign atan_table[04] = 'b00000010100010110000110101000011;
  assign atan_table[05] = 'b00000001010001011101011111100001;
  assign atan_table[06] = 'b00000000101000101111011000011110;
  assign atan_table[07] = 'b00000000010100010111110001010101;
  assign atan_table[08] = 'b00000000001010001011111001010011;
  assign atan_table[09] = 'b00000000000101000101111100101110;
  assign atan_table[10] = 'b00000000000010100010111110011000;
  assign atan_table[11] = 'b00000000000001010001011111001100;
  assign atan_table[12] = 'b00000000000000101000101111100110;
  assign atan_table[13] = 'b00000000000000010100010111110011;
  assign atan_table[14] = 'b00000000000000001010001011111001;
  assign atan_table[15] = 'b00000000000000000101000101111100;

always@(posedge clk) begin
if(reset) begin
    X_in <= Scaling_factor_K;
    Y_in <= 0;
    Z_in <= 0;
    i <= 0;
    busy <= 1;
end
else if(busy) begin
    X_shr = X_in >>> i;
    Y_shr = Y_in >>> i;
    if(Z_in > angle) begin
        X_in = X_in - Y_shr;
        Y_in = Y_in + X_shr;
        Z_in = Z_in - atan_table[i];
    end    
    else begin
        X_in = X_in + Y_shr;
        Y_in = Y_in - X_shr;
        Z_in = Z_in + atan_table[i];
    end
    i = i + 1;
    if(i == 0) busy = 0;    
end
end

assign Cos_value = X_in;
assign Sin_value = Y_in;
assign done = ~busy;

endmodule