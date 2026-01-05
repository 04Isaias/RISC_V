/*
January 4, 2025
Isaias M Ramirez
Env that declares and connects them (this can be used as the uvm root for sigasi diagrams) */

class env extends uvm_env;
    `uvm_component_utils(env);

    sequencer       sequencer_h;
    driver          driver_h;
    result_monitor  result_monitor_h;
    coverage        coverage_h;
    scoreboard      scoreboard_h;
    command_monitor command_monitor_h;

    function new(string name, uvm_component partent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        //stimulus

        //monitor

        //analysis

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);

    endfunction : connect_phase
endclass    :   env