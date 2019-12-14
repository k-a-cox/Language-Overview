module Proj_3(a, clk, m, n);
	input a, clk;
	output m, n;
	reg [2:0] state;
	always @(posedge clk)
		case(state)
			0: if(a) 
					state <= 1;
			  else 
					state <= 4;
			1: if(a)
					state <= 2;
			   else 
					state <= 3;
			2: if(a) 
					state <= 3;
			3: state <= 4;
			4: state <= 5;
			5: if(a) 
					state <= 6;
			   else
					state <= 7;
			6: if(a) state <= 7;
			7: state <= 0;
		endcase
		
	assign m = (state==7)||(state==2)&(~a)||(state==6)&(~a);
	assign n = (state==3)||(state==4);
endmodule
