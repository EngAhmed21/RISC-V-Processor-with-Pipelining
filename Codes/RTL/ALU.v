module ALU (
    input signed [31:0] A, B,
    input [3:0] opcode,
    output reg signed  [31:0] ALU_out,
    output zero_flag
);
    localparam ADD  = 0;     localparam SUB = 1;
    localparam SLL  = 2;     localparam SLT = 3;
    localparam SLTU = 4;     localparam XOR = 5;
    localparam SRL  = 6;     localparam SRA = 7;
    localparam OR   = 8;     localparam AND = 9;

    // ALU operations
    always @(*) begin
        case(opcode)
            ADD:    ALU_out = A + B;
            SUB:    ALU_out = A - B;
            SLL:    ALU_out = (A << B[4:0]);
            SLT:    ALU_out = (A < B);
            SLTU:   ALU_out = ($unsigned(A) < $unsigned(B));
            XOR:    ALU_out = A ^ B;
            SRL:    ALU_out = (A >> B);
            SRA:    ALU_out = {A[31], (A >> B)};
            OR:     ALU_out = A | B;
            AND:    ALU_out = A & B;
            default:   ALU_out = 32'd0;
        endcase
    end

    // Flags
    assign zero_flag = ~(|ALU_out);
endmodule