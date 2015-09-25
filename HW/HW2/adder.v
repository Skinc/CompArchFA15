module behavioralFullAdder(sum, carryout, a, b, carryin);
output sum, carryout;
input a, b, carryin;
assign {carryout, sum}=a+b+carryin;
endmodule

module structuralFullAdder(out, carryout, a, b, carryin);
`define AND and #50
`define OR or #50
`define NOT not #50
output out, carryout;
input a, b, carryin;
wire abc, ab, ac, bc, notcarryout, orabc, justone;

`AND all(abc, a, b, carryin);
`AND andab(ab, a, b);
`AND andac(ac, a, carryin);
`AND andbc(bc, b, carryin);

`OR co(carryout, ab, ac, bc);
`NOT nco(notcarryout, carryout);

`OR orall(orabc, a, b, carryin);

`AND j1(justone, orabc, notcarryout);

`OR sum(out, abc, justone);
endmodule

module testFullAdder;
reg a, b, carryin;
wire sum, carryout;
structuralFullAdder adder (sum, carryout, a, b, carryin);

initial begin
$display("a  b carryin | sum carryout | Expected Output");
a=0;b=0;carryin=0; #1000 
$display("%b  %b    %b    |  %b      %b    |   0 and 0", a, b, carryin, sum, carryout);
a=0;b=0;carryin=1; #1000 
$display("%b  %b    %b    |  %b      %b    |   1 and 0", a, b, carryin, sum, carryout);
a=0;b=1;carryin=0; #1000 
$display("%b  %b    %b    |  %b      %b    |   1 and 0", a, b, carryin, sum, carryout);
a=0;b=1;carryin=1; #1000 
$display("%b  %b    %b    |  %b      %b    |   0 and 1", a, b, carryin, sum, carryout);
a=1;b=0;carryin=0; #1000 
$display("%b  %b    %b    |  %b      %b    |   1 and 0", a, b, carryin, sum, carryout);
a=1;b=0;carryin=1; #1000 
$display("%b  %b    %b    |  %b      %b    |   0 and 1", a, b, carryin, sum, carryout);
a=1;b=1;carryin=0; #1000 
$display("%b  %b    %b    |  %b      %b    |   0 and 1", a, b, carryin, sum, carryout);
a=1;b=1;carryin=1; #1000 
$display("%b  %b    %b    |  %b      %b    |   1 and 1", a, b, carryin, sum, carryout);

  // Your test code here
end
endmodule
