grammar MOS ;
	
rule	:	conjunction;
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
THAT_LABEL
	:	'that'
	;

OR_LABEL
	:	'or'
	;

AND_LABEL
	:	'and'
	;
NOT_LABEL
	:	'not'
	;

NODE_ID
    : '_:' t=SIMPLE_IRI //{\$this->setText($t.text); }
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
INVERSE_LABEL
	:	'inverse'
	;

DIGIT
    : '0'..'9'
    ;

individual
	: NODE_ID
	| iri
	;


inverseObjectProperty
	:	INVERSE_LABEL iri
	;

objectPropertyExpression
	:	//IRI
	//|	
	inverseObjectProperty
	;

description
	: iri
	(conjunction (OR_LABEL conjunction)*)
	;

conjunction
	:	iri THAT_LABEL primary (AND_LABEL primary)*
	|	primary (AND_LABEL primary)*
	;

WS
    : (' '| '\t'| EOL)+ {$channel=HIDDEN;}
    ;

primary
	:	(NOT_LABEL)? (restriction | atomic)
	;

FULL_IRI
    : LESS ( options {greedy=false;} : ~(LESS | GREATER | '"' | OPEN_CURLY_BRACE | CLOSE_CURLY_BRACE | '|' | '^' | '\\' | '`' | ('\u0000'..'\u0020')) )* GREATER
    //{\$this->setText(substr(\$this->getText(), 1, strlen(\$this->getText()) - 2)); }
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

iri
	: FULL_IRI
//	| ABBREVIATED_IRI
	| SIMPLE_IRI
	;

restriction
	: 	objectPropertyExpression SOME_LABEL primary
	|	objectPropertyExpression ONLY_LABEL primary
	|	objectPropertyExpression VALUE_LABEL individual
	|	objectPropertyExpression SELF_LABEL
	|	objectPropertyExpression MIN_LABEL nonNegativeInteger (primary)?
	|	objectPropertyExpression MAX_LABEL nonNegativeInteger (primary)?
	|	objectPropertyExpression EXACTLY_LABEL nonNegativeInteger (primary)?
//	|	dataPropertyExpression SOME_LABEL dataRange
//	|	dataPropertyExpression ONLY_LABEL dataRange
//	|	dataPropertyExpression VALUE_LABEL literal
//	|	dataPropertyExpression MIN_LABEL nonNegativeInteger (dataRange)?
//	|	dataPropertyExpression MAX_LABEL nonNegativeInteger (dataRange)?
//	|	dataPropertyExpression EXACTLY_LABEL nonNegativeInteger (dataRange)?
	;


atomic
	:	iri
	|	OPEN_CURLY_BRACE individualList CLOSE_CURLY_BRACE
	|	OPEN_BRACE description CLOSE_BRACE
	;

individualList
	:	individual (COMMA individual)*
	;

COMMA	:	',';

OPEN_BRACE
    : '('
    ;

CLOSE_BRACE
    : ')'
    ;

nonNegativeInteger
	: DIGIT+
	;

dataPrimary
	:	NOT_LABEL? dataAtomic
	;

dataAtomic
	:	dataType
	|	OPEN_CURLY_BRACE literalList CLOSE_CURLY_BRACE
	|	dataTypeRestriction
	|	OPEN_BRACE dataRange CLOSE_BRACE
	;

literalList
	:	literal (COMMA literal)*
	;

dataType
	: iri
	| INTEGER_LABEL
	| DECIMAL_LABEL
	| FLOAT_LABEL
	| STRING_LABEL
	;


literal
	: typedLiteral
	| stringLiteralNoLanguage
	| stringLiteralWithLanguage
	| integerLiteral
	| decimalLiteral  
	| floatingPointLiteral
	;

typedLiteral
	: lexicalValue REFERENCE dataType
	;
	
REFERENCE
	: '^^'
	;

stringLiteralNoLanguage
	: QUOTED_STRING
	;
stringLiteralWithLanguage
	: QUOTED_STRING LANGUAGE_TAG
	;
	
LANGUAGE_TAG
    : '@' (('a'..'z')('A'..'Z'))+ (MINUS (('a'..'z')('A'..'Z')DIGIT)+)*
    //{\$this->setText(substr(\$this->getText(), 1, strlen(\$this->getText()) - 1)); }
    ;

lexicalValue
	: QUOTED_STRING
	;

QUOTED_STRING
    : '"'  ( options {greedy=false;} : ~('\u0022' | '\u005C' | '\u000A' | '\u000D') | ECHAR )* '"'
    ;

fragment
ECHAR
    : '\\' ('t' | 'b' | 'n' | 'r' | 'f' | '\\' | '"' | '\'')
    ;

DOT
    : '.'
    ;

PLUS
    : '+'
    ;

MINUS
    : '-'
    ;

dataPropertyExpression
	:	iri
	;

dataTypeRestriction
	:	dataType OPEN_SQUARE_BRACE facet restrictionValue  (COMMA facet restrictionValue)* CLOSE_SQUARE_BRACE
	;

OPEN_SQUARE_BRACE
    : '['
    ;

CLOSE_SQUARE_BRACE
    : ']'
    ;

facet
	:	LENGTH_LABEL
	|	MIN_LENGTH_LABEL
	|	MAX_LENGTH_LABEL
	|	PATTERN_LABEL
	|	LANG_PATTERN_LABEL
	|	LESS_EQUAL
	|	LESS
	|	GREATER_EQUAL
	|	GREATER
	;

restrictionValue
	:	literal
	;


decimalLiteral
	: (PLUS | MINUS)? DIGIT+ DOT DIGIT+
	;

integerLiteral
	: (PLUS | MINUS)? DIGIT+
		;

floatingPointLiteral
	: (PLUS | MINUS) (DIGIT+ (DOT DIGIT+)? EXPONENT? | DOT DIGIT+ EXPONENT?) ('f' | 'F')
	;
	
EXPONENT
	: ('e'|'E') (PLUS | MINUS)? DIGIT+
	;

dataRange
	:	dataConjunction (OR_LABEL dataConjunction)*
	;

dataConjunction
	:	dataPrimary (AND_LABEL dataPrimary)*
	;

//fragment
//ABBREVIATED_IRI
//    : PREFIX_NAME SIMPLE_IRI
//    ;

fragment
PREFIX_NAME
    : PN_PREFIX ':'
    ;

fragment
PN_PREFIX
    : (PN_CHARS)*
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

fragment
PN_CHARS
    : PN_CHARS_U
    | MINUS
    | DIGIT
    | '\u00B7' 
    | '\u0300'..'\u036F'
    | '\u203F'..'\u2040'
    ;

SIMPLE_IRI
	: ( PN_CHARS_U) ((PN_CHARS|DOT)* PN_CHARS)?
	;

fragment
EOL
    : '\n' | '\r'
    ;