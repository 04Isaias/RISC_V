/* 
 October 25, 2025
 Isaias M Ramirez
 The env class defines the structure of the testbench along with the interconnects
*/

class env extends uvm_env;
    `uvm_component_utils(env);

    sequencer           sequencer_h;
    driver              driver_h;
    result_monitor      result_monitor_h;

    function new( string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        //stimulus
        sequencer_h = new("sequencer_h", this);
        driver_h    = driver::type_id::create("driver_h", this);
        //monitor
        result_monitor_h = result_monitor::type_id::create("coverage_h", this);
        //analysis
        
            //missing coverage and scoreboard
    endfunction : build_phase
endclass : env