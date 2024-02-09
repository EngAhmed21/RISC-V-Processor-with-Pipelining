module MEM_stage #(parameter DATA = 32, ADDR = 32, MEM_DEPTH = 256) (
    input clk, memWrite,
    input [1:0] store,
    input [2:0] load,
    input [31:0] mem_WA, mem_RA, mem_WD,
    output reg [31:0] mem_RD,
    output [31:0] test
);
    localparam LW  = 3'b000;    localparam LH = 3'b001;
    localparam LB  = 3'b010;    localparam LHU = 3'b011;
    localparam LBU = 3'b100;    localparam SW  = 2'b00;
    localparam SH  = 2'b01;     localparam SB  = 2'b10;

    reg [31:0] mem_WD_S;
    wire [31:0] mem_RD_L;

    // STORE
    always @(*) begin
        if (store == SB)
            mem_WD_S = {{24{mem_WD[7]}}, mem_WD[7:0]};
        else if (store == SH)
            mem_WD_S = {{16{mem_WD[15]}}, mem_WD[15:0]};
        else
            mem_WD_S = mem_WD;
    end
    
    // Data Memory
    data_mem #(.DATA(32), .ADDR(32), .MEM_DEPTH(256)) DATA_MEM (.clk(clk), .WE(memWrite), 
     .WD(mem_WD_S), .WA(mem_WA), .RA(mem_RA), .RD(mem_RD_L), .test(test));

    // LOAD
    always @(*) begin
        if (load == LB)
                mem_RD = {{24{mem_RD_L[7]}}, mem_RD_L[7:0]};
            else if (load == LH)
                mem_RD = {{16{mem_RD_L[15]}}, mem_RD_L[15:0]};
            else if (load == LBU)
                mem_RD = {24'd0, mem_RD_L[7:0]};
            else if (load == LHU)
                mem_RD = {16'd0, mem_RD_L[15:0]};
            else
                mem_RD = mem_RD_L;
    end
endmodule