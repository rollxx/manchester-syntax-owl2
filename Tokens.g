lexer grammar Tokens;

LENGTH_LABEL
	:	'length'
	;

MIN_LENGTH_LABEL
	:	'minLength'
	;

MAX_LENGTH_LABEL
	:	'maxLength'
	;

PATTERN_LABEL
	:	'pattern'
	;

LANG_PATTERN_LABEL
	:	'langPattern'
	;

THAT_LABEL
	:	'that'
	;
INVERSE_LABEL
	:	'inverse'
	;

MINUS
    : '-'
    ;

DOT
    : '.'
    ;

PLUS
    : '+'
    ;

DIGIT
    : '0'..'9'
    ;

NOT_LABEL
	:	'not'
	;
WS
    : (' '| '\t'| EOL)+ {$channel = HIDDEN;}
    ;

LESS_EQUAL
    : '<='
    ;

GREATER_EQUAL
    : '>='
    ;

LESS
	: '<'
	;

GREATER
	: '>'
	;

OPEN_CURLY_BRACE
	: '{'
	;

CLOSE_CURLY_BRACE
	: '}'
	;

OR_LABEL
	:	'or'
	;

AND_LABEL
	:	'and'
	;

SOME_LABEL
	:	'some'
	;

ONLY_LABEL
	:	'only'
	;

VALUE_LABEL
	:	'value'
	;
	
SELF_LABEL
	:	'Self'
	;

MIN_LABEL
	:	'min'
	;

MAX_LABEL
	:	'max'
	;

EXACTLY_LABEL
	:	'exactly'
	;

COMMA	:	',';

OPEN_BRACE
    : '('
    ;

CLOSE_BRACE
    : ')'
    ;

INTEGER_LABEL
	:	'integer'
	;

DECIMAL_LABEL
	:	'decimal'
	;

FLOAT_LABEL
	:	'float'
	;

STRING_LABEL
	:	'string'
	;

REFERENCE
	: '^^'
	;


fragment
PN_PREFIX
    : (PN_CHARS)*
    ;

fragment
EOL
    : '\n' | '\r'
    ;


fragment
PN_CHARS_BASE
    : 'A'..'Z'
    | 'a'..'z'
    | '\u00C0'..'\u00D6'
    | '\u00D8'..'\u00F6'
    | '\u00F8'..'\u02FF'
    | '\u0370'..'\u037D'
    | '\u037F'..'\u1FFF'
    | '\u200C'..'\u200D'
    | '\u2070'..'\u218F'
    | '\u2C00'..'\u2FEF'
    | '\u3001'..'\uD7FF'
    | '\uF900'..'\uFDCF'
    | '\uFDF0'..'\uFFFD'
    ;

fragment
PN_CHARS_U
    : PN_CHARS_BASE | '_'
    ;

FULL_IRI
    : LESS ( options {greedy=false;} : ~(LESS | GREATER | '"' | OPEN_CURLY_BRACE | CLOSE_CURLY_BRACE | '|' | '^' | '\\' | '`' | ('\u0000'..'\u0020')) )* GREATER
    //{\$this->setText(substr(\$this->getText(), 1, strlen(\$this->getText()) - 2)); }
    ;

SIMPLE_IRI
	: ( PN_CHARS_U | DIGIT) ((PN_CHARS|DOT)* PN_CHARS)?
	;
NODE_ID
    : '_:' t=SIMPLE_IRI //{\$this->setText($t.text); }
    ;
fragment
PN_CHARS
    : PN_CHARS_U
    | MINUS
    | DIGIT
    | '\u00B7' 
    | '\u0300'..'\u036F'
    | '\u203F'..'\u2040'
    ;

OPEN_SQUARE_BRACE
    : '['
    ;

CLOSE_SQUARE_BRACE
    : ']'
    ;

QUOTED_STRING
    : '"'  ( options {greedy=false;} : ~('\u0022' | '\u005C' | '\u000A' | '\u000D') | ECHAR )* '"'
    ;

fragment
ECHAR
    : '\\' ('t' | 'b' | 'n' | 'r' | 'f' | '\\' | '"' | '\'')
    ;


LANGUAGE_TAG
    : '@' (('a'..'z')('A'..'Z'))+ (MINUS (('a'..'z')('A'..'Z')DIGIT)+)*
    //{\$this->setText(substr(\$this->getText(), 1, strlen(\$this->getText()) - 1)); }
    ;



EQUIVALENT_TO_LABEL
	:	'EquivalentTo:'
	;

SUBCLASS_OF_LABEL
	:	'SubClassOf:'
	;

DISJOINT_WITH_LABEL
	:	'DisjointWith:'
	;

DISJOINT_UNION_OF_LABEL
	:	'DisjointUnioniOf:'
	;

HAS_KEY_LABEL
	:	'HasKey:'
	;

INVERSE_OF_LABEL
	:	'InverseOf:'
	;
	
IMPORT_LABEL
	:	'Import:'
	;

SEMICOLON
	:	':'
	;


ANNOTATIONS_LABEL
	:	'Annotations:'
	;

CLASS_LABEL
	:	'Class:'
	;
EXPONENT
	: ('e'|'E') (PLUS | MINUS)? DIGIT+
	;

PREFIX_NAME:	PN_PREFIX SEMICOLON
	;
ABBREVIATED_IRI
    : PREFIX_NAME SIMPLE_IRI
    ;
