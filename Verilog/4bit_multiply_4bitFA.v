module Proj_2(m, q, p);     
	input [3:0] m, q;
	output [7:0] p;
	wire [3:0] lineB, lineC, lineD;
	wire [4:0] lineA, adderA, adderB, adderC;
	wire z, gnd;
	assign z = m[0]&q[0];
	assign gnd = 0;
	
	assign lineA = {gnd, m[3]&q[0],m[2]&q[0],m[1]&q[0],m[0]&q[0]};
	assign lineB = {m[3]&q[1],m[2]&q[1],m[1]&q[1],m[0]&q[1]};
	assign lineC = {m[3]&q[2],m[2]&q[2],m[1]&q[2],m[0]&q[2]};
	assign lineD = {m[3]&q[3],m[2]&q[3],m[1]&q[3],m[0]&q[3]};
		
	FourBitAdder bigAdder1 (lineA[4:1], lineB, adderA);
	FourBitAdder bigAdder2 (adderA[4:1], lineC, adderB);
	FourBitAdder bigAdder3 (adderB[4:1], lineD, adderC);
	
	assign p = {adderC, adderB[0], adderA[0], z};
		
endmodule

module FourBitAdder(a, b, sum);
	input [3:0] a, b;
	output [4:0] sum;
	wire [1:0] adderA, adderB, adderC, adderD;
	
	FA adder1 (a[0], b[0], 0, adderA);
	FA adder2 (a[1], b[1], adderA[1], adderB);
	FA adder3 (a[2], b[2], adderB[1], adderC);
	FA adder4 (a[3], b[3], adderC[1], adderD);

	assign sum = {adderD,adderC[0],adderB[0],adderA[0]};
endmodule
	

module FA(a, b, cin, total);     
	input a, b, cin;     
	output [1:0] total;
	assign total = a + b + cin; //add the three bits to form a 2-bit sum 
endmodule