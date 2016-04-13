`ifndef __K12A_INC_SV
`define __K12A_INC_SV

typedef enum logic {
    ACU_INPUT1_SEL_PC,
    ACU_INPUT1_SEL_CD
} acu_input1_sel_t;

typedef enum logic [1:0] {
    ACU_INPUT2_SEL_0001,
    ACU_INPUT2_SEL_0002,
    ACU_INPUT2_SEL_FFFF,
    ACU_INPUT2_SEL_REL_OFFSET
} acu_input2_sel_t;

typedef enum logic {
    ALU_OPERAND_SEL_B,
    ALU_OPERAND_SEL_INST
} alu_operand_sel_t;

typedef enum logic {
    CD_SEL_DATA_BUS,
    CD_SEL_ADDR_BUS
} cd_sel_t;

typedef enum logic {
    MEM_MODE_READ,
    MEM_MODE_WRITE
} mem_mode_t;

typedef enum logic [2:0] {
    STATE_FETCH1,
    STATE_FETCH2,
    STATE_FETCH3,
    STATE_EXEC,
    STATE_RJMP,
    STATE_HALT
} state_t;

`endif
