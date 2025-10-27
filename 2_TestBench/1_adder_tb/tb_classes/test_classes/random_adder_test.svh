/* 
 October 25, 2025
 Isaias M Ramirez
 this test runs the random sequence for the testbench
*/

class random_adder_test extends adder_base_test;
    `uvm_component_utils(random_adder_test);

    random_sequence random_seq;

    task run_phase (uvm_phase phase);
        random_seq = new("random_seq");
        phase.raise_objection(this);
        random_seq.start(null);
        phase.drop_objection(this);
    endtask : run_phase

endclass : random_adder_test