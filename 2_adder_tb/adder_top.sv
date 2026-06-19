/* 
 October 24, 2025
 Isaias M Ramirez
 The purpose of this UVM test bench is to test a 32-bit adder
 To enable coverage in vivado follow this guide and use this command:
 https://docs.amd.com/r/en-US/ug937-vivado-design-suite-simulation-tutorial/Code-Coverage-Functionality-Supported-by-xelab/xsim 
 export_xsim_coverage -cov_db_name DB1 -cov_db_dir cRun1 -output_dir cReport1 -open_html true
*/
module adder_top;
    import uvm_pkg::*;
    import adder_pkg::*;
`include "adder_macros.svh"
`include "uvm_macros.svh"

    adder_bfm       bfm();

    gen_adder DUT (
        .carry_in(bfm.carry_in), 
        .uint_1(bfm.uint_32_a), 
        .uint_2(bfm.uint_32_b), 
        .uint_sum(bfm.result),
        .gen_adder_c_out(bfm.carry_out) 
        );

initial begin
    uvm_config_db #(virtual adder_bfm)::set(null, "*", "bfm", bfm);
    run_test();
end
endmodule : adder_top