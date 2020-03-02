# Implementation description:
Nick Smith and Alan Rolla /n
ECE:3350  <br>
Project - Part 1

  Implementation description goes here 


Overview of the SISC Processor Architecture
This Simple Instruction Set Computer (SISC) is a multi-cycle RISC computer with separate
memory for instructions and data, with the following characteristics:
Word length: 32 bit
Bit ordering: little endian
General purpose registers: 16 x 32 bits
Program counter: 16 bits
Instruction/data space: 2^16 = 64 kilo-words = 64 KW
Addressing resolution: 32 bit word
Byte ordering: little endian
Instruction set: LOAD/STORE-architecture
Register operand length: 32 bit
Immediate operand length: 16 bit
Clock rate: 1 cycle / 10 ns
Cycles per instruction: 5 CPI
Addressing modes: immediate
register-direct
register-indirect
index
absolute
auto pre-increment
auto post-decrement
