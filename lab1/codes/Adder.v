module Adder
(
    data1_i,
    data2_i,
    data_o
);

// Ports
input   signed[31:0]      data1_i;
input   signed[31:0]      data2_i;
output  signed[31:0]      data_o;

assign data_o = data1_i + data2_i;

endmodule