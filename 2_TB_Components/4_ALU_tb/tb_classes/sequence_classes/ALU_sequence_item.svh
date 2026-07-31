/* 
 October 25, 2025
 Isaias M Ramirez
 definition of a sequence_item for multiple testbenches
 objects of this class are used to communicate data accross the testbench, 
 along with a few helpful functions for comparing, copying, and converting to string.
*/
class ALU_sequence_item extends base_sequence_item;
    `uvm_object_utils(ALU_sequence_item);

    function new(string name = "");
        super.new(name);
    endfunction : new

    rand bit [2:0] control;


    /* define the distribution of random values, this increase the probability of 0 and max */
    constraint cntr_range { 
        control       dist { [3'b000:3'b011 ] := 2, 3'b101 := 1};
    }

    /* deep compares two sequence items to check if they are the same. 
        rerturns a single bit 1 if they are and 0 if they are not*/
    function bit do_compare(uvm_object rhs, uvm_comparer comparer); 
        ALU_sequence_item tested;
        bit same;

        if(rhs==null)`uvm_fatal(get_type_name(),
            "Comparison to a null pointer is not allowed");

        if(!$cast(tested,rhs))
            same = 0;
        else
            same = super.do_compare(rhs, comparer) && /* deep comparison, parent object also compares */
            (tested.control == control);
        return same;
    endfunction : do_compare

    /* deep copy of sequence item */
    function void do_copy(uvm_object rhs);
        ALU_sequence_item RHS;
        assert(rhs != null) else
            $fatal(1,"Copying a null transaction is not allowed");
        super.do_copy(rhs);
        assert($cast(RHS, rhs)) else
            $fatal(1, "Failed to cast in do_copy");
        control = RHS.control;
    endfunction : do_copy

    /*returns a sequence_item represented as a string */
    function string convert2string();
        string  s;
        super.convert2string();
        s = $sformatf("\n control: %3b \n", control);
        return s;
    endfunction : convert2string

endclass : ALU_sequence_item