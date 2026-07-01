/* 
 October 25, 2025
 Isaias M Ramirez
 The scoreboard predicts the result of the DUT and prints it using the uvm.
*/
class ALU_scoreboard extends uvm_subscriber #(ALU_result_transaction);
    `uvm_component_utils(ALU_scoreboard);
    bit [1:0]  opp;
    bit [32:0] result;
    bit N;
    bit Z;
    bit C;
    bit V;

    
    uvm_tlm_analysis_fifo #(ALU_sequence_item) cmd_f;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase (uvm_phase phase);
        cmd_f = new ("cmd_f", this);
    endfunction : build_phase

    function ALU_result_transaction predict_result(ALU_sequence_item cmd);
        ALU_result_transaction predicted;
        predicted = new("predicted");
        opp = cmd.control;
        //determine result based on OPP
        case(opp)
            2'b00: result =  cmd.A + cmd.B;
            2'b01: result =  cmd.A - cmd.B;
            2'b10: result =  cmd.A & cmd.B;
            2'b11: result =  cmd.A | cmd.B;
            default: result = 32'h0000_0000;
        endcase
        //set result on prediction
        predicted.result = result[31:0];
        //determine N flag
        predicted.N = result[31];
        //determine Z
        predicted.Z = !(|result[31:0]);
        //determine C
        predicted.C = !opp[1] & result[32];
        //determine V
        predicted.V = 
        (   !opp[1]
            &
            (result[31] ^ cmd.A[31]) 
            &
            !(^{opp[0],cmd.A[31],cmd.B[31]})
        );
            
        return predicted; 

    endfunction : predict_result

    function void write(ALU_result_transaction t);
        string data_str;
        ALU_sequence_item cmd;
        ALU_result_transaction predicted;

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
endclass : ALU_scoreboard