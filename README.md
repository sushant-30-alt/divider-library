# 4-Bit Unsigned Divider — Restoring Division Algorithm

## Overview

This repository contains a **4-bit unsigned binary divider** implemented in Verilog HDL using the restoring division algorithm. The design is developed and verified using Xilinx Vivado.

The divider accepts two 4-bit unsigned inputs and produces a 4-bit quotient, a 4-bit remainder, and a division-by-zero status flag. The synthesizable RTL implements the division algorithm without using the Verilog division (`/`) or modulo (`%`) operators.

The project demonstrates combinational arithmetic design, algorithm-based RTL implementation, exhaustive functional verification, and FPGA synthesis analysis.

## Objectives

- Implement a 4-bit unsigned divider using the restoring division algorithm.
- Generate the quotient and remainder using combinational RTL.
- Detect division-by-zero conditions.
- Verify all possible combinations of the two 4-bit inputs.
- Analyze the synthesized schematic, LUT utilization, and LUT INIT values in Vivado.
- Develop a reusable divider module for larger digital systems.

## Repository Structure

```text
divider-library/
├── rtl/
│   └── divider_4bit.v
├── tb/
│   └── tb_divider_4bit.v
├── reports/
│   └── divider.docx
└── README.md
```

## Design Specifications

| Signal | Width | Description |
|---|---:|---|
| `A` | 4 bits | Dividend |
| `B` | 4 bits | Divisor |
| `Quotient` | 4 bits | Integer quotient |
| `Remainder` | 4 bits | Remainder after division |
| `DivideByZero` | 1 bit | Division-by-zero status flag |

The divider operates on unsigned operands ranging from 0 to 15.

## Restoring Division Algorithm

The restoring division algorithm processes the dividend from its most significant bit to its least significant bit.

At each iteration:

1. Shift the partial remainder and bring in the next dividend bit.
2. Compare the partial remainder with the divisor.
3. If the partial remainder is greater than or equal to the divisor, subtract the divisor and set the corresponding quotient bit to 1.
4. Otherwise, retain the partial remainder and set the quotient bit to 0.

The process continues until all four dividend bits have been processed. The final quotient and remainder are then available at the outputs.

The implementation uses intermediate remainder storage wide enough to preserve the value during shifting.

## Mathematical Relations

For a nonzero divisor:

\[
Q = \left\lfloor \frac{A}{B} \right\rfloor
\]

\[
R = A - (B \times Q)
\]

The quotient and remainder satisfy:

\[
A = (B \times Q) + R
\]

subject to:

\[
B \neq 0,\qquad 0 \le R < B
\]

These equations describe the mathematical behavior. The synthesizable RTL uses the restoring division algorithm rather than the `/` and `%` operators.

### Division-by-Zero Handling

When `B = 0`:

- `DivideByZero = 1`
- `Quotient = 0`
- `Remainder = 0`

When `B != 0`, `DivideByZero = 0`.

## Functional Verification

The divider was verified using a Verilog testbench in Xilinx Vivado.

**Recorded verification result:**

```text
PASS: All 256 divider test cases passed!
```

The testbench exhaustively tested all 256 combinations of the two 4-bit inputs, including all 16 cases where the divisor is zero.

The division and modulo operators were used only in the testbench to calculate reference results, not in the synthesizable divider RTL.

### Example Test Case

| Parameter | Value |
|---|---:|
| Dividend (`A`) | 6 |
| Divisor (`B`) | 3 |
| Expected quotient | 2 |
| Expected remainder | 0 |
| `DivideByZero` | 0 |

The simulation waveform for this case demonstrates the quotient, remainder, and status outputs for a valid division operation.

## FPGA Synthesis Results

The design was synthesized in Xilinx Vivado for the target FPGA recorded in the project synthesis results.

| Parameter | Recorded result |
|---|---:|
| Total cells | 50 |
| I/O ports | 17 |
| Nets | 58 |
| LUT count | 24 |

These values correspond to the recorded synthesis run and may vary with the FPGA target, synthesis settings, or RTL modifications.

## LUT INIT Analysis

The LUT INIT values were extracted from the Vivado Tcl Console after synthesis.

### Division-by-Zero Detection

| LUT cell | INIT value |
|---|---|
| `DivideByZero_OBUF_inst_i_1` | `16'h0001` |

### Quotient Logic

| LUT cell | INIT value |
|---|---|
| `Quotient_OBUF[0]_inst_i_4` | `64'hB6FF2400F000F000` |
| `Quotient_OBUF[0]_inst_i_5` | `64'h791873738A8A8888` |
| `Quotient_OBUF[0]_inst_i_6` | `64'hFBAAFFFB00000000` |
| `Quotient_OBUF[0]_inst_i_7` | `64'hA200AAA200000000` |
| `Quotient_OBUF[1]_inst_i_1` | `4'h2` |
| `Quotient_OBUF[1]_inst_i_2` | `64'h94DDD0880480D088` |
| `Quotient_OBUF[2]_inst_i_1` | `64'h0000000040445000` |
| `Quotient_OBUF[3]_inst_i_1` | `32'h00001000` |

### Remainder Logic

| LUT cell | INIT value |
|---|---|
| `Remainder_OBUF[0]_inst_i_4` | `64'h49CC24CC00000000` |
| `Remainder_OBUF[0]_inst_i_5` | `64'h86FF75FF18008A00` |
| `Remainder_OBUF[0]_inst_i_6` | `64'h02FFFFFFDC000000` |
| `Remainder_OBUF[0]_inst_i_7` | `64'h2FFFFFFF40000000` |
| `Remainder_OBUF[1]_inst_i_4` | `64'h1080806000000000` |
| `Remainder_OBUF[1]_inst_i_5` | `64'h1B4B57D7A0208828` |
| `Remainder_OBUF[1]_inst_i_6` | `64'h55A5FFFF88480000` |
| `Remainder_OBUF[1]_inst_i_7` | `64'h59FFFFFF00000000` |
| `Remainder_OBUF[2]_inst_i_1` | `32'hAFA0C0C0` |
| `Remainder_OBUF[2]_inst_i_2` | `64'h22B2FFFF00000000` |
| `Remainder_OBUF[2]_inst_i_3` | `64'hD4DDFFFF00000000` |
| `Remainder_OBUF[2]_inst_i_4` | `64'h0C046D0482800080` |
| `Remainder_OBUF[3]_inst_i_1` | `16'hE200` |
| `Remainder_OBUF[3]_inst_i_2` | `64'h1055001000000000` |
| `Remainder_OBUF[3]_inst_i_3` | `64'h75FF557500000000` |

The INIT values represent the truth-table configurations of the LUTs inferred by Vivado for the recorded synthesis run. They depend on logic mapping, LUT input assignments, target FPGA, and synthesis settings.

## Tools Used

- Verilog HDL
- Xilinx Vivado
- RTL behavioral simulation
- Self-checking testbench
- FPGA synthesis and schematic inspection
- LUT INIT analysis

## Project Report

The detailed report is available in the `reports/` directory:

**[`divider.docx`](reports/divider.docx)**

It includes the design objective, theory, mathematical relations, verification output, example waveform, synthesized schematic, synthesis statistics, and extracted LUT INIT values.

## Author

Sushant

*An educational digital design project focused on algorithm-based RTL implementation, combinational arithmetic, functional verification, and FPGA synthesis.*
