/* 
 October 25, 2025
 Isaias M Ramirez
 The scoreboard predicts the result of the DUT and prints it using the uvm.
*/
class scoreboard extends uvm_subscriber #(result_transaction);
    `uvm_component_utils(scoreboard);


    uvm_tlm_analysis_fifo #(sequence_item) cmd_f;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase (uvm_phase phase);
        cmd_f = new ("cmd_f", this);
    endfunction : build_phase

    function result_transaction predict_result(sequence_item cmd);
        result_transaction predicted;

        predicted = new("predicted");

        predicted.result = cmd.uint_32_a + cmd.uint_32_b;

        return predicted; 

    endfunction : predict_result

    function void write(result_transaction t);
        string data_str;
        sequence_item cmd;
        result_transaction predicted;

        if(!cmd_f.try_get(cmd))
            $fatal(1, "Missing command in self checker");

        predicted = predict_result(cmd);

        data_str = {
            cmd.convert2string(), " ==> Actual ", t.convert2string(),
            "/Predicted ", predicted.convert2string()
        };

        if(!predicted.compare(t))
            `uvm_error("SELF CHECKER", {"FAIL", data_str})
        else
            `uvm_info ("SELF CHECKER", {"PASS", data_str}, UVM_HIGH)
        
    endfunction : write
endclass : scoreboard