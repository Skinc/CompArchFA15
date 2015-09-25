module behavioralMultiplexer(out, address0,address1, in0,in1,in2,in3);
output out;
input address0, address1;
input in0, in1, in2, in3;
wire[3:0] inputs = {in3, in2, in1, in0};
wire[1:0] address = {address1, address0};
assign out = inputs[address];
endmodule

module structuralMultiplexer(out, address0,address1, in0,in1,in2,in3);
`define AND and #50
`define OR or #50
`define NOT not #50
output out;
input address0, address1;
input in0, in1, in2, in3;
wire o0, o1, o2, o3;

`NOT notA1(nA1, address1);
`NOT notA0(nA0, address0);

`AND nA0nA1(o0, nA1, nA0, in0);

`AND A0nA1(o1, nA1, address0, in1);

`AND nA0A1(o2, nA0, address1, in2 );

`AND A0A1(o3, address0, address1, in3 ); 

`OR orall(out, o0, o1, o2, o3 );

endmodule

module testMultiplexer;
reg addr0, addr1;
reg in0, in1, in2, in3;
wire out;
structuralMultiplexer decoder (out, addr0,addr1, in0,in1,in2,in3);
  // Your test code here

initial begin
$display("A0 A1 I0 I1 I2 I3| O | Expected Output");
addr0=0;addr1=0;in0=0;in1=1;in2=1;in3=1; #1000 
$display("%b  %b  %b  %b  %b  %b | %b |  Just in0", addr0, addr1, in0, in1, in2, in3, out);
addr0=0;addr1=0;in0=1;in1=0;in2=0;in3=0; #1000 
$display("%b  %b  %b  %b  %b  %b | %b |  Just in0", addr0, addr1, in0, in1, in2, in3, out);

addr0=1;addr1=0;in0=1;in1=0;in2=1;in3=1; #1000 
$display("%b  %b  %b  %b  %b  %b | %b |  Just in1", addr0, addr1, in0, in1, in2, in3, out);
addr0=1;addr1=0;in0=0;in1=1;in2=0;in3=0; #1000 
$display("%b  %b  %b  %b  %b  %b | %b |  Just in1", addr0, addr1, in0, in1, in2, in3, out);

addr0=0;addr1=1;in0=1;in1=1;in2=0;in3=1; #1000 
$display("%b  %b  %b  %b  %b  %b | %b |  Just in2", addr0, addr1, in0, in1, in2, in3, out);
addr0=0;addr1=1;in0=0;in1=0;in2=1;in3=0; #1000 
$display("%b  %b  %b  %b  %b  %b | %b |  Just in2", addr0, addr1, in0, in1, in2, in3, out);

addr0=1;addr1=1;in0=1;in1=1;in2=1;in3=0; #1000 
$display("%b  %b  %b  %b  %b  %b | %b |  Just in3", addr0, addr1, in0, in1, in2, in3, out);
addr0=1;addr1=1;in0=0;in1=0;in2=0;in3=1; #1000 
$display("%b  %b  %b  %b  %b  %b | %b |  Just in3", addr0, addr1, in0, in1, in2, in3, out);

/*enable=0;addr0=1;addr1=0; #1000
$display("%b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, out0, out1, out2, out3);
enable=0;addr0=0;addr1=1; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, out0, out1, out2, out3);
enable=0;addr0=1;addr1=1; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, out0, out1, out2, out3);
enable=1;addr0=0;addr1=0; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b | O0 Only", enable, addr0, addr1, out0, out1, out2, out3);
enable=1;addr0=1;addr1=0; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b | O1 Only", enable, addr0, addr1, out0, out1, out2, out3);
enable=1;addr0=0;addr1=1; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b | O2 Only", enable, addr0, addr1, out0, out1, out2, out3);
enable=1;addr0=1;addr1=1; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b | O3 Only", enable, addr0, addr1, out0, out1, out2, out3);
*/
end
endmodule