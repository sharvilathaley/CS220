`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:27:15 04/03/2024 
// Design Name: 
// Module Name:    fsm 
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

module fsm(
    input clk,
    output reg signed [7:0] led
);

    //Internal Variables
    reg signed [31:0] instruction_memory [0:10];
	reg signed [7:0] data[0:2];
    reg [31:0] instruct;
    reg [5:0] opcode, funct;
    reg [4:0] rs, rt, rd;
    reg signed [15:0] constant;
    reg [2:0] state;
	reg [7:0] pc;

    reg signed [7:0] op1, op2, temp, o_p, o_p1;
    reg [2:0] cycle;
    reg invalid;

    reg read_enable1, read_enable2, write_enable;
    reg [4:0] read_address1, read_address2, write_address;
    wire signed [7:0] read_data1, read_data2;
    reg signed [7:0] write_data;

    // Register File instantiation
    register_file FILE(
        .clk(clk),
        .read_enable1(read_enable1),
        .read_enable2(read_enable2),
        .write_enable(write_enable),
        .read_address1(read_address1),
        .read_address2(read_address2),
        .write_address(write_address),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    reg[7:0] a,b,c;
    initial begin
        pc <= 8'b0;
        state <= 3'b0;
        read_address1 <= 5'b0;
        read_address2 <= 5'b0;
        write_address <= 5'b0;
        write_data <= 8'b0;
        read_enable1 <= 0;
        read_enable2 <= 0;
        write_enable <= 0;
        led <= 8'b0;
        instruct <= 32'b0;
        opcode <= 6'b0;
        funct <=6'b0;
        rs <= 5'b0;
        rt <= 5'b0;
        rd <= 5'b0;
        constant <= 16'b0;
        op1 <= 8'b0;
        op2 <= 8'b0;
        temp <= 8'b0;
        o_p <= 8'b0;
		o_p1 <= 8'b0;
        cycle <= 3'b0;
        invalid <= 1;
        data[0] <= 8'b11101100;
		data[1] <= 8'd10;
		data[2] <= 8'd2;
        instruction_memory[0] <= 32'b10001100000000010000000000000000;
        instruction_memory[1] <= 32'b10001100000000100000000000000001;
        instruction_memory[2] <= 32'b10001100000000110000000000000010;
        instruction_memory[3] <= 32'b00100100000001000000000000000000;
        instruction_memory[4] <= 32'b00100100001001010000000000000000;
        instruction_memory[5] <= 32'b00000000101000100011000000101010;
        instruction_memory[6] <= 32'b00010000110000000000000000000101;
        instruction_memory[7] <= 32'b00000000100001010010000000100001;
        instruction_memory[8] <= 32'b00000000101000110010100000100001;
        instruction_memory[9] <= 32'b00000000101000100011000000101010;
        instruction_memory[10] <= 32'b00010100110000001111111111111101;
    end
	 
    initial begin

        #3500
        $display("led : %d",led);
        $finish;
    end

	 
    always @(posedge clk)begin
        //$display("time : %d pc : %d state : %d",$time,pc,state);
        if(pc<8'd12) begin
        case(state)
        0 : begin
            if(pc<8'd11)begin
            instruct <= instruction_memory[pc];
            //$display("time : %d pc : %d state : %d",$time,pc,state);
            //pc <= pc+1;
            state <= state+1;
            end
            else begin
            state <= 6;
            cycle <= 0;
            end
        end
        1: begin            
			  invalid <= 0;
			  opcode <= instruct[31:26];
			  rs <= instruct[25:21];
			  rt <= instruct[20:16];
			  rd <= instruct[15:11];
			  constant <= instruct[15:0];
			  funct <= instruct[5:0];
			  cycle <= 3'b0;
			  state <= state + 1;
              temp <= instruct[7:0];
        end
        2: begin
            //if(pc==8'd7) begin
            //$display("%d, opcode : %b, rs : %b, rt : %b, rd : %b, funct : %b",$time,opcode,rs,rt,rd,funct);
            //end
            case(opcode) 
                6'h0 : begin
                    case(cycle) 
                        3'b000 : begin
                            read_enable1 <= 1;
                            read_enable2 <= 1;
                            read_address1 <= rs;
                            read_address2 <= rt;
                            cycle <= 1;
                        end
                        3'b001 : begin
                            cycle <= 2;
                        end
                        3'b010 : begin
                            cycle <= 3;
                        end
                        3'b011 : begin
                            op1 <= read_data1;
                            op2 <= read_data2;
                            cycle <= 4;
                            read_enable1 <= 0;
                            read_enable2 <= 0;
                        end
                        3'b100 : begin
                            state <= state + 1;
                        end
                    endcase
                    
                end
                6'h9 : begin
                    case(cycle) 
                        3'b0 : begin
                            rd <= rt;
                            read_enable1 <= 1;
                            read_address1 <= rs;
                            cycle <= cycle + 1;
                        end
                        3'b001 : begin
                            cycle <= cycle + 1;
                        end
                        3'b010 : begin
                            cycle <= cycle + 1;
                        end
                        3'b011 : begin
                            op1 <= read_data1;
                            temp <= constant[7:0];
                            cycle <= cycle + 1;
                            read_enable1 <= 0;
                        end
                        3'b100 : begin
                            state <= state + 1;
                        end
                    endcase
                end
		        6'h23 : begin
                    case(cycle) 
                        3'b0 : begin
                            rd <= rt;
                            read_enable1 <= 1;
                            read_address1 <= rs;
                            cycle <= cycle + 1;
                        end
                        3'b001 : begin
                            cycle <= cycle + 1;
                        end
                        3'b010 : begin
                            cycle <= cycle + 1;
                        end
                        3'b011 : begin
                            op1 <= read_data1;
                            temp <= constant[7:0];
                            cycle <= cycle + 1;
                            read_enable1 <= 0;
                        end
                        3'b100 : begin
                            state <= state + 1;
                        end
                    endcase
                end
				6'h5 : begin
                    case(cycle) 
                        3'b000 : begin
                            read_enable1 <= 1;
                            read_enable2 <= 1;
                            read_address1 <= rs;
                            read_address2 <= rt;
                            cycle <= 1;
                        end
                        3'b001 : begin
                            cycle <= 2;
                        end
                        3'b010 : begin
                            cycle <= 3;
                        end
                        3'b011 : begin
                            op1 <= read_data1;
                            op2 <= read_data2;
                            cycle <= 4;
                            read_enable1 <= 0;
                            read_enable2 <= 0;
                        end
                        3'b100 : begin
                            state <= state + 1;
                        end
                    endcase
                end
				6'h4 : begin
                    case(cycle) 
                        3'b000 : begin
                            read_enable1 <= 1;
                            read_enable2 <= 1;
                            read_address1 <= rs;
                            read_address2 <= rt;
                            cycle <= 1;
                        end
                        3'b001 : begin
                            cycle <= 2;
                        end
                        3'b010 : begin
                            cycle <= 3;
                        end
                        3'b011 : begin
                            op1 <= read_data1;
                            op2 <= read_data2;
                            cycle <= 4;
                            read_enable1 <= 0;
                            read_enable2 <= 0;
                        end
                        3'b100 : begin
                            state <= state + 1;
                        end
                    endcase
                end
            endcase
        end
        3 : begin
            case(opcode)
                6'h0 : begin
                    case(funct)
                    6'h21 : begin
                        o_p <= op1+op2;
                        //if(pc==8'd7)begin
                        //$display("rs : %d rt : %d op1 : %d op2 : %d",rs,rt,op1,op2);
                        //end	
                        state <= state+1;
                        cycle <= 3'b0;
                    end
                    6'h2a : begin
                        o_p <= ($signed(op1) < $signed(op2)) ? 8'b00000001 : 8'b00000000;
                        state <= state+1;
                        cycle <= 3'b0;
                    end
                    default : begin
                        invalid <= 1;
                        state <= state+1;
                        cycle <= 3'b0;
                    end
                    endcase
                end
                6'h9 : begin
                    o_p <= (op1 + temp);
                    state <= state+1;
                    cycle <= 3'b0;
                end
                6'h4 : begin
                    if(op1 == op2) begin
                        pc <= (pc+temp);
                        state <= 0;
                        cycle <= 3'b0;
                    end
                    else begin
                        pc <= pc + 1;
                        state <= 0;
                        cycle <= 3'b0;
                    end
                end
                6'h5 : begin
                    //if(pc==8'd10) begin
                    //$display("rs : %d rt : %d op1 : %d op2 : %d temp %d",rs,rt,op1,op2,temp);
                    //end
                    if(op1 != op2) begin
                        pc <= (pc+temp);
                        state <= 0;
                        cycle <= 3'b0;
                    end
                    else begin
                        pc <= pc + 1;
                        state <= 0;
                        cycle <= 3'b0;
                    end
                end
                6'h23 : begin
                    o_p1 <= op1+temp;
                    state <= state+1;
                    cycle <= 3'b0;
                end
                default : begin
                    invalid <= 1;
                    state <= state+1;
                    cycle <= 3'b0;
                end
            endcase
        end
		  4 : begin
            if(opcode == 6'h23) begin
                o_p <= data[o_p1];
            end
            state <= state+1;
            cycle <= 3'b0;
		  end
        5 : begin
            //if(invalid==1'b0 && rd!=5'b0) begin
            case(cycle) 
                3'b0 : begin
                    //$display("%d : pc : %d, rd : %d, o_p : %d",$time,pc,rd,o_p);
                    write_enable <= 1;
                    write_address <= rd;
                    write_data <= o_p;
                    cycle <= cycle + 1;
                end
                3'b001 : begin
                    cycle <= cycle + 1;
                end
                3'b010 : begin
                    cycle <= cycle + 1;
                end
                3'b011 : begin
                    cycle <= cycle + 1;
                    write_enable <= 0;
                end
                3'b100 : begin
                    if(pc < 8'd11) begin
                        state <= 3'b0;
                        cycle <= 3'b0;
                        pc <= pc+1;
                    end
                    else begin
                        state <= state + 1;
                        cycle <= 3'b0;
                    end
                end
            endcase
                
            //end
            
        end

        6 : begin
            case(cycle) 
                3'b0 : begin
                    read_enable1 <= 1;
                    read_address1 <= 5'd4;
                    cycle <= cycle + 1;
                end
                3'b001 : begin
                    cycle <= cycle + 1;
                end
                3'b010 : begin
                    cycle <= cycle + 1;
                end
                3'b011 : begin
                    //$display("read_data : %d",read_data1);
                    led <= read_data1;
                    read_enable1 <= 0;
                    cycle <= cycle + 1;
                end
                //default : begin
                //$display("led : %d",led);
                //end
            endcase
        end
    endcase

    end

    end

    
endmodule



