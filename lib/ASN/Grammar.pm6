my grammar ASN::Grammar {
    token TOP { <module> }
    rule module { \n* <module-id> \n* 'DEFINITIONS' <default-tag>? '::=' 'BEGIN' \n* <body>? \n* 'END' \n* }
    rule default-tag { <explicit-or-implicit-tag> 'TAGS'}
    token module-id { <id-string> }

    token body { <assignment>+ }

    token assignment { <type-assignment> ';'? || <value-assignment> ';'? }

    rule value-assignment { <id-string> <type> '::=' <value>\n* }

    rule type-assignment { <id-string> '::=' <type> }
    token type { <builtin-type> || <defined-type> }

    token defined-type { <id-string> }

    token builtin-type {
        || <null-type> || <boolean-type> || <real-type>
        || <integer-type> || <object-id-type> || <string-type>
        || <bit-string-type> || <bits-type> || <sequence-type>
        || <sequence-of-type> || <set-type> || <set-of-type>
        || <choice-type> || <enumerated-type> || <selection-type>
        || <tagged-type> || <any-type>
     }

    token null-type { 'NULL' }
    token boolean-type { 'BOOLEAN' }
    token real-type { 'REAL' }
    rule integer-type { 'INTEGER' <value-or-constraint-list>? }
    token value-or-constraint-list { <named-number-list> || <constraint-list> }

    token named-number-list { '{' \n* <named-number>+ % ",\n" \s* '}' }
    rule named-number { \s* <id-string> '(' <number> ')'}

    token number { <number-value> || <binary-value> || <hex-value> || <defined-value> }

    rule constraint-list { '(' <constraint>+ % '|' ')' }

    token constraint { <value-const> || <size-const> || <alphabet-const> || <contained-type-const> || <inner-type-const> }
    token value-const { <lower-end-point> <value-range>? }
    token lower-end-point { <value> | 'MIN' }
    token upper-end-point { <value> | 'MAX' }
    rule value-range { '<'? '..' '<'? <upper-end-point> }

    token value { <builtin-value> || <defined-value> }
    token builtin-value {
        || <null-value> || <boolean-value>
        || <special-real-value> || <number-value>
        || <binary-value> || <hex-value>
        || <string-value> || <bit-or-objectid-value>
    }
    token null-value { 'NULL' }
    token boolean-value { 'TRUE' || 'FALSE' }
    token special-real-value { 'PLUS-INFINITY' || 'MINUS-INFINITY' }
    token string-value { '"' ( <-["]> | '""' )* '"' }
    token bit-or-objectid-value { <name-value-list> }

    rule name-value-list { '{' <name-value-component>* '}' }
    token name-value-component { ','? <name-or-number> }
    token name-or-number { \d+ || <id-string> || <name-and-number> }
    rule name-and-number { <id-string> '(' \d+ ')' || <id-string> '(' <defined-value> ')' }

    token number-value { '-'? \d+ }
    token binary-value { "'" <[01]>* "'" <[bB]> }
    token hex-value { "'" <xdigit>* "'" <[hH]> }
    token defined-value { <id-string> }

    rule object-id-type { 'OBJECT' 'IDENTIFIER' }
    rule string-type { 'OCTET' 'STRING' }
    rule bit-string-type { 'BIT' 'STRING' }
    token bits-type { 'BITS' }
    rule sequence-type { 'SEQUENCE' '{' <element-type-list> '}'}
    rule sequence-of-type { 'SEQUENCE' 'OF' <type> }
    rule set-type { 'SET' '{' <element-type-list> '}'}
    rule set-of-type { 'SET' 'OF' <type> }
    rule choice-type { 'CHOICE' '{' <element-type-list> '}' }
    rule enumerated-type { 'ENUMERATED' <named-number-list> }
    token selection-type { <id-string> '<' <type> }
    rule tagged-type { <tag> <explicit-or-implicit-tag>? <type>}
    rule any-type { 'ANY' || 'ANY' 'DEFINED' 'BY' <id-string> }

    rule tag { '[' <class>? \d+ ']'}
    token class { 'UNIVERSAL' || 'APPLICATION' || 'PRIVATE' }
    token explicit-or-implicit-tag { 'EXPLICIT' || 'IMPLICIT' }

    token element-type-list { <element-type>+ % ",\n" }

    rule element-type { <?> <id-string>? <type> <optional-or-default>? }
    rule optional-or-default { 'OPTIONAL' || 'DEFAULT' <id-string>? <value> }

    token id-string { <[A..Z a..z]> <[A..Z a..z 0..9 \- _ ]>* }
    token comment { '--' .+? \n+ }
}

our sub parse-ASN(Str $source) is export {
    my $clean-source = $source.subst(/ \s* '--' .*? \n /, "\n", :g).subst("\n\n", "\n", :g);
    ASN::Grammar.parse($clean-source);
}
