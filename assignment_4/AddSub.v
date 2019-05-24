
// Edward Prokopik
// Adder.v, 137 Verilog Programming Assignment #4

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

module AddSub(c_in, x_val, y_val, sum, c_4, c_5, e);

    input [4:0] x_val, y_val;
    input c_in;
    wire [4:0] xor_y;
    wire [4:1] c_val;     
    output [4:0] sum;
    output c_5, c_4;
    output e;

    xor(xor_y[0], c_in, y_val[0]);
    xor(xor_y[1], c_in, y_val[1]);
    xor(xor_y[2], c_in, y_val[2]);
    xor(xor_y[3], c_in, y_val[3]);
    xor(xor_y[4], c_in, y_val[4]);
    

    FullAdderMod adder1(c_in, x_val[0], xor_y[0], sum[0], c_val[1]);
    FullAdderMod adder2(c_val[1], x_val[1], xor_y[1], sum[1], c_val[2]);
    FullAdderMod adder3(c_val[2], x_val[2], xor_y[2], sum[2], c_val[3]);
    FullAdderMod adder4(c_val[3], x_val[3], xor_y[3], sum[3], c_4);
    FullAdderMod adder5(c_4, x_val[4], xor_y[4], sum[4], c_5);

    xor(e, c_4, c_5);

endmodule

module TestMod;    

   parameter STDIN = 32'h8000_0000; // I/O address of keyboard input channel

    reg [7:0] str [1:3];
    reg [4:0] x_val, y_val;
    reg c_in;
    wire [4:0] sum;
    wire c_5;   
    
    AddSub adder(c_in, x_val, y_val, sum, c_4, c_5, e);

    initial begin
       
            
        $display("Enter X (two digit 00~15: ");
        str[1] = $fgetc(STDIN);
        str[2] = $fgetc(STDIN);
        str[3]  = $fgetc(STDIN);
        str[1] = (str[1] - 48) * 10;
        str[2] = (str[2] - 48);
        x_val  = str[1] + str[2];

        $display("Enter Y (two digit 00~15: ");
        str[1] = $fgetc(STDIN);
        str[2] = $fgetc(STDIN);
        str[3]  = $fgetc(STDIN);
        str[1] = (str[1] - 48) * 10;
        str[2] = (str[2] - 48);
        y_val  = str[1] + str[2];

        $display("Enter either '+' or '-'");
        str[1] = $fgetc(STDIN);
        str[2] = $fgetc(STDIN);
        //if '+' c_in = 0
        // elsif '-' c_in = 1
        case(str[1])
            43: c_in = 0;
            45: c_in = 1;
        endcase

        #1;
        $display("X = %b (%d) \tY = %b (%d) C0=(%b)", x_val, x_val, y_val, y_val, c_in);

        $display("Result =%b (as unsigned %d)", sum, sum);

        $display("C4=%b C5=%b E=%b", c_4, c_5, e);

        case(e)
            0: $display("Since E is 0, C5 is not needed");
            1: $display("Since E is 1, correct with C5 in front: %b%b", c_5, sum);
        endcase

    end



endmodule
