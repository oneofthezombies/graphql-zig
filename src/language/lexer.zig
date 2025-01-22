const std = @import("std");
const Allocator = std.mem.Allocator;

const SourceText = @import("source_text.zig").SourceText;
const Token = @import("ast.zig").Token;
const TokenKind = @import("token_kind.zig").TokenKind;

const Lexer = struct {
    allocator: *Allocator,
    source_text: SourceText,
    last_token: ?*Token = null,
    token: *Token,
    line: usize,
    line_start: usize,

    fn init(allocator: *Allocator, unchecked_utf8: []const u8) Lexer {
        const start_of_file_token = try allocator.create(Token);
        start_of_file_token.* = .{
            .kind = TokenKind.SOF,
            .start = 0,
            .end = 0,
            .line = 0,
            .column = 0,
            .value = null,
        };
        return .{
            .source_text = SourceText.init(unchecked_utf8),
            .token = start_of_file_token,
            .line = 1,
            .line_start = 0,
        };
    }

    fn deinit(self: *Lexer) void {
        if (self.last_token) |last_token| {
            self.allocator.destroy(last_token);
            self.last_token = null;
        }
        if (self.token) |token| {
            self.allocator.destroy(token);
            self.token = null;
        }
    }
};
