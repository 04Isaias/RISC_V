/* 
 October 25, 2025
 Isaias M Ramirez
 The driver class sends data through the BFM when a sequence_item is ready
*/
class ALU_driver extends uvm_driver #(ALU_sequence_item);
    `uvm_component_utils(ALU_driver)

    virtual ALU_bfm bfm;

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual ALU_bfm)::get(null, "*", "bfm", bfm))
            `uvm_fatal("DRIVER", "Failed to get BFM")
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        ALU_sequence_item cmd;
        forever begin: cmd_loop
            seq_item_port.get_next_item(cmd);
            bfm.send_opp(cmd.control, cmd.A, cmd.B);
            seq_item_port.item_done();
        end : cmd_loop
    endtask : run_phase

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : ALU_driver