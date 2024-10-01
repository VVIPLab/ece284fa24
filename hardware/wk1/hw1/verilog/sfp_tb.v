// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module sfp_tb;

parameter bw = 8;
parameter psum_bw = 16;

reg clk = 0;

wire [psum_bw-1:0] out;
reg  [bw-1:0] in;
reg  [psum_bw-1:0] thres;
reg  relu;
reg  acc;
reg  reset;

integer in_file ; // file handler
integer in_scan_file ; // file handler

integer in_dec;
integer i; 
integer u; 

function [bw-1:0] dec2bin ;
  input integer  weight ;
  begin
    if (weight>-1) begin
      dec2bin[bw-1] = 0;
    end 
    else begin
      dec2bin[bw-1] = 1;
      weight = weight + 2**(bw-1);
    end

    for (u=bw-2; u>-1; u=u-1) begin
      if (weight>2**u-1) begin
        dec2bin[u] = 1;
        weight = weight - 2**u;
      end
      else begin
        dec2bin[u] = 0;
      end
    end
  end
endfunction


sfp #(.bw(bw), .psum_bw(psum_bw)) sfp_instance (
	.clk(clk), 
	.reset(reset), 
  .in(in),
  .thres(thres),
  .acc(acc), 
  .relu(relu),
	.out(out)
);

initial begin 

  in_file = $fopen("in_data.txt", "r"); 

  $dumpfile("sfp_tb.vcd");
  $dumpvars(0,sfp_tb);

  #1 clk = 1'b0;  reset = 1; relu = 0; acc = 0;
  #1 clk = 1'b1;  
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;  reset = 0;

  $display("-------------------- Computation start --------------------");
  

  for (i=0; i<10; i=i+1) begin  // Data lenght is 10 in the data files

    #1 clk = 1'b1;
    #1 clk = 1'b0; acc = 1; thres = 16'd64;

    in_scan_file = $fscanf(in_file, "%d\n", in_dec);
    in = dec2bin(in_dec); 

  end

  #1 clk = 1'b1;
  #1 clk = 1'b0; acc = 0; relu = 1;
  #1 clk = 1'b1;  
  #1 clk = 1'b0;  

  $display("-------------------- Computation completed --------------------");

  #10 $finish;
end

endmodule




