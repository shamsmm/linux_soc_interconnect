module ibus_interconnect(
    master_bus_if.ic ibus_if_core0,
    slave_bus_if.ic ibus_if_mem0,
    slave_bus_if.ic ibus_if_rom0
);
    always_comb begin
        // default bus values
        ibus_if_core0.rdata = 32'b0;
        ibus_if_core0.berror = 1'b0;
        ibus_if_core0.bdone = 1'b0;
        ibus_if_core0.bgnt = ibus_if_core0.breq; // always grant (no contention)

        ibus_if_mem0.ss = 1'b0;
        ibus_if_rom0.ss = 1'b0;

        // connect to bus
        ibus_if_mem0.wdata = ibus_if_core0.wdata;
        ibus_if_mem0.addr = ibus_if_core0.addr;
        ibus_if_mem0.tsize = ibus_if_core0.tsize;
        ibus_if_mem0.bstart = ibus_if_core0.bstart;
        ibus_if_mem0.ttype = READ;

        // connect to bus
        ibus_if_rom0.wdata = 32'b0;
        ibus_if_rom0.addr = ibus_if_core0.addr;
        ibus_if_rom0.tsize = WORD;
        ibus_if_rom0.bstart = ibus_if_core0.bstart;
        ibus_if_rom0.ttype = READ;

        // poor man's multiplexor
        case(ibus_if_core0.addr[31:28])
            4'h2: begin
                ibus_if_core0.bdone = ibus_if_rom0.bdone;
                ibus_if_core0.rdata = ibus_if_rom0.rdata;
                ibus_if_rom0.ss = 1'b1;
            end
            4'hF: begin
                ibus_if_core0.bdone = ibus_if_mem0.bdone;
                ibus_if_core0.rdata = ibus_if_mem0.rdata;
                ibus_if_mem0.ss = 1'b1;
            end
            // crossbar
        endcase
    end
endmodule