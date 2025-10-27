/* 
 October 26, 2025
 Isaias M Ramirez
 This sequence defines random stimulus to be injected into the testbench as ran by a test
*/

class random_sequence extends uvm_sequence #(sequence_item);
    `uvm_object_utils(random_sequence);

    sequence_item command; 

    function new(string name = "random_sequence");
        super.new(name);
    endfunction : new

    task body();
        repeat (10000) begin : random_loop
            command = sequence_item::type_id::create("command");
            start_item(command);
            assert(command.randomize()); // this command is provided by uvm
            finish_item(command);
        end : random_loop
    endtask : body

endclass : random_sequence