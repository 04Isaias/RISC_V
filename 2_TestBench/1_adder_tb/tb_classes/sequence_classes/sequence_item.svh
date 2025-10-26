/* 
 October 25, 2025
 Isaias M Ramirez
 definition of a sequence_item for this testbench objects of this class are used to 
 communicate data accross the testbench, 
 along with a few helpful functions for comparing, copying, and converting to string.
*/
class sequence_item extends uvm_sequence_item;
    `uvm_object_utils(sequence_item);

    function new(string name = "");
        super.new(name);
    endfunction : new

    rand int unsigned uint_32_a; 
    rand int unsigned uint_32_b;
    
    int unsigned result;

    /* define the distribution of random values, this increase the probability of 0 and max */
    constraint data { 
        uint_32_a dist { 32'h0000_0000 := 1, [32'h0000_0001 : 32'hFFFF_FFFE]:= 1, 32'hFFFF_FFFE:= 1 };
        uint_32_b dist { 32'h0000_0000 := 1, [32'h0000_0001 : 32'hFFFF_FFFE]:= 1, 32'hFFFF_FFFE:= 1 };
    }

    /* deep compares two sequence items to check if they are the same. 
        rerturns a single bit 1 if they are and 0 if they are not*/
    function bit do_compare(uvm_object rhs, uvm_comparer comparer); 
        sequence_item tested;
        bit same;

        if(rhs==null)`uvm_fatal(get_type_name(),
            "Comparison to a null pointer is not allowed");

        if(!$cast(tested,rhs))
            same = 0;
        else
            same = super.do_compare(rhs, comparer) && /* deep comparison, parent object also compares */
            (tested.uint_32_a == uint_32_a) && 
            (tested.uint_32_b == uint_32_b) && 
            (tested.result == result);
        return same;
    endfunction : do_compare

    /* deep copy of sequence item */
    function void do_copy(uvm_object rhs);
        sequence_item RHS;
        assert(rhs != null) else
            $fatal(1,"Copying a null transaction is not allowed");
        super.do_copy(rhs);
        assert($cast(RHS, rhs)) else
            $fatal(1, "Failed to cast in do_copy");
        uint_32_a = RHS.uint_32_a;
        uint_32_b = RHS.uint_32_b;
        result = RHS.result;
    endfunction : do_copy

    /*returns a sequence_item represented as a string */
    function string convert2string();
        string  s;
        s = $sformatf("uint_32_a: %8h \n uint_32_a: %8h \n result: %8h", 
            uint_32_a, uint_32_b, result);
        return s;
    endfunction : convert2string

endclass : sequence_item