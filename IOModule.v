`timescale 1ns / 1ps

module IO_Module#(DataSize = 8, RegisterDataAddress = 'd60000, DirectionAddress = 'd60001, PullupAddress = 'd60002)(
    input [(DataSize * 2) - 1: 0] Addr,
    input r_w,
    input write,
    inout [DataSize - 1 : 0] Data,
    inout [DataSize - 1: 0] PORT
    );
    
    reg [DataSize - 1 : 0] RegisterData = 'h0;
    reg [DataSize - 1 : 0] Direction = 'h0;
    reg [DataSize - 1 : 0] Pullup = 'h0;
    
    wire RegisterDataCE;
    assign RegisterDataCE = Addr == RegisterDataAddress;
    wire DirectonCE;
    assign DirectionCE = Addr == DirectionAddress;   
    wire PullupCE;
    assign PullupCE = Addr == PullupAddress;   
   
    reg [DataSize - 1 : 0] SystemDataPORT;
   
    assign Data = (RegisterDataCE | DirectionCE | PullupCE) ? (r_w ? 'hz : SystemDataPORT) : 'hz;
    
    always@(1)begin

    case(Addr)
        RegisterDataAddress: SystemDataPORT <= PORT;
        DirectionAddress: SystemDataPORT <= Direction;
        PullupAddress: SystemDataPORT <= Pullup;
        default: SystemDataPORT <= 'h0;
    endcase
    end
    
    always@(posedge write) begin
        if(RegisterDataCE)
            RegisterData <= Data;
        if(DirectionCE)
            Direction <= Data;
        if(PullupCE)
            Pullup <= Data;
            
    end
   
   wire [DataSize - 1 : 0] PullupInterface;
   
   genvar i;
   generate
        for(i = 0; i < DataSize; i = i + 1)begin
            assign PORT[i] = Direction[i] ? RegisterData[i] : 'hz;
            assign PullupInterface[i] = Pullup[i] ? PORT[i] : 'hz;
            PULLDOWN pulldown_inst(PullupInterface[i]);
        end
        
   endgenerate
   
   
   
    
   
endmodule
