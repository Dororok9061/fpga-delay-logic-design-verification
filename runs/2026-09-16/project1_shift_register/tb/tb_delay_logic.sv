`timescale 1ns/1ps

module tb_delay_logic;

    localparam int DATA_WIDTH = 16;
    localparam int DEPTH      = 10;
    localparam time CLK_PERIOD = 10ns;

    logic                  iClk;
    logic                  iRsn;
    logic                  iDataEn;
    logic [DATA_WIDTH-1:0] iData;
    logic [2:0]            iDelay;
    logic                  oDataEn;
    logic [DATA_WIDTH-1:0] oData;

    delay_logic #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .iClk(iClk),
        .iRsn(iRsn),
        .iDataEn(iDataEn),
        .iData(iData),
        .iDelay(iDelay),
        .oDataEn(oDataEn),
        .oData(oData)
    );

    initial iClk = 1'b0;
    always #(CLK_PERIOD/2) iClk = ~iClk;

    task automatic drive_cycle(
        input logic                  en,
        input logic [DATA_WIDTH-1:0] data,
        input logic [2:0]            delay_value
    );
        begin
            @(negedge iClk);
            iDataEn = en;
            iData   = data;
            iDelay  = delay_value;
        end
    endtask


    // Independent cycle-history checker, added for reproducible validation.
    // Tap N selects the Nth most recent sampled input, including this edge.
    logic [DATA_WIDTH-1:0] ref_data [0:DEPTH-1];
    logic [DEPTH-1:0] ref_valid = '0;
    logic [DATA_WIDTH-1:0] expected_data;
    logic expected_valid;
    logic test_done = 0;
    integer checked_cycles = 0;
    integer error_count = 0;
    integer k;
    always @(posedge iClk) begin
        if (!iRsn) begin
            ref_valid = '0;
            for (k=0; k<DEPTH; k=k+1) ref_data[k] = '0;
        end else begin
            for (k=DEPTH-1; k>0; k=k-1) begin
                ref_data[k] = ref_data[k-1];
                ref_valid[k] = ref_valid[k-1];
            end
            ref_data[0] = iDataEn ? iData : '0;
            ref_valid[0] = iDataEn;
        end
        #1;
        expected_valid = 0;
        expected_data = 0;
        if (iRsn && iDelay >= 1 && iDelay <= DEPTH) begin
            expected_valid = ref_valid[iDelay-1];
            expected_data = expected_valid ? ref_data[iDelay-1] : '0;
        end
        checked_cycles = checked_cycles + 1;
        if ({oDataEn,oData} !== {expected_valid,expected_data}) begin
            error_count = error_count + 1;
            $fatal(1,"[FAIL] t=%0t expected=%h/%b actual=%h/%b",
                   $time,expected_data,expected_valid,oData,oDataEn);
        end
    end

    initial begin
        iRsn    = 1'b0;
        iDataEn = 1'b0;
        iData   = '0;
        iDelay  = 3'd3;

        // Scenario 1: reset asserted and then released
        repeat (3) @(negedge iClk);
        iRsn = 1'b1;
        drive_cycle(1'b0, 16'h0000, 3'd3);
        drive_cycle(1'b0, 16'h0000, 3'd3);

        // Scenario 2: continuous Enable input, fixed iDelay=3
        drive_cycle(1'b1, 16'h1001, 3'd3);
        drive_cycle(1'b1, 16'h1002, 3'd3);
        drive_cycle(1'b1, 16'h1003, 3'd3);
        drive_cycle(1'b1, 16'h1004, 3'd3);
        drive_cycle(1'b1, 16'h1005, 3'd3);
        drive_cycle(1'b1, 16'h1006, 3'd3);
        drive_cycle(1'b0, 16'h0000, 3'd3);
        drive_cycle(1'b0, 16'h0000, 3'd3);
        drive_cycle(1'b0, 16'h0000, 3'd3);
        drive_cycle(1'b0, 16'h0000, 3'd3);

        // Scenario 3: change the delay value during operation (optional scenario)
        drive_cycle(1'b1, 16'h2001, 3'd2);
        drive_cycle(1'b1, 16'h2002, 3'd2);
        drive_cycle(1'b1, 16'h2003, 3'd2);
        drive_cycle(1'b1, 16'h2004, 3'd2);
        drive_cycle(1'b1, 16'h3001, 3'd5);
        drive_cycle(1'b1, 16'h3002, 3'd5);
        drive_cycle(1'b1, 16'h3003, 3'd5);
        drive_cycle(1'b1, 16'h3004, 3'd5);
        drive_cycle(1'b0, 16'h0000, 3'd5);
        drive_cycle(1'b0, 16'h0000, 3'd5);
        drive_cycle(1'b0, 16'h0000, 3'd5);
        drive_cycle(1'b0, 16'h0000, 3'd5);
        drive_cycle(1'b0, 16'h0000, 3'd5);
        drive_cycle(1'b0, 16'h0000, 3'd5);

        #20;
        test_done = 1;
        $display("[TEST PASS] project1_shift_register: checked_cycles=%0d errors=%0d", checked_cycles, error_count);
        $finish;
    end

endmodule
