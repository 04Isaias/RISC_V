/* 
 October 25, 2025
 Isaias M Ramirez
 The driver class sends data throught the BFM when a sequence_item is ready
*/
class driver extends uvm_driver #(sequence_item);
    `uvm_component_utils(driver)

    virtual adder_bfm bfm;

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual adder_bfm)::get(null, "*", "bfm", bfm))
            `uvm_fatal("DRIVER", "Failed to get BFM")
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        sequence_item cmd;
        forever begin: cmd_loop
            int unsigned result;
            seq_item_port.get_next_item(cmd);
            bfm.send_add(cmd.uint_32_a,cmd.uint_32_b, result);
            cmd.result = result;
            seq_item_port.item_done();
        end : cmd_loop
    endtask : run_phase

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : driver