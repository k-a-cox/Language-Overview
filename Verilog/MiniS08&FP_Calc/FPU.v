module FPU(clk, datain, dataout, FPUsel, addr, read, write);
input clk, FPUsel, read, write;
input [7:0] datain; // command or value being sent to the FPU
                    // commands are 1 Set Y as next value
                    //              2 Set X as next value
                    //              3 Perform division
                    //              4 Perform multiplication
					//              5 Perform addition
					//              6 Perform subtraction
input [1:0] addr;   // status read 00, result read 01, command write 10, value write 11
output [7:0] dataout;  // result being read from the FPU
reg [2:0] inloc;    // index in the YX set for next incoming value
reg [1:0] outloc;   // index in the R reg for next result out (on read)
reg [31:0] Y,X,Res;
wire [31:0] FPQ, FPP, FPSD;  // result of divide, mult, addsub
wire DivDone, MultDone, AddSubDone;
reg prevreadval, prevwritecmd, prevwriteval, Busy;
wire readval, readstatus, writecmd, writeval, DivStart, MultStart, AddSubStart;
wire readvalnegedge, writecmdposedge, writevalnegedge;  //write cmd is pos edge -- others neg edge
assign readstatus = read & FPUsel & (addr==0);
assign readval = read & FPUsel & (addr==1);
assign writecmd = write & FPUsel & (addr==2);
assign writeval = write & FPUsel & (addr==3);

assign DivStart = writecmdposedge&datain==3;
assign MultStart = writecmdposedge&datain==4;
assign AddSubStart = writecmdposedge&(datain==5 | datain==6);

always @(posedge clk)
   begin
      prevreadval <= readval;
      prevwritecmd <= writecmd;
      prevwriteval <= writeval;
      inloc <= writevalnegedge ? inloc+1 : writecmdposedge&datain==1 ? 0 : writecmdposedge&datain==2 ? 4 : inloc;
      outloc <= DivDone | MultDone | AddSubDone ? 0 : readvalnegedge ? outloc+1 : outloc;
      Y[31:24] <= writeval&inloc==0 ? datain : Y[31:24];
      Y[23:16] <= writeval&inloc==0 ? 0 : writeval&inloc==1 ? datain : Y[23:16];
      Y[15:8] <= writeval&inloc==0 ? 0 : writeval&inloc==2 ? datain : Y[15:8];
      Y[7:0] <= writeval&inloc==0 ? 0 : writeval&inloc==3 ? datain : Y[7:0];
      X[31:24] <= writeval&inloc==4 ? datain : X[31:24];
      X[23:16] <= writeval&inloc==4 ? 0 : writeval&inloc==5 ? datain : X[23:16];
      X[15:8] <= writeval&inloc==4 ? 0 : writeval&inloc==6 ? datain : X[15:8];
      X[7:0] <= writeval&inloc==4 ? 0 : writeval&inloc==7 ? datain : X[7:0];
      Res <= DivDone ? FPQ : MultDone ? FPP : AddSubDone ? FPSD : Res;
	  Busy <= DivStart | MultStart | AddSubStart ? 1 : DivDone | MultDone | AddSubDone ? 0 : Busy;
   end
    
assign dataout = readval&outloc==0 ? Res[31:24]
               : readval&outloc==1 ? Res[23:16]
               : readval&outloc==2 ? Res[15:8]
               : readval&outloc==3 ? Res[7:0]
               : readstatus ? {Busy,7'd0}  // msb of status is a FPU busy bit
               : 0;
			   
assign writecmdposedge = writecmd & ~prevwritecmd; // pos edge
assign readvalnegedge = ~readval & prevreadval;    // neg edge
assign writevalnegedge = ~writeval & prevwriteval; // neg edge

FPdivide FPdivUnit(clk, DivStart, Y, X, DivDone, FPQ);
FPmultiply FPmultUnit(clk, MultStart, Y, X, MultDone, FPP);
FPaddsub FPaddsubUnit(clk, AddSubStart, Y, {X[31]^(datain==6),X[30:0]}, AddSubDone, FPSD);

endmodule