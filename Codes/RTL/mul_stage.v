module mul_stage (
    input multiplier,
    input  signed [63:0] multiplicand,
    input signed [63:0] product_in,
    output reg signed [63:0] product_out
);
    always @(*) begin
        if (multiplier)
            product_out = product_in + multiplicand;
        else
            product_out = product_in;
    end
endmodule