const expect = @import("std").testing.expect;
const expectEqualStrings = @import("std").testing.expectEqualStrings;

const TokenKind = @import("token_kind.zig").TokenKind;

pub const Token = struct {
    kind: TokenKind,
    start: usize,
    end: usize,
    line: usize,
    column: usize,
    value: ?[]const u8,
    prev: ?*Token = null,
    next: ?*Token = null,
};

test "Token" {
    const token: Token = .{
        .name = TokenKind.NAME,
        .start = 0,
        .end = 4,
        .line = 1,
        .column = 1,
        .value = "Name",
    };
    try expect(token.kind == TokenKind.NAME);
    try expect(token.start == 0);
    try expect(token.end == 4);
    try expect(token.line == 1);
    try expect(token.column == 1);
    try expectEqualStrings("Name", token.value);
    try expect(token.prev == null);
    try expect(token.next == null);
}
