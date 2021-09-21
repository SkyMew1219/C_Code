`timescale 1ns / 1ps

module TwoC_2_sd(
    input  [2*bits:1] a,
    output  [2*bits:1] b
                );
    parameter bits = 32;
    
    reg  [2*bits:1] b_reg;
    
    always @(a)
        begin
        if(a[2*bits-1] == 0 && a[2*bits] == 0)
        begin
            b_reg = a;
        end
        else
        begin
            b_reg[2*bits:2*bits-1] = a[2*bits:2*bits-1];
            b_reg[2*bits-2:1] = ~(a[2*bits-2:1] - 1);
        end
    end
    
    assign b = b_reg;
    
endmodule
