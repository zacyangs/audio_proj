module dop_to_dsd#(
    parameter DW = 16
)(
    input rst,
    input bclk,
    input lrck,
    input data,

    output dclk,
    output ldata,
    output rdata
);

wire            valid;
wire [DW-1:0]   ldata_p;
wire [DW-1:0]   rdata_p;


dsd_tx#( .DW (DW)) u_dsd_tx (
    .rst    (rst),
    .bclk   (bclk),

    .valid_i(valid),
    .ldata_i(ldata_p),
    .rdata_i(rdata_p),

    .dclk   (dclk),
    .ldata  (ldata),
    .rdata  (rdata)
);

i2s_rx#( .DW (DW + 8), .TYPE ("I2S")) u_i2s_rx (
    .rst   (rst),
    .lrck  (lrck),
    .bclk  (bclk),
    .data  (data),

    .valid (valid),
    .l_data(ldata_p),
    .r_data(rdata_p)
);



endmodule
