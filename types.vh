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
