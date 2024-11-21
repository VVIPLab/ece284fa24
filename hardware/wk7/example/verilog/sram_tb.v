// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

`timescale 1 ns/1 ps

module sram_tb;


`define NULL 0

reg CLK = 0;
reg [10:0]  A = 0;
reg [127:0] D = 0;
reg CEN_EXT = 0;
reg CEN_Q ;
reg WEN_EXT = 1;
reg WEN_Q ;
wire [127:0] Q;


sram_128b_w2048 sram_instance (
	.CLK(CLK), 
	.CEN(CEN_Q), 
	.WEN(WEN_Q),
        .A(A), 
        .D(D), 
        .Q(Q));


initial begin 

  $dumpfile("sram_tb.vcd");
  $dumpvars(0,sram_tb);

    #20 CLK = 1'b1;  
 
    #20 CLK = 1'b0;  A = 11'b00000000000; D = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; WEN_EXT = 0;

    #20 CLK = 1'b1;  
  
    #20 CLK = 1'b0;  A = 11'b00000000010; D = 128'hEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE; WEN_EXT = 1;

    #20 CLK = 1'b1;   

    #20 CLK = 1'b0;  A = 11'b00000000001;

    #20 CLK = 1'b1;  

    #20 CLK = 1'b0;  A = 11'b00000000010;

    #20 CLK = 1'b1;  

    #20 CLK = 1'b0;  CEN_EXT = 1;

    #20 CLK = 1'b1;

    #20 CLK = 1'b0;

  #10 $finish;


end

 always @ (posedge CLK) begin
   WEN_Q <= WEN_EXT;
   CEN_Q <= CEN_EXT;
 end

endmodule




