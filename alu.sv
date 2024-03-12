`default_nettype none
`include types.vh

module alu(
input alu_op_t,
input logic[7:0] alu_input1, alu_input2,
output logic[15:0] result);

always_comb
  unique case (alu_op_t)
    ALU_ADD: result = alu_input1 + alu_input2;
    ALU_SUB: result = alu_input1 + twos_comp_alu_input2;
    ALU_LUI: result = alu_input2;
    ALU_SLL: result = alu_input1 << (alu_input2 & 16'h1F);
    ALU_SRL: result = alu_input1 >> (alu_input2 & 16'h1F);
    ALU_SRA: result = $signed(alu_input1) >>> (alu_input2 & 16'h1F);
    ALU_AUIPC: result = alu_input1 + alu_input2;
    ALU_SLT: result = ($signed(alu_input1) < $signed(alu_input2)) ? 16'b1 : 16'b0;
    ALU_SLTU: result = (alu_input1 < alu_input2) ? 16'b1 : 16'b0;
    ALU_XOR: result = alu_input1 ^ alu_input2;
    ALU_OR: result = alu_input1 | alu_input2;
    ALU_AND: result = alu_input1 & alu_input2;
    default: result = 'bx;
  
  endcase
endmodule