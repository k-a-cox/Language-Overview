// The MiniS08 for F19

module MiniS08(clk50,rxd,resetPBin,tickPBin,clksel,clkdisp,txd,addr,data,stateout,IRout);
input clk50, rxd, resetPBin, tickPBin;
input [2:0] clksel;
output clkdisp;
output txd;
output [20:0] addr;  // three 7-segment displays
output [13:0] data;  // two 7-segment displays
output [13:0] IRout;
output [6:0] stateout;

wire oePC, oeHX, oeSP;
wire oeA, oeH, oeX, oePCH, oePCL, Read;
wire ldIR, ldA, ldH, ldX, ldHX, ldMARH, ldMARL, ldMAR, ldPC;
wire IncPC, IncSP, DecSP;
wire Write, notst1n, BCT, SCIsel, RAMsel, ROMsel, FPUsel;

wire aiX, addPC, oeMAR, oeiSP, reset, N, Z, clkmux;
// wire addtoPC martoPC  //do I need these????

wire st0, st1, st2, st3, st4, st5;
wire modA, branch, jmp, jsr, rts;
wire inh, imm, dir, ext, ix;
wire pula, lda, add, sub, AND, ora, eor, lsra, asra, lsla, psha, sta;
wire ldx, ldhx, pulh, pulx, aix, stx, pshh, pshx;
wire bra, bcc, bcs, bpl, bmi, bne, beq, bge, blt;
wire [7:0] SCIout, RAMout, ROMout, FPUout; 
wire [10:0] abus;
wire [7:0] dbus;
wire [8:0] ALU,iSP;

reg RB, tick, S08clk;           // flip-flops to clean up (synchronize) the pushbutton & divided clock

reg [2:0] CPUstate;
reg [27:0] clkdiv;
reg C, V;
reg [7:0] A, IR;
reg [8:0] SP;
reg [10:0] HX, PC, MAR;

sevenseg A2({1'd0,abus[10:8]},addr[20:14]);
sevenseg A1(abus[7:4],addr[13:7]);
sevenseg A0(abus[3:0],addr[6:0]);
sevenseg D1(dbus[7:4],data[13:7]);
sevenseg D0(dbus[3:0],data[6:0]);
sevenseg IR1(IR[7:4], IRout[13:7]);    
sevenseg IR0(IR[3:0], IRout[6:0]);
sevenseg ST({1'b0,CPUstate},stateout);

sci S08sci(clk50, dbus, SCIout, SCIsel, abus[2:0], Read, Write, rxd, txd);
ram S08ram(abus[8:0],clk50,dbus,Write&RAMsel,RAMout);
rom2 S08rom(abus,clk50,ROMout);
FPU S08fpu(clk50, dbus, FPUout, FPUsel, abus[1:0], Read, Write);

always @(posedge clk50)
   begin
      clkdiv <= clkdiv+1;
      RB <= ~resetPBin;
      tick <= ~tickPBin;
      S08clk <= clkmux;
   end
assign clkmux = clksel==0 ? tick : clksel==1 ? clkdiv[27] : clksel==2 ? clkdiv[24] : clksel==3 ? clkdiv[21]
              : clksel==4 ? clkdiv[17] : clksel==5 ? clkdiv[15] : clksel==6 ? clkdiv[13] : clkdiv[0];
assign clkdisp = clkmux;
assign FPUsel = abus<4;
assign SCIsel = abus<8&~FPUsel;
assign RAMsel = abus>='h8 & ~ROMsel; 
assign ROMsel = abus>='h200;

assign st0 = CPUstate==0;
assign st1=(CPUstate==1);
assign st2=(CPUstate==2);
assign st3=(CPUstate==3);
assign st4=(CPUstate==4);
assign st5=(CPUstate==5);
assign notst1n=st0|st1|ext&(st2|st3)|dir&st2|ldhx&imm&st2|jsr&st4|rts&(st2|st3);
  
always @(posedge S08clk)
   begin
		C <= ldA&(add|sub|inh)?ALU[8]:C;
		V <= (add|sub)?((A[7]^dbus[7])^(ALU[7]^ALU[8])):V;
		A <= ldA ? ALU[7:0] : A;
		HX <= ldH ? {dbus[2:0],HX[7:0]} : ldX ? {HX[10:8],dbus} : aiX ? (HX+{dbus[7],dbus[7],dbus[7],dbus}) : HX;
		SP <= IncSP ? iSP : DecSP ? SP-1 : reset ? 9'h1ff : SP;
		PC <= reset ? 11'h200 : IncPC ? PC+1 : ldPC ? MAR : addPC ? (PC+1+(BCT ? {dbus[7],dbus[7],dbus[7],dbus} : 0)) : PC;
		IR <= ldIR ? dbus : IR;
		MAR <= ldMARH ? {dbus[2:0],MAR[7:0]} : ldMARL ? {MAR[10:8],dbus} : ldMAR ? dbus : MAR;
		CPUstate <= RB ? 0 : notst1n ? (CPUstate+1) : 1;
	end
// a lot more stuff

assign iSP = SP+1;

assign dbus = oeA ? A : oeH ? HX[10:8] : oeX ? HX[7:0] : oePCH ? PC[10:8] : oePCL ? PC[7:0] : Read&SCIsel ? SCIout : Read&RAMsel ? RAMout : Read&ROMsel ? ROMout : Read&FPUsel ? FPUout : 0;
assign abus = oeHX ? HX : oeSP ? SP : oePC ? PC : oeMAR ? MAR : oeiSP ? iSP : 0;
assign ALU = lda|pula ? dbus : add ? {1'd0,A}+{1'd0,dbus} : sub ? {1'd0,A}-{1'd0,dbus} : AND ? (A&dbus) : ora ? (A|dbus) : eor ? (A^dbus) : lsra ? A[7:1] : asra ? {A[7],A[7:1]} : lsla ? {A,1'd0} : 0;

assign N = A[7];
assign Z = (A==0);


assign inh=(IR[7:4]=='h4)&~(IR[3:0]=='h5);
assign imm=(IR[7:4]=='hA)|(IR=='h45);
assign dir=(IR[7:4]=='hB);
assign ext=(IR[7:4]=='hC);
assign ix=(IR[7:4]=='hF);

assign modA=lda|add|sub|AND|ora|eor|lsra|asra|lsla;
assign branch=bra|bcc|bcs|bpl|bmi|bne|beq|bge|blt;
assign BCT=bra|bcc&~C|bcs&C|bpl&~N|bmi&N|bne&~Z|beq&Z|bge&((~N)^V)|blt&(N^V);

//"Instructions"
assign pula=(IR=='h86);
assign lda=(IR[3:0]=='h6)&~pula&~bne;
assign add=(IR[3:0]=='hB)&~pshh&~bmi;
assign sub=(IR[3:0]=='h0)&~bra&~bge;
assign AND=(IR[3:0]=='h4)&~lsra&~bcc;
assign ora=(IR[3:0]=='hA)&~pulh&~bpl;
assign eor=(IR[3:0]=='h8)&~lsla&~pulx;
assign lsra=(IR=='h44);
assign asra=(IR=='h47);
assign lsla=(IR=='h48);
assign psha=(IR=='h87);
assign sta=(IR[3:0]=='h7)&~asra&~psha&~beq;
assign ldx=(IR[3:0]=='hE);
assign ldhx=(IR=='h45);
assign pulh=(IR=='h8A);
assign pulx=(IR=='h88);
assign aix=(IR=='hAF);
assign stx=(IR[3:0]=='hF)&~aix;
assign pshh=(IR=='h8B);
assign pshx=(IR=='h89);
assign bra=(IR=='h20);
assign bcc=(IR=='h24);
assign bcs=(IR=='h25);
assign bpl=(IR=='h2A);
assign bmi=(IR=='h2B);
assign bne=(IR=='h26);
assign beq=(IR=='h27);
assign bge=(IR=='h90);
assign blt=(IR=='h91);
assign jmp=(IR=='hCC);
assign jsr=(IR=='hCD);
assign rts=(IR=='h81);

//"Control signals"
assign reset=st0;
assign ldA=modA&(imm&st2|ix&st2|dir&st3|ext&st4|inh&st2)|pula&st2;
assign ldH=ldhx&imm&st2|pulh&st2;
assign ldX=ldx&(ext&st4|dir&st3|imm&st2|ix&st2)|ldhx&imm&st3|pulx&st2;
assign aiX=aix&st2;
assign IncSP=st2&(pula|pulh|pulx|rts)|rts&st3;
assign DecSP=st2&(psha|pshh|pshx)|jsr&(st4|st5);
assign ldPC=jmp&st4|jsr&st5|rts&st4;
assign IncPC=st1|ext&st2|ext&st3|dir&st2|modA&imm&st2|ldx&imm&st2|ldhx&imm&(st2|st3)|aix&st2;
assign ldIR=st1;
assign ldMARH=ext&st2|rts&st2;
assign ldMARL=ext&st3|rts&st3;
assign ldMAR=dir&st2;
assign addPC=branch&st2;

assign oeA=psha&st2|sta&(ix&st2|dir&st3|imm&st4);
assign oeH=pshh&st2;
assign oeX=stx&(ext&st4|dir&st3|ix&st2)|pshx&st2;
assign oePCH=jsr&st5;
assign oePCL=jsr&st4;
assign Read=st1|ext&st2|ext&st3|dir&st2|st2&(pula|pulh|pulx|rts)|rts&st3|modA&imm&st2|modA&ix&st2|modA&dir&st3|modA&ext&st4|ldx&(ext&st4|dir&st3|imm&st2|ix&st2)|ldhx&imm&(st2|st3)|aix&st2|branch&st2;
assign Write=st2&(psha|pshh|pshx)|jsr&(st4|st5)|sta&(ix&st2|dir&st3|imm&st4)|stx&(ext&st4|dir&st3|ix&st2);

assign oeHX=modA&ix&st2|sta&ix&st2|ldx&ix&st2|stx&ix&st2;
assign oeSP=st2&(psha|pshh|pshx)|jsr&(st4|st5);
assign oePC=st1|ext&st2|ext&st3|dir&st2|modA&imm&st2|ldx&imm&st2|ldhx&imm&(st2|st3)|aix&st2|branch&st2;
assign oeMAR=modA&dir&st3|modA&ext&st4|sta&dir&st3|sta&ext&st4|ldx&ext&st4|ldx&dir&st3|stx&(ext&st4|dir&st3);
assign oeiSP=st2&(pula|pulh|pulx|rts)|rts&st3;


endmodule
