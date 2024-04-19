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

module eight_bit_spispo(
  input logic load, rst, clk,
  input logic shift_out, shift_in,
  input logic[7:0] serial_in,
  input logic[15:0] prll_in,
  output logic[15:0] prll_out,
  output logic[7:0] serial_out,
  output logic error;
);

  logic low_b;

  assign error = (shift_out & shift_in) | (load & shift_in) | (load & shift_out);

  assign serial_out = low_b ? prll_out[7:0] : prll_out[15:8];

  always_ff @(posedge clk) begin
    if(rst) begin
      prll_out <= 'd0;
      intern_mask <= 'hFF;
      low_b <= 1'b1;
    end else begin
      if(load) begin
        prll_out <= prll_in;
      end else if(shift_in) begin
        prll_out <= {prll_out[7:0], serial_in};
      end else if(shift_out) begin
        low_b <= ~low_b;
      end else begin
        prll_out <= prll_out;
      end
    end
  end

endmodule