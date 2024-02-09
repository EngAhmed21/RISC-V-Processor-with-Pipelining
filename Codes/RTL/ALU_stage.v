module ALU_stage (
    input branch, jump, 
    input [2:0] funct3,
    input [3:0] aluControl,
    input [31:0] r_RD1, r_RD2, PC, imm_extend,
    output reg [1:0] PCSrc,
    output [31:0] PC_target, aluResult
);
    wire zero;

    ALU ALU (.A(r_RD1), .B(r_RD2), .opcode(aluControl), .ALU_out(aluResult), .zero_flag(zero)); 

    // PCSrc
    always @(*) begin
        PCSrc[1] = jump;
        if (~funct3[2])
            if (~funct3[0])
                PCSrc[0] = (branch & zero);      // BEQ
            else
                PCSrc[0] = (branch & (~zero));   // BNE
        else
            if (funct3[0])
                PCSrc[0] = (branch & zero);      // BGE, BGEU
            else
                PCSrc[0] = (branch & (~zero));   // BLT, BLTU
    end

    // PC_target
    assign PC_target = PC + imm_extend;
endmodule