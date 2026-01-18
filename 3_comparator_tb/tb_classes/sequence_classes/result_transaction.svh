/*
January 4, 2026
Isaias M Ramirez
objects of this class are used to communincate results between testbench components.
comes with a few helpful funcitons for comparing, copying, and converting to string.
*/
class result_transaction extends uvm_transaction; 
        bit eq;
        bit neq;
        bit lt;
        bit lte;
        bit gt;
        bit gte;

    function new(string name = "");
        super.new(name);
    endfunction : new

    /* deep copy of a result transaction */
    function void do_copy(uvm_object rhs);
        result_transaction copied_transaction_h;
        assert(rhs != null) else 
            $fatal(1,"Copying a null transaction is not allowed");
        super.do_copy(rhs);
        assert($cast(copied_transaction_h, rhs))else
            $fatal(1, "Failed cast in do_copy");
        eq = copied_transaction_h.eq;
        neq = copied_transaction_h.neq;
        lt = copied_transaction_h.lt;
        lte = copied_transaction_h.lte;
        gt = copied_transaction_h.gt;
        gte = copied_transaction_h.gte;
    endfunction : do_copy

    /* convert a result_transaction into readable string format */
    function string convert2string();
        string s;
        s = $sformatf(
        {"equal: %d\n",
        "not equal: %d\n",
        "lessthan: %d\n",
        "less than equal to : %d\n", 
        "greater than: %d\n", 
        "greater than or equal to: %d"}
        , eq, neq, lt, lte, gt, gte);
        return s;
    endfunction : convert2string

    /* deep compare of a result_transaction */
    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        result_transaction RHS;
        bit same;
        assert(rhs != null) else
            $fatal(1, "Comparison to null is not allowed");
        
        same = super.do_compare(rhs, comparer);

        if($cast(RHS, rhs))begin
            same = 
            (eq == RHS.eq)
            && (neq == RHS.neq)
            && (lt == RHS.lt)
            && (lte == RHS.lte)
            && (gt == RHS.gt)
            && (gte == RHS.gte)
            && same; 
        end else 
            $fatal(1, "FAILED to cast result transaction");
        return same;
    endfunction : do_compare


endclass : result_transaction;