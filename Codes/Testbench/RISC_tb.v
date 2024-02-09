module RISC_tb ();
    reg clk, clk_2, rstn;
    wire [31:0] test;

    TOP_MODULE uut (.clk(clk), .clk_2(clk_2), .rstn(rstn), .test(test));

    localparam CLK_PERIOD = 4;
    always 
        #(CLK_PERIOD / 2)  clk   = ~clk;
    always 
        #(CLK_PERIOD / 4)  clk_2 = ~clk_2;
        
    initial begin
        clk = 1;        clk_2 = 1;      rstn = 0;   

        $readmemh("Test_Program3.dat", uut.FETCH.INSTR_MEM.I_MEM, 0, 6);

        @(negedge clk)  rstn = 1;

        repeat (25)  @(negedge clk);
        $stop;
    end
endmodule
