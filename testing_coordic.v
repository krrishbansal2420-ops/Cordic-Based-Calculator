`timescale 1ns / 1ps
`include "Coordic.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2025 00:27:36
// Design Name: 
// Module Name: testing_coordic
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


module testing_coordic;
reg signed[31:0] angle;
reg clk;
reg reset;
wire done;
wire signed[15:0] Sin_value;
wire signed[15:0] Cos_value;

Coordic DUT(angle,clk,reset,done,Sin_value,Cos_value);

initial begin
clk = 1'b0;
forever #5 clk = ~clk;
end

initial begin
$dumpfile("cordiccalc.vcd");
$dumpvars;

reset = 1'b1;
angle = 32'b11111000001001001111000000000000;
#10 reset = 1'b0;
#160 $display("Sin(%2.2f degrees) = %2.6f",((angle/1073741824.0)*90),(Sin_value/16384.0));
$display("Cos(%2.2f degrees) = %2.6f",((angle/1073741824.0)*90),(Cos_value/16384.0));
$finish;
end

endmodule