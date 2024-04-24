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
  logic[15:0] pc, store_address, load_data;
  // function make_instr(opcode_t opcode, logic[2:0] rd, logic[2:0] rs1, logic[2:0] rs2, opcode_t type);
  //   return {opcode, rd, rs1, rs2, type};
  // endfunction
  // task pc_to_instr;
  //   // logic[15:0] pc, store_address, load_data;
  //   @(posedge clk);
  //   ard_receive_ready <= 1'b1;
  //   @(posedge clk)
  //   pc <= {out_bus, pc[15:8]};
  //   @(posedge clk)
  //   pc <= {out_bus, pc[15:8]};
  //   @(posedge clk)
  //   ard_data_ready <= 1'b1;
  //   in_bus <= instr_memory[pc][7:0];
  //   @(posedge clk);
  // endtask

  // task send_data;
  // endtask

  // task read_mar_mdr;
  // endtask

  // task send_program;
  // endtask

  task test_add(logic signed[15:0] a, logic signed [15:0] b, logic[15:0] addr);
    logic signed [15:0] result;
    logic[31:0] instruction;

    //setup memory
    result = a + b;
    instr_memory[0] = {ADD, 3'd1, 3'd0, 3'd0, I_TYPE};
    instr_memory[1] = a;
    instr_memory[2] = {ADD, 3'd2 , 3'd0, 3'd0, I_TYPE};
    instr_memory[3] = b;
    instr_memory[4] = {ADD, 3'd3, 3'd1 , 3'd2, R_TYPE};
    instr_memory[5] = {SW, 3'd0, 3'd3, 3'd0, M_TYPE};
    instr_memory[6] = addr;
    instr_memory[7] = {'b0, SYS_END};



    rst <= 1'b0;
    ard_receive_ready <= 1'b0;
    ard_data_ready <= 1'b0;
    pc <= 'd0;
    in_bus <= 'd0;
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
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc + 1][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc + 1][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b0;
    @(posedge clk);
    ard_receive_ready <= 1'b1;
    @(posedge clk);
    while(~bus_pc) @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][7:0];
    assert(pc == 2)
    else $error ("Failed assertion! PC should be 2 but is %d", pc);
    @(posedge clk)
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc+1][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc+1][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b0;
    ard_receive_ready <= 1'b1;
    @(posedge clk);
    while(~bus_pc) @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    assert(pc == 4)
    else $error ("Failed assertion! PC should be 4 but is %d", pc);
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
    else $error ("Failed assertion! PC should be 5 but is %d", pc);
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
    data_memory[store_address] <= load_data;
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
    else $error ("Failed assertion! Memory at address %h should be %b but is %b", addr, result, $signed(data_memory[store_address]));

    $display("Add Test Case Passed!! Memory at address %h was %d, which is %d + %d.", addr, $signed(data_memory[store_address]), a, b);
  endtask

  task test_sub(logic signed[15:0] a, logic signed [15:0] b, logic[15:0] addr);
    logic signed [15:0] result;
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
    result = a - b;
    instr_memory[0] = {SUB, 3'd1, 3'd0, 3'd0, I_TYPE};
    instr_memory[1] = a;
    instr_memory[2] = {SUB, 3'd2 , 3'd0, 3'd0, I_TYPE};
    instr_memory[3] = b;
    instr_memory[4] = {SUB, 3'd3, 3'd1 , 3'd2, R_TYPE};
    instr_memory[5] = {SW, 3'd0, 3'd3, 3'd0, M_TYPE};
    instr_memory[6] = addr;
    instr_memory[7] = {'b0, SYS_END};



    rst <= 1'b0;
    ard_receive_ready <= 1'b0;
    ard_data_ready <= 1'b0;
    pc <= 'd0;
    in_bus <= 'd0;
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
    ard_receive_ready <= 1'b1;
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][7:0];
    assert(pc == 0)
    else $display ("Failed assertion! PC should be 0 but is %d", pc);
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc + 1][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc + 1][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b0;
    @(posedge clk);
    ard_receive_ready <= 1'b1;
    @(posedge clk);
    while(~bus_pc) @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][7:0];
    assert(pc == 2)
    else $error ("Failed assertion! PC should be 2 but is %d", pc);
    @(posedge clk)
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc+1][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc+1][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b0;
    ard_receive_ready <= 1'b1;
    @(posedge clk);
    while(~bus_pc & ~bus_mar & ~bus_mdr) @(posedge clk);
    if(bus_mar | bus_mdr) $error("wrong flag");
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    pc <= {out_bus, pc[15:8]};
    @(posedge clk)
    assert(pc == 4)
    else $error ("Failed assertion! PC should be 4 but is %d", pc);
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
    else $error ("Failed assertion! PC should be 5 but is %d", pc);
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
    data_memory[store_address] <= load_data;
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
    ard_data_ready <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    assert(data_memory[store_address] == result)
    else $error ("Failed assertion! Memory at address %h should be %b but is %b", addr, result, $signed(data_memory[store_address]));

    $display("Subtract Test Case Passed!! Memory at address %h was %d, which is %d - %d.", addr, $signed(data_memory[store_address]), a, b);
  endtask


  task test_store(logic[15:0] val, logic[15:0] addr);
    instr_memory[0] = {ADD, 3'd1, 3'd0, 3'd0, I_TYPE};
    instr_memory[1] = val;
    instr_memory[2] = {SW, 3'd0, 3'd3, 3'd0, M_TYPE};
    instr_memory[3] = addr;
    instr_memory[4] = {'b0, SYS_END};
  endtask

  task test_load(logic[15:0] load_addr, logic[2:0] rd, logic signed[15:0] check_val);
    logic[15:0] addr;
    instr_memory[0] = {LW, rd, 3'd0, 3'd0, M_TYPE};
    instr_memory[1] = load_addr;
    instr_memory[2] = {'b0, SYS_END};
    rst <= 1'b0;
    @(posedge clk);
    rst <= 1'b1;
    @(posedge clk);
    rst <= 1'b0;
    @(posedge clk)
    ard_receive_ready <= 1'b1;
    while(~bus_pc) @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk);
    pc <= {out_bus, pc[15:8]};
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][7:0];
    assert(pc == 0)
    else $display ("Failed assertion! PC should be 0 but is %d", pc);
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc + 1][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= instr_memory[pc + 1][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b0;
    ard_receive_ready <= 1'b1;
    while(~bus_mar) @(posedge clk);
    addr <= {out_bus, addr[15:8]};
    @(posedge clk);
    
    addr <= {out_bus, addr[15:8]};
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= data_memory[addr][7:0];
    @(posedge clk);
    ard_data_ready <= 1'b1;
    in_bus <= data_memory[addr][15:8];
    @(posedge clk);
    ard_data_ready <= 1'b0;
    while(~bus_pc) @(posedge clk);
    if(bus_mar | bus_mdr) $error("wrong flag");
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
    ard_data_ready <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    assert(cpu.rf.reg_file[rd] == check_val)
    else $error ("Failed assertion! Register 8 should be %d but is %d", check_val, cpu.rf.reg_file[rd]);
  endtask
  cpu_core cpu(.*);



  initial begin
    clk = 1'b0;
    forever #200 clk = ~clk;
  end

  initial begin
    //ALU OPS
    $display("%b", I_TYPE);
    // test_add(16'd1, 16'd2, 16'd3);
    // test_add(16'd5, 16'd6, 16'd10);
    // test_add(-16'd1, -16'd2, 16'd12);
    // test_add(-100, -100, 16'd15);
    
    // test_sub(16'd1, 16'd1, 16'd3);
    // test_sub(16'd3, 16'd2, 16'd3);
    // test_sub(16'd6, 16'd2, 16'd5);
    // test_sub(16'd7, 16'd3, 16'd6);
    test_sub(16'd0, 16'd3, 16'd6);

    test_load(16'd6, 16'd7, -16'd3);

    //MEM_TYPE
    // test_store(),
    // test_load(),
    // test_store(),
    // test_load(),

    // $display ("-----------------")
    // $display("|All tests passed!|")
    // $display ("-----------------")
    $finish;
  end
endmodule