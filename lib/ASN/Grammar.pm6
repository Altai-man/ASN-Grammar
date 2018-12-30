# A quickly created grammar made to parse a single `ldap.asn` file
# though it possibly can parse a bigger scope of ASN.1 declarations

grammar ASN::Grammar {
    # Basic part
    token TOP { <module>+ }
    rule module { \n* <id-string> \n* 'DEFINITIONS' <default-tag> '::=' 'BEGIN' \n* <body>? \n* 'END' \n* }
    rule default-tag { <( <explicit-or-implicit-tag> )> 'TAGS' }
    token body { [ <type-assignment> || <value-assignment> ]+ }

    # Type part
    rule type-assignment { <id-string> '::=' <type> }
    token type { <builtin-type> || <id-string> }
    token builtin-type {
        || <null-type> || <boolean-type> || <real-type>
        || <integer-type> || <object-id-type> || <string-type>
        || <bit-string-type> || <bits-type> || <sequence-type>
        || <sequence-of-type> || <set-type> || <set-of-type>
        || <choice-type> || <enumerated-type> || <tagged-type> || <any-type>
    }

    token null-type { 'NULL' }
    token boolean-type { 'BOOLEAN' }
    token real-type { 'REAL' }
    rule integer-type { 'INTEGER' [ <named-number-list> || <constraint-list> ]? }

    token named-number-list { '{' \n* <named-number>+ % ",\n" \s* '}' }
    rule named-number { \s* <id-string> '(' <number> ')'}
    token number { <value:sym<number>> || <binary-value> || <hex-value> || <id-string> }

    rule constraint-list { '(' <lower-end-point> <value-range>? ')' }
    token lower-end-point { <value> || 'MIN' }
    token upper-end-point { <value> || 'MAX' }
    rule value-range { '<'? '..' '<'? <upper-end-point> }

    rule object-id-type { 'OBJECT' 'IDENTIFIER' }
    rule string-type { 'OCTET' 'STRING' }
    rule bit-string-type { 'BIT' 'STRING' }
    token bits-type { 'BITS' }
    rule sequence-type { 'SEQUENCE' '{' <element-type-list> '}'}
    rule sequence-of-type { 'SEQUENCE' 'OF' <type> }
    rule set-type { 'SET' '{' <element-type-list> '}' }
    rule set-of-type { 'SET' 'OF' <type> }
    rule choice-type { 'CHOICE' '{' <element-type-list> '}' }
    rule enumerated-type { 'ENUMERATED' <named-number-list> }
    rule any-type { 'ANY' }
    rule tagged-type { <tag> <explicit-or-implicit-tag>? <type>}
    rule tag { '[' <class>? \d+ ']'}
    token class { 'UNIVERSAL' || 'APPLICATION' || 'PRIVATE' }

    token element-type-list { <element-type>+ % ",\n" }
    rule element-type { <?> <id-string>? <type> <optional-or-default>? }
    rule optional-or-default { 'OPTIONAL' || 'DEFAULT' <id-string>? <value> }

    # Value part
    rule value-assignment { <id-string> <type> '::=' <value>\n* }
    proto token value {*}
    token value:sym<defined> { <id-string> }
    token value:sym<null> { 'NULL' }
    token value:sym<bool> { 'TRUE' || 'FALSE' }
    token value:sym<special-real> { 'PLUS-INFINITY' || 'MINUS-INFINITY' }
    token value:sym<number> { '-'? \d+ }
    token value:sym<binary> { "'" <[01]>* "'" <[bB]> }
    token value:sym<hex> {  "'" <xdigit>* "'" <[hH]> }
    token value:sym<string> { '"' ( <-["]> | '""' )* '"' }
    token value:sym<bit> { '{' <name-value-component>* '}' }
    token name-value-component { ','? <name-or-number> }
    token name-or-number { \d+ || <id-string> || <name-and-number> }
    rule name-and-number { <id-string> '(' \d+ ')' || <id-string> '(' <id-string> ')' }

    token explicit-or-implicit-tag { 'EXPLICIT' || 'IMPLICIT' }
    token id-string { <[A..Z a..z]> <[A..Z a..z 0..9 \- _ ]>* }
}

class ASN::Module {
    has $.name;
    has $.schema;
    has @.types;
}

class ASN::TypeAssignment {
    has $.name;
}

class ASN::ValueAssignment {
    has $.name;
    has $.type;
    has $.value;
}

class ASN::Result {
    method TOP($/) {
        if $<module>.elems == 1 {
            make ASN::Module.new(|$<module>[0].made) if $<module>.elems == 1;
        } else {
            make $<module>.map(ASN::Module.new(|$_.made));
        }
    }
    method module($/) {
        make Map.new('name', ~$<id-string>, 'schema', ~$<default-tag>.trim, Pair.new('types', $<body>.made));
    }

    method body($/) {
        my @types;
        @types.push: .made for $<value-assignment>;
        @types.push: .made for $<type-assignment>;
        make @types;
    }

    method type-assignment($/) {
        make ASN::TypeAssignment.new(name => ~$<id-string>);
    }

    method value-assignment($/) {
        make ASN::ValueAssignment.new(name => ~$<id-string>, type => ~$<type>, value => $<value>.made);
    }
    method value:sym<defined>($/) { make ~$/ }
    method value:sym<null>($/) { make 'NULL' }
    method value:sym<bool>($/) { make ~$/ }
    method value:sym<number>($/) { make $/.Int }
}

our sub parse-ASN(Str $source) is export {
    my $clean-source = $source.subst(/ \s* '--' .*? \n /, "\n", :g).subst("\n\n", "\n", :g);
    ASN::Grammar.parse($clean-source, :actions(ASN::Result.new)).made;
}
