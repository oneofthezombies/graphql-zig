const Source = @import("source.zig").Source;
const Token = @import("ast.zig").Token;
const TokenKind = @import("token_kind.zig").TokenKind;

pub const Lexer = struct {
    source: *Source,
    last_token: *Token,
    token: *Token,
    line: usize,
    line_start: usize,

    pub fn init(source: *Source) Lexer {
        const start_of_file_token = Token.init(
            TokenKind.SOF,
            0,
            0,
            0,
            0,
            null,
        );
        return Lexer{
            .source = source,
            .last_token = &start_of_file_token,
            .token = &start_of_file_token,
            .line = 1,
            .line_start = 0,
        };
    }
};
