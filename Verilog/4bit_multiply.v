module Proj_1(m, q, p);     
	input [3:0] m, q;
	output [7:0] p;
	wire [3:0] lineA, lineB, lineC, lineD;
	wire [1:0] adderA, adderB, adderC, adderD, adderE, adderF, adderG, adderH, adderI, adderJ, adderK, adderL;
	wire z;
	assign z = m[0]&q[0];
	
	assign lineA = {m[3]&q[0],m[2]&q[0],m[1]&q[0],m[0]&q[0]};
	assign lineB = {m[3]&q[1],m[2]&q[1],m[1]&q[1],m[0]&q[1]};
	assign lineC = {m[3]&q[2],m[2]&q[2],m[1]&q[2],m[0]&q[2]};
	assign lineD = {m[3]&q[3],m[2]&q[3],m[1]&q[3],m[0]&q[3]};
	
	adderFA adder1 (lineA[1], lineB[0], 0, adderA);
	adderFA adder2 (lineA[2], lineB[1], adderA[1], adderB);
	adderFA adder3 (lineA[3], lineB[2], adderB[1], adderC);
	adderFA adder4 (lineB[3], 0, adderC[1], adderD);
	
	adderFA adder5 (adderB[0], lineC[0], 0, adderE);
	adderFA adder6 (lineC[1], adderC[0], adderE[1], adderF);
	adderFA adder7 (lineC[2], adderD[0], adderF[1], adderG);
	adderFA adder8 (lineC[3], adderD[1], adderG[1], adderH);
	
	adderFA adder9 (lineD[0], adderF[0], 0, adderI);
	adderFA adder10 (lineD[1], adderG[0], adderI[1], adderJ);
	adderFA adder11 (lineD[2], adderH[0], adderJ[1], adderK);
	adderFA adder12 (lineD[3], adderH[1], adderK[1], adderL);
	
	assign p = {adderL[1],adderL[0],adderK[0],adderJ[0],adderI[0],adderE[0],adderA[0],z};
		
endmodule

module adderFA(a, b, c, sum);     
	input a, b, c;     
	output [1:0] sum;
	assign sum = a + b + c; //add the three bits to form a 2-bit sum 
endmodule