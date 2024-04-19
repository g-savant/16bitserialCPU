`default_nettype none

`include "types.vh"

//need to add repeat state if error;
//NRZI may be a good idea

module control(
  input logic ard_data_ready, clk, rst, ard_receive_ready, error;
  input dec_sig_t signals,
  output ctrl_sig_t ctrl,
  output logic bus_pc, bus_mdr, bus_mar);

  enum logic[3:0] {OP, 
                  SSHIFT_ADDR1,SSHIFT_ADDR2, SSHIFT_DATA1,SSHIFT_DATA2, 
                  LSHIFT_OUT1, LSHIFT_OUT2, WAIT, WAITPC_INSTR,
                  LOAD_MEM1, LOAD_MEM2,
                  PC_OUT1, PC_OUT2, INSTR_SHIFT1, INSTR_SHIFT2} cs, ns;

  


  always_comb begin
    ctrl.instr_shift_in = 1'b0;
    ctrl.pc_shift_out = 1'b0;
    ctrl.mdr_shift_out = 1'b0;
    ctrl.mar_shift_out = 1'b0;
    ctrl.mdr_shift_in = 1'b0;
    ctrl.mdr_load = 1'b0;
    ctrl.mar_load = 1'b0;
    ctrl.go = 1'b0;
    bus_pc = 1'b0;
    bus_mdr = 1'b0;
    bus_mar = 1'b0;
    case(cs)
      OP: begin
        ctrl.go = 1'b1;
        if(signals.opcode == M_TYPE & mem_op == LOAD) begin
          ns = LSHIFT_OUT;
          ctrl.mar_load = 1'b1;
        end else if(signals.opcode == M_TYPE & mem_op == STORE) begin
          ns = SSHIFT_ADDR1;
          ctrl.mar_load = 1'b1;
          ctrl.mdr_load = 1'b1;
        end else begin
          ns = PC_OUT;
        end
      end
        //put ctrl.go into instruction decode
        //no ops when not ctrl.go
      SSHIFT_ADDR1:begin
        ctrl.mar_shift_out = 1'b1;
        bus_mar = 1'b1;
        ns = SSHIFT_ADDR2;
      end
      SSHIFT_ADDR2:begin
        ctrl.mar_shift_out = 1'b1;
        bus_mar = 1'b1;
        ns = SSHIFT_DATA1;
      end
      SSHIFT_DATA1:begin
        ctrl.mdr_shift_out = 1'b1;
        bus_mdr = 1'b1;
        ns = SSHIFT_DATA2;
      end
      SSHIFT_DATA2:begin
        ctrl.mdr_shift_out = 1'b1;
        bus_mdr = 1'b1;
        ns = PC_OUT;
      end
      LSHIFT_OUT1:
        ctrl.mar_shift_out = 1'b1;
        bus_mar = 1'b1;
        ns = LSHIFT_OUT2;
      LSHIFT_OUT2:
        ctrl.mar_shift_out = 1'b1;
        bus_mar = 1'b1;
        ns = PC_OUT1;
      WAIT:
        if(ard_data_ready) begin
          ns = LOAD_MEM1;
        end else ns = WAIT;
      LOAD_MEM1:
        ctrl.mdr_shift_in = 1'b1;
        ns = LOAD_MEM2;
      LOAD_MEM2: 
        ctrl.mdr_shift_in = 1'b1;
        ns = PC_OUT1;
      PC_OUT1: begin
        ctrl.pc_shift_out = 1'b1;
        bus_pc = 1'b1;
        ns = PC_OUT2;
      end
      PC_OUT2: begin
        ctrl.pc_shift_out = 1'b1;
        bus_pc = 1'b1;
        ns = INSTR_SHIFT1;
      end
      WAITPC_INSTR:
        if(ard_receive_ready) begin
          ns = INSTR_SHIFT1;
          ctrl.instr_shift_in = 1'b1;
        end
      INSTR_SHIFT1:
        ctrl.instr_shift_in = 1'b1;
        ns = INSTR_SHIFT2;
      INSTR_SHIFT2:
        ctrl.go  = 1'b1;
        ns = OP;
    endcase
  end

  always_ff @(posedge clk) begin
    if(rst) cs <= PC_OUT;
    else cs <= ns;
  end



endmodule