module main_decoder (
    input [6:0] opcode, 
    output reg [1:0] aluOP, resultSrc, aluSrcA, 
    output reg [2:0] immSrc,
    output reg branch, memWrite, aluSrcB, regWrite, jump
);
    localparam LOAD    = 7'b0000011;           localparam STORE   = 7'b0100011;
    localparam R_Type  = 7'b0110011;           localparam I_Type  = 7'b0010011;
    localparam SB_Type = 7'b1100011;           localparam JAL     = 7'b1101111;
    localparam LUI     = 7'b0110111;           localparam AUIPC   = 7'b0010111;
    localparam JALR    = 7'b1100111;

    always @(*) begin
        case (opcode)
            LOAD: begin   
                regWrite  = 1;          immSrc    = 3'b000;
                aluSrcA   = 2'b00;      aluSrcB   = 1;
                memWrite  = 0;          resultSrc = 2'b01;
                branch    = 0;          aluOP     = 2'b00;
                jump      = 0;          
            end
            STORE: begin   
                regWrite  = 0;          immSrc    = 3'b001;
                aluSrcA   = 2'b00;      aluSrcB   = 1;
                memWrite  = 1;          resultSrc = 2'b11;  // x
                branch    = 0;          aluOP     = 2'b00;
                jump      = 0;          
            end
            R_Type: begin   
                regWrite   = 1;         immSrc    = 3'b000; // 2'bxx
                aluSrcA   = 2'b00;      aluSrcB   = 0;
                memWrite  = 0;          resultSrc = 2'b00;
                branch    = 0;          aluOP     = 2'b10; 
                jump      = 0;          
            end
            SB_Type: begin   
                regWrite  = 0;          immSrc    = 3'b010;
                aluSrcA   = 2'b00;      aluSrcB   = 0;
                memWrite  = 0;          resultSrc = 2'b11;  // x
                branch    = 1;          aluOP     = 2'b01;
                jump      = 0;          
            end
            I_Type: begin   
                regWrite  = 1;          immSrc    = 3'b000;
                aluSrcA   = 2'b00;      aluSrcB   = 1;
                memWrite  = 0;          resultSrc = 2'b00;  
                branch    = 0;          aluOP     = 2'b10;
                jump      = 0;          
            end
            JAL: begin   
                regWrite  = 1;          immSrc    = 3'b011;
                aluSrcA   = 2'b10;      aluSrcB   = 1;
                memWrite  = 0;          resultSrc = 2'b10;  
                branch    = 0;          aluOP     = 2'b00;
                jump      = 1;          
            end
            LUI: begin   
                regWrite  = 1;          immSrc    = 3'b100;
                aluSrcA   = 2'b01;      aluSrcB   = 1;
                memWrite  = 0;          resultSrc = 2'b00;  
                branch    = 0;          aluOP     = 2'b00;
                jump      = 0;          
            end
            AUIPC: begin
                regWrite  = 1;          immSrc    = 3'b100;
                aluSrcA   = 2'b10;      aluSrcB   = 1;
                memWrite  = 0;          resultSrc = 2'b00;  
                branch    = 0;          aluOP     = 2'b00;
                jump      = 0;          
            end
            JALR: begin   
                regWrite  = 1;          immSrc    = 3'b000;
                aluSrcA   = 2'b00;      aluSrcB   = 1;
                memWrite  = 0;          resultSrc = 2'b10;  
                branch    = 0;          aluOP     = 2'b00;
                jump      = 1;          
            end
            default:    begin   
                regWrite  = 0;          immSrc    = 3'b000;
                aluSrcA   = 2'b00;      aluSrcB   = 0;
                memWrite  = 0;          resultSrc = 0;
                branch    = 0;          aluOP     = 2'b00;
                jump      = 0;          
            end
        endcase
    end
endmodule