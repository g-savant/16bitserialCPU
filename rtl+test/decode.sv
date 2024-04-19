`default_nettype none
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
        signals.rd = instruction[11:9];
        signals.rs1 = instruction[5:3];
        signals.rs2 = instruction[8:6];
        signals.m_type = instruction[15:12];
        signals.ldst = instruction[16];
        signals.addr_offset = instruction[31:17]
        signals.useAddr = 1'b1;
      end
    endcase
  end

endmodule