module FPmultiply(clk,Start,Y,X,muldone,FPP);
input clk, Start;
input [31:0] X,Y;
output reg muldone;
output [31:0] FPP;

reg [24:0] P;
reg [9:0] E;
reg [23:0] A,B;
reg Round, sbit, S;

reg [1:0] state;
wire Wait, Step, Shift;
assign Wait = (state==0);
assign Step = (state==1);
assign Shift = (state==2);

wire [23:0] pp;
wire done, Rneed;

always @(posedge clk)
	begin
		state <= Wait ? (Start ? 2'd1 : 0) : Step ? (done ? 2'd2 : 2'd1) : Shift ? 0 : 0;
		P <= Wait&Start ? 0 : Step ? (done ? P+Rneed : P[24:1]+pp) : Shift&P[24] ? P[24:1]  : P;
		B <= Wait&Start ? {1'd1,X[22:0]} : B;
		S <= Wait&Start ? X[31]^Y[31] : S;
		A <= Wait&Start ? {1'd1,Y[22:0]} : Step&~done ? {1'd0,A[23:1]} : A ;
		E <= Wait&Start ? ({2'd0,Y[30:23]} + {2'd0,X[30:23]} - 127 - 24) : Step&~done ? E + 1 : Shift&P[24] ? E+1 : E;
		Round <= Wait&Start ? 0 : Step&~done ? P[0] : Round;
		sbit <= Wait&Start ? 0 : Step&~done ? Round|sbit : sbit;
		muldone <= Shift;
	end
	
assign pp = A[0] ? B : 0;
assign done = (A==0)&~P[24];
assign Rneed = Round&sbit|Round&~sbit&P[0];
assign FPP = {S,E[7:0],P[22:0]};


endmodule