
// Edward Prokopik
// Adder.v, 137 Verilog Programming Assignment #3

module ParityMod(c_in, x_val, y_val, sum);
    input c_in, x_val, y_val;
    output sum;

    wire r1;

    xor(r1, x_val, y_val);
    xor(sum, r1, c_in);
    
endmodule

module MajorityMod(c_in, x_val, y_val, c_out);
    input c_in, x_val, y_val;
    output c_out;

    wire [1:3] r;

    and(r[1], x_val, y_val);
    and(r[2], x_val, c_in);
    and(r[3], y_val, c_in);
    or(c_out, r[1], r[2], r[3]);

endmodule

module FullAdderMod(c_in, x_val, y_val, sum, c_out);
    input c_in, x_val, y_val;
    output sum, c_out;

    ParityMod parity(c_in, x_val, y_val, sum);
    MajorityMod majority(c_in, x_val, y_val, c_out);


endmodule

module BigAdder(x_val, y_val, sum, c_5);

    input [4:0] x_val, y_val;
    output [4:0] sum;
    output c_5;

    reg c_in = 0;
    wire [4:1] c_val; 

    FullAdderMod adder1(c_in, x_val[0], y_val[0], sum[0], c_val[1]);
    FullAdderMod adder2(c_val[1], x_val[1], y_val[1], sum[1], c_val[2]);
    FullAdderMod adder3(c_val[2], x_val[2], y_val[2], sum[2], c_val[3]);
    FullAdderMod adder4(c_val[3], x_val[3], y_val[3], sum[3], c_val[4]);
    FullAdderMod adder5(c_val[4], x_val[4], y_val[4], sum[4], c_5);

endmodule

module TestMod;    

   parameter STDIN = 32'h8000_0000; // I/O address of keyboard input channel

    reg [7:0] str [1:3];
    reg [4:0] x_val, y_val;
  
    wire [4:0] sum;
    wire c_5;   
    
    BigAdder adder(x_val, y_val, sum, c_5);

    initial begin
       
            
        $display("Enter X (two digit 00~15 (since max is 01111): ");
        str[1] = $fgetc(STDIN);
        str[2] = $fgetc(STDIN);
        str[3]  = $fgetc(STDIN);
        str[1] = (str[1] - 48) * 10;
        str[2] = (str[2] - 48);
        x_val  = str[1] + str[2];

        $display("Enter Y (two digit 00~15 (since max is 01111): ");
        str[1] = $fgetc(STDIN);
        str[2] = $fgetc(STDIN);
        str[3]  = $fgetc(STDIN);
        str[1] = (str[1] - 48) * 10;
        str[2] = (str[2] - 48);
        y_val  = str[1] + str[2];

        #1;
        $display("X = %d (%b) \tY = %d (%b)", x_val, x_val, y_val, y_val);
        $display("Result =%d (%b) \tC5 = %b", sum, sum, c_5);

    end



endmodule
