## 98. PWM Generator (Parameterized Duty Cycle)

### Description
This module implements a digital Pulse-Width Modulation (PWM) generator with a configurable duty cycle. It uses a free-running binary counter and a digital magnitude comparator to produce a square wave output whose high-time ratio (duty cycle) is determined dynamically by the input port.

When the internal counter value is strictly less than the target duty threshold, the output stays HIGH (`1`); once the counter reaches or exceeds the threshold, the output transitions to LOW (`0`).

---

### Hardware Architecture & Waveform
## Block Diagram

```
                +--------------------+
counter [7:0] ->|                    |
                | Magnitude Comp.    |---> Comparator Output
on time [7:0] ->| (counter < on time)|      (Select Line)
                +--------------------+           |
                                                 v
                                          +-----------+
                       1'b1 ------------->| 1         |
                                          |   2:1 MUX |---> pwm_out (reg)
                       1'b0 ------------->| 0         |
                                          +-----------+
```
## Block Diagram
just make this graphical ... and in a copyablw way for github

### Ports

| Port      | Direction | Width  | Description                          |
|-----------|-----------|--------|---------------------------------------|
| `clk`     | Input     | 1 bit  | System clock                          |
| `rst`     | Input     | 1 bit  | Active-high reset                     |
| `on time` | Input     | 8 bits | Duty cycle threshold value            |
| `pwm_out` | Output    | 1 bit  | Generated PWM signal (registered)     |

### Internal Registers

| Register  | Width  | Description                                              |
|-----------|--------|------------------------------------------------------------|
| `counter` | 8 bits | Free-running up-counter, counts 0 to 255, wraps on overflow |### Duty Cycle Calculation

The duty cycle percentage is given by the formula:

$$\text{Duty Cycle (\%)} = \left( \frac{\text{duty}}{256} \right) \times 100$$

* **`duty = 8'd0`** $\rightarrow$ **0% Duty Cycle** (Output remains continuously LOW)
* **`duty = 8'd64`** $\rightarrow$ **25% Duty Cycle**
* **`duty = 8'd128`** $\rightarrow$ **50% Duty Cycle** (Balanced square wave)
* **`duty = 8'd192`** $\rightarrow$ **75% Duty Cycle**
* **`duty = 8'd255`** $\rightarrow$ **99.6% Duty Cycle**

---

## Output 
### Simulation Terminal 
<img width="645" height="303" alt="image" src="https://github.com/user-attachments/assets/555ee09f-85d1-4341-a2de-b76b830e2946" />
### Waveform
<img width="926" height="273" alt="image" src="https://github.com/user-attachments/assets/4d2f7097-e54f-4619-b28c-c85ba00f319e" />

### PWM Signal Timing Diagram (`on_time = 3`)
<img width="503" height="100" alt="image" src="https://github.com/user-attachments/assets/c96f38a5-48cb-4b25-b08a-20ab35d946da" />

<img width="500" height="161" alt="image" src="https://github.com/user-attachments/assets/024686a3-4769-4895-ba5b-ec43287a38ca" />




