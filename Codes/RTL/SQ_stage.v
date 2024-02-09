// entry valid_entry | PC | valid_data | addr | data

module SQ_stage (
    input clk, clk_2, rstn, WE_D, WE_E, del, ld,
    input [5:0] WA_E, 
    input [7:0] ldM_A, addrE,
    input [31:0] PCld, PCD, PCE, dataE,
    output full, valid,
    output [5:0] tail,
    output [31:0] data_out
);
    wire [73:0] WD_D, WD_E, RD;

    // WD
    assign WD_D = {1'b1, PCD, 1'b0, 40'b0};
    assign WD_E = {1'b1, PCE, 1'b1, addrE, dataE};

    // SQ_mem
    SQ_mem SQ_MEM (.clk(clk), .clk_2(clk_2), .rstn(rstn), .WE_D(WE_D), .WE_E(WE_E), .del(del), .ld(ld), .WA_E(WA_E), .ldM_A(ldM_A),
     .PCld(PCld), .WD_D(WD_D), .WD_E(WD_E), .full(full), .valid(valid), .tail(tail), .RD(RD));

    // Output Addr and Data
    assign data_out = RD[31:0];
endmodule