// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 8;
parameter psum_bw = 16;

reg clk = 0;

wire [psum_bw-1:0] out;
reg  [bw-1:0] in1=0;
reg  [bw-1:0] in2=0;
reg  reset;
reg format;
reg acc;

integer in1_file ; // file handler
integer in1_sm_file ; // file handler
integer in2_file ; // file handler
integer in2_sm_file ; // file handler
integer in1_scan_file ; // file handler
integer in2_scan_file ; // file handler

integer in1_dec;
integer in2_dec;
integer i; 
integer u; 


//Convert Decimal Number to 2s Complement
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

//Convert Decimal Number to Sign and Magnitude
    function [7:0] to_sign_magnitude;
        input integer decimal;
        reg [7:0] result;
    begin
        if (decimal < 0) begin
            result = {1'b1, -decimal[6:0]};  // Set MSB to 1 for negative
            //result = {1'b1, ~decimal + 1'b1};  // Set MSB to 1 for negative
        end else begin
            result = {1'b0, decimal};  // Set MSB to 0 for positive
        end
        to_sign_magnitude = result;
    end
    endfunction

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
.clk(clk), 
.reset(reset), 
.A(in1),
.B(in2),
.format(format),
.out(out),
.acc(acc)
);

initial begin 

  in1_file = $fopen("a_data.txt", "r"); 
  in2_file = $fopen("b_data.txt", "r"); 
  in1_sm_file = $fopen("a_data.txt", "r"); 
  in2_sm_file = $fopen("b_data.txt", "r"); 

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);

  #1 clk = 1'b0;  reset = 1; format=0;
  #1 clk = 1'b1;  
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;  reset = 0;

  $display("-------------------- Computation start For 2's Complement Mode --------------------");
  

  for (i=0; i<10; i=i+1) begin  // Data lenght is 10 in the data files

    #1 clk = 1'b1;
    #1 clk = 1'b0;   format=0; acc=1; 

    in1_scan_file = $fscanf(in1_file, "%d\n", in1_dec);
    in1 = dec2bin(in1_dec); 
    in2_scan_file = $fscanf(in2_file, "%d\n", in2_dec);
    in2 = dec2bin(in2_dec); 

  end

  #1 clk = 1'b1;
  #1 clk = 1'b0; format=0; in1=8'h0; in2=8'h0; 
  #1 clk = 1'b1;  
  #1 clk = 1'b0; acc=0;  

  $display("-------------------- Computation completed For 2's Complement Mode--------------------");

  #1 clk = 1'b1;  
  #1 clk = 1'b0;  reset = 1;  format=0;
  #1 clk = 1'b1;  
  #1 clk = 1'b0;  reset = 0;

  $display("-------------------- Computation start For Sign and Magnitude Mode --------------------");
  

  for (i=0; i<10; i=i+1) begin  // Data lenght is 10 in the data files

    #1 clk = 1'b1;
    #1 clk = 1'b0;   format=1; acc=1;

    in1_scan_file = $fscanf(in1_sm_file, "%d\n", in1_dec);
    in1 = to_sign_magnitude(in1_dec); 
    in2_scan_file = $fscanf(in2_sm_file, "%d\n", in2_dec);
    in2 = to_sign_magnitude(in2_dec); 

  end

  #1 clk = 1'b1;
  #1 clk = 1'b0; in1=8'h0; in2=8'h0; 
  #1 clk = 1'b1;  
  #1 clk = 1'b0; acc=0;format=0; 

  $display("-------------------- Computation completed For Sign and Magnitude Mode--------------------");


  #10 $finish;
end

endmodule
