const mem = @import("std").mem;

pub const TokenKind = enum(u8) {
    SOF,
    EOF,
    BANG,
    DOLLAR,
    AMP,
    PAREN_L,
    PAREN_R,
    SPREAD,
    COLON,
    EQUALS,
    AT,
    BRACKET_L,
    BRACKET_R,
    BRACE_L,
    PIPE,
    BRACE_R,
    NAME,
    INT,
    FLOAT,
    STRING,
    BLOCK_STRING,
    COMMENT,

    fn toString(self: TokenKind) []const u8 {
        switch (self) {
            TokenKind.SOF => "<SOF>",
            TokenKind.EOF => "<EOF>",
            TokenKind.BANG => "!",
            TokenKind.DOLLAR => "$",
            TokenKind.AMP => "&",
            TokenKind.PAREN_L => "(",
            TokenKind.PAREN_R => ")",
            TokenKind.SPREAD => "...",
            TokenKind.COLON => ":",
            TokenKind.EQUALS => "=",
            TokenKind.AT => "@",
            TokenKind.BRACKET_L => "[",
            TokenKind.BRACKET_R => "]",
            TokenKind.BRACE_L => "{",
            TokenKind.PIPE => "|",
            TokenKind.BRACE_R => "}",
            TokenKind.NAME => "Name",
            TokenKind.INT => "Int",
            TokenKind.FLOAT => "Float",
            TokenKind.STRING => "String",
            TokenKind.BLOCK_STRING => "BlockString",
            TokenKind.COMMENT => "Comment",
        }
    }

    fn fromString(s: []const u8) ?TokenKind {
        if (mem.eql(u8, s, "<SOF>")) {
            return TokenKind.SOF;
        } else if (mem.eql(u8, s, "<EOF>")) {
            return TokenKind.EOF;
        } else if (mem.eql(u8, s, "!")) {
            return TokenKind.BANG;
        } else if (mem.eql(u8, s, "$")) {
            return TokenKind.DOLLAR;
        } else if (mem.eql(u8, s, "&")) {
            return TokenKind.AMP;
        } else if (mem.eql(u8, s, "(")) {
            return TokenKind.PAREN_L;
        } else if (mem.eql(u8, s, ")")) {
            return TokenKind.PAREN_R;
        } else if (mem.eql(u8, s, "...")) {
            return TokenKind.SPREAD;
        } else if (mem.eql(u8, s, ":")) {
            return TokenKind.COLON;
        } else if (mem.eql(u8, s, "=")) {
            return TokenKind.EQUALS;
        } else if (mem.eql(u8, s, "@")) {
            return TokenKind.AT;
        } else if (mem.eql(u8, s, "[")) {
            return TokenKind.BRACKET_L;
        } else if (mem.eql(u8, s, "]")) {
            return TokenKind.BRACKET_R;
        } else if (mem.eql(u8, s, "{")) {
            return TokenKind.BRACE_L;
        } else if (mem.eql(u8, s, "|")) {
            return TokenKind.PIPE;
        } else if (mem.eql(u8, s, "}")) {
            return TokenKind.BRACE_R;
        } else if (mem.eql(u8, s, "Name")) {
            return TokenKind.NAME;
        } else if (mem.eql(u8, s, "Int")) {
            return TokenKind.INT;
        } else if (mem.eql(u8, s, "Float")) {
            return TokenKind.FLOAT;
        } else if (mem.eql(u8, s, "String")) {
            return TokenKind.STRING;
        } else if (mem.eql(u8, s, "BlockString")) {
            return TokenKind.BLOCK_STRING;
        } else if (mem.eql(u8, s, "Comment")) {
            return TokenKind.COMMENT;
        } else {
            return null;
        }
    }
};
