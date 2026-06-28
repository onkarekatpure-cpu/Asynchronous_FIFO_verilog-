# Asynchronous FIFO using Verilog

## Overview

This project implements an **Asynchronous FIFO (First-In First-Out)** using Verilog HDL. The FIFO enables safe data transfer between two independent clock domains by using Gray code pointers and two-stage synchronizers.

The project was developed to gain practical experience in RTL design, Clock Domain Crossing (CDC), verification, and digital system design.

## Key Features

* Independent Read and Write Clocks
* Parameterized FIFO Design
* Gray Code Pointer Generation
* Full and Empty Flag Detection
* Two-Stage Synchronizers for CDC
* Self-Checking Testbench
* GTKWave Simulation Support


## Project Structure

```text
asynchronous-fifo-verilog/
│
├── async_fifo.v
├── mem.v
├── wrptr_fulllogic.v
├── rdptr_emptylogic.v
├── sync_wtr.v
├── sync_rtw.v
├── async_fifo_tb.v
│
├── waveforms/
│   └── async_fifo_waveform.png
│
└── README.md
```


## Design Description

### Memory Module

Stores FIFO data and supports independent read and write operations.

### Write Pointer Logic

* Generates binary and Gray code write pointers.
* Detects FIFO full condition.
* Updates write address during write operations.

### Read Pointer Logic

* Generates binary and Gray code read pointers.
* Detects FIFO empty condition.
* Updates read address during read operations.

### Synchronizers

Two-stage synchronizers safely transfer Gray code pointers between clock domains to reduce metastability risks.

## Verification

A self-checking testbench was created to verify FIFO functionality.

### Test Cases Performed

* Reset Verification
* Sequential Writes
* Sequential Reads
* FIFO Full Detection
* FIFO Empty Detection
* Simultaneous Read and Write Operations
* Data Integrity Verification

The testbench automatically compares expected data against actual FIFO output and reports PASS/FAIL messages.

## Simulation

### Compile

```bash
iverilog -o sim *.v
```
### Run

```bash
vvp sim
```

### View Waveforms

```bash
gtkwave async_fifo.vcd
```

## Sample Output

```text
[65000] write data = 11
[85000] write data = 22
[105000] write data = 33

[265000] PASS Read = 11
[293000] PASS Read = 22
[321000] PASS Read = 33
```

## Skills Demonstrated

* Verilog HDL
* RTL Design
* Asynchronous FIFO Design
* Clock Domain Crossing (CDC)
* Gray Code Counters
* Digital Verification
* Testbench Development
* GTKWave Analysis


## Future Improvements

* SystemVerilog Assertions (SVA)
* Functional Coverage
* UVM-Based Verification
* FPGA Implementation
* Synthesis and Timing Analysis


## Author

**Onkar Ekatpure**

Instrumentation and Control Engineering

Vishwakarma Institute of Technology (VIT), Pune
