const std = @import("std");

pub fn build(b: *std.Build) void {
    const run_step = b.step("run", "run sqlite shell");

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const src = b.dependency("sqlite3", .{});

    const lib = b.addLibrary(.{
        .name = "sqlite3",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    lib.root_module.addCSourceFile(.{
        .file = src.path("sqlite3.c"),
    });
    lib.installHeader(src.path("sqlite3.h"), "sqlite3.h");
    lib.installHeader(src.path("sqlite3ext.h"), "sqlite3ext.h");
    b.installArtifact(lib);

    const shell = b.addExecutable(.{
        .name = "shell",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    shell.root_module.addCSourceFile(.{
        .file = src.path("shell.c"),
    });
    shell.root_module.linkLibrary(lib);
    const shell_install = b.addInstallArtifact(shell, .{
        .dest_sub_path = "sqlite3",
    });
    b.getInstallStep().dependOn(&shell_install.step);

    const shell_run = b.addRunArtifact(shell);
    if (b.args) |args| {
        shell_run.addArgs(args);
    }
    run_step.dependOn(&shell_run.step);
}
