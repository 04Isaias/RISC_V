/* 
 October 25, 2025
 Isaias M Ramirez
 The coverage defines covergroups and coverpoints to achieve the desired coverage
 this is necessary because we are using random constrained stimulus.
*/
class ALU_coverage extends uvm_subscriber #(ALU_sequence_item);
    `uvm_component_utils(ALU_coverage)

    bit [2:0]   control;
    bit [31:0]  A;
    bit [31:0]  B;
    

    covergroup zeros_or_ones;
        c_leg : coverpoint control{
            bins add = {3'b000};
            bins sub = {3'b001};
            bins and_opp = {3'b010};
            bins or_opp  = {3'b011};
            bins slt_opp = {3'b101};
            bins others = {3'b100, 3'b110, 3'b111};
        }

        a_leg : coverpoint A {
            bins zeros = {32'h0000_0000};
            bins others = {[32'h0000_0001 : 32'hFFFF_FFFE]};
            bins ones = {32'hFFFF_FFFF};
        }

        b_leg : coverpoint B {
            bins zeros = {32'h0000_0000};
            bins others = {[32'h0000_0001 : 32'hFFFF_FFFE]};
            bins ones = {32'hFFFF_FFFF};
        }

        all_comb: cross c_leg, a_leg, b_leg {
            // make sure interesting values are covered, ignore all others.
            bins add_zeros = binsof(c_leg.add) && binsof(a_leg.zeros) && binsof(b_leg.zeros); 
            bins add_ones  = binsof(c_leg.add) && binsof(a_leg.ones)  && binsof(b_leg.ones); 
            bins sub_ones  = binsof(c_leg.sub) && binsof(a_leg.zeros) && binsof(b_leg.zeros); 
            bins sub_zeros = binsof(c_leg.sub) && binsof(a_leg.ones)  && binsof(b_leg.ones); 
            bins AND_ones  = binsof(c_leg.and_opp) && binsof(a_leg.ones)  && binsof(b_leg.ones); 
            bins AND_zeros  = binsof(c_leg.and_opp) && binsof(a_leg.zeros)  && binsof(b_leg.zeros); 
            bins OR_ones   = binsof(c_leg.or_opp) && binsof(a_leg.ones)  && binsof(b_leg.ones); 
            bins OR_zeros   = binsof(c_leg.or_opp) && binsof(a_leg.zeros)  && binsof(b_leg.zeros); 
            bins slt_ones   = binsof(c_leg.slt_opp) && binsof(a_leg.ones)  && binsof(b_leg.ones);  
            bins slt_zeros   = binsof(c_leg.slt_opp) && binsof(a_leg.zeros)  && binsof(b_leg.zeros);  
            ignore_bins others_only = binsof(c_leg.others) && binsof(a_leg.others) && binsof(b_leg.others);
        }
    endgroup

    function new (string name, uvm_component parent);
        super.new(name, parent);
        zeros_or_ones = new();
    endfunction : new

    function void write ( ALU_sequence_item t );
        A = t.A;
        B = t.B;
        control = t.control;
        zeros_or_ones.sample();
    endfunction : write
    
endclass : ALU_coverage