`default_nettype none

`include "core.sv"


module chipInterface(
  output logic[27:0] gp,
  input logic[27:0] gn,
);

  // logic[7:0] out_bus, in_bus;

  // logic bus_pc, bus_mar, bus_mdr, clk, rst;

  // logic ard_data_ready, ard_receive_ready, halt;

  // assign gp[27:20] = out_bus;

  // assign gp[19] = bus_pc;
  // assign gp[18] = bus_mar;
  // assign gp[17] = bus_mdr;
  // assign gp[16] = halt;


  // assign in_bus = gn[27:20];
  // assign ard_data_ready = gn[19];
  // assign ard_receive_ready = gn[18];
  // assign clk = gn[17];
  // assign rst = gn[16];
  


  // cpu_core cpu(
  //   .clk(clk),
  //   .rst(rst),
  //   .ard_data_ready(ard_data_ready),
  //   .ard_receive_ready(ard_receive_ready),
  //   .in_bus(in_bus),
  //   .out_bus(out_bus),
  //   .bus_pc(bus_pc),
  //   .bus_mar(bus_mar),
  //   .bus_mdr(bus_mdr),
  //   .halt(halt)
  // );

  assign gp = {28{1'b1}};


endmodule