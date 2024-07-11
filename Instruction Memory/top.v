`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:59:46 04/03/2024
// Design Name:   fsm
// Module Name:   /users/misc/kartik21/mips_processor/top.v
// Project Name:  mips_processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fsm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module top;
    reg clk;
    wire [7:0] led;
    fsm FSM(
        .clk(clk),
        .led(led)
    );

    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk; // Toggle clock
        end
    end
endmodule

