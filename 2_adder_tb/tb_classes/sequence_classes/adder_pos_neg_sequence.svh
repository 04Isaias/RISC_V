/*
July 3rd, 2026
Isaias M Ramirez
This sequence randomizes A and B, but performs a two's compliment on B
*/

class adder_pos_neg_sequence extends uvm_sequence #(adder_sequence_item);
    `uvm_object_utils(adder_pos_neg_sequence);
    adder_sequence_item command;

    function new (string name = "pos_neg_sequence");
        super.new(name);
    endfunction : new

    task body();
        repeat (5000) begin : pos_neg_loop
            command = adder_sequence_item::type_id::create("command");
            start_item(command);
            assert(command.randomize());
            `uvm_info ("ADDER POS NEG SEQ", $sformatf(" B_og: %8H ",command.B), UVM_HIGH);
            command.B = ~command.B + 1;
            finish_item(command);
        end
    endtask : body
    
endclass : adder_pos_neg_sequence