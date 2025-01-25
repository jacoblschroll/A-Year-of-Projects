module ROM(address, data);
    input [1:0] address; // 2-bit address (can range from 0 to 3)
    output [7:0] data;

    reg [7:0] store [0:3]; // Declare a 4-element array of 8-bit registers

    // Initialize the store array
    initial begin
        store[0] = 8'h10;
        store[1] = 8'h30;
        store[2] = 8'h40;
        store[3] = 8'h40;
    end

    // Assign data from the store array
    assign data = store[address];
endmodule