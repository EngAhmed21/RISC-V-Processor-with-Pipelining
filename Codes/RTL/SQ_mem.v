// Queue size is 64
// entry valid_entry | PC | valid_data | addr | data
// addr >> mem_addr[$clog2(MEM_DEPTH) - 1 : 0]  >> in this implementation >> MEM_DEPTH = 256

module SQ_mem  (
    input clk, clk_2, rstn, WE_D, WE_E, del, ld,
    input [5:0] WA_E, 
    input [7:0] ldM_A,
    input [31:0] PCld,
    input [73:0] WD_D, WD_E,
    output full,  
    output reg valid,
    output [5:0] tail,
    output reg [73:0] RD
);    
    reg [73:0] QUEUE [0:63];
    reg [6:0] head_ptr, tail_ptr;
    reg [5:0] ldQ_addr;
    reg clk_en;
    wire empty;

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
            QUEUE[tail_ptr[5:0]] <= WD_D;
            tail_ptr <= tail_ptr + 1;
        end
        else if ((WE_E) && (~clk_en) && (!empty)) 
            QUEUE[WA_E] <= WD_E;
    end

    // De-allocate
    always @(posedge clk) begin
        if (!rstn)
            head_ptr <= 0;
        else if (del && (!empty)) 
            head_ptr <= head_ptr + 1;            
    end

    // Read
    integer i;
    always @(*) begin
        valid = 0;
        RD    = 0;

        for (i = 0; i < 64; i = i + 1) begin
            if (ld && (ldM_A == QUEUE[i][39:32]) && QUEUE[i][73] && QUEUE[i][40] && (PCld > QUEUE[i][72:41]) && (!empty)) begin
                valid = 1;
                RD    = QUEUE[i];
            end 
        end
    end

    // Flags
    assign full  = ((head_ptr[5:0] == tail_ptr[5:0]) && (head_ptr[6] != tail_ptr[6]));
    assign empty = (tail_ptr == head_ptr);

    // tail
    assign tail = tail_ptr[5:0];
endmodule