module FPaddsub(clk,Start,Y,X,sumdone,FPS);
input clk, Start;
input [31:0] X,Y;
output reg sumdone;
//output [31:0] FPS;
output reg [31:0] FPS;


reg [7:0] eA,eB;
reg [28:0] A,B;
reg sA,sB;

reg [1:0] state;
wire Wait, Norm, Rnd;
assign Wait = (state==0);
assign Norm = (state==1);
assign Rnd = (state==2);

wire Rneed;

always @(posedge clk)
	begin
		state <= Wait ? (Start ? ( (Y[30:0] == X[30:0])&(Y[31]^X[31]) ? 0 : 1 ) : 0) :
				 Norm ? ( (eA > eB) ? 1 : 2 ) :
				 Rnd ? ( (A==0) ? 0 : (~A[27]&A[26]&~Rneed) ? 0 : 2 ) : 0;
		sA <= Wait&Start ? ((X[30:0] > Y[30:0]) ? X[31] : Y[31] ) : sA;
		sB <= Wait&Start ? ((X[30:0] > Y[30:0]) ? Y[31] : X[31] ) : sB;
		eA <= Wait&Start ? ((X[30:0] > Y[30:0]) ? X[30:23] : Y[30:23] ) : 
				Rnd ? (A[27] ? eA+1 : ~A[26] ? eA - 1 : eA) : eA;
		eB <=  Wait&Start ? ((X[30:0] > Y[30:0]) ? Y[30:23] : X[30:23] ) :
				Norm & (eA > eB) ? eB + 1 : eB;
		A  <=  Wait&Start ? ((X[30:0] > Y[30:0]) ? {2'd1,X[22:0],3'd0} : {2'd1,Y[22:0],3'd0} ) :
				Norm & (eA == eB) ? ( (sA^sB) ? A-B : A+B ) :
				Rnd ? (A[27] ? {1'd0, A[27:1]} : ~A[26] ? {A[26:0],1'd0} : Rneed ? A+4 : A) : A;
		B  <= Wait&Start ? ((X[30:0] > Y[30:0]) ? {2'd1,Y[22:0],3'd0} : {2'd1,X[22:0],3'd0} ) :
				Norm & (eA > eB) ? {1'd0,B[27:2],(B[1]|B[0])} : B;
		FPS <= Rnd&(A==0) ? {sA,eA,23'd0} : Rnd&(~A[27]&A[26]&~Rneed) ? {sA,eA,A[25:3]} : 0;
		sumdone <= Rnd&~A[27]&A[26]&~Rneed | Wait&Start&(Y[30:0] == X[30:0])&(Y[31]^X[31])|Rnd&(A==0);
	end
//assign FPS = {sA,eA,A[25:3]};
//assign FPS = {sB,eB,B[25:3]};
assign Rneed = A[2]&(A[3]|A[1]|A[0]);


endmodule