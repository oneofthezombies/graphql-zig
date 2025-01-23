const std = @import("std");
const Allocator = std.mem.Allocator;

const SourceText = @import("source_text.zig").SourceText;
const Token = @import("ast.zig").Token;
const TokenKind = @import("token_kind.zig").TokenKind;

const Lexer = struct {
    allocator: *Allocator,
    source_text: SourceText,
    last_token: ?*Token,
    token: *Token,
    line: usize,
    line_start_position: usize,

    pub fn init(allocator: *Allocator, unchecked_utf8: []const u8) !Lexer {
        const token = try allocator.create(Token);
        token.* = .{
            .kind = TokenKind.SOF,
            .start = 0,
            .end = 0,
            .line = 0,
            .column = 0,
            .value = null,
        };

        return .{
            .allocator = allocator,
            .source_text = SourceText.init(unchecked_utf8),
            .last_token = null,
            .token = token,
            .line = 1,
            .line_start_position = 0,
        };
    }

    pub fn deinit(self: *Lexer) void {
        if (self.last_token) |last_token| {
            self.allocator.destroy(last_token);
            self.last_token = null;
        }
        self.allocator.destroy(self.token);
        self.token = null;
    }
};
