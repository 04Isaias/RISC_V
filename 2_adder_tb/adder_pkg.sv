/* 
 October 25, 2025
 Isaias M Ramirez
 adder_pkg
*/

package adder_pkg; 
    import uvm_pkg::*;
`include "uvm_macros.svh"

`include "base_sequence_item.svh"
`include "adder_sequence_item.svh"
typedef uvm_sequencer #(adder_sequence_item) sequencer;

`include "adder_random_sequence.svh"
`include "run_sequences.svh"

`include "adder_result_transaction.svh"
`include "adder_command_monitor.svh"

`include "adder_driver.svh"
`include "adder_result_monitor.svh"
`include "adder_scoreboard.svh"
`include "adder_coverage.svh"

`include "adder_env.svh"

`include "base_test.svh"
`include "random_test.svh"

endpackage : adder_pkg