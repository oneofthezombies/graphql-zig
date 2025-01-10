const std = @import("std");
const assert = std.debug.assert;
const source = @import("source.zig");
const Source = source.Source;
const SourceTag = source.SourceTag;
const Lexer = @import("lexer.zig").Lexer;

pub const ParseOptions = struct {
    no_location: ?bool = null,
    max_tokens: ?usize = null,
};

pub fn parse(sourceTag: SourceTag, options: ParseOptions) !void {
    std.debug.print("", sourceTag, options);
}

pub const Parser = struct {
    options: ParseOptions,
    lexer: *Lexer,
    token_count: usize,

    pub fn init(allocator: *std.mem.Allocator, sourceTag: *SourceTag, options: ParseOptions) !Parser {
        const sourceObj = switch (sourceTag.*) {
            .Source => sourceTag.source,
            .String => try allocator.create(Source).init(sourceTag.string),
            else => return error.OutOfRange,
        };
        const lexer = try allocator.create(Lexer).init(sourceObj);
        return Parser{
            .options = options,
            .lexer = lexer,
            .token_count = 0,
        };
    }

    pub fn deinit(self: *Parser) void {
        self.lexer.deinit();
    }
};

test "parse" {
    var allocator = std.heap.page_allocator;
    var sourceObj = Source.init("query { hello }", .{});
    var sourceTag = SourceTag{ .source = &sourceObj };
    const parser = try Parser.init(&allocator, &sourceTag, .{});
    defer parser.deinit();

    try parse(sourceTag, ParseOptions{});
}
