// The SCI module for the F19 MiniS08
// the clk, rxd, and txd must be ports in the top-level module
// the clk is the 50 MHz clock, not the S08clk

module sci(clk, datain, dataout, IOsel, addr, read, write, rxd, txd);
input clk, IOsel, read, write, rxd;
input [7:0] datain;  // data being sent to the SCI
input [2:0] addr; // status read 100, data read 101, data write 110
output txd;
output [7:0] dataout;  // data being read from the SCI

// the input clk will be 50 MHz -- the count sequence for baudgenA (divide by 651) produces
// 76,804.9155 Hz in top bit of baudgenA.  Using that to clock baudgen produces a 4x oversamped
// 9600 baud clock in baudgen[0] and 9600 in baudgen[2] with only 0.0064 % error
// Higher standard baud rates are 19200, 38400, 57600, and 115200.
// They are 2x, 4x, 6x, and 12x faster than 9600 baud.
// To use 115.2KB we need to have our initial divide be 651/12 which is 54.  Also, instead
// of using baudgenA
//reg [9:0] baudgenA;   // size needed for 9600 baud 651 count
reg [5:0] baudgenA;     // size needed for 115200 baud 54 count
reg [2:0] baudgen;
reg [2:0] rcvstate, rcvbitcnt;
reg [8:0] shiftout;
reg [7:0] shiftin, trandata;
reg [3:0] txdstate;
reg rdrf, tdrf, newtrandata;
wire readdataedge, writedataedge, rcvstate7edge, txdstate1edge, txdstate9edge;
reg prevreaddata, prevwritedata, prevrcvstate7, prevtxdstate1, prevtxdstate9;

assign readdataedge = read & IOsel & (addr==5) & ~prevreaddata;
assign writedataedge = write & IOsel & (addr==6) & ~prevwritedata;
assign rcvstate7edge = (rcvstate==7)&~prevrcvstate7;
assign txdstate1edge = (txdstate==1)&~prevtxdstate1;
assign txdstate9edge = (txdstate==9)&~prevtxdstate9;
assign dataout = read&IOsel&(addr==5) ? shiftin
               : read&IOsel&(addr==4) ? {~tdrf,6'd0,rdrf} : 0;
assign txd = shiftout[0];

always @(posedge clk)
   begin
      baudgenA <= baudgenA==53 ? 0 : baudgenA+1;
      prevreaddata <= read & IOsel & (addr==5);
      prevwritedata <= write & IOsel & (addr==6);
      prevrcvstate7 <= (rcvstate==7);
      prevtxdstate1 <= (txdstate==1);
      prevtxdstate9 <= (txdstate==9);
      rdrf <= rcvstate7edge ? 1 : readdataedge ? 0 : rdrf;
      tdrf <= writedataedge ? 1 : txdstate9edge ? 0 : tdrf;
      newtrandata <= writedataedge ? 1 : txdstate1edge ? 0 : newtrandata;
      trandata <= writedataedge ? datain : trandata;
   end
//always @(posedge baudgenA[9])    // for 9600 baud
always @(posedge baudgenA[5])     // for 115200 baud
   baudgen <= baudgen + 1;
   
always @(posedge baudgen[0])   // 4x 9600 baud clock
   begin
      rcvstate <= (rcvstate==0)&rxd ? 0 : (rcvstate==7)&~rxd ? 7
                : (rcvstate==6)&(rcvbitcnt!=0) ? 3 : rcvstate+1;
      rcvbitcnt <= (rcvstate==0) ? 0 : (rcvstate==5) ? rcvbitcnt+1 : rcvbitcnt;
      shiftin <= (rcvstate==5) ? {rxd,shiftin[7:1]} : shiftin;
   end
   
always @(posedge baudgen[2])   // 1x 9600 baud clock
   begin
      shiftout <= newtrandata&(txdstate==0) ? {trandata,1'b0} : {1'b1,shiftout[8:1]};
      txdstate <= txdstate==0 ? (newtrandata ? 1 : 0)
                : txdstate==9 ? 0 : txdstate+1;
   end
endmodule
