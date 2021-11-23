module Adder
(
    data1_in, 
    data2_in,
    data_o
);

// Ports
input   signed[31:0]      data1_in;
input   signed[31:0]      data2_in;
output  signed[31:0]      data_o;

assign data_o = data1_in + data2_in;

endmodule