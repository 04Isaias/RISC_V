module top(input   logic              clk, reset,
                  output logic [31:0] WriteData, DataAdr,
                  output logic             MemWrite);
    logic [31:0] PC, Instr, ReadData;
    // instantiate processor and memories
     single_cycle_processor rvsingle(
        .Instr(Instr),
        .ReadData(ReadData), 
        .CLK(clk),
        .reset(reset),
        .PC(PC),
        .writedata(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite)
        );
    imem imem(.a(PC), .rd(Instr));
    dmem dmem(.clk(clk), .we(MemWrite), .a(DataAdr), .wd(WriteData), .rd(ReadData));
endmodule