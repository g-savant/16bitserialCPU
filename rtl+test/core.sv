`default_nettype none

`include "reg_file.sv"
`include "alu.sv"
`include "types.vh"


//12 in 12 out
module cpu_core(
  input logic clk, rst,
  input logic ard_data_ready,
  input logic ard_recieve_ready,
  input logic[7:0] in_bus,
  input logic data_in_ready,
  output logic data_out_ready, shift_done,
  output logic[7:0] out_bus,
);




endmodule