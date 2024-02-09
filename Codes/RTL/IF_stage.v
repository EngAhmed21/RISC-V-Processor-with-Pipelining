module IF_stage #(parameter DATA = 32, ADDR = 32, MEM_DEPTH = 256) (
    input clk, rstn, I_WE, PCE, BTB_validF, BTB_jumpF, BTB_validE, BTB_jumpE, BHB_validF,
    input BHB_takenF,BHB_validE, BHB_takenE, branchE,
    input [1:0] PCSrc, 
    input [31:0] PC_targetE, PC_plus4E, I_WD, aluResultE, BTB_targetF, BTB_targetE,
    output reg [31:0] PC,
    output [31:0] PC_plus4F, instr
);
    // PC
    always @(posedge clk) begin
        if (!rstn)
            PC <= 0;
        else if (PCE)
            if ((PCSrc[1]) && (~(BTB_jumpE && BTB_validE && (BTB_targetE == aluResultE))))
                PC <= aluResultE;
            else if (PCSrc[0] && ((~(BHB_validE && BHB_takenE && BTB_validE && (~BTB_jumpE) && (BTB_targetE == PC_targetE))) || (~BHB_takenE)))
                PC <= PC_targetE;
            else if (branchE && (~PCSrc[0]) && BHB_takenE && BHB_validE) 
                PC <= PC_plus4E;
            else if (BTB_validF && (BTB_jumpF || (BHB_validF && BHB_takenF && (~BTB_jumpF))))
                PC <= BTB_targetF;
            else
                PC <= PC_plus4F;
    end

    assign PC_plus4F = PC + 32'd4;

    // Instr    
    instr_mem #(.DATA(DATA), .ADDR(ADDR), .MEM_DEPTH(MEM_DEPTH)) INSTR_MEM (.clk(clk), .WE(I_WE), .WD(I_WD),
     .PC(PC), .RD(instr));
endmodule