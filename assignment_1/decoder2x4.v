// Edward Prokopik
//
// decoder2x4.v, 2x4 decoder, gate synthesis
//


module DecoderMod(s1, s0, o0, o1, o2, o3); //module definition
    input s1, s0;
    output o0, o1, o2, o3;
    
    wire inv_s1, inv_s0;
    
    not(inv_s1, s1);
    not(inv_s0, s0);

    and(o0, inv_s1, inv_s0);
    and(o1, inv_s1, s0);
    and(o2, s1, inv_s0);
    and(o3, s1, s0);
endmodule

module TestMod;    // tests DecoderMod
    reg s1, s0;         // s is a 1-bit flipflop
    wire o0, o1;   // 2 additional wires
    
    DecoderMod decoder(s1, s0, o0, o1, o2, o3);

    initial begin
        $monitor("%0d\t%b\t%b\t%b\t%b\t%b\t%b",
            $time, s1, s0, o0, o1, o2, o3);
        $display("Time\ts1\ts0\to0\to1\to2\to3");
        $display("----------------------------------------------------");
    end


    initial begin
        s1 = 0; s0 = 0; #1;
        s1 = 0; s0 = 1; #1;
        s1 = 1; s0 = 0; #1;
        s1 = 1; s0 = 1; #1;
    end
endmodule
