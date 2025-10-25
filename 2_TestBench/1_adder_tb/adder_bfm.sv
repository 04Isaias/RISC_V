/* 
 October 25, 2025
 Isaias M Ramirez
 The bfm class provides the interface used throughout the testbench
*/

interface adder_bfm;
    import adder_pkg::*;

    int unsigned    uint_32_a;
    int unsigned    uint_32_b;

    bit             clk;

    wire [32 : 0]   result;

    task send_add(input int iA, input int iB, output int adder_result);
        begin 
            uint_32_a = iA;
            uint_32_b = iB;
            adder_result = result;
        end
    endtask : send_add

    /* write the result monitor 
    -
    -
    -
    -
    */


    initial begin
        clk = 0;
        fork
            forever begin
                #10
                clk = ~clk;
            end
        join_none
    end


endinterface : adder_bfm