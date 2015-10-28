// Single-bit D Flip-Flop with enable
//   Positive edge triggered
module register
(
output reg	q,
input		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end

endmodule


module register32
(
output reg[31:0]	q,
input[31:0]		d,
input		wrenable,
input		clk
);
integer i;
	for (i = 0; i < 32; i = i+1 ) begin
    	always @(posedge clk) begin
    		if(wrenable) begin
    	
    			q[i] = d[i];
    
    		end
        end
    end

endmodule

module register32zerp
(
output reg[31:0]	q,
input[31:0]		d,
input		wrenable,
input		clk
);
integer i;
	for (i = 0; i < 32; i = i+1 ) begin
    	q[i] = 0;
    end

endmodule




module mux32to1by1
(
	output      out,
	input[4:0]  address,
	input[31:0] inputs
);

out = inputs[address]

endmodule