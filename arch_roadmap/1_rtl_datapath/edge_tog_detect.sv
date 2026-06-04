// ============================================================
// ID: rtl1 — Edge / Toggle Detector
// ============================================================
// Goal: detect rising, falling, and any toggle using previous-sample compare. 

module edge_toggle_detect (
  input  logic clk,
  input  logic rst_n,
  input  logic sig_in,
  output logic rise_pulse,
  output logic fall_pulse,
  output logic toggle_pulse
);

  // TODO: Create 1-cycle delayed sample (sig_prev).
  // Why: edges are detected by comparing current sample with previous sample.
  logic sig_prev;

  // TODO: Sequential sample of sig_in into sig_prev (always_ff).
  // Why: makes comparison synchronous and stable.
  // On reset (rst_n=0), initialize sig_prev to 0 to prevent false pulses.
  always_ff @(posedge clk) begin
    if(!rst_n) begin
      sig_prev <= '0;
      rise_pulse <= '0;
      fall_pulse <= '0;
      toggle_pulse <= '0;
    end else begin
      sig_prev <= sig_in;
      rise_pulse = ~sig_prev & sig_in;
      fall_pulse = sig_prev & ~sig_in;
      toggle_pulse = rise_pulse | fall_pulse;
    end
  end
endmodule