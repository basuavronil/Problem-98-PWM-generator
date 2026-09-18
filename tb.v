`timescale 1ns / 1ps

module tb_pwm;

    // Testbench Signals
    reg        clk;
    reg        rst;
    reg  [7:0] duty;
    wire       pwm_out;

    // Instantiate the Unit Under Test (UUT)
    pwm uut (
        .clk(clk),
        .rst(rst),
        .duty(duty),
        .pwm_out(pwm_out)
    );

    // Clock Generation (100 MHz clock -> 10ns period)
    always #5 clk = ~clk;

    // Main Stimulus and Execution
    initial begin
        // Initialize Inputs
        clk  = 0;
        rst  = 0; // Active-low reset asserted
        duty = 0;

        // Waveform Dumping (.vcd for GTKWave / EDA Playground)
        $dumpfile("pwm_waveform.vcd");
        $dumpvars(0, tb_pwm);

        // Terminal Monitoring
        $monitor("Time = %0t ns | rst = %b | duty = %3d | pwm_out = %b", 
                 $time, rst, duty, pwm_out);

        // --- Step 1: Assert Reset ---
        #20;
        rst = 1; // De-assert reset (active-low)
        #10;

        // --- Step 2: Test 25% Duty Cycle (duty = 64) ---
        duty = 8'd64;
        #(256 * 10 * 2); // Run for 2 full PWM cycles (256 counts * 10ns clock * 2)

        // --- Step 3: Test 50% Duty Cycle (duty = 128) ---
        duty = 8'd128;
        #(256 * 10 * 2);

        // --- Step 4: Test 75% Duty Cycle (duty = 192) ---
        duty = 8'd192;
        #(256 * 10 * 2);

        // --- Step 5: Test 0% Duty Cycle (duty = 0) ---
        duty = 8'd0;
        #(256 * 10);

        // --- Step 6: Test ~100% Duty Cycle (duty = 255) ---
        duty = 8'd255;
        #(256 * 10);

        $display("\n--- Simulation Complete ---");
        $finish;
    end

endmodule
