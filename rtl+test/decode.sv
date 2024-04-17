module instr_shift_register(
  input logic rst, clk,
  input logic data_ready, 
  input logic[7:0] serial_in,
  output logic[15:0] instruction,
  output logic valid, error
);

  logic[4:0] count;

  opcode_t opcode;

  always_ff @(posedge clk) begin
    if(rst) begin
      instruction <= 'd0;
      count <= 'd0;
    end else begin
      if(data_ready & count < 2) begin
        instruction <= {instruction[7:0], serial_in};
        count <= count + 1;
      end
    end
  end

  assign valid = (count == 2 & ~error);

  assign opcode = instruction[2:0];

  assign error =  (opcode != R_TYPE) & 
                  (opcode != I_TYPE) & 
                  (opcode != B_TYPE) & 
                  (opcode != J_TYPE) & 
                  (opcode != M_TYPE);

endmodule


module instruction_decode(
  input logic[15:0] instruction,
  output signals_t signals
);

  always_comb begin
    signals.opcode = instruction[2:0]
    case(signals.opcode)
      R_TYPE: begin
        signals.rs1 = instruction[5:3];
        signals.rs2 = instruction[8:6];
        signals.rd = instruction[11:9];
        signals.instr =  instruction[15:12]
        signals.is_double_word = 1'b0;
        signals.dest = REG_FILE;
      end
      I_TYPE: begin
        signals.rs1 = instruction[5:3];
        signals.rd = instruction[11:9];
        signals.dest = REG_FILE;
        signals.is_double_word = 1'b1;
        signals.useImm = 1'b1;
        signals.instr = instruction[15:12]
      end
      B_TYPE: begin
        signals.rs1 = instruction[5:3];
        signals.rs2 = instruction[8:6];
        signals.offset = instruction[12:9];
        signals.is_double_word = 1'b0;
        signals.b_type = instruction[15:13]
        
      end
      J_TYPE: begin
        signals.is_double_word = 1'b0;
        signals.offset = {instruction[15:12], instruction[8:4]};
        signals.jump_type = instructions[6];
        signals.rd = instruction[11:9];
      end
      M_TYPE: begin
        signals.is_double_word = 1'b1;
        signals.ldst = instruction[3];
        signals.m_type = instruction[6:3];
        signals.useAddr = 1'b1;
        //memory address = instruction[31:7];
      end
    endcase
  end

endmodule