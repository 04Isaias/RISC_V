/* 
 October 25, 2025
 Isaias M Ramirez
 The bfm class provides the interface used throughout the testbench
*/

interface ALU_bfm;
    import ALU_pkg::*;

    bit [31:0]     A;
    bit [31:0]     B;
    bit [1:0]      control;
    
    wire[31:0]    result;
    bit            N;
    bit            Z;
    bit            C;
    bit            V;

    bit            done;
    bit            clk;
    

    task send_opp(bit[1:0] icontrol, bit [31:0] iA, bit [31:0] iB);
        begin 
            @(posedge clk)begin
                control = icontrol; 
                A = iA;
                B = iB;
            end

        end;
    endtask : send_opp

    command_monitor command_monitor_h;

    always @(posedge clk) begin : ALU_monitor
        command_monitor_h.write_to_monitor(control, A, B);
    end

    result_monitor result_monitor_h;

    initial begin: result_monitor_thread
        forever begin: result_monitor_block
            @(negedge clk);
            result_monitor_h.write_to_monitor(result, N, Z, C, V);
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


endinterface : ALU_bfm