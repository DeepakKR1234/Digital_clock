module test_bench
 reg Clk;
 reg Reset_n;
  reg Io0_down;
  reg Io1_up;
  reg Io2_setminute;
  reg Io4_militiary;
  reg Io5_stopwatch_enable;
  reg Io6_stopwatch_run;
  reg I07_stopwatch_zero;
wire Ad0_L1;
wire Ad1_L2;
wire Ad3_L4;
 wire Io8_a;
 wire Io9_b;
 wire Io10_c;
 wire Io11_d;
 wire Io12_e;
 wire Ad4_g;
 wire Ad5_dp;

 lab_6 clock(.clk(Clk), .reset_n(Reset_n), .io0_down(Io0_down), .io1_up(Io1_up), .io2_setminute(Io2_setminute), 
 .io4_militiary(Io4_militiary), 
 .io5_stopwatch_enable(Io5_stopwatch_enable), .io6_stopwatch_run(Io6_stopwatch_run), .i07_stopwatch_zero(I07_stopwatch_zero),
.ad0_L1(Ad0_L1), .ad1_L2(Ad1_L2), .ad3_L4(Ad3_L4), .io8_a(Io8_a), .io9_b(Io9_b), .io10_c(Io10_c), .io11_d(Io11_d), .io12_e(Io12_e), 
.ad4_g(Ad4_g), .ad5_dp(Ad5_dp)  )
endmodule


