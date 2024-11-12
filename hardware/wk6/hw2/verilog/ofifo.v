// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module ofifo (clk, in, out, rd, wr, o_full, reset, o_ready, o_valid);

  parameter col  = 8;
  parameter bw = 4;

  input  clk;
  input  [??] wr;
  input  rd;
  input  reset;
  input  [??] in;
  output [??] out;
  output o_full;
  output o_ready;
  output o_valid;

  wire [??] empty;
  wire [??] full;
  reg  rd_en;
  
  genvar i;

  assign o_ready = ?? ;
  assign o_full  = ?? ;
  assign o_valid = ?? ;

  for (i=0; i<col ; i=i+1) begin : col_num
      fifo_depth64 #(.bw(bw)) fifo_instance (
	 .rd_clk(clk),
	 .wr_clk(clk),
	 .rd(???),
	 .wr(???),
         .o_empty(???),
         .o_full(???),
	 .in(???),
	 .out(???),
         .reset(reset));
  end


  always @ (posedge clk) begin
   if (reset) begin
      rd_en <= 0;
   end
   else
      
     ????
 
  end


 

endmodule
