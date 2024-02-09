module ALU_decoder (
    input [1:0] aluOP, OP_f7,
    input [2:0] funct3,
    output reg [3:0] ALU_control
);
    localparam ADD  = 0;     localparam SUB = 1;
    localparam SLL  = 2;     localparam SLT = 3;
    localparam SLTU = 4;     localparam XOR = 5;
    localparam SRL  = 6;     localparam SRA = 7;
    localparam OR   = 8;     localparam AND = 9;

    always @(*) begin
        case (aluOP)
            2'b00:      ALU_control = ADD;              // LW, SW, LUI, AUIPC, JAL, JALR
            2'b01:                                      // SB
                if ((funct3 == 3'b000) || (funct3 == 3'b001))
                    ALU_control = SUB;
                else if ((funct3 == 3'b100) || (funct3 == 3'b101))
                    ALU_control = SLT;
                else if ((funct3 == 3'b110) || (funct3 == 3'b111))
                    ALU_control = SLTU;
                else
                    ALU_control = 15;
            2'b10:                                      // R-I Type
                case (funct3)
                    3'b000: 
                        if (&OP_f7)
                            ALU_control = SUB;       
                        else
                            ALU_control = ADD;       
                    3'b001:
                            ALU_control = SLL;      
                    3'b010:
                            ALU_control = SLT;       
                    3'b011:
                            ALU_control = SLTU;     
                    3'b100:
                            ALU_control = XOR;       
                    3'b101:
                        if (OP_f7[0])
                            ALU_control = SRA;       
                        else
                            ALU_control = SRL;    
                    3'b110:
                        ALU_control = OR;       
                    3'b111: 
                        ALU_control = AND;       
                    default: 
                        ALU_control = 15;
                endcase
            default:    ALU_control = 15;   // ALU_result = 0 
        endcase
    end
endmodule