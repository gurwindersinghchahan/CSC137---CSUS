// Edward Prokopik

// Parity Module
// x,y      -> xor -> r1
// c_in,r1  -> xor -> sum

// Majority Module
// x,y      -> and -> r1
// x,c_in   -> and -> r2
// y,c_in   -> and -> r3
// r1,r2,r3 -> or  -> c_out

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

module TestMod;    
    reg  x_val, y_val, c_in;       
    wire c_out, sum;   
    
    ParityMod parity(c_in, x_val, y_val, sum);
    MajorityMod majority(c_in, x_val, y_val, c_out);

    initial begin
        $monitor("%0d\t%b\t%b\t%b\t%b\t%b",
            $time, c_in, x_val, y_val, c_out, sum);
        $display("Time\tCin\tX\tY\tCout\tSum");
        $display("----------------------------------------------------");
    end


    initial begin
        c_in = 0; x_val = 0; y_val = 0; #1;
        c_in = 0; x_val = 0; y_val = 1; #1;
        c_in = 0; x_val = 1; y_val = 0; #1;
        c_in = 0; x_val = 1; y_val = 1; #1;
        c_in = 1; x_val = 0; y_val = 0; #1;
        c_in = 1; x_val = 0; y_val = 1; #1;
        c_in = 1; x_val = 1; y_val = 0; #1;
        c_in = 1; x_val = 1; y_val = 1; #1;

    end
endmodule