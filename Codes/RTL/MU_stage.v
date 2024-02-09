module MU_stage (
    input clk, rstn,
    input mul_en,
    input [1:0] funct3,
    input [4:0] r_WA,
    input [6:0] tailE,
    input [31:0] r_RD1, r_RD2, PC_plus4E,
    output mul_en1, mul_en2, mul_done,
    output reg [4:0] r_WA1, r_WA2, r_WA3,
    output reg [6:0] tail_MU,
    output [31:0] product,
    output reg [31:0] PC_plus4MU
);
    reg [6:0] tail_MU1, tail_MU2;
    reg [31:0] PC_plus4M1, PC_plus4M2;

    // MUL
    multiply_unit MUL_UNIT (.clk(clk), .rstn(rstn), .mul_en(mul_en), .mul(funct3), .multiplicand(r_RD1), .multiplier(r_RD2),
     .mul_en1(mul_en1), .mul_en2(mul_en2), .mul_done(mul_done), .product(product));

    // r_WA1
    always @(posedge clk) begin
        if (!rstn) 
            r_WA1 <= 0;
        else if (mul_en)
            r_WA1 <= r_WA;
    end

    // r_WA2
    always @(posedge clk) begin
        if (!rstn) 
            r_WA2 <= 0;
        else if (mul_en1)
            r_WA2 <= r_WA1;
    end

    // r_WA3
    always @(posedge clk) begin
        if (!rstn) 
            r_WA3 <= 0;
        else if (mul_en2)
            r_WA3 <= r_WA2;
    end

    // PC_plus4MU, tailMU
    always @(posedge clk) begin
        if (!rstn) begin
            PC_plus4M1 <= 0;            PC_plus4M2 <= 0;
            PC_plus4MU <= 0;            tail_MU1   <= 0;
            tail_MU2   <= 0;            tail_MU    <= 0;
        end
        else begin
            PC_plus4M1 <= PC_plus4E;    PC_plus4M2 <= PC_plus4M1;
            PC_plus4MU <= PC_plus4M2;   tail_MU1   <= tailE;
            tail_MU2   <= tail_MU1;     tail_MU    <= tail_MU2;
        end
    end
endmodule