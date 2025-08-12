# Sequential 2x2 Matrix Multiplier

This project implements a **sequential 2x2 matrix multiplier** in Verilog. The design uses a single **Multiply-Accumulate (MAC) unit** controlled by a finite state machine (FSM) to compute the product of two 2x2 matrices over multiple clock cycles efficiently.

---

## Design Overview

- **MAC Unit:** Multiplies two 8-bit inputs and accumulates the result.
- **Control FSM:** Sequences multiply-accumulate operations for all four output matrix elements.
- **Registers:** Store input matrices and output results.
- **Done Signal:** Indicates when multiplication is complete.

This design demonstrates resource-efficient matrix multiplication by reusing hardware sequentially instead of fully parallel combinational logic.

---

## Files

- `matrix_mul_2x2_seq.v` — Sequential matrix multiplier RTL code.
- `tb_matrix_mul_2x2_seq.v` — Testbench for functional verification.
- (Optional) `waveform.vcd` — Waveform dump file generated after simulation.

---

## Simulation Instructions

### Using Icarus Verilog:

1. Compile the design and testbench:

    ```bash
    iverilog -o matrix_seq_tb.vvp matrix_mul_2x2_seq.v tb_matrix_mul_2x2_seq.v
    ```

2. Run the simulation:

    ```bash
    vvp matrix_seq_tb.vvp
    ```

3. The testbench will print output matrix values for multiple test cases to the console, for example:

    ```
    Test 1 done: c11=1 c12=2 c21=3 c22=4
    Test 2 done: c11=8 c12=8 c21=8 c22=8
    Test 3 done: c11=38 c12=66 c21=22 c22=23
    ```

4. To view waveforms, open GTKWave:

    ```bash
    gtkwave matrix_seq_tb.vcd
    ```

    You can see signal transitions, control FSM states, and data flow over time.

---

## How to Interpret Outputs

- **Console Outputs:** The testbench prints the final values of the output matrix elements (`c11`, `c12`, `c21`, `c22`) after each test.
- **Waveform Viewer:** The `.vcd` file allows visualization of signals like input registers, MAC operation start/done, FSM states, and output registers over time, helping debug and understand the design's sequential behavior.

---

## Future Work

- Extend to larger matrix sizes.
- Implement pipelined systolic array architectures.
- Add interface support for streaming inputs.

---

Feel free to open issues or contribute improvements!

---




