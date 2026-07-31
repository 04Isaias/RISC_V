/*
January 3, 2026
Isaias M Ramirez 
Specifies the files used in the TB*/

package comparator_pkg;
    import uvm_pkg::*;
`include "uvm_macros.svh"

`include "sequence_item.svh"
typedef uvm_sequencer #(sequence_item) sequencer;

`include "random_sequence.svh"
`include "run_sequences.svh"

`include "result_transaction.svh"
`include "command_monitor.svh"

`include "driver.svh"
`include "result_monitor.svh"
`include "scoreboard.svh"
`include "coverage.svh"

`include "env.svh"

`include "base_test.svh"
`include "random_test.svh"

endpackage : comparator_pkg