const std = @import("std");

pub fn main() !void {
    const s = try makeSomething();
    std.debug.print("x: {d}, y: {d}\n", .{ s.x, s.y });
    std.debug.print("x: {d}, y: {d}\n", .{ s.x, s.y });
    std.debug.print("x: {d}, y: {d}\n", .{ s.x, s.y });
    std.debug.print("x: {d}, y: {d}\n", .{ s.x, s.y });
    std.debug.print("{any}", .{s});
}

const Something = struct {
    x: i32,
    y: i32,
};

fn makeSomething() !*Something {
    var s = Something{ .x = 1, .y = 2 };
    return &s;
}
