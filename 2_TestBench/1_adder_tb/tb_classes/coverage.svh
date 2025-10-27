/* 
 October 25, 2025
 Isaias M Ramirez
 The coverage deifnes covergroups and coverpoints to achieve the desired coverage
 this is necessary because we are using random constrained stimulus.
*/
class coverage extends uvm_subscriber #(sequence_item);
    `uvm_component_utils(coverage)

    int unsigned uint_A;
    int unsigned uint_B;

    covergroup zeros_or_ones;
        a_leg : coverpoint uint_A {
            bins zeros = {32'h0000_0000};
            bins others = {[32'h0000_0001 : 32'hFFFF_FFFE]};
            bins ones = {32'hFFFF_FFFF};
        }

        b_leg : coverpoint uint_B {
            bins zeros = {32'h0000_0000};
            bins others = {[32'h0000_0001 : 32'hFFFF_FFFE]};
            bins ones = {32'hFFFF_FFFF};
        }

        all_comb: cross a_leg, b_leg {
            // make sure interesting values are covered, ignore all others.
            bins add_00 = binsof(a_leg.zeros) && binsof(b_leg.zeros); 
            bins add_FF = binsof(a_leg.ones) && binsof(b_leg.ones);
            ignore_bins others_only = binsof(a_leg.others) && binsof(b_leg.others);
        }
    endgroup

    function new (string name, uvm_component parent);
        super.new(name, parent);
        zeros_or_ones = new();
    endfunction : new

    function void write ( sequence_item t);
        uint_A = t.uint_32_a;
        uint_B = t.uint_32_b;
        zeros_or_ones.sample();
    endfunction : write
    
endclass : coverage