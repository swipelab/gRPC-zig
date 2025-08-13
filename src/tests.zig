const std = @import("std");
const testing = std.testing;
const proto = @import("proto/service.zig");
const spice = @import("spice");
const benchmark = @import("benchmark.zig");

test "HelloRequest encode/decode" {
    const request = proto.HelloRequest{ .name = "test" };
    var buf: [1024]u8 = undefined;
    var writer = spice.ProtoWriter.init(&buf);
    try request.encode(&writer);

    var reader = spice.ProtoReader.init(buf[0..writer.pos]);
    const decoded = try proto.HelloRequest.decode(&reader);
    try testing.expectEqualStrings("test", decoded.name);
}

test "HelloResponse encode/decode" {
    const response = proto.HelloResponse{ .message = "Hello, test!" };
    var buf: [1024]u8 = undefined;
    var writer = spice.ProtoWriter.init(&buf);
    try response.encode(&writer);

    var reader = spice.ProtoReader.init(buf[0..writer.pos]);
    const decoded = try proto.HelloResponse.decode(&reader);
    try testing.expectEqualStrings("Hello, test!", decoded.message);
}

test "benchmark handler" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const request = "test_request";
    const response = try benchmark.benchmarkHandler(request, allocator);
    defer allocator.free(response);

    // Verify response contains the request
    try testing.expect(std.mem.indexOf(u8, response, request) != null);
    // Verify response contains timestamp
    try testing.expect(std.mem.indexOf(u8, response, "processed at") != null);
}