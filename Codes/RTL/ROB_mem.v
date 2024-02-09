// ROB_mem has a clock (clk_2) which is double the original (clk) one to be able to write at decode and execute stages
// entry >> hValidEntry | destReg | EX_result | mem_WD | control | pc_plus4E

module ROB_mem #(parameter ADDR = 7) (
    input clk, clk_2, rstn, WE_D, WE_E,
    input [(ADDR-1):0] WA_E, tail_src1E, tail_src2E,
    input [113:0] WD_D, WD_E,
    output full, empty, head_valid, 
    output [(ADDR-1):0] tail,
    output [113:0] RD_W, RD_E1, RD_E2
);
    reg [113:0] ROB_MEM [0:((2**ADDR)-1)];
    reg [ADDR:0] head_ptr, tail_ptr;
    wire hValidEntry, hValidR, hValidM;
    reg clk_en;

    // head_valid
    assign hValidEntry = ROB_MEM[head_ptr[(ADDR-1):0]][113];
    assign hValidR     = ROB_MEM[head_ptr[(ADDR-1):0]][32];
    assign hValidM     = ROB_MEM[head_ptr[(ADDR-1):0]][33];
    assign branch      = ROB_MEM[head_ptr[(ADDR-1):0]][34];
    assign head_valid  = (hValidEntry & (hValidR | hValidM | branch));

    // clk_en
    always @(posedge clk_2) begin
        if (!rstn)
            clk_en <= 0;
        else 
            clk_en <= (~clk);
    end

    // Write 
    always @(posedge clk_2) begin
        if (!rstn)
            tail_ptr <= 0;
        else if ((WE_D) && (!full) && (clk_en)) begin
            ROB_MEM[tail_ptr[(ADDR-1):0]] <= WD_D;
            tail_ptr <= tail_ptr + 1;
        end
        else if ((WE_E) && (~clk_en) && (!empty)) 
            ROB_MEM[WA_E] <= WD_E;
    end

    // Read
    always @(posedge clk) begin
        if (!rstn)
            head_ptr <= 0;
        else if ((head_valid) && (!empty)) 
            head_ptr <= head_ptr + 1;            
    end

    // RD
    assign RD_W  = ROB_MEM[head_ptr[(ADDR-1):0]];
    assign RD_E1 = ROB_MEM[tail_src1E];
    assign RD_E2 = ROB_MEM[tail_src2E];

    // Flags
    assign full = ((head_ptr[(ADDR-1):0] == tail_ptr[(ADDR-1):0]) && (head_ptr[ADDR] != tail_ptr[ADDR]));
    assign empty = (tail_ptr == head_ptr);

    // tail
    assign tail = tail_ptr[(ADDR-1):0];
endmodule