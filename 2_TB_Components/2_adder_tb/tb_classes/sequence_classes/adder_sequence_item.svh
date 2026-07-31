/* 
 October 25, 2025
 Isaias M Ramirez
 definition of a sequence_item for this testbench objects of this class are used to 
 communicate data accross the testbench, 
 along with a few helpful functions for comparing, copying, and converting to string.
*/
class adder_sequence_item extends base_sequence_item;
    `uvm_object_utils(adder_sequence_item);

    function new(string name = "");
        super.new(name);
    endfunction : new

    rand bit           c_in;

    /* define the distribution of random values, this increase the probability of 0 and max */
    constraint data { 
        c_in      dist {0 := 1, 1 := 1};
    }

    /* deep compares two sequence items to check if they are the same. 
        rerturns a single bit 1 if they are and 0 if they are not*/
    function bit do_compare(uvm_object rhs, uvm_comparer comparer); 
        adder_sequence_item tested;
        bit same;

        if(rhs==null)`uvm_fatal(get_type_name(),
            "Comparison to a null pointer is not allowed");

        if(!$cast(tested,rhs))
            same = 0;
        else
            same = super.do_compare(rhs, comparer) && /* deep comparison, parent object also compares */
            (tested.c_in == c_in);
        return same;
    endfunction : do_compare

    /* deep copy of sequence item */
    function void do_copy(uvm_object rhs);
        adder_sequence_item RHS;
        assert(rhs != null) else
            $fatal(1,"Copying a null transaction is not allowed");
        super.do_copy(rhs);
        assert($cast(RHS, rhs)) else
            $fatal(1, "Failed to cast in do_copy");
        c_in = RHS.c_in;
    endfunction : do_copy

    /*returns a sequence_item represented as a string */
    function string convert2string();
        string  s;
        super.convert2string();
        s = $sformatf("\n C_in: %b \n", c_in);
        return s;
    endfunction : convert2string

endclass : adder_sequence_item