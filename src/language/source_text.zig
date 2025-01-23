//! GraphQL Language Source Text
//! https://spec.graphql.org/October2021/#sec-Language.Source-Text

const std = @import("std");
const utf8ByteSequenceLength = std.unicode.utf8ByteSequenceLength;
const utf8Decode = std.unicode.utf8Decode;
const expect = std.testing.expect;

const SourceTextError = error{
    // std.unicode.utf8ByteSequenceLength
    Utf8InvalidStartByte,

    // std.unicode.utf8Decode
    Utf8ExpectedContinuation,
    Utf8OverlongEncoding,
    Utf8EncodesSurrogateHalf,
    Utf8CodepointTooLarge,

    Utf8InvalidByteSequenceLength,
    InvalidSourceCharacter,
};

pub const SourceText = struct {
    unchecked_utf8: []const u8,
    pos: usize = 0,

    pub fn init(unchecked_utf8: []const u8) SourceText {
        return SourceText{ .unchecked_utf8 = unchecked_utf8 };
    }

    pub fn nextSourceCharacter(self: *SourceText) SourceTextError!?u32 {
        if (self.pos >= self.unchecked_utf8.len) {
            return null;
        }

        const seq_len = try utf8ByteSequenceLength(self.unchecked_utf8[self.pos]);
        const seq_end_pos = self.pos + seq_len;
        if (seq_end_pos > self.unchecked_utf8.len) {
            return error.Utf8InvalidByteSequenceLength;
        }

        const cp = try utf8Decode(self.unchecked_utf8[self.pos..seq_end_pos]);
        if (!isSourceCharacter(cp)) {
            return error.InvalidSourceCharacter;
        }

        self.pos = seq_end_pos;
        return cp;
    }
};

test "SourceText.nextSourceCharacter" {
    var src_text = SourceText.init("abc가나다");
    try expect(try src_text.nextSourceCharacter() == 'a');
    try expect(try src_text.nextSourceCharacter() == 'b');
    try expect(try src_text.nextSourceCharacter() == 'c');
    try expect(try src_text.nextSourceCharacter() == '가');
    try expect(try src_text.nextSourceCharacter() == '나');
    try expect(try src_text.nextSourceCharacter() == '다');
    try expect(try src_text.nextSourceCharacter() == null);
}

fn isSourceCharacter(codepoint: u32) bool {
    return codepoint == '\u{0009}' // <Character Tabulation> (HT, TAB)
    or codepoint == '\u{000A}' // <End of Line> (EOL, LF, NL)
    or codepoint == '\u{000D}' // <Carriage Return> (CR)
    or ('\u{0020}' <= codepoint and codepoint <= '\u{FFFF}'); // Space (SP) ~ U+FFFF
}

test "isSourceCharacter" {
    try expect(isSourceCharacter('a'));
    try expect(isSourceCharacter(' '));
    try expect(isSourceCharacter('\t'));
    try expect(isSourceCharacter('\n'));
    try expect(isSourceCharacter('\r'));
    try expect(isSourceCharacter('\u{FFFF}'));
    try expect(!isSourceCharacter('\u{10000}'));
}
