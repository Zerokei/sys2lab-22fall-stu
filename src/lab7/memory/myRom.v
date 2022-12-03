`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/03 00:46:55
// Design Name: 
// Module Name: myRom
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


module myRom(
    input [10:0] address,
    output [31:0] out
);
    reg [31:0] rom [0:2047];


    localparam FILE_PATH = "kernel.sim";
    initial begin
        $readmemh(FILE_PATH, rom);
    end


    assign out = rom[address];
endmodule
