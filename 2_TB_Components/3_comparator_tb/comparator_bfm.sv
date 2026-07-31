/*
January 3, 2025
Isaias M Ramirez
The bfm class provides the interface used by the comparator tb.
*/

interface comparator_bfm;
    import comparator_pkg::*;

    bit [31:0]      A;
    bit [31:0]      B;
    bit             done;
    bit             clk;

    wire  eq, neq, lt, lte, gt, gte;

    task send_comp(bit [31:0] iA, bit [31:0] iB);
        begin
            @(posedge clk)begin
                A = iA;
                B = iB;
            end

        end
    endtask : send_comp

    command_monitor command_monitor_h;

    always @(posedge clk) begin: add_monitor
        command_monitor_h.write_to_monitor(A, B);
    end

    result_monitor result_monitor_h;

    initial begin: result_monitor_thread
        forever begin: result_monitor_block
            @(negedge clk);
            result_monitor_h.write_to_monitor(eq, neq, lt, lte, gt, gte);
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
    

endinterface : comparator_bfm