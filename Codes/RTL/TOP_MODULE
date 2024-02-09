module TOP_MODULE (
    input clk, clk_2, rstn, I_WE,
    input [31:0] I_WD,
    output [31:0] test
);
    // Internal Signals
    wire regWriteD, memWriteD, aluSrcBD, jumpD, branchD, stallF, stallD, flushD, flushE, BTB_jumpF, BTB_validF, BHB_validF;
    wire mul_enD, BHB_takenF, mul_doneE, mul_en1E, mul_en2E, WE_ER, validR, regWriteR, memWriteR, ROB_full, valid1D, valid2D;
    wire vSrc1R, vSrc2R, WE_DR, WE_DS, full_SQ, valid_SQ, ldE;
    wire [1:0] resultSrcD, aluSrcAD, storeD, PCSrcE, forwardAE, forwardBE, resultSrcR, storeR;
    wire [2:0] immSrcD, loadD, funct3D, loadR;
    wire [3:0] aluControlD;
    wire [4:0] r_RA1D, r_RA2D, r_WAD, r_WA_MU1, r_WA_MU2, r_WA_MU3, r_WAR;
    wire [5:0] tail_SQD;
    wire [6:0] tail_ROBD, tail_ROB_MU, tail_ROB_src1D, tail_ROB_src2D;
    wire [31:0] PCF, PC_plus4F, PC_targetE, instrF, imm_extendD, r_RD1D2, r_RD2D2, aluResultE, mem_RD, resultW, BTB_targetF;
    wire [31:0] EX_A, EX_B, productE, EX_resultR, mem_WDR, PC_plus4R, src1R, src2R, PC_plus4MU, data_out_SQ;
    wire [39:0] r_RD1D1, r_RD2D1;
    reg regWriteE, memWriteE, aluSrcBE, jumpE, branchE, memWriteRM, regWriteW, BTB_validD, BTB_jumpD, BTB_jumpE, BTB_validE;
    reg BHB_validD, BHB_takenD, BHB_validE, BHB_takenE, mul_enE, regWriteER, memWriteER, regWriteEM, valid1E, valid2E, branchER, memwriteW;
    reg [1:0] resultSrcE, aluSrcAE, storeE, storeRM, resultSrcW, resultSrcER, storeER, resultSrcEM;
    reg [2:0] loadE, funct3E, loadER, loadEM;
    reg [3:0] aluControlE;
    reg [4:0] r_RA1E, r_RA2E, r_WAE, r_WAW, r_WAER, r_WAEM;
    reg [5:0] tail_SQE;
    reg [6:0] opcodeE, tail_ROBE, WA_ER, tail_ROB_src1E, tail_ROB_src2E, tail_ROBEM; 
    reg [31:0] PCD, PC_plus4D, instrD, PCE, PC_plus4E, PC_plus4EM, imm_extendE, r_RD1E, r_RD2E, aluResultRM, EX_result, PC_plus4ER, aluResultEM;
    reg [31:0] mem_WDRM, aluResultW, mem_RD_reg, PC_plus4W, srcAE, srcBE, BTB_targetD, BTB_targetE, srcBER;

    // Fetch Stage
    IF_stage #(.DATA(32), .ADDR(32), .MEM_DEPTH(256)) FETCH (.clk(clk), .rstn(rstn), .I_WE(I_WE), .BTB_validF(BTB_validF),
     .BTB_jumpF(BTB_jumpF), .BTB_validE(BTB_validE), .BTB_jumpE(BTB_jumpE), .BHB_validF(BHB_validF), .BHB_takenF(BHB_takenF),
     .BHB_validE(BHB_validE), .BHB_takenE(BHB_takenE), .branchE(branchE), .PCSrc(PCSrcE), .PCE(~stallF), .BTB_targetF(BTB_targetF),
     .PC_targetE(PC_targetE), .PC_plus4E(PC_plus4E), .I_WD(I_WD), .BTB_targetE(BTB_targetE), .aluResultE(aluResultE), .PC(PCF),
     .PC_plus4F(PC_plus4F), .instr(instrF));

    // F-D reg
    always @(posedge clk, negedge rstn) begin
        if ((!rstn) || (flushD)) begin
            PCD        <= 0;                    PC_plus4D   <= 0;
            instrD     <= 0;                    BTB_jumpD   <= 0;
            BTB_validD <= 0;                    BTB_targetD <= 0;
            BHB_validD <= 0;                    BHB_takenD  <= 0;
        end
        else if (!stallD) begin
            PCD        <= PCF;                  PC_plus4D   <= PC_plus4F;
            instrD     <= instrF;               BTB_jumpD   <= BTB_jumpF;
            BTB_validD <= BTB_validF;           BTB_targetD <= BTB_targetF;
            BHB_validD <= BHB_validF;           BHB_takenD  <= BHB_takenF;
        end
    end

    // Decode Stage
    ID_stage DECODE (.instr(instrD), .r_RD1D1(r_RD1D1), .r_RD2D1(r_RD2D1), .memWrite(memWriteD), .aluSrcB(aluSrcBD), 
     .regWrite(regWriteD), .jump(jumpD), .branch(branchD), .resultSrc(resultSrcD), .aluSrcA(aluSrcAD), .store(storeD),
     .immSrc(immSrcD), .load(loadD), .aluControl(aluControlD), .funct3(funct3D), .r_RA1(r_RA1D), .r_RA2(r_RA2D), 
     .r_WA(r_WAD), .mul_en(mul_enD), .valid1(valid1D), .valid2(valid2D), .tail1(tail_ROB_src1D), .tail2(tail_ROB_src2D), 
     .imm_extend(imm_extendD), .r_RD1D2(r_RD1D2), .r_RD2D2(r_RD2D2));

    // D-E reg
    always @(posedge clk) begin
        if ((!rstn) || (flushE)) begin
            memWriteE      <= 0;               aluSrcBE       <= 0;
            regWriteE      <= 0;               jumpE          <= 0;
            branchE        <= 0;               resultSrcE     <= 0;
            aluSrcAE       <= 0;               storeE         <= 0;
            loadE          <= 0;               aluControlE    <= 0;
            r_RD1E         <= 0;               r_RD2E         <= 0;
            r_WAE          <= 0;               imm_extendE    <= 0;
            PCE            <= 0;               PC_plus4E      <= 0;
            funct3E        <= 0;               r_RA1E         <= 0;
            r_RA2E         <= 0;               opcodeE        <= 0;
            BTB_jumpE      <= 0;               BTB_validE     <= 0;
            BTB_targetE    <= 0;               BHB_validE     <= 0;
            BHB_takenE     <= 0;               mul_enE        <= 0;
            tail_ROBE      <= 0;               tail_ROB_src1E <= 0;               
            tail_ROB_src2E <= 0;               valid1E        <= 0;               
            valid2E        <= 0;               tail_SQE       <= 0;              
        end
        else begin
            memWriteE      <= memWriteD;       aluSrcBE       <= aluSrcBD;
            regWriteE      <= regWriteD;       jumpE          <= jumpD;
            branchE        <= branchD;         resultSrcE     <= resultSrcD;
            aluSrcAE       <= aluSrcAD;        storeE         <= storeD;
            loadE          <= loadD;           aluControlE    <= aluControlD;
            r_RD1E         <= r_RD1D2;         r_RD2E         <= r_RD2D2;
            r_WAE          <= r_WAD;           imm_extendE    <= imm_extendD;
            PCE            <= PCD;             PC_plus4E      <= PC_plus4D;
            funct3E        <= funct3D;         r_RA1E         <= r_RA1D;
            r_RA2E         <= r_RA2D;          opcodeE        <= instrD[6:0];
            BTB_jumpE      <= BTB_jumpD;       BTB_validE     <= BTB_validD;        
            BTB_targetE    <= BTB_targetD;     BHB_validE     <= BHB_validD;
            BHB_takenE     <= BHB_takenD;      mul_enE        <= mul_enD;
            tail_ROBE      <= tail_ROBD;       tail_ROB_src1E <= tail_ROB_src1D;      
            tail_ROB_src2E <= tail_ROB_src2D;  valid1E        <= valid1D;         
            valid2E        <= valid2D;         tail_SQE       <= tail_SQD; 
        end
    end

    // SQ Stage
    assign ldE      = (resultSrcE == 2'b01);     
    assign WE_DS    = memWriteD & (~(stallD | flushD| full_SQ));

    SQ_stage SQ (.clk(clk), .clk_2(clk_2), .rstn(rstn), .WE_D(WE_DS), .WE_E(memWriteE), .del(memwriteW), .ld(ldE), .WA_E(tail_SQE),
     .ldM_A(aluResultE[7:0]), .addrE(aluResultE[7:0]), .PCld(PCE), .PCD(PCD), .PCE(PCE), .dataE(srcBE), .full(full_SQ), .valid(valid_SQ), 
     .tail(tail_SQD), .data_out(data_out_SQ));


    // Excute Stage

    // Operands
    assign EX_A = (aluSrcAE == 2'b00) ? srcAE : (aluSrcAE == 2'b10) ? PCE : 32'd0;
    assign EX_B = aluSrcBE ? imm_extendE : srcBE;

    // ALU Stage
    ALU_stage ALU_STAGE (.branch(branchE), .jump(jumpE), .funct3(funct3E), .aluControl(aluControlE), .r_RD1(EX_A), 
     .r_RD2(EX_B), .PC(PCE), .imm_extend(imm_extendE), .PCSrc(PCSrcE), .PC_target(PC_targetE), .aluResult(aluResultE));

    // MU Stage
    MU_stage MU_STAGE (.clk(clk), .rstn(rstn), .mul_en(mul_enE), .funct3(funct3E[1:0]), .r_RD1(EX_A), .r_RD2(EX_B), .tailE(tail_ROBE), 
     .r_WA(r_WAE), .PC_plus4E(PC_plus4E), .mul_en1(mul_en1E), .mul_en2(mul_en2E), .mul_done(mul_doneE), .r_WA1(r_WA_MU1), 
     .r_WA2(r_WA_MU2), .r_WA3(r_WA_MU3), .tail_MU(tail_ROB_MU), .PC_plus4MU(PC_plus4MU), .product(productE));
    
        
    // E/M-R
    always @(*) begin
        if (resultSrcEM == 2'b01) begin
            regWriteER  = regWriteEM;       memWriteER  = 0;
            branchER    = 0;                resultSrcER = resultSrcEM;
            storeER     = 0;                loadER      = loadEM;
            r_WAER      = r_WAEM;           EX_result   = mem_RD;
            srcBER      = 0;                PC_plus4ER  = PC_plus4EM;
            WA_ER       = tail_ROBEM;           
        end
        else if (mul_enE || ((resultSrcE == 2'b01) && (~valid_SQ))) begin         // Load or MUL
            regWriteER  = 0;                memWriteER  = 0;
            branchER    = 0;                resultSrcER = 0;
            storeER     = 0;                loadER      = 0;
            r_WAER      = 0;                EX_result   = 0;
            srcBER      = 0;                PC_plus4ER  = 0;
            WA_ER       = 0;           
        end
        else if (mul_doneE) begin
            regWriteER  = 1;                memWriteER  = 0;
            branchER    = 0;                resultSrcER = 0;
            storeER     = 0;                loadER      = 0;
            r_WAER      = r_WA_MU3;         EX_result   = productE;
            srcBER      = 0;                PC_plus4ER  = PC_plus4MU;
            WA_ER       = tail_ROB_MU;      
        end
        else if ((resultSrcE == 2'b01) && valid_SQ) begin
            regWriteER  = regWriteE;        memWriteER  = memWriteE;
            branchER    = branchE;          resultSrcER = resultSrcE;
            storeER     = storeE;           loadER      = loadE;
            r_WAER      = r_WAE;            EX_result   = data_out_SQ;
            srcBER      = srcBE;            PC_plus4ER  = PC_plus4E;
            WA_ER       = tail_ROBE;        
        end
        else begin
            regWriteER  = regWriteE;        memWriteER  = memWriteE;
            branchER    = branchE;          resultSrcER = resultSrcE;
            storeER     = storeE;           loadER      = loadE;
            r_WAER      = r_WAE;            EX_result   = aluResultE;
            srcBER      = srcBE;            PC_plus4ER  = PC_plus4E;
            WA_ER       = tail_ROBE;        
        end
    end
    assign WE_ER = mul_doneE | branchER | regWriteER | memWriteER | (resultSrcER == 2'b01);
    assign WE_DR = ~(stallD | flushD) & (branchD | regWriteD | memWriteD | jumpD); 

    // ROB Stage
    ROB_stage #(.ADDR(7)) ROB_STAGE (.clk(clk), .clk_2(clk_2), .rstn(rstn), .WE_D(WE_DR), .WE_E(WE_ER), .regWriteD(regWriteD),
     .memWriteD(memWriteD), .regWriteE(regWriteER), .memWriteE(memWriteER), .branchE(branchER), .resultSrcE(resultSrcER), 
     .storeE(storeER), .loadE(loadER), .r_WAD(r_WAD), .r_WAE(r_WAER), .WA_E(WA_ER), .tail_src1E(tail_ROB_src1E), .tail_src2E(tail_ROB_src2E),
     .EX_result(EX_result), .mem_WD(srcBER), .PC_plus4E(PC_plus4ER), .full(ROB_full), .valid(validR), .regWriteR(regWriteR),
     .memWriteR(memWriteR), .vSrc1R(vSrc1R), .vSrc2R(vSrc2R), .resultSrcR(resultSrcR), .storeR(storeR), .loadR(loadR), .r_WAR(r_WAR), 
     .tail(tail_ROBD), .EX_resultR(EX_resultR), .mem_WDR(mem_WDR), .PC_plus4R(PC_plus4R), .src1R(src1R), .src2R(src2R));

    // R-M reg >> for store instruction only
    always @(posedge clk) begin
        if ((!rstn) || (!(validR && memWriteR))) begin
            memWriteRM  <= 0;                   aluResultRM <= 0;               
            mem_WDRM    <= 0;                   storeRM     <= 0;
        end
        else if (validR && memWriteR) begin     // store
            memWriteRM  <= memWriteR;           aluResultRM <= EX_resultR;               
            mem_WDRM    <= mem_WDR;             storeRM     <= storeR;
        end
    end
    
    // E-M reg >> for load instruction only
    always @(posedge clk) begin
        if ((!rstn) || (resultSrcE != 2'b01) || (valid_SQ)) begin
            regWriteEM  <= 0;                   resultSrcEM <= 0;               
            aluResultEM <= 0;                   r_WAEM      <= 0;               
            loadEM      <= 0;                   tail_ROBEM  <= 0;
            PC_plus4EM  <= 0;
        end
        else if ((resultSrcE == 2'b01) && (!valid_SQ)) begin     // load
            regWriteEM  <= regWriteE;           resultSrcEM <= resultSrcE;
            aluResultEM <= aluResultE;          r_WAEM      <= r_WAE;           
            loadEM      <= loadE;               tail_ROBEM  <= tail_ROBE;
            PC_plus4EM  <= PC_plus4E;
        end
    end

    // Memory Stage
    MEM_stage #(.DATA(32), .ADDR(32), .MEM_DEPTH(256)) MEMORY (.clk(clk), .memWrite(memWriteRM), .store(storeRM),
     .load(loadEM), .mem_WA(aluResultRM), .mem_RA(aluResultEM), .mem_WD(mem_WDRM), .mem_RD(mem_RD), .test(test));

    // R-W reg
    always @(posedge clk) begin
        if ((!rstn) || (!(validR && (resultSrcR != 2'b01)))) begin
            r_WAW        <= 0;                  regWriteW    <= 0;
            resultSrcW   <= 0;                  aluResultW   <= 0;               
            PC_plus4W    <= 0;                  mem_RD_reg   <= 0;
            memwriteW    <= 0;
        end
        else if (validR && (resultSrcR != 2'b01)) begin
            r_WAW        <= r_WAR;              regWriteW    <= regWriteR;
            resultSrcW   <= resultSrcR;         aluResultW   <= EX_resultR;               
            PC_plus4W    <= PC_plus4R;          mem_RD_reg   <= 0;
            memwriteW    <= memWriteR;
        end
    end

    // Write-Back Stage
    WB_stage WRITE_BACK (.resultSrc(resultSrcW), .aluResultE(aluResultW), .mem_RD(mem_RD_reg),
     .PC_plus4(PC_plus4W), .result(resultW));

    // Register File
    register_file #(.DATA(40), .ADDR(5)) REG_FILE (.clk(clk), .clk_2(clk_2), .rstn(rstn), .WE_D(WE_DR), .WE_W(regWriteW), 
     .RA1(r_RA1D), .RA2(r_RA2D), .WA_D(r_WAD), .WA_W(r_WAW), .tailD(tail_ROBD), .WD(resultW), .RD1(r_RD1D1), .RD2(r_RD2D1));

    // Forwarding
    always @(*) begin
        if (forwardAE == 2'b00)
            srcAE = r_RD1E;
        else if (forwardAE == 2'b01)
            srcAE = resultW;
        else if (forwardAE == 2'b10)
            srcAE = aluResultRM;
        else 
            srcAE = src1R;
    end
    always @(*) begin
        if (forwardBE == 2'b00)
            srcBE = r_RD2E;
        else if (forwardBE == 2'b01)
            srcBE = resultW;
        else if (forwardBE == 2'b10)
            srcBE = aluResultRM;
        else 
            srcBE = src2R;
    end

    // Hazard Unit
    hazard_unit HAZARD_UNIT (.valid1E(valid1E), .valid2E(valid2E), .regWriteM(regWriteEM), .regWriteW(regWriteW), .PCSrc(PCSrcE), 
     .resultSrcE(resultSrcE), .BTB_jumpE(BTB_jumpE), .BTB_validE(BTB_validE), .branchE(branchE), .BHB_validE(BHB_validE), 
     .BHB_takenE(BHB_takenE), .r_RA1D(r_RA1D), .r_RA2D(r_RA2D), .r_RA1E(r_RA1E), .r_RA2E(r_RA2E), .r_WAE(r_WAE), .r_WAM(r_WAEM), 
     .r_WAW(r_WAW), .mul_enE(mul_enE), .mul_en1E(mul_en1E), .mul_en2E(mul_en2E), .ROB_full(ROB_full), .full_SQ(full_SQ),
     .vSrc1R(vSrc1R), .vSrc2R(vSrc2R), .r_WA_MU1(r_WA_MU1), .r_WA_MU2(r_WA_MU2), .opcodeD(instrD[6:0]), .opcodeE(opcodeE), 
     .BTB_targetE(BTB_targetE), .PC_targetE(PC_targetE), .aluResultE(aluResultE), .stallF(stallF), .stallD(stallD), .flushD(flushD), 
     .flushE(flushE), .forwardAE(forwardAE), .forwardBE(forwardBE));

    // Branch Target Buffer
    BTB #(.SIZE(128)) BTB (.clk(clk), .rstn(rstn), .PCSrc(PCSrcE), .PC_IF(PCF[31:2]), .PC_EX(PCE[31:2]),
     .PC_target(PC_targetE), .aluResultE(aluResultE), .valid(BTB_validF), .jump(BTB_jumpF), .target_out(BTB_targetF));

    // Branch History Buffer
    BHB #(.SIZE(128)) BHB (.clk(clk), .rstn(rstn), .takenE(PCSrcE[0]), .branch(branchE), .PC_IF(PCF[31:2]), .PC_EX(PCE[31:2]),
     .valid(BHB_validF), .takenF(BHB_takenF));
endmodule
