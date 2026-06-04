module overflow_detect #(
  parameter W = 32
)(
  input  logic [W-1:0] a,
  input  logic [W-1:0] b,
  input  logic [W-1:0] result,
  input  logic         is_sub,
  output logic         overflow,
  output logic         carry
);
  logic [W:0] ext;
  always_comb begin    
    ext = is_sub ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b});
    carry = ext[W];
    overflow = is_sub
      ? (a[W-1] != b[W-1]) && (result[W-1] != a[W-1])
      : (a[W-1] == b[W-1]) && (result[W-1] != a[W-1]);
  end
endmodule