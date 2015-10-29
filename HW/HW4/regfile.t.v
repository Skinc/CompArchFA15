//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional 
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData), 
    .ReadRegister1(ReadRegister1), 
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite), 
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);

  // Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  $display("Test Case 1: No writing");
  // Test Case 1: No writing or reading, everything should be zero.

  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse
  // Verify expectations and report test result
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 1 Failed" );
  end

  $display("Test Case 2: Writing");
  
  // Test Case 2: 
  //   Write '42' to register 31, verify with Read Ports 1 and 2. Check both that register 31 is 42 and that other registers are 0
  WriteRegister = 5'd31;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //First, check that 2 registers are not affected
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 2 Failed" );
  end
  ReadRegister1 = 5'd30;
  ReadRegister2 = 5'd31;

  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse
  //Now, verify that R31 is changed, but R30 is unaffected/
  if((ReadData1 != 0) || (ReadData2 != 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 2 Failed" );
  end

  ReadRegister1 = 5'd31;
  ReadRegister2 = 5'd30;
  //finally switch the order of the registers
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse
  //Now, verify that R31 is changed, but R30 is unaffected/
  if((ReadData1 != 42) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 2 Failed" );
  end

  //resetting register 31 to 0
  WriteRegister = 5'd31;
  WriteData = 32'd0;
  RegWrite = 1;
  ReadRegister1 = 5'd31;
  ReadRegister2 = 5'd31;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //Ensuring register 31 is reset
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 2 Failed" );
  end
  

  $display("Test Case 3: Trying to change the 0 register");

// Test Case 3: 
  //   Register 0 is supposed to always be 0 so I'll try change it and make sure nothing happens/ 
  WriteRegister = 5'd0;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //First, check that 2 registers are not affected
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 3 Failed" );
  end
  
  $display("Test Case 4: Changing data without Wrenable high");

// Test Case 4: 
  // It should only be possible change data when RegWrite is equal to 1 so we'll try without that being the case.
  WriteRegister = 5'd1;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd1;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //First, check that register was correctly altered
  if((ReadData1 != 15) || (ReadData2 != 15)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 4 Failed" );
  end
  
  WriteRegister = 5'd1;
  WriteData = 32'd16;
  RegWrite = 0;
  ReadRegister1 = 5'd1;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //This time RegWrite =0 so no change should have happened.
  if((ReadData1 != 15) || (ReadData2 != 15)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 4 Failed" );
  end
  

  WriteRegister = 5'd1;
  WriteData = 32'd16;
  RegWrite = 1;
  ReadRegister1 = 5'd1;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //RegWrite =1 again so changes should occur. 
  if((ReadData1 != 16) || (ReadData2 != 16)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 4 Failed" );
  end
  
  $display("Test Case 5: Ensuring only one register written to. ");

// Test Case 5: 
  // This test will ensure only one register being written to. Test Case 2, does a brief test of this, but this will be a full test.
  WriteRegister = 5'd1;
  WriteData = 32'd63;
  RegWrite = 1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //First, check that register was correctly altered
  if((ReadData1 != 0) || (ReadData2 != 63)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  //Now testing that every other register is still 0 as it should be. 
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd3;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd4;
  ReadRegister2 = 5'd5;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd6;
  ReadRegister2 = 5'd7;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd8;
  ReadRegister2 = 5'd9;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd10;
  ReadRegister2 = 5'd11;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd12;
  ReadRegister2 = 5'd13;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd14;
  ReadRegister2 = 5'd15;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd16;
  ReadRegister2 = 5'd17;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd18;
  ReadRegister2 = 5'd19;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd20;
  ReadRegister2 = 5'd21;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd22;
  ReadRegister2 = 5'd23;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd24;
  ReadRegister2 = 5'd25;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd26;
  ReadRegister2 = 5'd27;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd28;
  ReadRegister2 = 5'd29;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end
  ReadRegister1 = 5'd30;
  ReadRegister2 = 5'd31;
  #5 Clk=1; #5 Clk=0; 
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 5 Failed" );
  end

 $display("Test Case 6: Ensuring Port 2 does not always read Register 17");

// Test Case 6: 
  // We will ensure Port 2 does not always read register 17

  // Setting register 17 to 63
  WriteRegister = 5'd16;
  WriteData = 32'd63;
  RegWrite = 1;
  ReadRegister1 = 5'd16;
  ReadRegister2 = 5'd16;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //First, check that register was correctly altered
  if((ReadData1 != 63) || (ReadData2 != 63)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 6 Failed" );
  end

  //Checking random other registers to see the port to is not hooked up to register 17
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd31;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //First, check that register was correctly altered
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 6 Failed" );
  end


  //Checking random other registers to see the port to is not hooked up to register 17
  ReadRegister1 = 5'd15;
  ReadRegister2 = 5'd17;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //First, check that register was correctly altered
  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 6 Failed" );
  end

  //rechecking register 17
  ReadRegister1 = 5'd16;
  ReadRegister2 = 5'd16;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  //First, check that register was correctly altered
  if((ReadData1 != 63) || (ReadData2 != 63)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 6 Failed" );
  end

  //resetting register 17
  WriteRegister = 5'd16;
  WriteData = 32'd0;
  RegWrite = 1;
  ReadRegister1 = 5'd16;
  ReadRegister2 = 5'd16;
  #5 Clk=1; #5 Clk=0; // Generate single clock pulse

  if((ReadData1 != 0) || (ReadData2 != 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Test Case 6 Failed" );
  end


 

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule