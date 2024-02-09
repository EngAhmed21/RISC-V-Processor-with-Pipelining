module ID_stage (
    input [31:0] instr, 
    input [39:0] r_RD1D1, r_RD2D1,
    output memWrite, aluSrcB, regWrite, jump, branch, mul_en, valid1, valid2,
    output [1:0] resultSrc, aluSrcA, store, 
    output [2:0] immSrc, load, funct3,
    output [3:0] aluControl,
    output [4:0] r_RA1, r_RA2, r_WA, 
    output [6:0] tail1, tail2,
    output [31:0] imm_extend, r_RD1D2, r_RD2D2
);
    wire [6:0] opcode, funct7;
    wire [1:0] OP_f7;

    // Instr
    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
    assign OP_f7  = {opcode[5], instr[30]};
    assign r_RA1  = instr[19:15];
    assign r_RA2  = instr[24:20];
    assign r_WA   = instr[11:7];
    
    // Control Unit
    control_unit CONTROL_UNIT (.opcode(opcode), .funct3(funct3), .funct7(funct7), .OP_f7(OP_f7), .resultSrc(resultSrc),
     .memWrite(memWrite), .aluSrcA(aluSrcA), .aluSrcB(aluSrcB), .regWrite(regWrite), .immSrc(immSrc), .load(load), 
     .store(store), .aluControl(aluControl), .mul_en(mul_en), .jump(jump), .branch(branch));

    // Sign Extend
    sign_extend IMM_SIGN_EXTEND (.instr(instr[31:7]), .sel(immSrc), .out(imm_extend));

    // r_RD
    assign r_RD1D2 = r_RD1D1[31:0];
    assign r_RD2D2 = r_RD2D1[31:0];
    assign tail1   = r_RD1D1[38:32];
    assign tail2   = r_RD2D1[38:32];
    assign valid1  = r_RD1D1[39];
    assign valid2  = r_RD2D1[39];  
endmodule