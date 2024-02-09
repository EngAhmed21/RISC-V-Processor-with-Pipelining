module mul_sub_unit #(parameter SIZE = 8) (
    input signed [63:0] product_in,
    input signed [63:0] multiplicand_in,
    input [(SIZE-1):0] multiplier,
    output signed [63:0] product
);
    wire [63:0] result_in [(SIZE-1):0];
    wire [63:0] result_out [(SIZE-1):0];

    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin: Stage
            if (i == 0)
                assign result_in[i] = product_in;
            else
                assign result_in[i] = result_out[i-1];

            mul_stage MS (.multiplier(multiplier[i]), .multiplicand((multiplicand_in << i)), .product_in(result_in[i]),
             .product_out(result_out[i]));
        end
    endgenerate

    assign product = result_out[(SIZE-1)];
endmodule