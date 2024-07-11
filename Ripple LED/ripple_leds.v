module ripple_leds(clk,led);
`define SHIFT_TIME 50000000
    input clk;

    output [7:0] led;
    reg [7:0] led;

    reg [28:0] counter;

    initial begin
        led[0] <= 1;
        led[1] <= 0;
        led[2] <= 0;
        led[3] <= 0;
        led[4] <= 0;
        led[5] <= 0;
        led[6] <= 0;
        led[7] <= 0;
        counter <= 29'b0;
    end

    always @(posedge clk) begin
        counter <= counter+1;
        if((counter == `SHIFT_TIME))
        begin
            counter <= 1;
            led[1] <= led[0];
            led[2] <= led[1];
            led[3] <= led[2];
            led[4] <= led[3];
            led[5] <= led[4];
            led[6] <= led[5];
            led[7] <= led[6];
            led[0] <= led[7];
        end
    end


endmodule