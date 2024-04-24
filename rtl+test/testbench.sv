`include "core.sv"

module test();

  logic clk, rst;
  logic ard_data_ready;
  logic ard_receive_ready;
  logic[7:0] in_bus;
  logic[7:0] out_bus;
  logic bus_pc, bus_mar, bus_mdr;

  logic[15:0][15:0] instr_memory;

  logic[15:0][15:0] data_memory;

  // function make_instr(opcode_t opcode, logic[2:0] rd, logic[2:0] rs1, logic[2:0] rs2, opcode_t type);
  //   return {opcode, rd, rs1, rs2, type};
  // endfunction
  task pc_to_instr;
  endtask

  task send_data;
  endtask

  task read_mar_mdr;
  endtask

  task test_add(logic signed[15:0] a, logic signed [15:0] b);
    logic[15:0] result = a + b;
    logic[15:0] pc, store_address, load_data;
    // instr_memory = {{a, ADD, 3'd1, 3'd0, 3'd0, I_TYPE},
    //                 {b, ADD, 3'd2 , 3'd0, I_TYPE},
    //                 {ADD, 3'd3, 3'd1 , 3'd2, R_TYPE},
    //                 {15'd0, SW, 3'd0, 3'd3, 3'd0, M_TYPE},
    //                 {'b0, SYS_END}};
    logic[31:0] instruction;
    // instr_memory = {{'b0, SYS_END}, 
    //                 {15'd0, SW, 3'd0, 3'd3, 3'd0, M_TYPE},
    //                 {ADD, 3'd3, 3'd1 , 3'd2, R_TYPE},
    //                 {b, ADD, 3'd2 , 3'd0, 3'd0, I_TYPE},
    //                 {a, ADD, 3'd1, 3'd0, 3'd0, I_TYPE}};

    //setup memory
    instr_memory[0] = {ADD, 3'd1, 3'd0, 3'd0, I_TYPE};
    instr_memory[1] = a;
    instr_memory[2] = {ADD, 3'd2 , 3'd0, 3'd0, I_TYPE};
    instr_memory[3] = b;
    instr_memory[4] = {ADD, 3'd3, 3'd1 , 3'd2, R_TYPE};
    instr_memory[5] = {SW, 3'd0, 3'd3, 3'd0, M_TYPE};
    instr_memory[6] = 15'd0;
    instr_memory[7] = {'b0, SYS_END};



    rst <= 1'b0;
    ard_receive_ready <= 1'b0;
    ard_data_ready <= 1'b0;
    pc <= 'd0;
    in_bus <= 'd0;
    // assign instruction =  {a, ADD, 3'd1, 3'd0, 3'd0, I_TYPE};
    // $display("instr %b", instruction[15:0]);
    // $display("imm %b", instruction[31:16]);
    @(posedge clk)
    rst <= 1'b1;
    @(posedge clk)
    rst <= 1'b0;
    ard_receive_ready <= 1'b1;
    @(posedge clk)
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][7:0];
    assert(pc == 0)
    else $display ("Failed assertion! PC should be 0 but is %d", pc);
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][15:8];
    $display("instr: %b", instr_memory[pc]);
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc + 1][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc + 1][15:8];
    $display("decoded instruction %b", (cpu.instr));
    @(posedge clk);
    ard_data_ready <= 1'b0;
    @(posedge clk);
    ard_receive_ready <= 1'b1;
    @(posedge clk);
    while(~bus_pc) @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    pc <= {out_bus, pc[15:8]};
    // assert(pc == 2);
    @(posedge clk)
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][7:0];
    assert(pc == 2)
    else $display ("Failed assertion! PC should be 2 but is %d", pc);
    @(posedge clk)
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc+1][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc+1][15:8];
    $strobe("decoded instruction %b", (cpu.instr));
    @(posedge clk);
    ard_data_ready <= 1'b0;
    ard_receive_ready <= 1'b1;
    @(posedge clk);
    while(~bus_pc) @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    pc <= {out_bus, pc[15:8]};
    // assert(pc == 4);
    @(posedge clk)
    assert(pc == 4)
    else $display ("Failed assertion! PC should be 4 but is %d", pc);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][7:0];
    @(posedge clk)
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b0;
    @(posedge clk);
    ard_receive_ready <= 1'b1;
    @(posedge clk);
    while(~bus_pc) @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk);
    assert(pc == 5)
    else $display ("Failed assertion! PC should be 5 but is %d", pc);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc+1][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc+1][15:8];
    $display("decoded instruction %b", (cpu.instr));
    @(posedge clk);
    ard_data_ready <= 1'b0;
    @(posedge clk);
    ard_receive_ready <= 1'b1;
    @(posedge clk);
    while(~bus_mar) @(posedge clk);
    store_address <= {out_bus, store_address[15:8]};
    @(posedge clk);
    store_address <= {out_bus, store_address[15:8]};
    @(posedge clk);
    load_data <= {out_bus, load_data[15:8]};
    @(posedge clk);
    load_data <= {out_bus, load_data[15:8]};
    @(posedge clk);
    while(~bus_pc) @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][15:8];
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    assert(data_memory[store_address] == result)
    else $display ("Failed assertion! Memory should be 3 but is %d", data_memory[store_address]);
  endtask

  cpu_core cpu(.*);



  initial begin
    clk = 1'b0;
    forever #200 clk = ~clk;
  end

  initial begin
    $display("%b", I_TYPE);
    test_add(16'd1, 16'd2);
    $finish;
  end
endmodule