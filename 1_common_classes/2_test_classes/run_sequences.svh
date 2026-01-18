/* 
 October 26, 2025
 Isaias M Ramirez
 this sequence makes use of stimulus defined in other sequences
*/

class run_sequences extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(run_sequences);

    protected sequencer sequencer_h;
    protected random_sequence random;
    protected uvm_component uvm_component_h;

function new(string name = "run_sequences");
    super.new(name);
    uvm_component_h = uvm_top.find("*.env_h.sequencer_h");

    if(uvm_component_h == null)
        `uvm_fatal("RUN SEQUENCE", "Failed to get the sequencer")

    if(!$cast(sequencer_h, uvm_component_h))
        `uvm_fatal("RUN SEQUENCE", "Failed to cast from uvm_component_h")

    random = random_sequence::type_id::create("random");
endfunction : new

task body();
    random.start(sequencer_h);
endtask : body

endclass : run_sequences