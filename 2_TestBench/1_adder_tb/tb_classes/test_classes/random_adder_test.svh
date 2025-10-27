/* 
 October 25, 2025
 Isaias M Ramirez
 this test runs the random sequence for the testbench
*/

class random_adder_test extends adder_base_test;
    `uvm_component_utils(random_adder_test);

    run_sequences run_seqs;

    task run_phase (uvm_phase phase);
        run_seqs = new("run_seqs");
        phase.raise_objection(this);
        run_seqs.start(null);
        phase.drop_objection(this);
    endtask : run_phase
    
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new
endclass : random_adder_test