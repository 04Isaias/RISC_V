/* 
 October 25, 2025
 Isaias M Ramirez
 definition of a transaction for this testbench. Objects of this class are used to 
 communicate data accross the testbench, 
 along with a few helpful functions for comparing, copying, and converting to string.
 */

class result_transaction_adder extends uvm_transaction; 
    bit [31:0] result;
    bit  c_out_result;

    function new(string name = "");
        super.new(name);
    endfunction : new

    /* deep copy of a result transaction */
    function void do_copy(uvm_object rhs);
        result_transaction_adder copied_transaction_h;
        assert(rhs != null) else 
            $fatal(1,"Copying a null transaction is not allowed");
        super.do_copy(rhs);
        assert($cast(copied_transaction_h, rhs))else
            $fatal(1, "Failed cast in do_copy");
        result = copied_transaction_h.result;
        c_out_result = copied_transaction_h.c_out_result;
    endfunction : do_copy

    /* convert a result_transaction into readable string format */
    function string convert2string();
        string s;
        s = $sformatf("result: %8h c: %b", result, c_out_result);
        return s;
    endfunction : convert2string

    /* deep compare of a result_transaction */
    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        result_transaction_adder RHS;
        bit same;
        assert(rhs != null) else
            $fatal(1, "Comparison to null is not allowed");
        
        same = super.do_compare(rhs, comparer);

        if($cast(RHS, rhs))begin
            same = (result == RHS.result) && ( c_out_result == RHS.c_out_result ) && same; 
        end else 
            $fatal(1, "FAILED to cast result transaction");
               
        
        return same;
    endfunction : do_compare


endclass : result_transaction_adder;