/* 
 October 25, 2025
 Isaias M Ramirez
 definition of a transaction for this testbench. Objects of this class are used to 
 communicate data accross the testbench, 
 along with a few helpful functions for comparing, copying, and converting to string.
 */

class ALU_result_transaction extends result_transaction; 
    bit N;
    bit Z;
    bit C;
    bit V;

    function new(string name = "");
        super.new(name);
    endfunction : new

    /* deep copy of a result transaction */
    function void do_copy(uvm_object rhs);
        ALU_result_transaction copied_transaction_h;
        assert(rhs != null) else 
            $fatal(1,"Copying a null transaction is not allowed");
        super.do_copy(rhs);
        assert($cast(copied_transaction_h, rhs))else
            $fatal(1, "Failed cast in do_copy");
        N = copied_transaction_h.N;
        Z = copied_transaction_h.Z;
        C = copied_transaction_h.C;
        V = copied_transaction_h.V;
    endfunction : do_copy

    /* convert a result_transaction into readable string format */
    function string convert2string();
        string s;
        super.convert2string();
        s = $sformatf(" N: %b Z: %b C: %b V: %b ", N, Z, C, V);
        return s;
    endfunction : convert2string

    /* deep compare of a result_transaction */
    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        ALU_result_transaction RHS;
        bit same;
        assert(rhs != null) else
            $fatal(1, "Comparison to null is not allowed");
        
        same = super.do_compare(rhs, comparer);

        if($cast(RHS, rhs))begin
            same = (N == RHS.N) &&
                   (Z == RHS.Z) && 
                   (C == RHS.C) && 
                   (V == RHS.V) && 
                   same; 
        end else 
            $fatal(1, "FAILED to cast ALU result transaction");
        return same;
    endfunction : do_compare


endclass : ALU_result_transaction;