`timescale 1ns / 1ps

module adder(
        input [bits:0] a,
        input [bits:0] b,
        output [bits:0] c
    );
    parameter bits = 32;
    reg [bits:0] c_reg;
    always @(a or b)
    begin
        c_reg = a + b;
    end
    assign c =c_reg;
    
endmodule
