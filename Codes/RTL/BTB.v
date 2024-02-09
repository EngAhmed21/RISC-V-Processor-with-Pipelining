// entry >> valid bit + a bit that determine if the instruction is a jump or branch + TAG + 32 bit target
// PC is shift right by 2 so the 2 LSBs are ignored 

module BTB #(parameter SIZE = 1024) (
    input clk, rstn, 
    input [1:0] PCSrc,
    input [29:0] PC_IF, PC_EX, // PC[31:2] as PC[1:0] always equal 2'b00 
    input [31:0] PC_target, aluResultE,
    output valid, jump,
    output [31:0] target_out
);
    localparam INDEX = $clog2(SIZE);
    localparam TAG   = 30 - INDEX;

    wire [(TAG+33):0] entry;
    reg [(TAG+33):0] buffer [0:(SIZE-1)];

    // Write the target after computed in EX stage
    integer i;
    always @(negedge clk) begin
        if (!rstn)
            for (i = 0; i < SIZE; i = i + 1)
                buffer[i] <= 0;
        else if (PCSrc[1])
            buffer[PC_EX[(INDEX-1):0]] <= {1'b1, 1'b1, PC_EX[29:INDEX], aluResultE};
        else if (PCSrc[0])
            buffer[PC_EX[(INDEX-1):0]] <= {1'b1, 1'b0, PC_EX[29:INDEX], PC_target};
    end

    // Read the target at iF stage
    assign entry = buffer[PC_IF[(INDEX-1):0]];
    assign jump = entry[TAG+32];
    assign valid = ((entry[TAG+33]) && (entry[(TAG+31):32]) == PC_IF[29:INDEX]);
    assign target_out = (valid) ? entry[31:0] : 32'd0;
endmodule