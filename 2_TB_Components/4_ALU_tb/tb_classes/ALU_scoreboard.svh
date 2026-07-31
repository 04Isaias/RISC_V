/* 
 October 25, 2025
 Isaias M Ramirez
 The scoreboard predicts the result of the DUT and prints it using the uvm.
*/
class ALU_scoreboard extends uvm_subscriber #(ALU_result_transaction);
    `uvm_component_utils(ALU_scoreboard);
    bit [2:0]  opp;
    bit [32 : 0 ] result;
    bit [32 : 0 ] subtraction;
    bit [32 : 0 ] addition;
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
        // subtraction and addition seperated because it's used twice
        subtraction = cmd.A + (~cmd.B + opp[0]);
        addition = cmd.A + cmd.B;
        //determine V before result since it's used in the case statement. (addition/subtraction used based on first bit)
        V = 
        (   ~opp[1]
            &
            (( (subtraction[31] ^ cmd.A[31]) & opp[0] ) | ( (addition[31] ^ cmd.A[31]) & ~opp[0] ))
            &
            ~(^{opp[0],cmd.A[31],cmd.B[31]})
        );
        predicted.V = V;
        //determine result based on OPP
        case(opp)
            3'b000: result =  addition;
            3'b001: result =  subtraction;
            3'b010: result =  cmd.A & cmd.B;
            3'b011: result =  cmd.A | cmd.B;
            // put the slt result in bit 0, then zero extend the rest of the bits.
            3'b101: result =  {(30)'(0),V ^ subtraction[31]};
            default: result = 33'h0_0000_0000;
        endcase
        //set result on prediction
        predicted.result = result[31:0];
        //determine N flag
        predicted.N = result[31];
        //determine Z
        predicted.Z = ~(|result[31:0]);
        //determine C
        case(opp)
            3'b000: predicted.C = result[32];
            3'b001: predicted.C = ~result[32]; //carry is inverse when subtracting
            default: predicted.C = 1'b0;
        endcase

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