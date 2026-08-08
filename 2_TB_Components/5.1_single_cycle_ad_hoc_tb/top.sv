module top(input   logic              clk, reset,
                  output logic [31:0] WriteData, DataAdr,
                  output logic             MemWrite);
    logic [31:0] PC, Instr, ReadData;
    // instantiate processor and memories
     single_cycle_processor rvsingle(
        .Instr(Instr),
        .ReadData(ReadData), 
        .CLK(),
        .reset(reset),
        .PC(PC),
        .writedata(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite)
        );
    imem imem(PC, Instr);
    dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData);
endmodule