module dsd_tx#(
    parameter DW = 16
)(
    input   rst,
    input   bclk,

    input           valid_i,
    input [DW-1:0]  ldata_i,
    input [DW-1:0]  rdata_i,

    output          ldata,
    output          rdata
);

reg [8:0] bcnt;
reg [DW-1:0] ldata_q;
reg [DW-1:0] rdata_q;


always@(posedge bclk or posedge rst)
begin
    if(rst)
        bcnt <= 0;
    else if(valid_i)
        bcnt <= 0;
    else begin
        if(bcnt == DW-1)
            bcnt <= 0;
        else
            bcnt <= bcnt + 1;
    end

    if(valid_i) begin
        ldata_q <= ldata_i;
        rdata_q <= rdata_i;
    end
    else begin
        ldata_q <= ldata_q << 1;
        rdata_q <= rdata_q << 1;
    end
end

assign ldata = ldata_q[DW-1];
assign rdata = rdata_q[DW-1];


endmodule
