const std = @import("std");

pub fn main() !void {
    // send a GET request to the specified URL
    const url = "https://www.google.com";
    const uri = try std.Uri.parse(url);
    var client = std.http.Client{ .allocator = std.heap.page_allocator };
    defer client.deinit();

    var buf: [4096]u8 = undefined;

    var req = try client.open(.GET, uri, .{ .server_header_buffer = &buf });
    defer req.deinit();

    try req.send();
    try req.wait();

    // var respBody: [65536]u8 = undefined;
    // const written = try req.readAll(&respBody);
    var buffer = std.ArrayList(u8).init(std.heap.page_allocator);
    defer buffer.deinit();

    var chunk: [4096]u8 = undefined;
    while (true) {
        const n = try req.read(&chunk);
        if (n == 0) {
            break;
        }
        try buffer.appendSlice(&chunk);
    }

    std.debug.print("status: {d}\n", .{req.response.status});
    var it = req.response.iterateHeaders();
    while (it.next()) |header| {
        std.debug.print("header: {s}:{s}\n", .{ header.name, header.value });
    }
    const s = try buffer.toOwnedSlice();
    std.debug.print("body: {s}\n", .{s});
}
