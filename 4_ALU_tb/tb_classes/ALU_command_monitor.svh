/* 
 November 2, 2025
 Isaias M Ramirez
 The command monitor receives commands from the bfm and writes them over to the 
 scoreboard and coverage objects for processing
*/

class ALU_command_monitor extends uvm_component;
   `uvm_component_utils(ALU_command_monitor);

   virtual ALU_bfm bfm;
   uvm_analysis_port #(ALU_sequence_item) ap;

   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);

      if(!uvm_config_db #(virtual ALU_bfm)::get(null, "*","bfm", bfm))
        `uvm_fatal("DRIVER", "Failed to get BFM")

      ap  = new("ap",this);
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      bfm.command_monitor_h = this;
   endfunction : connect_phase

   function void write_to_monitor(bit[1:0] control, bit [31:0]  A, bit [31:0]  B);
      ALU_sequence_item cmd;
      $display(""); // added for formating
      `uvm_info ("COMMAND MONITOR", $sformatf(" C: %2b A: %8H B: %8H ",
                 control, A ,B), UVM_HIGH);
      cmd = new("cmd");
      cmd.A = A;
      cmd.B = B;
      cmd.control = control;  
      ap.write(cmd);
   endfunction : write_to_monitor
endclass : ALU_command_monitor
