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

    result_monitor result_monitor_h;

endinterface : comparator_bfm