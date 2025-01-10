const TokenKind = @import("token_kind.zig").TokenKind;
const testing = @import("std").testing;
const expect = testing.expect;
const expectEqualStrings = testing.expectEqualStrings;

pub const Token = struct {
    kind: TokenKind,
    start: usize,
    end: usize,
    line: usize,
    column: usize,
    value: []const u8,
    prev: ?*Token,
    next: ?*Token,

    pub fn init(
        kind: TokenKind,
        start: usize,
        end: usize,
        line: usize,
        column: usize,
        value: []const u8,
    ) Token {
        return Token{
            .kind = kind,
            .start = start,
            .end = end,
            .line = line,
            .column = column,
            .value = value,
            .prev = null,
            .next = null,
        };
    }
};

test "Token" {
    const token = Token.init(
        TokenKind.NAME,
        0,
        4,
        1,
        1,
        "Name",
    );
    try expect(token.kind == TokenKind.NAME);
    try expect(token.start == 0);
    try expect(token.end == 4);
    try expect(token.line == 1);
    try expect(token.column == 1);
    try expectEqualStrings("Name", token.value);
    try expect(token.prev == null);
    try expect(token.next == null);
}
