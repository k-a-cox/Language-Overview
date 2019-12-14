module FPdivide(clk,Start,Y,X,divdone,FPQ); 
input clk, Start;
input [31:0] X,Y;
output reg divdone;
output [31:0] FPQ;

reg [23:0] Q;
reg [9:0] EQ;
reg [24:0] A,B;
reg S, Step;

wire [24:0] AmB;
wire neg, done, Rneed, Wait;

always @(posedge clk)
	begin
		Step <= Wait&Start | Step&~done;	
		Q <= Step ? (done ? Q+Rneed : {Q[22:0],~neg}) : 0;
		B <= Wait&Start ? {2'd1,X[22:0]} : B;
		A <= Wait&Start ? {2'd1,Y[22:0]} : Step ? {neg ? A[23:0] : AmB[23:0],1'd0} : 0;
		S <= Wait&Start ? X[31]^Y[31] : S;
		EQ <= Wait&Start ? ({2'd0,Y[30:23]} - {2'd0,X[30:23]} + 127 + 24) : Step&~done ? EQ - 1 : EQ;
		divdone <= Step&done;
	end
	
assign AmB = A - B;
assign neg = AmB[24];
assign done = Q[23];
assign Rneed = (A>B) | (A==B)&Q[0];
assign FPQ = {S,EQ[7:0],Q[22:0]};

assign Wait = ~Step;

endmodule