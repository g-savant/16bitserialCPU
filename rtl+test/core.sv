`default_nettype none

`include "reg_file.sv"
`include "alu.sv"
`include "types.vh"
`include "control.sv"
`include "components.sv"
`include "decode.sv"


//12 in 12 out
module cpu_core(
  input logic clk, rst,
  input logic ard_data_ready,
  input logic ard_receive_ready,
  input logic[7:0] in_bus,
  input logic data_in_ready,
  output logic data_out_ready, shift_done,
  output logic[7:0] out_bus,
);


logic pc_en, error;

logic[2:0] aluinp1_sel, aluinp2_sel;

logic[15:0] alu_input1, alu_input2, alu_result;

logic valid_instr, error_instr;

logic[15:0] instr, mdr_in, mdr_out, mar_in, mar_out, pc, in_pc;

logic[15:0] alu_pc, pc_next, pc_offset;

logic[15:0] rs1_data, rs2_data, rd_data;

ctrl_sig_t ctrl;

dec_sig_t dec;
//declare components



control ctrl( .clk(clk),
              .rst(rst),
              .done(),
              .ard_data_ready(ard_data_ready),
              .ard_receive_ready(ard_receive_ready),
              .signals(dec),
              .ctrl(ctrl));

decode dec(.instruction(instr),
           .signals(dec));

reg_file rf(.clk(clk),
            .rst(rst),
            .rs1(dec.rs1),
            .rs2(dec.rs2),
            .rd(dec.rd),
            .rd_data(rd_data),
            .rs1_data(rs1_data),
            .rs2_data(rs2_data));

instr_shift_register dec( .clk(clk),
                          .rst(rst),
                          .serial_in(in_bus),
                          .instruction(instr),
                          .valid(valid_instr),
                          .error(error_instr));


alu alu(.alu_input1(alu_input1),
        .alu_input2(alu_input2),
        .op(dec.alu_op),
        .result(alu_result));

eight_bit_spispo pc_shift_reg(.clk(clk),
                             .rst(rst),
                             .load(pc_en),
                             .shift_out(ctrl.pc_shift_out),
                             .shift_in(1'b0),
                             .serial_in(8'b0),
                             .prll_in(in_pc),
                             .prll_out(pc),
                             .serial_out(out_bus),
                             .error(error));

eight_bit_spispo mdr_shift_reg(.clk(clk),
                             .rst(rst),
                             .load(ctrl.mdr_load),
                             .shift_out(ctrl.mdr_shift_out),
                             .shift_in(ctrl.mdr_shift_in),
                             .serial_in(bus_in),
                             .prll_in(mdr_in),
                             .prll_out(mdr_out),
                             .serial_out(out_bus),
                             .error(error));

eight_bit_spispo mar_shift_reg(.clk(clk),
                              .rst(rst),
                              .load(ctrl.mar_load),
                              .shift_out(ctrl.mar_shift_out),
                              .shift_in(1'b0),
                              .serial_in(8'b0),
                              .prll_in(mar_in),
                              .prll_out(mar_out),
                              .serial_out(out_bus),
                              .error(error));

//minor components

always_comb begin
  case(dec.opcode)
    R_TYPE: begin
      alu_input1 = rs1_data;
      alu_input2 = rs2_data;
    end
    I_TYPE: begin
      alu_input1 = rs1_data;
      alu_input2 = dec.useImm ? instr[11:0] : rs2_data;
    end
    B_TYPE: begin
      alu_input1 = rs1_data;
      alu_input2 = rs2_data;
    end
    J_TYPE: begin
      alu_input1 = pc;
      alu_input2 = dec.offset;
    end
    M_TYPE: begin
      if(ldst == LOAD) begin
        alu_input1 = rs1_data;
        alu_input2 = dec.addr_offset;
      end else if(ldst == STORE) begin
        alu_input1 = rs1_data; 
        alu_input2 = dec.addr_offset;
      end
    end
  endcase

  mdr_in = (dec.opcode == M_TYPE) ? rs2_data : alu_result;
  
  mar_in = alu_result;

  //3 cases, pc is set to value in jump, pc is pc + offset ( branch), pc is pc+4
  pc_offset = (dec.opcode == B_TYPE) ? dec.addr_offset : 4; //jump will have pure address

  pc_in = (dec.opcode == J_TYPE) ? offset: pc + pc_offset;
end






endmodule