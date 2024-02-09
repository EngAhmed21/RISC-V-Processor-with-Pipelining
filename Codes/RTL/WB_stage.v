module WB_stage (
    input [1:0] resultSrc,
    input [31:0] aluResultE, mem_RD, PC_plus4,
    output reg [31:0] result
);
    always @(*) begin
        if (resultSrc == 2'b01)
            result = mem_RD;
        else if (resultSrc == 2'b10)
            result = (PC_plus4 + 32'd4);
        else 
            result = aluResultE;
    end
endmodule