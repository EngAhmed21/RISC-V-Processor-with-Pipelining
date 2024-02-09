module multiply_unit(
    input clk, rstn, mul_en,
    input [1:0] mul,
    input signed [31:0] multiplicand,
    input signed [31:0] multiplier,
    output mul_en1, mul_en2, mul_done,
    output reg signed [31:0] product
);  
    localparam MUL    = 0;    localparam MULH  = 1;
    localparam MULHSU = 2;    localparam MULHU = 3;

    wire [63:0] product_in0, result0, result1, result2, result3;
    reg [63:0] multiplicand0, product_in1, multiplicand1,  product_in2, multiplicand2, product_in3, multiplicand3;
    reg [31:0] multiplier0, multiplier1, multiplier2, multiplier3;
    reg mul_done1, mul_done2, mul_done3;
    
    // sub_unit 0
    always @(*) begin
        if ((mul == MUL) || (mul == MULH)) begin
            multiplicand0 = {32'b0, multiplicand};
            multiplier0 = multiplier;
        end
        else if (mul == MULHSU) begin
            multiplicand0 = {32'b0, multiplicand};
            multiplier0 = $unsigned(multiplier);
        end
        else if (mul == MULHU) begin
            multiplicand0 = {32'b0, $unsigned(multiplicand)};
            multiplier0 = $unsigned(multiplier);
        end
        else begin
            multiplicand0 = 64'b0;
            multiplier0 = 32'b0;
        end
    end
    assign product_in0 = 64'b0;  
    mul_sub_unit #(.SIZE(8)) SU0 (.product_in(product_in0), .multiplicand_in(multiplicand0),
     .multiplier(multiplier0[7:0]), .product(result0));

    // 0-1
    always @(posedge clk) begin
        if (!rstn) begin
            product_in1   <= 64'b0;
            multiplicand1 <= 64'b0;
            multiplier1   <= 32'b0;
            mul_done1     <= 0;
        end
        else begin
            product_in1   <= result0;
            multiplicand1 <= (multiplicand0 << 8);
            multiplier1   <= multiplier0;
            mul_done1     <= mul_en;
        end
    end

    // sub_unit 1
    mul_sub_unit #(.SIZE(8)) SU1 (.product_in(product_in1), .multiplicand_in(multiplicand1),
     .multiplier(multiplier1[15:8]), .product(result1));

     // 1-2
    always @(posedge clk) begin
        if (!rstn) begin
            product_in2   <= 64'b0;
            multiplicand2 <= 64'b0;
            multiplier2   <= 32'b0;
            mul_done2     <= 0;
        end
        else begin
            product_in2   <= result1;
            multiplicand2 <= (multiplicand1 << 8);
            multiplier2   <= multiplier1;
            mul_done2     <= mul_done1;
        end
    end

    // sub_unit 2
    mul_sub_unit #(.SIZE(8)) SU2 (.product_in(product_in2), .multiplicand_in(multiplicand2),
     .multiplier(multiplier2[23:16]), .product(result2));

     // 2-3
    always @(posedge clk) begin
        if (!rstn) begin
            product_in3   <= 64'b0;
            multiplicand3 <= 64'b0;
            multiplier3   <= 32'b0;
            mul_done3     <= 0;
        end
        else begin
            product_in3   <= result2;
            multiplicand3 <= (multiplicand2 << 8);
            multiplier3   <= multiplier2;
            mul_done3     <= mul_done2;
        end
    end

    // sub_unit 3
    mul_sub_unit #(.SIZE(8)) SU3 (.product_in(product_in3), .multiplicand_in(multiplicand3),
     .multiplier(multiplier3[31:24]), .product(result3));

    // Output
    assign mul_en1 = mul_done1;
    assign mul_en2 = mul_done2;
    assign mul_done = mul_done3;
    
    always @(*) begin
        if (mul == MUL)
            product = result3[31:0];
        else
            product = result3[63:32];
    end
endmodule