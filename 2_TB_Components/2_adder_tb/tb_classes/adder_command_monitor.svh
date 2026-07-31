/* 
 November 2, 2025
 Isaias M Ramirez
 The command monitor receives commands from the bfm and writes them over to the 
 scoreboard and coverage objects for processing
*/

class command_monitor extends uvm_component;
   `uvm_component_utils(command_monitor);

   virtual adder_bfm bfm;
   uvm_analysis_port #(adder_sequence_item) ap;

   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);

      if(!uvm_config_db #(virtual adder_bfm)::get(null, "*","bfm", bfm))
        `uvm_fatal("DRIVER", "Failed to get BFM")

      ap  = new("ap",this);
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      bfm.command_monitor_h = this;
   endfunction : connect_phase

   function void write_to_monitor(bit c_in, bit [31:0]  A, bit [31:0]  B);
      adder_sequence_item cmd;
      $display(""); // added for formating
      `uvm_info ("COMMAND MONITOR", $sformatf(" C: %b A: %8H B: %8H ",
                 c_in, A, B), UVM_HIGH);
      cmd = new("cmd");
      cmd.A = A;
      cmd.B = B;
      cmd.c_in = c_in;  
      ap.write(cmd);
   endfunction : write_to_monitor
endclass : command_monitor
