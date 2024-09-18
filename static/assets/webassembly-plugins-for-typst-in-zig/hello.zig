const typ = @import("typ");

export fn hello() i32 {
    const msg = "*Hello* from `hello.wasm` written in Zig!";

    return typ.str(msg);
}

export fn echo(n: usize) i32 {
    const data = typ.alloc(u8, n) catch
        return typ.err("alloc failed");
    defer typ.free(data);

    typ.write(data.ptr);

    return typ.ok(data);
}
