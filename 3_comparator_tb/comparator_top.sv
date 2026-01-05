/*
Isaias M Ramirez
The purpose of this UVM test bench is to test a 32-bit comparator
To enable coverage in vivado follow this guide and use this command:
 https://docs.amd.com/r/en-US/ug937-vivado-design-suite-simulation-tutorial/Code-Coverage-Functionality-Supported-by-xelab/xsim 
 export_xsim_coverage -cov_db_name DB1 -cov_db_dir cRun1 -output_dir cReport1 -open_html true
*/
module comparator_top;
    import uvm_pkg::*;
    import comparator_pkg::*;
`include "comparator_macros.svh"
`include "uvm_macros.svh"

    comparator_bfm      bfm();

    gen_comparator DUT (
        .a(bfm.A),
        .b(bfm.B),
        .eq(bfm.eq),
        .neq(bfm.neq),
        .lt(bfm.lt),
        .lte(bfm.lte),
        .gt(bfm.gt),
        .gte(bfm.gte),
    );

    initial begin
        uvm_config_db #(virtual comparator_bfm)::set(null, "*", "bfm", bfm);
        run_test();
    end
endmodule : comparator_top