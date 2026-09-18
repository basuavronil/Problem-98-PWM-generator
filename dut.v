module pwm (
    input  wire       clk,      
    input  wire       rst,      // Active-low reset (0 = reset, 1 = run)
    input  wire [7:0] duty,     // 8-bit duty threshold (0 to 255)
    output reg        pwm_out   
);

    reg [7:0] counter; // 8-bit counter naturally counts 0-255

    // Counter Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            counter <= 8'd0;
        end else begin
            counter <= counter + 8'd1; // Auto-overflows from 255 back to 0
        end
    end

    // Duty cycle comparator logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            pwm_out <= 1'b0;
        end else begin
            pwm_out <= (counter < duty) ? 1'b1 : 1'b0;
        end
    end

endmodule
