/* 
 October 24, 2025
 Isaias M Ramirez
 The purpose of this UVM test bench is to test a 32-bit adder
 To enable coverage in vivado follow this guide and use this command:
 https://docs.amd.com/r/en-US/ug937-vivado-design-suite-simulation-tutorial/Code-Coverage-Functionality-Supported-by-xelab/xsim 
 export_xsim_coverage -cov_db_name DB1 -cov_db_dir cRun1 -output_dir cReport1 -open_html true
*/
module ALU_top;
    import uvm_pkg::*;
    import ALU_pkg::*;
`include "ALU_macros.svh"
`include "uvm_macros.svh"

    ALU_bfm       bfm();

    ALU DUT (
         .a(bfm.A),
         .b(bfm.B), 
         .control(bfm.control), 
         .result(bfm.result), 
         .flags(bfm.flags)
        );

initial begin
    uvm_config_db #(virtual ALU_bfm)::set(null, "*", "bfm", bfm);
    run_test();
end
endmodule : ALU_top