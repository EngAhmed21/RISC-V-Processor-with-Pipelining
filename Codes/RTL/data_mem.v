// Dual port memory

module data_mem #(parameter DATA = 32, ADDR = 32, MEM_DEPTH = 256)(
    input clk, WE,
    input [ADDR - 1 : 0] WA, RA,
    input [DATA - 1 : 0] WD,
    output [DATA - 1 : 0] RD, test
);
    reg [DATA - 1 : 0] D_MEM [0 : MEM_DEPTH - 1];

    always @(posedge clk) begin
        if (WE)
            D_MEM[WA] <= WD;
    end
    
   assign RD = D_MEM[RA];
   assign test = D_MEM[0];
endmodule