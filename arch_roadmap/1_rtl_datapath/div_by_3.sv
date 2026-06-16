// ============================================================
// ID: rtl7 — Divisible-by-3 FSM (serial bits)
// ============================================================
// Goal: track remainder mod 3 (0/1/2) as bits stream in; div_by_3 when rem==0. 

module div_by_3 (
  input  logic clk,
  input  logic rst_n,
  input  logic bit_in,
  output logic div_by_3
);

  // TODO: Choose bit-append convention and document.
  // Why: transitions depend on whether bit_in is appended as LSB or MSB.

  // TODO: Define 3 FSM states = remainder {0,1,2}.
  typedef enum logic [1:0] {REM0, REM1, REM2} state_t;
  
  // for appending bits (LSB first - 101 -> 1011):
    // appending a zero just doubles number -> N = 2N
    // appending a one -> N = 2N + 1
    // generally -> N = 2N + bit
    // also works for mod 3 (proof in back of notebook)
    // CAN GENERALLY USE RULE FOR INTERVIEWS fir div by M
    // new_rem = (2*rem + bit) mod M

  state_t current_state, next_state;
  // TODO: State register (always_ff) with reset to REM0.
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      current_state <= REM0;
    end else begin
      current_state <= next_state;
    end
  end

  // TODO: Next-state logic derived from modulo update.
  always_comb begin
    case(current_state)
      // 0 + 1 = 1
      // 0 + 0 = 0
      REM0: begin
        if(bit_in)
          next_state = REM1;
        else
          next_state = REM0;
      end
      // 2 + 1 = 0
      // 2 + 0 = 2
      REM1: begin
        if(bit_in)
          next_state = REM0;
        else
          next_state = REM2;
      end
      // 4 + 1 = 2
      // 4 + 0 = 1
      REM2: begin
        if(bit_in) begin
          next_state = REM2;
        end
        else
          next_state = REM1;
      end
      default: next_state = REM0;
    endcase
  end

  // TODO: Output logic.
  assign div_by_3 = (current_state == REM0);

// cleaner version:
// FSM: 3 states = remainder mod 3 (MSB-first serial input)
/*
module div_by_3 (
  input  logic clk,
  input  logic rst_n,
  input  logic bit_in,
  output logic div_by_3
);
  // States: R0 (rem=0), R1 (rem=1), R2 (rem=2)
  // Transition: new_rem = (2*rem + bit_in) mod 3
  typedef enum logic [1:0] {
    R0,   // remainder 0
    R1,   // remainder 1
    R2    // remainder 2
  } state_t;

  state_t state;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= R0;
    else case (state)
      R0: state <= bit_in ? R1 : R0;
      R1: state <= bit_in ? R0 : R2;
      R2: state <= bit_in ? R2 : R1;
    endcase
  end

  assign div_by_3 = (state == R0);
endmodule
*/
endmodule