//test is to initialise the env and run sequences
//interface handle as a argument is needed as don't use run_test in top
`include "env.sv"
//module test(intf vif);
module test(intf vif);
//env
env t_env;
//agnt t_agnt;

//how to control the phase in sv
//create in UVM and new in SV
initial begin
//t_env = new(env);
t_env = new(vif);
t_env.build();
t_env.run(); //define run task in env 
end
//how to implement run phase in SV
//run sequences -  same as UVM?
//raise_objection??
//seq1.start(t_env.t_agnt.a_seqr);
endmodule
