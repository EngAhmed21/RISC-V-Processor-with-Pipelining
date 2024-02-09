// entry >> hValidEntry | destReg | EX_result | mem_WD | control | PC_plus4E
// control >> regWrite | memWrite | rsultSrc | load | store | branch | mem_valid | reg_valid 

module ROB_stage #(parameter ADDR = 7) (
    input clk, clk_2, rstn, WE_D, WE_E, regWriteD, memWriteD, regWriteE, memWriteE, branchE,
    input [1:0] resultSrcE, storeE,
    input [2:0] loadE,
    input [4:0] r_WAD, r_WAE,
    input [(ADDR-1):0] WA_E, tail_src1E, tail_src2E,
    input [31:0] EX_result, mem_WD, PC_plus4E, 
    output valid, regWriteR, memWriteR, full, vSrc1R, vSrc2R,
    output [1:0] resultSrcR, storeR,
    output [2:0] loadR,
    output [4:0] r_WAR,
    output [(ADDR-1):0] tail,
    output [31:0] EX_resultR, mem_WDR, PC_plus4R, src1R, src2R
);
    wire [113:0] WD_D, WD_E, RD_W, RD_E1, RD_E2;
    wire buff_full, buff_empty, head_valid;
    
    assign WD_D = {1'b1, r_WAD, 32'b0, 32'b0, regWriteD, memWriteD, 10'b0, 32'b0};
    assign WD_E = {1'b1, r_WAE, EX_result, mem_WD, regWriteE, memWriteE, resultSrcE, loadE, storeE, branchE, memWriteE, regWriteE, PC_plus4E};
    
    ROB_mem #(.ADDR(ADDR)) RO_Buffer (.clk(clk), .clk_2(clk_2), .rstn(rstn), .WE_D(WE_D), .WE_E(WE_E), .WA_E(WA_E), .WD_D(WD_D),
     .tail_src1E(tail_src1E), .tail_src2E(tail_src2E), .WD_E(WD_E), .full(buff_full), .empty(buff_empty), .head_valid(head_valid), 
     .tail(tail), .RD_W(RD_W), .RD_E1(RD_E1), .RD_E2(RD_E2));

    assign valid      = head_valid & (~buff_empty);
    assign regWriteR  = RD_W[43];
    assign memWriteR  = RD_W[42];
    assign resultSrcR = RD_W[41:40];
    assign loadR      = RD_W[39:37];
    assign storeR     = RD_W[36:35];
    assign r_WAR      = RD_W[112:108];
    assign EX_resultR = RD_W[107:76];
    assign mem_WDR    = RD_W[75:44];
    assign PC_plus4R  = RD_W[31:0];

    assign full = buff_full;

    assign vSrc1R = RD_E1[113] & RD_E1[43] & RD_E1[32]; // valid entry + regwrite + valid_reg
    assign vSrc2R = RD_E2[113] & RD_E2[43] & RD_E2[32];
    assign src1R = RD_E1[107:76];
    assign src2R = RD_E2[107:76];
endmodule