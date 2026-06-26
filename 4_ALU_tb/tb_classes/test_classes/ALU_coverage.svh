/* 
 October 25, 2025
 Isaias M Ramirez
 The coverage defines covergroups and coverpoints to achieve the desired coverage
 this is necessary because we are using random constrained stimulus.
*/
class coverage extends uvm_subscriber #(sequence_item);
    `uvm_component_utils(coverage)

    bit         c_in;
    bit [31:0]  uint_A;
    bit [31:0]  uint_B;
    

    covergroup zeros_or_ones;
        c_leg : coverpoint c_in{
            bins zero = {1'b0};
            bins one  = {1'b1};
        }

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

        all_comb: cross c_leg, a_leg, b_leg {
            // make sure interesting values are covered, ignore all others.
            bins add_00 = binsof(c_leg.zero) && binsof(a_leg.zeros) &&  binsof(b_leg.zeros); 
            bins add_FF_cc = binsof(c_leg.one) && binsof(a_leg.ones) && binsof(b_leg.ones); 
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
        c_in = t.c_in;
        zeros_or_ones.sample();
    endfunction : write
    
endclass : coverage