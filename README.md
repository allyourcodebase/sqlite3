This build script takes the SQLite source code amalgam and exposes a statically
linked `sqlite3` library and the `sqlite3` shell executable.

To add it to your `build.zig.zon`:

```
zig fetch --save git+https://github.com/allyourcodebase/sqlite3
```

Using it in your build script:

```zig
const sqlite3 = b.dependency("sqlite3", .{
  .target = target,
  .optimize = optimize,
});
const sqlite3_lib = b.artifact("sqlite3");
const sqlite3_exe = b.artifact("shell");
```

[This build script is licensed under the MIT License](./LICENSE).

[SQLite itself is dedicated to the public domain](https://sqlite.org/copyright.html).
