const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .wasm32,
        .os_tag = .freestanding,
    });

    const hello = b.addExecutable(.{
        .name = "hello",
        .root_source_file = b.path("hello.zig"),
        .strip = true,
        .target = target,
        .optimize = .ReleaseSmall,
    });

    const typ = b.dependency("typ", .{}).module("typ");

    hello.root_module.addImport("typ", typ);
    hello.entry = .disabled;
    hello.rdynamic = true;

    b.installArtifact(hello);
}
