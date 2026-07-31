/* 
 October 25, 2025
 Isaias M Ramirez
 test that starts the random stimulus seqeunce. 
 run_sequences is capable of running multiple sequenes and is left in for future development. 
*/

class random_test extends base_test;
    `uvm_component_utils(random_test);

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
endclass : random_test