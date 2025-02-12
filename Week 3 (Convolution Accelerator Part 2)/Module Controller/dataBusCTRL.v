module dataController #(parameter memWidth = 16;) (clk, rst, memIn, toBus, fromBus);
    input clk, rst;
    input [mem - 1:0] memIn;

    input [17:0] fromBus;

    // Acts as a boolean denoting scope A/B
    reg workingScope;

    reg [71:0] scopeA;
    reg [71:0] scopeB;

    reg [17:0] storedResult;

    output reg [71:0] toBus;

    always @ (posedge clk) begin
        if (rst) begin
            scopeA <= 72'b0;
            scopeB <= 72'b0;
            storedResult <= 18'b0;
        end else if (workingScope) begin
            scopeA <= {memIn, scopeA[71:memWidth]};
            toBus <= scopeB;
        end else begin
            scopeB <= {memIn, scopeB[71:memWidth]};
            toBus <= scopeA;
        end
    end
endmodule