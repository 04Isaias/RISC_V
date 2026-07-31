/* 
 October 25, 2025
 Isaias M Ramirez
 ALU_pkg
*/

package ALU_pkg; 
    import uvm_pkg::*;
`include "uvm_macros.svh"

`include "base_sequence_item.svh"
`include "ALU_sequence_item.svh"
typedef uvm_sequencer #(ALU_sequence_item) sequencer;

`include "ALU_random_sequence.svh"
`include "run_sequences.svh"

`include "base_result_transaction.svh"
`include "ALU_result_transaction.svh"
`include "ALU_command_monitor.svh"

`include "ALU_driver.svh"
`include "ALU_result_monitor.svh"
`include "ALU_scoreboard.svh"
`include "ALU_coverage.svh"

`include "ALU_env.svh"

`include "base_test.svh"
`include "random_test.svh"

endpackage : ALU_pkg