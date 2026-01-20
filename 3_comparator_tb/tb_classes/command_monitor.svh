/* 
 January 1, 2026
 Isaias M Ramirez
 The command monitor receives commands from the bfm and writes them over to the 
 scoreboard and coverage objects for processing
*/

class command_monitor extends uvm_component;
    `uvm_component_utils(command_monitor);

    virtual comparator_bfm bfm;
    uvm_analysis_port #(sequence_item) ap;

    function new (string name, uvm_component parent);
        super .new(name, parent); 
    endfunction
    
    function void build_phase(uvm_phase phase);

        if(!uvm_config_db #(virtual comparator_bfm)::get(null, "*", "bfm", bfm))
            `uvm_fatal("Driver", "Failed to get BFM")

        ap = new("ap", this);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        bfm.command_monitor_h = this;
    endfunction : connect_phase

    function void write_to_monitor(bit [31:0] A, bit [31:0] B);
        sequence_item cmd;
        $display("");//
        `uvm_info ("COMMAND MONITOR", $sformatf("A: %8H B: %8H", 
                    A, B ), UVM_HIGH);
        cmd = new("cmd");
        cmd.uint_32_a = A;
        cmd.uint_32_b = B;
        ap.write(cmd);
    endfunction : write_to_monitor

endclass : command_monitor