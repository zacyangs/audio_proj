module dsd_tx#(
    parameter DW = 16
)(
    input   rst,
    input   bclk,

    input           valid_i,
    input [DW-1:0]  ldata_i,
    input [DW-1:0]  rdata_i,

    output          dclk,
    output          ldata,
    output          rdata
);

reg [8:0] bcnt = 0;
reg [1:0] dcnt = 0;
reg [DW-1:0] ldata_q;
reg [DW-1:0] rdata_q;

wire dclk_i;
reg     valid_sync; 

assign dclk_i = dcnt[1];
assign dclk = ~dclk_i;

synchronizer_puls u_synchronizer_puls(
    .sclk      (bclk),
    .srstn     (~rst),
    .puls_in   (valid_i),

    .dclk      (dclk_i),
    .drstn     (~rst),
    .puls_out  (valid_sync)
);

always@(posedge bclk or posedge rst)
begin
    if(rst) begin
        dcnt <= 0;
    end
    else begin
        dcnt <= dcnt + 1;
    end
end


always@(posedge dclk_i or posedge rst)
begin
    if(rst)
        bcnt <= 0;
    else if(valid_sync)
        bcnt <= 0;
    else begin
        if(bcnt == DW-1)
            bcnt <= 0;
        else
            bcnt <= bcnt + 1;
    end

    if(valid_sync) begin
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
