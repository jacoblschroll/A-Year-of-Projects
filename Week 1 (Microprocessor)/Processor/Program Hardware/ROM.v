module ROM #(parameter N = 2) (address, data);
    input [N-1:0] address;
    output [7:0] data;

    reg [7:0] store [0:(2 ** N) - 1]; // Declare a 2 ^ N-element array of 8-bit registers

    // Initialize the store array
    initial begin
        store[0] = 8'h10;
        store[1] = 8'h30;
        store[2] = 8'h40;
        store[3] = 8'h80;
    end

    // Assign data from the store array
    assign data = store[address];
endmodule