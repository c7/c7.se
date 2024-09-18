const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .wasm32,
        .os_tag = .freestanding,
    });

    const exe = b.addExecutable(.{
        .name = "hello",
        .root_source_file = b.path("hello.zig"),
        .strip = true,
        .target = target,
        .optimize = .ReleaseSmall,
    });

    const typ = b.dependency("typ", .{}).module("typ");

    exe.root_module.addImport("typ", typ);
    exe.entry = .disabled;
    exe.rdynamic = true;

    b.installArtifact(exe);
}
