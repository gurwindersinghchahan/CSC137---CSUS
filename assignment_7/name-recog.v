// name-recog.v
// sequence recognizer, recognize input of "Edwar" by ouput match = 1

module TestMod;
   	parameter STDIN = 32'h8000_0000; // keyboard-input file-handle address

   	reg clk;
   	reg [6:0] str [1:6];  // to what's to be entered
   	wire match;           // to be set 1 when matched
   	reg [6:0] ascii;      // each input letter is an ASCII bitmap

   	RecognizerMod my_recognizer(clk, ascii, match);

   	initial begin
      	$display("Enter the the magic sequence: ");
      	str[1] = $fgetc(STDIN);  // 1st letter 'E'
      	str[2] = $fgetc(STDIN);  // 2nd letter 'd'
		str[3] = $fgetc(STDIN);  // 3rd letter 'w'
		str[4] = $fgetc(STDIN);  // 4th letter 'a'
		str[5] = $fgetc(STDIN);  // 5th letter 'r'
		str[6] = $fgetc(STDIN);  // enter key

        $display("Time clk    ascii       match");
        $monitor("%4d   %b    %c %b   %b", $time, clk, ascii, ascii, match);

        clk = 0;

        ascii = str[1];
        #1 clk = 1; #1 clk = 0;

		ascii = str[2];
		#1 clk = 1; #1 clk = 0;

		ascii = str[3];
		#1 clk = 1; #1 clk = 0;

		ascii = str[4];
		#1 clk = 1; #1 clk = 0;	
        
		ascii = str[5];
		#1 clk = 1; #1 clk = 0;
   	end
endmodule

module RecognizerMod(clk, ascii, match);
   	input clk;
   	input [6:0] ascii;
   	output match;

   	wire [0:4] Q [0:6];   // 5-input sequence, 7 bits each
   	wire [6:0] submatch;  // all bits matched (7 3-bit sequences)

   	wire invQ54, 
	     invQ44, invQ43, invQ41, 
	     invQ35, invQ34, invQ33, invQ32, invQ31, invQ30, 
	     invQ21, invQ20, 
	     invQ14, invQ13, invQ12, invQ10,
	     invQ03, invQ00; // inverted signals

   	//         654 3210   Q
   	//     hex binary
   	// 'E' 45  100 0101 < q4
   	// 'd' 64  110 0100 < q3
   	// 'w' 77  111 0111 < q2
	// 'a' 61  110 0001 < q1
	// 'r' 72  111 0010 < q0

   	RippleMod Ripple6(clk, ascii[6], Q[6]);
	RippleMod Ripple5(clk, ascii[5], Q[5]);
	RippleMod Ripple4(clk, ascii[4], Q[4]);
	RippleMod Ripple3(clk, ascii[3], Q[3]);
	RippleMod Ripple2(clk, ascii[2], Q[2]);
	RippleMod Ripple1(clk, ascii[1], Q[1]);
	RippleMod Ripple0(clk, ascii[0], Q[0]);

   	and(submatch[6], Q[6][4], Q[6][3], Q[6][2], Q[6][1], Q[6][0]); // 6th column 111 111
  	
    not(invQ54, Q[5][4]);
	and(submatch[5], invQ54, Q[5][3], Q[5][2], Q[5][1], Q[5][0]); 	//5th column 011 111
	
    not(invQ44, Q[4][4]);	
	not(invQ43, Q[4][3]);	
	not(invQ41, Q[4][1]);
	and(submatch[4], invQ44, invQ43, Q[4][2], invQ41, Q[4][0]); 	//4th column 100 101
	
    not(invQ34, Q[3][4]);	
	not(invQ32, Q[3][2]);	
	not(invQ33, Q[3][3]);	
	not(invQ31, Q[3][1]);	
	not(invQ30, Q[3][0]);	
	and(submatch[3], invQ34, invQ33, invQ32, invQ31, invQ30); 	//3rd column 010 010
	
    not(invQ21, Q[2][1]);
	not(invQ20, Q[2][0]);
	and(submatch[2], Q[2][4], Q[2][3], Q[2][2], invQ21, invQ20); 	//2nd column 100 110
	
    not(invQ14, Q[1][4]);
	not(invQ13, Q[1][3]);
	not(invQ11, Q[1][1]);
	and(submatch[1], invQ14, invQ13, Q[1][2], invQ11, Q[1][0]); 	//1st column 101 011
	
    not(invQ03, Q[0][3]);	
    not(invQ00, Q[0][0]);
	and(submatch[0],Q[0][4], invQ03, Q[0][2], Q[0][1], invQ00);	//0th column 011 010

   	and(match, submatch[6], submatch[5], submatch[4], submatch[3], submatch[2], submatch[1], submatch[0]);
endmodule

module RippleMod(clk, ascii_bit, q);
   	input clk, ascii_bit;
   	output [0:4] q;

   	reg [0:4] q;          // flipflops

   	always @(posedge clk) begin
      	q[0] <= ascii_bit;
		q[1] <= q[0];
		q[2] <= q[1];
		q[3] <= q[2];
		q[4] <= q[3];
   	end

   	initial q = 5'b00000;
endmodule