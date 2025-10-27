/* 
 October 24, 2025
 Isaias M Ramirez
 The purpose of this UVM test bench is to test a 32-bit adder
*/
module adder_top;
    import uvm_pkg::*;
    import adder_pkg::*;
`include "adder_macros.svh"
`include "uvm_macros.svh"

    adder_bfm       bfm();

    gen_adder DUT (
        .uint_1(bfm.uint_32_a), 
        .uint_2(bfm.uint_32_b), 
        .uint_sum(bfm.result),
        .over_flow() // not used; implement logic later
        );

initial begin
    uvm_config_db #(virtual adder_bfm)::set(null, "*", "bfm", bfm);
    run_test();
end
endmodule : adder_top