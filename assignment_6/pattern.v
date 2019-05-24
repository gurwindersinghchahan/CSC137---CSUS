// complete this code first
// then expand it to count 0~14, and name it as count16.v
// use only arrays for all registers and wires (except CLK)
// Edward Prokopik

module TestMod;
   reg CLK;
   wire [0:15] Q;
   wire [7:0] ascii;

   always begin // this is clock wave
      CLK = 0;  // 0 for half cycle (#1)
      #1;
      CLK = 1;  // 1 for half cycle (#1)
      //#1;
   end

   RippleMod my_ripple(CLK, Q);
   CoderMod my_coder(Q, ascii);

   initial #36 $finish;

   initial begin
        $monitor("%0d\t%b\t%b\t%c %d %b",
            $time,CLK,Q, ascii, ascii, ascii);
        $display("Time\tCLK\tQ\t\t\tName");
   end
endmodule

module CoderMod(Q, ascii);
   input [0:15] Q;
   output [7:0] ascii;

   assign ascii[7] = 0;
   or(ascii[6], Q[0] , Q[1] , Q[2] , Q[3], Q[4], Q[5], Q[7], Q[8], Q[9], Q[10], Q[11], Q[12], Q[13], Q[14]);   
   or(ascii[5], Q[6], Q[15], Q[1], Q[2], Q[3], Q[4], Q[5], Q[8], Q[9], Q[10], Q[11], Q[12], Q[13], Q[14]);
   or(ascii[4], Q[2], Q[4], Q[7] , Q[8], Q[12]);
   or(ascii[3], Q[9], Q[10], Q[11] , Q[13], Q[14]);
   or(ascii[2], Q[0] , Q[1] , Q[2] , Q[5], Q[9], Q[11]);
   or(ascii[1], Q[2] , Q[4] , Q[8] , Q[9], Q[10], Q[11], Q[14]);
   or(ascii[0], Q[0] , Q[2] , Q[3] , Q[9], Q[10], Q[11], Q[13], Q[14]);

endmodule

module RippleMod(CLK, Q);
   input CLK;
   output [0:15]Q;

   reg [0:15]Q;

   always @(posedge CLK) begin
      Q[0] <= Q[15];
      Q[1] <= Q[0];
      Q[2] <= Q[1];
      Q[3] <= Q[2];
      Q[4] <= Q[3];
      Q[5] <= Q[4];
      Q[6] <= Q[5];
      Q[7] <= Q[6];
      Q[8] <= Q[7];
      Q[9] <= Q[8];
      Q[10] <= Q[9];
      Q[11] <= Q[10];
      Q[12] <= Q[11];
      Q[13] <= Q[12];
      Q[14] <= Q[13];
      Q[15] <= Q[14];
      
   end

   initial begin // here we conveniently set flipflops to 1000 (binary)
      Q[0] = 1;
      Q[1] = 0;
      Q[2] = 0;
      Q[3] = 0;
      Q[4] = 0;
      Q[5] = 0;
      Q[6] = 0;
      Q[7] = 0;
      Q[8] = 0;
      Q[9] = 0;
      Q[10] = 0;
      Q[11] = 0;
      Q[12] = 0;
      Q[13] = 0;
      Q[14] = 0;
      Q[15] = 0;
      

   end
endmodule

