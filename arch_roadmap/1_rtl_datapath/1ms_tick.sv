// ============================================================
// ID: rtl9 — Timebase from 1ms tick (sec/min/hr)
// ============================================================
// Goal: count 1ms pulses to generate 1-cycle sec/min/hour pulses. 

module timebase (
  input  logic clk,
  input  logic rst_n,
  input  logic tick_1ms,
  output logic sec_pulse,
  output logic min_pulse,
  output logic hour_pulse
);

  // TODO: ms counter 0..999 (counts tick_1ms events).
  logic [9:0] ms_cnt;

  // TODO: sec counter 0..59 (counts sec_pulse events).
  logic [5:0] sec_cnt;

  // TODO: min counter 0..59 (counts min_pulse events).
  logic [5:0] min_cnt;

  // TODO: Use tick_1ms as clock-enable.
  // TODO: Generate sec_pulse on ms_cnt rollover.
  // Why: single-cycle pulse at terminal count (999 -> 0).

  // MAKE SURE YOU ALWAYS FOCUS ON EACH CASE ALONE
  // e.g. here since it is using sec_pulse and ms_cnt, only update those on rst

  always_ff @(posedge clk) begin
    if(!rst_n) begin
      ms_cnt <= '0;
      sec_pulse <= 0;
    end else begin
      if(tick_1ms) begin
        if(ms_cnt == 999) begin
          ms_cnt <= '0;
          sec_pulse <= 1;
        end else begin
          ms_cnt <= ms_cnt + 'd1; // REMEMBER THIS SYNTAX -> just '1 fills all bits with 1 instead of just 1
        end
      end
    end
  end

  // TODO: Generate min_pulse on sec_cnt rollover (driven by sec_pulse).
  // Why: cascade timebase hierarchy.
  always_ff @(posedge clk) begin
    if(!rst_n) begin
      sec_cnt <= '0;
      min_pulse <= 0;
    end else begin
      if(sec_pulse) begin
        if(sec_cnt == 59) begin
          sec_cnt <= '0;
          min_pulse <= 1;
        end else begin
          sec_cnt <= sec_cnt + 'd1;
        end
      end
    end
  end

  // TODO: Generate hour_pulse on min_cnt rollover (driven by min_pulse).
  always_ff @(posedge clk) begin
    if(!rst_n) begin
      min_cnt <= '0;
      hour_pulse <= 0;
    end else begin
      if(min_pulse) begin
        if(min_cnt == 59) begin
          min_cnt <= '0;
          hour_pulse <= 1;
        end else begin
          min_cnt <= min_cnt + 'd1;
        end
      end
    end
  end

endmodule