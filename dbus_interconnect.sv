module dbus_interconnect(master_bus_if.ic dbus_if_core0, slave_bus_if.ic dbus_if_mem0);

always_comb begin
    // default bus values
    dbus_if_core0.rdata = 32'b0;
    dbus_if_core0.berror = 1'b0;
    dbus_if_core0.bdone = 1'b0;
    dbus_if_core0.bgnt = dbus_if_core0.breq; // always grant (no contention)

    dbus_if_mem0.ss = 1'b0;
    //dbus_if_sram0.ss = 1'b0;
    //dbus_if_uart0.ss = 1'b0;

    // connect to bus
    dbus_if_mem0.wdata = dbus_if_core0.wdata;
    dbus_if_mem0.addr = dbus_if_core0.addr;
    dbus_if_mem0.tsize = dbus_if_core0.tsize;
    dbus_if_mem0.bstart = dbus_if_core0.bstart;
    dbus_if_mem0.ttype = dbus_if_core0.ttype;

    // poor man's multiplexor
    case(dbus_if_core0.addr[31:28])
        4'hF: begin
            dbus_if_core0.bdone = dbus_if_mem0.bdone;
            dbus_if_core0.rdata = dbus_if_mem0.rdata;
            dbus_if_mem0.ss = 1'b1;
        end
        // other
    endcase
end

endmodule