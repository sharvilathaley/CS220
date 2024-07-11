module ripple_leds_top;
reg clk;

wire [7:0] led;

ripple_leds uut(.clk(clk),.led(led));

always @(led[0], led[1], led[2], led[3], led[4], led[5], led[6], led[7]) begin
	$display("time=%d: clk=%b, led0=%b, led1=%b, led2=%b, led3=%b, led4=%b, led5=%b, led6=%b, led7=%b", $time, clk, led[0], led[1], led[2], led[3], led[4], led[5], led[6], led[7]);
end

initial begin
   forever begin
      clk=0;
      #1
      clk=1;
      #1
      clk=0;
   end
end

initial begin
   #500000000
   $finish;
end

endmodule