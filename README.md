# Implementation description:
Nick Smith and Alan Rolla <br>
ECE:3350  <br>
Project - Part 1 <br>

  Implementation description goes here <br>


Overview of the SISC Processor Architecture<br>
This Simple Instruction Set Computer (SISC) is a multi-cycle RISC computer with separate<br>
memory for instructions and data, with the following characteristics:<br>
Word length: 32 bit<br>
Bit ordering: little endian<br>
General purpose registers: 16 x 32 bits<br>
Program counter: 16 bits<br>
Instruction/data space: 2^16 = 64 kilo-words = 64 KW<br>
Addressing resolution: 32 bit word<br>
Byte ordering: little endian<br>
Instruction set: LOAD/STORE-architecture<br>
Register operand length: 32 bit<br>
Immediate operand length: 16 bit<br>
Clock rate: 1 cycle / 10 ns<br>
Cycles per instruction: 5 CPI<br>
Addressing modes: immediate<br>
register-direct<br>
register-indirect<br>
index<br>
absolute<br>
auto pre-increment<br>
auto post-decrement<br>
