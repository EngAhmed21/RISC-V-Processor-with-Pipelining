module sign_extend (
    input [31:7] instr,
    input [2:0] sel,
    output reg [31:0] out
);
    always @(*) begin
        case (sel)
            3'b000:   out = {{20{instr[31]}}, instr[31:20]};                                 // I Type
            3'b001:   out = {{20{instr[31]}}, instr[31:25], instr[11:7]};                    // S Type
            3'b010:   out = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};    // B Type
            3'b011:   out = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};  // J Type
            3'b100:   out = {instr[31:12], 12'd0};                                           // U Type  
            default:  out = 0;
        endcase
    end
endmodule