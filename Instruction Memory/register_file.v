`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:28:05 04/03/2024 
// Design Name: 
// Module Name:    register_file 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module register_file(
    input clk,
    input read_enable1,
    input read_enable2,
    input write_enable,
    input [4:0] read_address1,
    input [4:0] read_address2,
    input [4:0] write_address,
    input signed [7:0] write_data,
    output reg signed [7:0] read_data1,
    output reg signed [7:0] read_data2);

  // Internal Variables
  reg signed [7:0] register_file [31:0]; // 32 registers of 8 bits each.
  
  initial
    begin
		//$monitor("%d",register_file[4]);
		//$monitor("%d",register_file[2]);
		//$monitor("%d",register_file[6]);

    read_data1 <= 8'b0;
    read_data2 <= 8'b0;
    register_file[0] <= 8'b0; // Initialise all registers to 0.
    register_file[1] <= 8'b0;
    register_file[2] <= 8'b0;
    register_file[3] <= 8'b0;
    register_file[4] <= 8'b0;
    register_file[5] <= 8'b0;
    register_file[6] <= 8'b0;
    register_file[7] <= 8'b0;
    register_file[8] <= 8'b0;
    register_file[9] <= 8'b0;
    register_file[10] <= 8'b0;
    register_file[11] <= 8'b0;
    register_file[12] <= 8'b0;
    register_file[13] <= 8'b0;
    register_file[14] <= 8'b0;
    register_file[15] <= 8'b0;
    register_file[16] <= 8'b0;
    register_file[17] <= 8'b0;
    register_file[18] <= 8'b0;
    register_file[19] <= 8'b0;
    register_file[20] <= 8'b0;
    register_file[21] <= 8'b0;
    register_file[22] <= 8'b0;
    register_file[23] <= 8'b0;
    register_file[24] <= 8'b0;
    register_file[25] <= 8'b0;
    register_file[26] <= 8'b0;
    register_file[27] <= 8'b0;
    register_file[28] <= 8'b0;
    register_file[29] <= 8'b0;
    register_file[30] <= 8'b0;
    register_file[31] <= 8'b0;
    end
 

  always @(posedge clk)
    begin
    if (write_enable)
        begin
        register_file[write_address] <= write_data;
        end
    if (read_enable1)
        begin
        read_data1 <= register_file[read_address1];
        end
    if (read_enable2)
        begin
        read_data2 <= register_file[read_address2];
        end
    end
endmodule

