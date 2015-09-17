module hw1test;
reg A;
reg B;
wire nA;
wire nB;
wire AB;
wire nAB;
wire nAornB;
wire nAandnB;
wire AorB;
wire nallAorB;

not Ainv(nA, A);
not Binv(nB, B);

and andgate1(AB, A, B);
not ABinv(nAB, AB);

or orgate1(nAornB, nA, nB);

or orgate2(AorB, A, B);
not AorBinv(nallAorB, AorB);

and andgate2(nAandnB, nA, nB);
initial begin 
$display("A B | ~A ~B | ~(AB) ~A+~B | ~(A+B) ~A~B ");
A=0;B=0; #1
$display("%b %b |  %b  %b |   %b     %b   |    %b    %b ", A, B, nA, nB, nAB, nAornB, nallAorB, nAandnB);
A=0;B=1; #1
$display("%b %b |  %b  %b |   %b     %b   |    %b    %b ", A, B, nA, nB, nAB, nAornB, nallAorB, nAandnB);
A=1;B=0; #1
$display("%b %b |  %b  %b |   %b     %b   |    %b    %b ", A, B, nA, nB, nAB, nAornB, nallAorB, nAandnB);
A=1;B=1; #1
$display("%b %b |  %b  %b |   %b     %b   |    %b    %b ", A, B, nA, nB, nAB, nAornB, nallAorB, nAandnB);
end
endmodule
