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


typedef enum logic [2:0] {
    R_TYPE,
    I_TYPE,
    B_TYPE,
    J_TYPE,
    M_TYPE
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
  logic[23:0] mem_addr
} signals_t;