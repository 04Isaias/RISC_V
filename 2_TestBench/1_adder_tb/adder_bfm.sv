/* 
 October 25, 2025
 Isaias M Ramirez
 The bfm class provides the interface used throughout the testbench
*/

interface adder_bfm;
    import adder_pkg::*;

    bit [31:0]     uint_32_a;
    bit [31:0]     uint_32_b;
    bit            done;
    bit             clk;

    wire [31 : 0]   result;

    task send_add(bit [31:0] iA, bit [31:0] iB);
        begin 
            @(posedge clk)begin 
                uint_32_a = iA;
                uint_32_b = iB;
            end

        end;
    endtask : send_add

    command_monitor command_monitor_h;

    always @(posedge clk) begin : add_monitor
        command_monitor_h.write_to_monitor(uint_32_a, uint_32_b);
    end

    result_monitor result_monitor_h;

    initial begin: result_monitor_thread
        forever begin: result_monitor_block
            @(negedge clk);
            result_monitor_h.write_to_monitor(result);
        end: result_monitor_block        
    end : result_monitor_thread


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