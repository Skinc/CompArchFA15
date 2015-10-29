//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);


wire[31:0] wrenables;

wire[31:0] r0out;
wire[31:0] r1out;
wire[31:0] r2out;
wire[31:0] r3out;
wire[31:0] r4out;
wire[31:0] r5out;
wire[31:0] r6out;
wire[31:0] r7out;
wire[31:0] r8out;
wire[31:0] r9out;
wire[31:0] r10out;
wire[31:0] r11out;
wire[31:0] r12out;
wire[31:0] r13out;
wire[31:0] r14out;
wire[31:0] r15out;
wire[31:0] r16out;
wire[31:0] r17out;
wire[31:0] r18out;
wire[31:0] r19out;
wire[31:0] r20out;
wire[31:0] r21out;
wire[31:0] r22out;
wire[31:0] r23out;
wire[31:0] r24out;
wire[31:0] r25out;
wire[31:0] r26out;
wire[31:0] r27out;
wire[31:0] r28out;
wire[31:0] r29out;
wire[31:0] r30out;
wire[31:0] r31out;

decoder1to32 decoder(wrenables, RegWrite, WriteRegister);


register32zero r0(r0out, WriteData, wrenables[0], Clk );

register32 r1(r1out, WriteData, wrenables[1], Clk );
register32 r2(r2out, WriteData, wrenables[2], Clk );
register32 r3(r3out, WriteData, wrenables[3], Clk );
register32 r4(r4out, WriteData, wrenables[4], Clk );
register32 r5(r5out, WriteData, wrenables[5], Clk );
register32 r6(r6out, WriteData, wrenables[6], Clk );
register32 r7(r7out, WriteData, wrenables[7], Clk );
register32 r8(r8out, WriteData, wrenables[8], Clk );
register32 r9(r9out, WriteData, wrenables[9], Clk );
register32 r10(r10out, WriteData, wrenables[10], Clk );
register32 r11(r11out, WriteData, wrenables[11], Clk );
register32 r12(r12out, WriteData, wrenables[12], Clk );
register32 r13(r13out, WriteData, wrenables[13], Clk );
register32 r14(r14out, WriteData, wrenables[14], Clk );
register32 r15(r15out, WriteData, wrenables[15], Clk );
register32 r16(r16out, WriteData, wrenables[16], Clk );
register32 r17(r17out, WriteData, wrenables[17], Clk );
register32 r18(r18out, WriteData, wrenables[18], Clk );
register32 r19(r19out, WriteData, wrenables[19], Clk );
register32 r20(r20out, WriteData, wrenables[20], Clk );
register32 r21(r21out, WriteData, wrenables[21], Clk );
register32 r22(r22out, WriteData, wrenables[22], Clk );
register32 r23(r23out, WriteData, wrenables[23], Clk );
register32 r24(r24out, WriteData, wrenables[24], Clk );
register32 r25(r25out, WriteData, wrenables[25], Clk );
register32 r26(r26out, WriteData, wrenables[26], Clk );
register32 r27(r27out, WriteData, wrenables[27], Clk );
register32 r28(r28out, WriteData, wrenables[28], Clk );
register32 r29(r29out, WriteData, wrenables[29], Clk );
register32 r30(r30out, WriteData, wrenables[30], Clk );
register32 r31(r31out, WriteData, wrenables[31], Clk );

mux32to1by32 readData1Set(ReadData1, ReadRegister1, r0out, r1out, r2out, r3out, r4out, r5out, r6out, r7out, r8out, r9out, r10out, r11out, r12out, r13out, r14out, r15out, r16out, r17out, r18out, r19out, r20out, r21out, r22out, r23out, r24out, r25out, r26out, r27out, r28out, r29out, r30out, r31out);
mux32to1by32 readData2Set(ReadData2, ReadRegister2, r0out, r1out, r2out, r3out, r4out, r5out, r6out, r7out, r8out, r9out, r10out, r11out, r12out, r13out, r14out, r15out, r16out, r17out, r18out, r19out, r20out, r21out, r22out, r23out, r24out, r25out, r26out, r27out, r28out, r29out, r30out, r31out);

endmodule