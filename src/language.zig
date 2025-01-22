const std = @import("std");
const Utf8Iterator = std.unicode.Utf8Iterator;
const Utf16LeIterator = std.unicode.Utf16LeIterator;
const expect = std.testing.expect;

const SourceTextIterator = union(enum) {
    utf8_it: Utf8Iterator,
    utf16le_it: Utf16LeIterator,

    fn initUtf8(text: []const u8) SourceTextIterator {
        return .{
            .utf8_it = Utf8Iterator.init(text),
        };
    }

    fn initUtf16Le(text: []const u16) SourceTextIterator {
        return .{
            .utf16le_it = Utf16LeIterator.init(text),
        };
    }

    fn nextSourceCharacter(self: *SourceTextIterator) !u32 {
        return switch (self) {
            .utf8_it => return self.utf8_it.nextCodepoint(),
            .utf16le_it => return self.utf16le_it.nextCodepoint(),
        };
    }
};

test "SourceTextIterator" {
    const text = "hello, world";
    var it = SourceTextIterator.initUtf8(text);
    var codepoint = try it.nextSourceCharacter();
    expect(codepoint == 'h');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == 'e');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == 'l');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == 'l');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == 'o');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == ',');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == ' ');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == 'w');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == 'o');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == 'r');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == 'l');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == 'd');
    codepoint = try it.nextSourceCharacter();
    expect(codepoint == 0);
}
