// Constants that specify which operation the ALU should perform
typedef enum logic [3:0] {
    ALU_ADD,                // Addition operation
    ALU_SUB,                // Subtraction/Compare operation
    ALU_LUI,
    ALU_SLL,
    ALU_SRL,
    ALU_SRA,
    ALU_AUIPC,
    ALU_SLT,
    ALU_SLTU,
    ALU_XOR,
    ALU_AND,
    ALU_OR,
    ALU_DC = 'bx            // Don't care value
} alu_op_t;

typedef enum logic {
  LOAD = 1'b0,
  STORE = 1'b1
} ldst_t;


typedef enum logic [2:0] {
    R_TYPE = 3'b000,
    I_TYPE = 3'b001,
    B_TYPE = 3'b010,
    J_TYPE = 3'b011,
    M_TYPE = 3'b100,
    NOP_TYPE = 3'b101
} opcode_t;

typedef enum logic[2:0] {
    LS_BYTE,
    LS_HW,
    LS_W,
    LS_NONE
} mem_op_t;


typedef enum logic[2:0] {
    BR_EQ,
    BR_NE,
    BR_LT,
    BR_GE,
    BR_LTU,
    BR_GEU,
    BR_NONE
} br_op_t;

typedef enum logic[3:0] {
    ADD = 4'b0000,
    SUB = 4'b0001,
    OR = 4'b0010, 
    XOR = 4'b0011,
    SLL = 4'b0100,
    SRL = 4'b0101, 
    SRA = 4'b0110,
    SLT = 4'b0111
} alu_op_t;

typedef struct packed {
  opcode_t opcode,
  logic[2:0] rs1,
  logic[2:0] rs2,
  logic[2:0] rd,
  logic[3:0] instr,
  logic is_double_word,
  mem_op_t mem_op,
  br_op_t br_op,
  logic[8:0] offset,
  logic[14:0] addr_offset,
  logic useImm,
  logic useAddr,
  br_op_t br_op,
  alu_op_t alu_op,
  ldst_t ldst

} dec_sig_t;

typedef struct packed {
  logic go,
  logic instr_shift_in,
  logic mdr_shift_out,
  logic mar_shift_out,
  logic mdr_shift_in,
  logic pc_shift_out,
  logic shift_done
} ctrl_sig_t;