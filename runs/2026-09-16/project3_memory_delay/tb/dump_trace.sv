`timescale 1ns/1ps
module dump_trace;
  initial begin
    $dumpfile("results/simulation.vcd");
    $dumpvars(0, tb_memory_delay_logic);
  end
endmodule
