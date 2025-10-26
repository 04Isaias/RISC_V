/* 
 October 25, 2025
 Isaias M Ramirez
 The result monitor publishes the tesbench results when they become available
*/

class result_monitor extends uvm_component;
    `uvm_component_utils(result_monitor);

    virtual adder_bfm bfm;
    uvm_analysis_port #(result_transaction) ap;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual adder_bfm)::get(null, "*", "bfm", bfm))
            `uvm_fatal("DRIVER", "Failed to get BFM");
        ap = new("ap", this);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        bfm.result_monitor_h = this;
    endfunction : connect_phase

    function void write_to_monitor(int unsigned r);
        result_transaction result_t;
        result_t = new("result_t");
        result_t.result = r;
        ap.write(result_t);
    endfunction : write_to_monitor;

endclass : result_monitor