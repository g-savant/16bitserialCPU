`default_nettype none

`include "reg_file.sv"
`include "alu.sv"
`include "types.vh"

module cpu_core(
  input logic clk, rst,
  input logic[7:0] in_bus,
  input logic data_in_ready,
  output logic data_out_ready
  output logic[7:0] out_bus,
);




endmodule