module hazard_unit (
    input regWriteM, regWriteW, BTB_validE, BTB_jumpE, BHB_validE, BHB_takenE, branchE, mul_enE, mul_en1E,
    input mul_en2E, ROB_full, vSrc1R, vSrc2R, valid1E, valid2E, full_SQ,
    input [1:0] PCSrc, resultSrcE,
    input [4:0] r_RA1D, r_RA2D, r_RA1E, r_RA2E, r_WAE, r_WAM, r_WAW, r_WA_MU1, r_WA_MU2,
    input [6:0] opcodeD, opcodeE,
    input [31:0] BTB_targetE, PC_targetE, aluResultE,
    output stallF, stallD, flushE,
    output reg flushD,
    output reg [1:0] forwardAE, forwardBE
);
    localparam LOAD    = 7'b0000011;           localparam STORE   = 7'b0100011;
    localparam R_Type  = 7'b0110011;           localparam I_Type  = 7'b0010011;
    localparam SB_Type = 7'b1100011;           localparam JAL     = 7'b1101111;
    localparam LUI     = 7'b0110111;           localparam AUIPC   = 7'b0010111;
    localparam JALR    = 7'b1100111;

    wire stall_ld;          // load >> stall 
    wire stall_MU1;         // src1 is written by mul_unit
    wire stall_MU2;         // src2 is written by mul_unit
    wire stall_MU_done;     // A mul instruction is done 
    wire src1D, src2D;      // opcodeD is for instruction with which number of sources
    wire src1E, src2E;      // opcodeE is for instruction with which number of sources

    // src1D, src2D, src1E, src2E
    assign src1D = ((opcodeD == LOAD) || (opcodeD == STORE) || (opcodeD == R_Type) || (opcodeD == I_Type) || (opcodeD == SB_Type) || (opcodeD == JALR));
    assign src2D = ((opcodeD == R_Type) || (opcodeD == SB_Type) || (opcodeD == STORE));
    assign src1E = ((opcodeE == LOAD) || (opcodeE == STORE) || (opcodeE == R_Type) || (opcodeE == I_Type) || (opcodeE == SB_Type) || (opcodeE == JALR));
    assign src2E = ((opcodeE == R_Type) || (opcodeE == SB_Type) || (opcodeE == STORE));
    
    // forwardAE
    always @(*) begin
        if(valid1E)
            forwardAE = 2'b00;
        else if (src1E && (|r_RA1E))
            if (vSrc1R)
                forwardAE = 2'b11;
            else if ((r_RA1E == r_WAM) && regWriteM)
                forwardAE = 2'b10;
            else if ((r_RA1E == r_WAW) && regWriteW)
                forwardAE = 2'b01; 
            else
                forwardAE = 2'b00;
        else
            forwardAE = 2'b00;
    end

    // forwardBE
    always @(*) begin
        if (valid2E)
            forwardBE = 2'b00;
        else if (src2E && (|r_RA2E))
            if (vSrc2R)
                forwardBE = 2'b11;
            else if ((r_RA2E == r_WAM) && regWriteM)
                forwardBE = 2'b10;
            else if ((r_RA2E == r_WAW) && regWriteW)
                forwardBE = 2'b01;
            else
                forwardBE = 2'b00;
        else
            forwardBE = 2'b00;
    end

    // stallF, stallD    
    assign stall_ld = ((resultSrcE == 2'b01));

    assign stall_MU1 = ((|r_RA1D) && src1D && ((mul_enE & (r_RA1D == r_WAE)) || (mul_en1E & (r_RA1D == r_WA_MU1)) || (mul_en2E & (r_RA1D == r_WA_MU2))));
    assign stall_MU2 = ((|r_RA2D) && src2D && ((mul_enE & (r_RA2D == r_WAE)) || (mul_en1E & (r_RA2D == r_WA_MU1)) || (mul_en2E & (r_RA2D == r_WA_MU2))));
    
    assign stall_MU_done = mul_en2E;

    assign stallF = stall_ld | stall_MU1 | stall_MU2 | stall_MU_done | ROB_full |full_SQ;
    assign stallD = stallF; 

    // flushD, flushE
    always @(*) begin
        if (PCSrc[1])
            flushD = ~(BTB_validE & BTB_jumpE & (BTB_targetE == aluResultE));
        else if (PCSrc[0])
            flushD = ~(BTB_validE & (~BTB_jumpE) & BHB_validE & BHB_takenE & (BTB_targetE == PC_targetE));
        else if (branchE)
            flushD = (BHB_validE && BHB_takenE);
        else 
            flushD = 0;
    end
    assign flushE = stallF | flushD;
endmodule