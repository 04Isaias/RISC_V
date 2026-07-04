/* 
 October 25, 2025
 Isaias M Ramirez
 The scoreboard predicts the result of the DUT and prints it using the uvm.
*/
class scoreboard extends uvm_subscriber #(result_transaction_adder);
    `uvm_component_utils(scoreboard);

    bit[32:0] add_result;
    uvm_tlm_analysis_fifo #(adder_sequence_item) cmd_f;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase (uvm_phase phase);
        cmd_f = new ("cmd_f", this);
    endfunction : build_phase

    function result_transaction_adder predict_result(adder_sequence_item cmd);
        result_transaction_adder predicted;

        predicted = new("predicted");

        add_result = cmd.c_in + cmd.A + cmd.B;
        predicted.result = add_result[31:0];
        predicted.c_out_result = add_result[32];
        
        return predicted; 

    endfunction : predict_result

    function void write(result_transaction_adder t);
        string data_str;
        adder_sequence_item cmd;
        result_transaction_adder predicted;

        if(!cmd_f.try_get(cmd))
            $fatal(1, "Missing command in self checker");

        predicted = predict_result(cmd);

        data_str = {
            cmd.convert2string(), " Actual ", t.convert2string(),
            "\n Predicted ", predicted.convert2string()
        };

        $display(""); // added for formating
        if(!predicted.compare(t))
            `uvm_error("SELF CHECKER", {"FAIL", data_str})
        else
            `uvm_info ("SELF CHECKER", {"PASS", data_str}, UVM_HIGH)
        
    endfunction : write
endclass : scoreboard