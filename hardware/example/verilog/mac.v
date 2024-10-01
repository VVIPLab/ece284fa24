// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (clk, out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

output signed [psum_bw-1:0] out;
input signed [bw-1:0] a;
input signed [bw-1:0] b;
input signed [psum_bw-1:0] c;
input signed clk;

wire signed  [2*bw-1:0] product;

reg signed   [bw-1:0] a_q;
reg signed   [bw-1:0] b_q;
reg signed   [psum_bw-1:0] c_q;

assign product = a_q*b_q;
assign out     = product + c_q;

always @ (posedge clk) begin
        b_q  <= b;
        a_q  <= a;
        c_q  <= c;
end

endmodule
