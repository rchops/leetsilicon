// ============================================================
// ID: rtl3 — Sequence Detector FSM (10110)
// ============================================================
// Goal: FSM asserts 1-cycle match when serial pattern 10110 completes. 

module seq_det_10110 (
  input  logic clk,
  input  logic rst_n,
  input  logic bit_in,
  output logic match_pulse
);

  // TODO: Define states for partial matches.
  // Why: each state encodes "how many prefix bits matched so far".
  // Example: IDLE, GOT1, GOT10, GOT101, GOT1011.
  typedef enum logic [2:0] {
    IDLE = 3'b000,
    GOT1 = 3'b001,
    GOT10 = 3'b010,
    GOT101 = 3'b011,
    GOT1011 = 3'b100
  } state_t;

  // create reg for storing current state and next state
  state_t current_state, next_state;
  // fsm:
  // if reset -> next_state = IDLE
  // if first bit = 1 -> next_state = GOT1

  // TODO: Implement state register (always_ff).
  // Why: FSM must be synchronous.
  always_ff @(posedge clk) begin
    if(!rst_n) begin
      current_state <= IDLE;
    end
    else begin
      current_state <= next_state;
    end
  end

  // TODO: Implement next-state logic (always_comb).
  // Why: transitions depend on bit_in and overlap policy.
  always_comb begin
    case (current_state)
      IDLE: begin
        if(bit_in)
          next_state = GOT1;
        else
          next_state = IDLE;
      end
      GOT1: begin
        if(!bit_in)
          next_state = GOT10;
        else
          next_state = GOT1;
      end
      GOT10: begin
        if(bit_in)
          next_state = GOT101;
        else
          next_state = GOT1;
      end
      GOT101: begin
        if(bit_in)
          next_state = GOT1011;
        else
          next_state = GOT1;
      end
      GOT1011: begin
        if(!bit_in) begin
          next_state = IDLE;
        end
        else begin
          next_state = GOT1;
        end
      end
      default: next_state = IDLE;
    endcase
  end

  assign match_pulse = ((current_state == GOT1011) && (!bit_in));

  // TODO: Define overlap behavior.
  // Why: on mismatch you may go to a non-IDLE state if suffix is a prefix.

  // TODO: Generate match_pulse.
  // Why: usually asserted on the cycle the last bit '0' is accepted.

endmodule