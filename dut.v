module pwm(
  input clk, rst,
  input [7:0] duty,
  output reg pwm_out
);
  reg [10:0] counter;
  
  // Counter Logic
  always@(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
          counter <= 11'd0;
        end
      else begin
        if (counter == 256)
          counter <= 11'd0;
        else 
          counter <= counter + 1;
      end
    end
  
  // Duty cycle comparator output register
  always@(posedge clk or negedge rst)
    begin
      if (!rst)
        pwm_out <= 1'd0;
      else 
        pwm_out <= (counter < duty) ? 1'b1 : 1'b0;
        end
    end
endmodule
