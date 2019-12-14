module sevenseg(hex, segs);
input [3:0] hex;
output [6:0] segs;
assign segs = hex==0  ? 'b0000001   // active-low segments
            : hex==1  ? 'b1001111
            : hex==2  ? 'b0010010
            : hex==3  ? 'b0000110
            : hex==4  ? 'b1001100
            : hex==5  ? 'b0100100
            : hex==6  ? 'b0100000
            : hex==7  ? 'b0001111
            : hex==8  ? 'b0000000
            : hex==9  ? 'b0001100
            : hex==10 ? 'b0001000
            : hex==11 ? 'b1100000
            : hex==12 ? 'b0110001
            : hex==13 ? 'b1000010
            : hex==14 ? 'b0110000
            :           'b0111000;
endmodule
