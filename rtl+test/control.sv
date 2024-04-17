`default_nettype none

`include "types.vh"


module control(
  input logic done, ard_data_ready, clk, rst, ard_receive_ready,
  input signals_t signals,
  output logic go, instr_shift_in, mdr_shift_out, mar_shift_out, mdr_shift_in,
  output logic pc_shift_out, shift_done);

  enum logic[3:0] {OP, 
                  SSHIFT_ADDR1,SSHIFT_ADDR2, SSHIFT_DATA1,SSHIFT_DATA2, 
                  LSHIFT_OUT1, LSHIFT_OUT2, WAIT, 
                  LOAD_MEM1, LOAD_MEM2,
                  PC_OUT, INSTR_SHIFT} cs, ns;

  


  always_comb begin
    case(cs)
      OP: begin
        instr_shift_in = 1'b0;
        pc_shift_out = 1'b0;
        mdr_shift_out = 1'b0;
        pc_shift_out = 1'b0;
        mar_shift_out = 1'b0;
        mdr_shift_in = 1'b0;
        go = 1'b1;
        if(done) begin
          go = 1'b0;
          if(signals.opcode == M_TYPE & mem_op == LOAD) begin
            ns = LSHIFT_OUT;
            mdr_shift_out = 1'b1;
          end else if(signals.opcode == M_TYPE & mem_op == STORE) begin
            ns = SSHIFT_ADDR1;
            mar_shift_out = 1'b1;
          end else begin
            ns = PC_OUT;
          end
        end else begin
          ns = OP;
        end
        //put go into instruction decode
        //no ops when not go
      end
      SSHIFT_ADDR1:begin
        instr_shift_in = 1'b0;
        pc_shift_out = 1'b0;
        mdr_shift_out = 1'b0;
        pc_shift_out = 1'b0;
        mar_shift_out = 1'b1;
        mdr_shift_in = 1'b0;
        go = 1'b0;
        ns = SSHIFT_ADDR2;
      end
      SSHIFT_ADDR2:begin
        instr_shift_in = 1'b0;
        pc_shift_out = 1'b0;
        mdr_shift_out = 1'b1;
        pc_shift_out = 1'b0;
        mar_shift_out = 1'b0;
        mdr_shift_in = 1'b0;
        go = 1'b0;
        ns = SSHIFT_DATA1;
      end
      SSHIFT_DATA1:begin
        instr_shift_in = 1'b0;
        pc_shift_out = 1'b0;
        mdr_shift_out = 1'b1;
        pc_shift_out = 1'b0;
        mar_shift_out = 1'b0;
        mdr_shift_in = 1'b0;
        go = 1'b0;
        ns = SSHIFT_DATA2;
      end
      SSHIFT_DATA2:begin
        instr_shift_in = 1'b0;
        pc_shift_out = 1'b0;
        mdr_shift_out = 1'b1;
        pc_shift_out = 1'b0;
        mar_shift_out = 1'b0;
        mdr_shift_in = 1'b0;
        go = 1'b0;
        ns = PC_OUT;
      end
      LSHIFT_OUT1:
        instr_shift_in = 1'b0;
        pc_shift_out = 1'b0;
        mdr_shift_out = 1'b0;
        pc_shift_out = 1'b0;
        mar_shift_out = 1'b1;
        mdr_shift_in = 1'b0;
        go = 1'b0;
        ns = LSHIFT_OUT2;
      LSHIFT_OUT2:
        instr_shift_in = 1'b0;
        pc_shift_out = 1'b0;
        mdr_shift_out = 1'b0;
        pc_shift_out = 1'b0;
        mar_shift_out = 1'b1;
        mdr_shift_in = 1'b0;
        go = 1'b0;
        ns = PC_OUT;
      WAIT:
      LOAD_MEM:
      PC_OUT: begin
        
      end
      INSTR_SHIFT:
    endcase
  end

  always_ff @(posedge clk) begin
    if(rst) cs <= PC_OUT;
    else cs <= ns;
  end



endmodule