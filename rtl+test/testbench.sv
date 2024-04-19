`include "core.sv"

module test();

  logic clk, rst;
  logic ard_data_ready;
  logic ard_receive_ready;
  logic[7:0] in_bus;
  logic data_in_ready;
  logic data_out_ready, shift_done;
  logic[7:0] out_bus;


  cpu_core cpu(.*);

  logic[7:0][15:0] instr_memory;

  logic[7:0][15:0] data_memory;

  initial begin
    clk = 1'b0;
    forever #200 clk = ~clk;
  end



  initial begin

  end

endmodule