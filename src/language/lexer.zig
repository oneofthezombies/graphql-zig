const std = @import("std");
const Allocator = std.mem.Allocator;
const utf8Decode = std.unicode.utf8Decode;
const utf8ByteSequenceLength = std.unicode.utf8ByteSequenceLength;
const utf8CodepointSequenceLength = std.unicode.utf8CodepointSequenceLength;

const Source = @import("source.zig").Source;
const Token = @import("ast.zig").Token;
const TokenKind = @import("token_kind.zig").TokenKind;

pub const Lexer = struct {
    allocator: *Allocator,
    source: *Source,
    last_token: ?*Token = null,
    token: ?*Token = null,
    line: usize,
    line_start: usize,

    pub fn init(allocator: *Allocator, source: *Source) Lexer {
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
            .source = source,
            .token = start_of_file_token,
            .line = 1,
            .line_start = 0,
        };
    }

    pub fn deinit(self: *Lexer) void {
        if (self.last_token) |last_token| {
            self.allocator.destroy(last_token);
            self.last_token = null;
        }
        if (self.token) |token| {
            self.allocator.destroy(token);
            self.token = null;
        }
    }

    pub fn advance(self: *Lexer) !*Token {
        self.last_token = self.token;
        self.token = try self.lookahead();
        return self.token;
    }

    pub fn lookahead(self: *Lexer) !*Token {
        var token = self.token;
        if (token.kind != TokenKind.EOF) {
            while (true) {
                if (token.next) |next| {
                    token = next;
                } else {
                    // TODO
                    // const next_token = try self.readNextToken(token.end);
                }
                if (token.kind != TokenKind.COMMENT) {
                    break;
                }
            }
        }
        return token;
    }

    fn readNextToken(self: *Lexer, start: usize) !*Token {
        const body = self.source.body;
        var position = start;
        while (position < body.len) {
            const byte_seq_len = try utf8ByteSequenceLength(body[position]);
            const codepoint = try utf8Decode(body[position .. position + byte_seq_len]);
            switch (codepoint) {
                // Ignored ::
                //   - UnicodeBOM
                //   - WhiteSpace
                //   - LineTerminator
                //   - Comment
                //   - Comma
                //
                // UnicodeBOM :: "Byte Order Mark (U+FEFF)"
                //
                // WhiteSpace ::
                //   - "Horizontal Tab (U+0009)"
                //   - "Space (U+0020)"
                //
                // Comma :: ,
                0xFEFF, // <BOM>
                0x09, // \t
                0x20, // <space>
                0x2C, // ,
                => {
                    position += utf8CodepointSequenceLength(codepoint);
                    continue;
                },
                // LineTerminator ::
                //   - "New Line (U+000A)"
                //   - "Carriage Return (U+000D)" [lookahead != "New Line (U+000A)"]
                //   - "Carriage Return (U+000D)" "New Line (U+000A)"
                0x0A, // \n
                => {
                    position += utf8CodepointSequenceLength(codepoint);
                    self.line += 1;
                    self.line_start = position;
                    continue;
                },
                0x0D, // \r
                => {
                    position += utf8CodepointSequenceLength(codepoint);
                    if (position < body.len) {
                        const next_codepoint = try utf8Decode(body[position..]);
                        if (next_codepoint == 0x0A) {
                            position += utf8CodepointSequenceLength(next_codepoint);
                        }
                    }
                    self.line += 1;
                    self.line_start = position;
                    continue;
                },
                // Comment
                0x23, // #
                => return try self.readComment(position),
            }
        }
    }

    fn readComment(self: *Lexer, start: usize) !*Token {
        const body = self.source.body;
        var position = start + 1;
        while (position < body.len) {
            const codepoint = try utf8Decode(body[position..]);
        }
    }
};
