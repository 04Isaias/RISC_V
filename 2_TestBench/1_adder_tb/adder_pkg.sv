/* 
 October 25, 2025
 Isaias M Ramirez
 adder_pkg
*/

package adder_pkg; 
    import uvm_pkg::*;
`include "uvm_macros.svh"

`include "sequence_item.svh"
typedef uvm_sequencer #(sequence_item) sequencer;

`include "random_sequence.svh"
`include "run_sequences.svh"

`include "result_transaction.svh"

`include "driver.svh"
`include "result_monitor.svh"
`include "scoreboard.svh"
`include "coverage.svh"

`include "env.svh"

`include "adder_base_test.svh"
`include "random_adder_test.svh"

endpackage : adder_pkg