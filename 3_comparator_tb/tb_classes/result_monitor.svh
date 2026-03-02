/*
January 4, 2026
Isaias M Ramirez
Result monitor publishes the testbench results once available
*/

class result_monitor extends uvm_component;
    `uvm_component_utils(result_monitor);

    virtual comparator_bfm bfm;
    uvm_analysis_port #(result_transaction) ap;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual comparator_bfm)::get(null, "*", "bfm", bfm))
            `uvm_fatal("DRIVER", "Failed to get BFM");
        ap = new("ap", this);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        bfm.result_monitor_h = this;
    endfunction : connect_phase

    function void write_to_monitor(bit eq, bit neq,bit lt,bit lte,bit gt,bit gte);
        result_transaction result_t;
        result_t = new("result_t");
        result_t.eq = eq;
        result_t.neq = neq;
        result_t.lt = lt;
        result_t.lte = lte;
        result_t.gt = gt;
        result_t.gte = gte;
        ap.write(result_t);
        bfm.done = ~bfm.done;
    endfunction : write_to_monitor;

endclass : result_monitor