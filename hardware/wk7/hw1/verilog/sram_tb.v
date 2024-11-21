// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

`timescale 1 ns/1 ps

module sram_tb;


`define NULL 0

reg CLK = 0;
reg [10:0]  A = 0;
reg [31:0] D = 0;
reg CEN_EXT = 0;
reg CEN_Q ;
reg WEN_EXT = 1;
reg WEN_Q ;
wire [31:0] Q;

integer x_file, x_scan_file ; // file_handler
integer captured_data; 
integer t, i, error;
reg [31:0] D_2D [63:0];

parameter run_cycle = 64;
parameter col = 0;

sram_32b_w2048 sram_instance (
	.CLK(CLK), 
	.CEN(CEN_Q), 
	.WEN(WEN_Q),
        .A(A), 
        .D(D), 
        .Q(Q));


initial begin 

  $dumpfile("sram_tb.vcd");
  $dumpvars(0,sram_tb);

  x_file = $fopen("activation.txt", "r");

  // Following three lines are to remove the first three comment lines of the file
  x_scan_file = $fscanf(x_file,"%s", captured_data);
  x_scan_file = $fscanf(x_file,"%s", captured_data);
  x_scan_file = $fscanf(x_file,"%s", captured_data);


  #20 CLK = 1'b1;  
 
  #20 CLK = 1'b0;   WEN_EXT = 0;

  #20 CLK = 1'b1; 

  for (t=0; t<run_cycle-1; t=t+1) begin  

    #20 CLK = 1'b0;

    A = A + 1;
    x_scan_file = $fscanf(x_file,"%32b", D);
    D_2D[t][31:0] = D;
    $display("%2d-th written data is %h", t, D);
    
    #20 CLK = 1'b1;
     
    
  end

  #20 CLK = 1'b0;   WEN_EXT = 1; A = 0;
  #20 CLK = 1'b1; 

  #20 CLK = 1'b0;   A = A + 1; error = 0;
  #20 CLK = 1'b1;   

  for (t=0; t<run_cycle-1; t=t+1) begin  

    #20 CLK = 1'b0;   A = A + 1;
    if (D_2D[t][31:0] == Q)
        $display("%2d-th read data is %h --- Data matched", t, Q);
    else begin
        $display("%2d-th read data is %h --- Data ERROR !!!", t, Q);
        error = error+1;
    end

    #20 CLK = 1'b1;   

  end

  $display("###### Total %2d errors are detected ######", error);
  #10 $finish;


end

 always @ (posedge CLK) begin
   WEN_Q <= WEN_EXT;
   CEN_Q <= CEN_EXT;
 end

endmodule




