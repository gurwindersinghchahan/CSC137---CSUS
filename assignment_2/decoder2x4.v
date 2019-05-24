// Edward Prokopik
//
// decoder2x4.v, 2x4 decoder, gate synthesis
//


module DecoderMod(s, o); //module definition
    input  [1:0] s;
    output [0:3] o;
    
    wire [0:1] inv_s;
    
    not(inv_s[1], s[1]);
    not(inv_s[0], s[0]);

    and(o[0], inv_s[1], inv_s[0]);
    and(o[1], inv_s[1], s[0]);
    and(o[2], s[1], inv_s[0]);
    and(o[3], s[1], s[0]);
endmodule

module TestMod;    // tests DecoderMod
    reg  [0:1] s;         // s is a 1-bit flipflop
    wire [0:3] o;   // 2 additional wires
    
    DecoderMod decoder(s, o);

    initial begin
        $monitor("%0d\t%b\t%b",
            $time, s, o);
        $display("Time\ts\to");
        $display("----------------------------------------------------");
    end


    initial begin
        s = 2'b00; #1;
        s = 2'b01; #1;
        s = 2'b10; #1;
        s = 2'b11; #1;

    end
endmodule
