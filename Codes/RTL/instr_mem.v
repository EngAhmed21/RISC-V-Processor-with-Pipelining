module instr_mem #(parameter DATA = 32, ADDR = 32, MEM_DEPTH = 256)(
    input clk, WE,
    input [DATA - 1 : 0] WD,
    input [ADDR - 1 : 0] PC,
    output [DATA - 1 : 0] RD
);
    wire [ADDR - 1 : 0] A;
    reg [DATA - 1 : 0] I_MEM [0 : MEM_DEPTH - 1];

    always @(posedge clk) begin
        if (WE)
            I_MEM[A] <= WD;
    end

    assign A = PC >> 2;
    assign RD = I_MEM[A];
endmodule