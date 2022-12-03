`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/03 10:21:51
// Design Name: 
// Module Name: myRam
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


module myRam(
    input clk,
    input we,
    input [31:0] write_data,
    input [10:0] address,
    output [31:0] read_data
    );
    reg [31:0] ram [0:2047];
    integer i;

    always @(posedge clk) begin
        if (we == 1) ram[address] <= write_data;
    end

    assign read_data = ram[address];

endmodule
