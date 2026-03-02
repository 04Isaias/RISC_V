/* 
 October 25, 2025
 Isaias M Ramirez
 The coverage defines covergroups and coverpoints to achieve the desired coverage
 this is necessary because we are using random constrained stimulus.
 The coverpoints define that the following must be covered:
    1. both numbers are all ones
    2. both numbers are all zeros
    3. A is greater than B
    4. A is less than B
    5. A is equal to B
//could this be made generic? (no hardcoding for a 32 bit?)
*/
class coverage extends uvm_subscriber #(sequence_item);
    `uvm_component_utils(coverage)

    bit [31:0]  uint_A;
    bit [31:0]  uint_B;

    covergroup all_comb;
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

        edge_cases: cross a_leg, b_leg {
            // Answers => Have all zeros and all ones have been covered? (implicitly covers eq)
            bins compare_00 = binsof(a_leg.zeros) && binsof(b_leg.zeros); 
            bins compare_FF = binsof(a_leg.ones) && binsof(b_leg.ones);
            ignore_bins others_only = binsof(a_leg.others) && binsof(b_leg.others);
        }

        // coverpoints for testing gt/lt
        a_gt_lt : coverpoint uint_A {
            bins upper = {[32'h0000_FFFF : 32'hFFFF_FFFF]};
            bins lower = {[32'h0000_0000 : 32'h0000_FFFE]};
        }

        b_gt_lt : coverpoint uint_B {
            bins upper = {[32'h0000_FFFF : 32'hFFFF_FFFF]};
            bins lower = {[32'h0000_0000 : 32'h0000_FFFE]};
        }
        
        gt_lt: cross a_gt_lt, b_gt_lt {
            // Answers => Have A>B and A<B been covered? (implicitly covers neq)
            bins compare_gt = binsof(a_gt_lt.upper) && binsof(b_gt_lt.lower); 
            bins compare_lt = binsof(a_gt_lt.lower) && binsof(b_gt_lt.upper); 
        }
    endgroup

    function new (string name, uvm_component parent);
        super.new(name, parent);
        all_comb = new();
    endfunction : new

    function void write ( sequence_item t);
        uint_A = t.uint_32_a;
        uint_B = t.uint_32_b;
        all_comb.sample();
    endfunction : write
    
endclass : coverage