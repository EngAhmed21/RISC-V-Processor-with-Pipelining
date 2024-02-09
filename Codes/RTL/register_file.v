// frequency of clk_2 is double frequency of clk
// entry >> valid | address in ROB | data 

module register_file #(parameter DATA = 40, ADDR = 5)(
    input clk, clk_2, rstn, WE_D, WE_W, 
    input [(ADDR-1):0] RA1, RA2, WA_D, WA_W,
    input [6:0] tailD,
    input [31:0] WD,
    output [(DATA-1):0] RD1, RD2 
);
    reg [(DATA-1):0] reg_file [0:((2**ADDR)-1)];
    reg clk_en;

    always @(posedge clk_2) begin
        if (!rstn)
            clk_en <= 0;
        else 
            clk_en <= (~clk);
    end

    // Writing
    integer i;
    always @(posedge clk_2) begin
        if (!rstn)
            for (i = 0; i < (2**ADDR); i = i + 1) 
                reg_file[i] <= {1'b1, 39'b0};
        else if ((~clk_en) && WE_W && (|WA_W))
            reg_file[WA_W] <= {1'b1, 7'b0, WD};
        else if ((clk_en) && WE_D && (|WA_D))
            reg_file[WA_D] <= {1'b0, tailD, 32'b0};
    end

    // Reading 
    assign RD1 = reg_file[RA1];
    assign RD2 = reg_file[RA2];
endmodule