`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2026 17:19:46
// Design Name: 
// Module Name: tb_divider_4bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




module tb_divider_4bit;

    reg  [3:0] A;
    reg  [3:0] B;

    wire [3:0] Quotient;
    wire [3:0] Remainder;
    wire       DivideByZero;

    integer i, j;
    integer errors;

    reg [3:0] expected_quotient;
    reg [3:0] expected_remainder;

    divider_4bit DUT (
        .A(A),
        .B(B),
        .Quotient(Quotient),
        .Remainder(Remainder),
        .DivideByZero(DivideByZero)
    );

    initial begin
        errors = 0;
        A = 0;
        B = 0;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin

                A = i;
                B = j;

                if (j == 0) begin
                    expected_quotient  = 0;
                    expected_remainder = 0;
                end
                else begin
                    expected_quotient  = i / j;
                    expected_remainder = i % j;
                end

                #10;

                if (j == 0) begin
                    if (DivideByZero !== 1'b1 ||
                        Quotient !== 4'b0000 ||
                        Remainder !== 4'b0000) begin

                        $display(
                            "FAIL: A=%0d B=%0d | DivideByZero=%b Q=%0d R=%0d",
                            A, B, DivideByZero, Quotient, Remainder
                        );
                        errors = errors + 1;
                    end
                end
                else begin
                    if (DivideByZero !== 1'b0 ||
                        Quotient !== expected_quotient ||
                        Remainder !== expected_remainder) begin

                        $display(
                            "FAIL: A=%0d B=%0d | Q=%0d R=%0d | Expected Q=%0d R=%0d",
                            A, B, Quotient, Remainder,
                            expected_quotient, expected_remainder
                        );
                        errors = errors + 1;
                    end
                end

            end
        end

        if (errors == 0)
            $display("PASS: All 256 divider test cases passed!");
        else
            $display("FAIL: %0d test cases failed.", errors);

        $finish;
    end

endmodule
