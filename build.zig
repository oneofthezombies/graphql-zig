const std = @import("std");

pub fn build(b: *std.Build) void {
    const zigraphql = b.addStaticLibrary(.{
        .name = "zigraphql",
        .root_source_file = b.path("src/zigraphql.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    b.installArtifact(zigraphql);
}
