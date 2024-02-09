// entry >> valid bit + TAG + 2 bit predictor

module BHB #(parameter SIZE = 1024) (
    input clk, rstn, takenE, branch,
    input [29:0] PC_IF, PC_EX,
    output valid, 
    output reg takenF
);
    localparam INDEX = $clog2(SIZE);
    localparam TAG   = 30 - INDEX;

    wire [1:0] predict_temp;
    reg [1:0] predict_EX;
    wire [(TAG+2):0] entry;
    reg [(TAG+2):0] buffer [0:(SIZE-1)];

    // Write the target after computed in EX stage
    assign predict_temp = buffer[PC_EX[(INDEX-1):0]][1:0];

    always @(*) begin
        if (takenE && (predict_temp != 2'b11))
            predict_EX = predict_temp + 1;
        else if ((~takenE) && (predict_temp != 2'b00))
            predict_EX = predict_temp - 1;
        else 
            predict_EX = predict_temp;
    end
    integer i;
    always @(negedge clk) begin
        if (!rstn)
            for (i = 0; i < SIZE; i = i + 1)
                buffer[i] <= 1;    // initialy weakly not takenF
        else if (branch)
            buffer[PC_EX[(INDEX-1):0]] <= {1'b1, PC_EX[29:INDEX], predict_EX};
    end

    // Read the target at iF stage
    assign entry = buffer[PC_IF[(INDEX-1):0]];
    assign valid = ((entry[TAG+2]) && (entry[(TAG+1):2]) == PC_IF[29:INDEX]);

    always @(*) begin
        if (valid)
            if ((entry[1:0] == 2'b10) || (entry[1:0] == 2'b11))
                takenF = 1;
            else
                takenF = 0;
        else
            takenF = 0;
    end
endmodule