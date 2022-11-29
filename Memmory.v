`timescale 1ns / 1ps

module Memmory#(DataSize = 8, StartingAddress = 0, MemmorySize = 60000, BootFile = "BOOT_ROM.mem")(
    input [(DataSize * 2) - 1: 0] Addr,
    input r_w,
    input write,
    inout [DataSize - 1 : 0] Data
    );
    

    wire CE;
    
    reg [DataSize - 1:0] RAM [StartingAddress + MemmorySize - 1 : StartingAddress];
    initial 
        $readmemh(BootFile, RAM, StartingAddress, (MemmorySize + StartingAddress) - 1);
        
    assign CE = (Addr >= StartingAddress) & (Addr < (StartingAddress + MemmorySize));
    assign Data = CE ? (r_w ? 'hz : RAM[Addr]) : 'hz;
    
    always@(posedge write) begin
        if(CE)
            RAM[Addr] <= Data;
    end
endmodule