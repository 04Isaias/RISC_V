/* 
 October 25, 2025
 Isaias M Ramirez
 The scoreboard predicts the result of the DUT and prints it using the uvm.
*/
class scoreboard extends uvm_subscriber #(ALU_result_transaction);
    `uvm_component_utils(scoreboard);

    bit[31:0] result;
    bit N;
    bit Z;
    bit C;
    bit V;
    
    uvm_tlm_analysis_fifo #(sequence_item) cmd_f;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase (uvm_phase phase);
        cmd_f = new ("cmd_f", this);
    endfunction : build_phase

    function ALU_result_transaction predict_result(sequence_item cmd);
        ALU_result_transaction predicted;

        predicted = new("predicted");

        add_result = cmd.c_in + cmd.uint_32_a + cmd.uint_32_b;
        predicted.result = add_result[31:0];
        predicted.c_out_result = add_result[32];
        
        return predicted; 

    endfunction : predict_result

    function void write(result_transaction_adder t);
        string data_str;
        sequence_item cmd;
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