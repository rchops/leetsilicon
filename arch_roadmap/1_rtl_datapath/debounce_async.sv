// ============================================================
// ID: rtl5 — Debounce + Synchronize + Rising Pulse
// ============================================================
// Goal: 2FF sync async input, require stable-high for >=2 cycles, pulse on rise. 

module debounce_sync (
  input  logic clk,
  input  logic rst_n,
  input  logic async_in,
  output logic debounced_level,
  output logic debounced_rise_pulse
);

  // TODO: 2FF synchronizer (s1,s2).
  // Why: reduce metastability risk when bringing async_in into clk domain.
  logic s1, s2;
  always_ff @(posedge clk) begin
    s1 <= async_in;
    s2 <= s1;
  end

  // TODO: Stability filter state.
  // Why: require 2 consecutive high samples before asserting debounced_level.
  // Options: 2-bit history shift register, or small counter.
  logic [1:0] hi_hist;
  logic debounced_d;

  // TODO: Edge detect on debounced_level.


  // TODO: always_ff: synchronizer + filter + delayed debounced.
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      s1 <= 0;
      s2 <= 0;
      hi_hist <= 'b0;
    end else if (s2) begin
      hi_hist <= {hi_hist[0], 1'b1};
    end
    if (hi_hist == 'd3) begin
      debounced_level <= 1;
      debounced_d <= debounced_level;
    end
  end

  assign debounced_rise_pulse = debounced_level & ~debounced_d;

  // TODO: Filter rule.
  // Why: ">=2 cycles high" acceptance; optionally do symmetric deassert on 2 lows.

  // TODO: debounced_rise_pulse equation.
  // Why: 1-cycle pulse generation.
  // debounced_rise_pulse = debounced_level & ~debounced_d;

endmodule