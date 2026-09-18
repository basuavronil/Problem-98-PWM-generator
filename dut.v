module pwm (
    input  wire       clk,        // System clock
    input  wire       rst,        // Active-low reset (0 = reset, 1 = run)
    input  wire [7:0] on_time,    // Number of clock ticks the output stays HIGH (0 to 255)
    output reg        pwm_out     // PWM output signal
);

    reg [7:0] counter; // Free-running 8-bit counter (0 to 255)

    // Counter Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            counter <= 8'd0;
        end else begin
            counter <= counter + 8'd1;
        end
    end

    // Output State Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            pwm_out <= 1'b0;
        end else begin
            // Stay HIGH while counter is within the on_time limit
            pwm_out <= (counter < on_time) ? 1'b1 : 1'b0;
        end
    end

endmodule
