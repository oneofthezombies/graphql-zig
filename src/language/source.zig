const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const expect = testing.expect;
const expectEqualStrings = testing.expectEqualStrings;

const Location = struct {
    line: usize,
    column: usize,
};

const Source = struct {
    const Args = struct {
        name: []const u8 = "GraphQL request",
        location_offset: Location = .{
            .line = 1,
            .column = 1,
        },
    };

    body: []const u8,
    name: []const u8,
    location_offset: Location,

    fn init(body: []const u8, args: Args) Source {
        assert(args.location_offset.line > 0);
        assert(args.location_offset.column > 0);
        return Source{
            .body = body,
            .name = args.name,
            .location_offset = args.location_offset,
        };
    }
};

const SourceTag = union(enum) {
    string: []const u8,
    source: *Source,
};

fn isSource(tag: SourceTag) bool {
    switch (tag) {
        .string => return false,
        .source => return true,
    }
}

test "Source.Args default values" {
    const args = Source.Args{};
    try expectEqualStrings("GraphQL request", args.name);
    try expect(args.location_offset.line == 1);
    try expect(args.location_offset.column == 1);
}

test "Source.init empty body" {
    const source = Source.init("", .{});
    try expectEqualStrings("GraphQL request", source.name);
    const args = Source.Args{};
    try expectEqualStrings(args.name, source.name);
    try expect(args.location_offset.line == source.location_offset.line);
    try expect(args.location_offset.column == source.location_offset.column);
}

test "Source.init with body" {
    const source = Source.init("query { hello }", .{});
    try expectEqualStrings("GraphQL request", source.name);
    try expectEqualStrings("query { hello }", source.body);
    const args = Source.Args{};
    try expectEqualStrings(args.name, source.name);
    try expect(args.location_offset.line == source.location_offset.line);
    try expect(args.location_offset.column == source.location_offset.column);
}

test "Source.init with custom args" {
    const args = Source.Args{
        .name = "Custom name",
        .location_offset = Location{
            .line = 2,
            .column = 2,
        },
    };
    const source = Source.init("query { hello }", args);
    try expectEqualStrings("Custom name", source.name);
    try expectEqualStrings("query { hello }", source.body);
    try expect(args.location_offset.line == source.location_offset.line);
    try expect(args.location_offset.column == source.location_offset.column);
}

test "SourceTag.isSource" {
    var source = Source.init("query { hello }", .{});
    const tag = SourceTag{ .source = &source };
    try expect(isSource(tag));
}

test "SourceTag.isSource false" {
    const tag = SourceTag{ .string = "query { hello }" };
    try expect(!isSource(tag));
}
