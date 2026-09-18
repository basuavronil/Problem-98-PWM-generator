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

| Signal Name | New Name | Meaning |
| :--- | :--- | :--- |
| `duty` | **`on_time`** | Number of clock cycles the output stays **HIGH** (1) out of 256. |
| *(Implicit)* | **`256 - on_time`** | Number of clock cycles the output stays **LOW** (0) out of 256. |

---

### **2. Updated Testbench with Terminal Monitor**

```verilog
`timescale 1ns / 1ps

module tb_pwm;

    // Testbench Signals
    reg        clk;
    reg        rst;
    reg  [7:0] on_time;
    wire       pwm_out;

    // Instantiate Unit Under Test (UUT)
    pwm uut (
        .clk(clk),
        .rst(rst),
        .on_time(on_time),
        .pwm_out(pwm_out)
    );

    // Clock Generation (100 MHz clock -> 10ns period)
    always #5 clk = ~clk;

    // Main Test Execution
    initial begin
        // Initialize Inputs
        clk     = 0;
        rst     = 0; // Assert Active-low reset
        on_time = 0;

        // Waveform Dumping
        $dumpfile("pwm_waveform.vcd");
        $dumpvars(0, tb_pwm);

        // Terminal Monitoring - Easily track ON vs OFF duration
        $monitor("Time = %0t ns | rst = %b | ON Ticks = %3d | OFF Ticks = %3d | pwm_out = %b", 
                 $time, rst, on_time, (256 - on_time), pwm_out);

        // De-assert reset
        #20;
        rst = 1;
        #10;

        // --- Test 1: 50% Duty (128 ticks ON, 128 ticks OFF) ---
        on_time = 8'd128;
        #(256 * 10 * 2); // Observe 2 complete PWM cycles

        // --- Test 2: 25% Duty (64 ticks ON, 192 ticks OFF) ---
        on_time = 8 me= 8'd64;
        #(256 * 10 * 2);

        // --- Test 3: 75% Duty (192 ticks ON, 64 ticks OFF) ---
        on_time = 8'd192;
        #(256 * 10 * 2);

        $display("\n--- Simulation Complete ---");
        $finish;
    end

endmodule
