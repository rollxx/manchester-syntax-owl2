grammar MOS ;
	
options {
language = Java;
backtrack=true;
}
import Tokens;

description
	: conjunction (OR_LABEL conjunction)*
	;

conjunction
	:	primary (AND_LABEL primary)*
	|	iri THAT_LABEL primary (AND_LABEL primary)*
	;


primary
	:	(NOT_LABEL)? (restriction | atomic)
	;

iri
	: FULL_IRI
	| ABBREVIATED_IRI
	| SIMPLE_IRI
	;
	
objectPropertyExpression
	:	iri
	|	inverseObjectProperty
	;

restriction
	: 	objectPropertyExpression SOME_LABEL  primary
	|	objectPropertyExpression ONLY_LABEL primary
	|	objectPropertyExpression VALUE_LABEL individual
	|	objectPropertyExpression SELF_LABEL
	|	objectPropertyExpression MIN_LABEL nonNegativeInteger (primary)?
	|	objectPropertyExpression MAX_LABEL nonNegativeInteger (primary)?
	|	objectPropertyExpression EXACTLY_LABEL nonNegativeInteger (primary)?
	|	dataPropertyExpression SOME_LABEL dataPrimary
	|	dataPropertyExpression ONLY_LABEL dataPrimary
	|	dataPropertyExpression VALUE_LABEL literal
	|	dataPropertyExpression MIN_LABEL nonNegativeInteger (dataPrimary)?
	|	dataPropertyExpression MAX_LABEL nonNegativeInteger (dataPrimary)?
	|	dataPropertyExpression EXACTLY_LABEL nonNegativeInteger (dataPrimary)?
	;

atomic
	:	iri
	|	OPEN_CURLY_BRACE individualList CLOSE_CURLY_BRACE
	|	OPEN_BRACE description CLOSE_BRACE
	;

individualList
	:	individual (COMMA individual)*
	;

individual
	: iri
	| NODE_ID
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
	

stringLiteralNoLanguage
	: QUOTED_STRING
	;
stringLiteralWithLanguage
	: QUOTED_STRING LANGUAGE_TAG
	;
	
lexicalValue
	: QUOTED_STRING
	;

dataPropertyExpression
	:	iri
	;

dataTypeRestriction
	:	dataType OPEN_SQUARE_BRACE facet restrictionValue  (COMMA facet restrictionValue)* CLOSE_SQUARE_BRACE
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

inverseObjectProperty
	:	INVERSE_LABEL iri
	;

decimalLiteral
	: (PLUS | MINUS)? DIGIT+ DOT DIGIT+
	;

integerLiteral
	: (PLUS | MINUS)? (DIGIT+)=>DIGIT+
	;

floatingPointLiteral
	: (PLUS | MINUS) (DIGIT+ (DOT DIGIT+)? EXPONENT? | DOT DIGIT+ EXPONENT?) ('f' | 'F')
	;
	
dataRange
	:	dataConjunction (OR_LABEL dataConjunction)*
	;

dataConjunction
	:	dataPrimary (AND_LABEL dataPrimary)*
	;

annotationAnnotatedList
	:	(annotations)? annotation (COMMA (annotations) annotation)*
	;

annotation
	:	iri annotationTarget
	;

annotationTarget
	:	NODE_ID
	|	iri
	|	literal
	;
annotations
	: ANNOTATIONS_LABEL annotationAnnotatedList
	;

descriptionAnnotatedList
	:	description (COMMA description)*
	;

description2List
	:	description COMMA descriptionList
	;

descriptionList
	:	description (COMMA description)*
	;

classFrame
	:	CLASS_LABEL iri
	(	ANNOTATIONS_LABEL annotationAnnotatedList
		|	SUBCLASS_OF_LABEL descriptionAnnotatedList
		|	EQUIVALENT_TO_LABEL descriptionAnnotatedList
		|	DISJOINT_WITH_LABEL descriptionAnnotatedList
		|	DISJOINT_UNION_OF_LABEL annotations description2List
	)*
	//TODO owl2 primer error?
	(	HAS_KEY_LABEL annotations?
			(objectPropertyExpression | dataPropertyExpression)+)?
	;
