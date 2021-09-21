module booth(
    input  [bits-1:0] x,
    input  [bits-1:0] y,
    output  [2*bits:1] result
            );
    parameter bits = 32;
    
    wire  [bits-1:0] _x;
    assign _x = {~x[bits-1],x[bits-2:0]};
    wire  [bits:0] x_2c;
    wire  [bits:0] y_2c;
    wire  [bits:0] _x_2c;
    
    sd_2_2c c_u1(.a(x),.b(x_2c[bits-1:0]));
    sd_2_2c c_u2(.a(y),.b(y_2c[bits:1]));
    sd_2_2c c_u3(.a(_x),.b(_x_2c[bits-1:0]));
    
    assign    x_2c[bits] = x_2c[bits-1];
    assign    y_2c[0] = 0;
    assign    _x_2c[bits] = _x_2c[bits-1];
    
    wire [bits:0] part_product [bits:1];
    wire [bits:0] multiplier [bits - 1:0];
    
    wire [bits:0] part_product_shift [bits-1:0];
    
    reg [2*bits:1] result_reg_2c;
    
    assign part_product_shift[0] = 9'b0;
    assign multiplier[0] = y_2c;
    genvar m;
    generate
    for(m=1; m<bits; m=m+1)
    begin:unit
        adder myadder (
                        .a(part_product_shift[m-1]),
                        .b(multiplier[m-1][0] > multiplier[m-1][1]? x_2c : (
                            multiplier[m-1][0] < multiplier[m-1][1]? _x_2c : 0)),
                        .c(part_product[m])
                        );
        shift myshift (
                        .a(part_product[m]),
                        .b(multiplier[m-1]),
                        .a_shift(part_product_shift[m]),
                        .b_shift(multiplier[m])
                        );
    end
    adder final_add (
                        .a(part_product_shift[bits-1]),
                        .b(multiplier[bits-1][0] > multiplier[bits-1][1]? x_2c : (
                            multiplier[bits-1][0] < multiplier[bits-1][1]? _x_2c : 0)),
                        .c(part_product[bits])
                        );
    endgenerate
    
    always @(part_product[bits] or multiplier[bits-1])
    begin
        result_reg_2c = {part_product[bits][bits:0],multiplier[bits-1][bits:2]};
    end
    
    TwoC_2_sd myTwoc_2_sd(
                            .a(result_reg_2c),
                            .b(result)
                            );
    
endmodule