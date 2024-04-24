`default_nettype none
`include "types.vh"

module top;


  logic clk, rst, valid, err, data_ready;
  logic[7:0] in_bus;
  logic[15:0] instr, imm;
  logic[31:0] instruction;

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end
  assign instruction = {16'd1, ADD, 3'd1, 3'd0, 3'd0, I_TYPE};
  

  initial begin
    rst <= 1'b0;
    data_ready <= 1'b0;
    @(posedge clk);
    rst <= 1'b1;
    @(posedge clk);
    rst <= 1'b0;
    data_ready <= 1'b1;
    in_bus <= instruction[7:0];
    @(posedge clk);
    data_ready <= 1'b1;
    in_bus <= instruction[15:8];
    @(posedge clk);
    data_ready <= 1'b1;
    in_bus <= instruction[23:16];
    @(posedge clk);
    data_ready <= 1'b1;
    in_bus <= instruction[31:24];
    @(posedge clk);
    data_ready <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    $finish;
  end
  




instr_shift_register instr_shift( .clk(clk),
                          .rst(rst),
                          .serial_in(in_bus),
                          .instruction(instr),
                          .valid(valid),
                          .error(err),
                          .data_ready(data_ready),
                          .imm(imm));

endmodule


module instr_shift_register(
  input logic rst, clk,
  input logic data_ready, 
  input logic[7:0] serial_in,
  output logic[15:0] instruction, //to compensate for double word
  output logic[15:0] imm,
  output logic valid, error
);

  logic[4:0] count;

  opcode_t opcode;

  assign valid = ((opcode != M_TYPE & opcode != I_TYPE) & count == 2) | ((opcode == M_TYPE | opcode == I_TYPE) & count == 4);

  assign opcode = opcode_t'(instruction[2:0]);


  assign error =  (opcode != R_TYPE) & 
                  (opcode != I_TYPE) & 
                  (opcode != B_TYPE) & 
                  (opcode != J_TYPE) & 
                  (opcode != M_TYPE) & 
                  (opcode != SYS_END);

  always_ff @(posedge clk) begin
    if(rst) begin
      instruction <= 'd0;
      count <= 'd0;
      imm <= 'd0;
    end else begin
      if(data_ready) begin
        count <= count + 1;
        if(count >= 2) begin
          if(opcode == M_TYPE | opcode == I_TYPE & count < 4) begin
            imm <= {serial_in, imm[15:8]};
            count <= count + 1;
          end
        end else begin
          instruction <= {serial_in, instruction[15:8]};
        end
      end
    end
  end
endmodule


                        
