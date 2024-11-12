// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module l0_tb;

parameter bw = 4;
parameter col = 8;
parameter total_cycle = 64;
parameter total_cycle_2nd = 8;

reg clk = 0;
reg rd = 0;
reg wr = 0;
reg  reset = 0;
reg [bw*col-1:0] w_vector_bin;
wire [bw*col-1:0] out;
wire full, ready;

integer w_file ; // file handler
integer w_scan_file ; // file handler
integer captured_data;
reg [bw-1:0] binary;
integer i; 
integer j; 
integer u; 

integer  w[total_cycle-1:0][col-1:0];



function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction


l0 #(.bw(bw)) l0_instance (
        .clk(clk),
        .in(w_vector_bin), 
        .out(out), 
        .rd(rd),
        .wr(wr), 
        .o_full(full), 
        .reset(reset), 
        .o_ready(ready));

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data

  $dumpfile("l0_tb.vcd");
  $dumpvars(0,l0_tb);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- 1st Computation start --------------------");
  
  wr = 1;
  for (i=0; i<total_cycle; i=i+1) begin

     for (j=0; j<col; j=j+1) begin

        w_scan_file = $fscanf(w_file, "%d\n", captured_data);
        w[i][j] = captured_data;
        binary = w_bin(w[i][j]);  
        w_vector_bin = {binary, w_vector_bin[bw*col-1:bw]};
     end

     #1 clk = 1'b1;
     #1 clk = 1'b0;

  end

  wr = 0;
  #1 clk = 1'b1;
  #1 clk = 1'b0;


  rd = 1;

  for (i=0; i<2*total_cycle; i=i+1) begin
     #1 clk = 1'b1;
     #1 clk = 1'b0;
  end
  rd = 0;

  $display("-------------------- 1st Computation completed --------------------");




  $display("-------------------- 2nd Computation start --------------------");

  wr = 1;
  for (i=0; i<total_cycle_2nd; i=i+1) begin

     for (j=0; j<col; j=j+1) begin

        w_scan_file = $fscanf(w_file, "%d\n", captured_data);
        w[i][j] = captured_data;
        binary = w_bin(w[i][j]);  
        w_vector_bin = {binary, w_vector_bin[bw*col-1:bw]};
     end

     #1 clk = 1'b1;
     #1 clk = 1'b0;

  end

  wr = 0;
  #1 clk = 1'b1;
  #1 clk = 1'b0;


  rd = 1;

  for (i=0; i<2*total_cycle_2nd; i=i+1) begin
     #1 clk = 1'b1;
     #1 clk = 1'b0;
  end
  rd = 0;

  $display("-------------------- 2nd Computation completed --------------------");

  #10 $finish;


end

endmodule





