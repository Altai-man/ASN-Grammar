use ASN::Grammar;
use Test;

my $ldap-asn = q:to/LDAPEND/;
-- from http://www.research.ibm.com/trl/projects/xml/xss4j/data/asn1/grammars/ldap.asn

Lightweight-Directory-Access-Protocol-V3

DEFINITIONS IMPLICIT TAGS ::=

BEGIN

LDAPMessage ::= SEQUENCE {
  messageID   MessageID,
  protocolOp  CHOICE {
                bindRequest      BindRequest,
                bindResponse     BindResponse,
                unbindRequest    UnbindRequest,
                searchRequest    SearchRequest,
                searchResEntry   SearchResultEntry,
                searchResDone    SearchResultDone,
                searchResRef     SearchResultReference,
                modifyRequest    ModifyRequest,
                modifyResponse   ModifyResponse,
                addRequest       AddRequest,
                addResponse      AddResponse,
                delRequest       DelRequest,
                delResponse      DelResponse,
                modDNRequest     ModifyDNRequest,
                modDNResponse    ModifyDNResponse,
                compareRequest   CompareRequest,
                compareResponse  CompareResponse,
                abandonRequest   AbandonRequest,
                extendedReq      ExtendedRequest,
                extendedResp     ExtendedResponse },
  controls    [0] Controls OPTIONAL }

MessageID ::= INTEGER (0 .. maxInt)

maxInt INTEGER ::= 2147483647 -- (2^^31 - 1) --

LDAPString ::= OCTET STRING

LDAPOID ::= OCTET STRING

LDAPDN ::= LDAPString

RelativeLDAPDN ::= LDAPString

AttributeType ::= LDAPString

AttributeDescription ::= LDAPString

AttributeDescriptionList ::= SEQUENCE OF AttributeDescription

AttributeValue ::= OCTET STRING

AttributeValueAssertion ::= SEQUENCE {
  attributeDesc   AttributeDescription,
  assertionValue  AssertionValue }

AssertionValue ::= OCTET STRING

Attribute ::= SEQUENCE {
  type  AttributeDescription,
  vals  SET OF AttributeValue }

MatchingRuleId ::= LDAPString

LDAPResult ::= SEQUENCE {
  resultCode    ENUMERATED {
                  success                      (0),
                  operationsError              (1),
                  protocolError                (2),
                  timeLimitExceeded            (3),
                  sizeLimitExceeded            (4),
                  compareFalse                 (5),
                  compareTrue                  (6),
                  authMethodNotSupported       (7),
                  strongAuthRequired           (8),
                    -- 9 reserved --
                  referral                     (10), -- new
                  adminLimitExceeded           (11), -- new
                  unavailableCriticalExtension (12), -- new
                  confidentialityRequired      (13), -- new
                  saslBindInProgress           (14), -- new
                  noSuchAttribute              (16),
                  undefinedAttributeType       (17),
                  inappropriateMatching        (18),
                  constraintViolation          (19),
                  attributeOrValueExists       (20),
                  invalidAttributeSyntax       (21),
                    -- 22-31 unused --
                  noSuchObject                 (32),
                  aliasProblem                 (33),
                  invalidDNSyntax              (34),
                    -- 35 reserved for undefined isLeaf --
                  aliasDereferencingProblem    (36),
                    -- 37-47 unused --
                  inappropriateAuthentication  (48),
                  invalidCredentials           (49),
                  insufficientAccessRights     (50),
                  busy                         (51),
                  unavailable                  (52),
                  unwillingToPerform           (53),
                  loopDetect                   (54),
                    -- 55-63 unused --
                  namingViolation              (64),
                  objectClassViolation         (65),
                  notAllowedOnNonLeaf          (66),
                  notAllowedOnRDN              (67),
                  entryAlreadyExists           (68),
                  objectClassModsProhibited    (69),
                    -- 70 reserved for CLDAP --
                  affectsMultipleDSAs          (71), -- new
                    -- 72-79 unused --
                  other                        (80) },
                    -- 81-90 reserved for APIs --
  matchedDN     LDAPDN,
  errorMessage  LDAPString,
  referral      [3] Referral OPTIONAL }

Referral ::= SEQUENCE OF LDAPURL

LDAPURL ::= LDAPString -- limited to characters permitted in URLs

Controls ::= SEQUENCE OF Control

Control ::= SEQUENCE {
  controlType   LDAPOID,
  criticality   BOOLEAN DEFAULT FALSE,
  controlValue  OCTET STRING OPTIONAL }

BindRequest ::= [APPLICATION 0] SEQUENCE {
  version         INTEGER (1 .. 127),
  name            LDAPDN,
  authentication  AuthenticationChoice }

AuthenticationChoice ::= CHOICE {
  simple  [0] OCTET STRING,
            -- 1 and 2 reserved
  sasl    [3] SaslCredentials }

SaslCredentials ::= SEQUENCE {
  mechanism    LDAPString,
  credentials  OCTET STRING OPTIONAL }

BindResponse ::= [APPLICATION 1] SEQUENCE {
  resultCode    ENUMERATED {
                  success                      (0),
                  operationsError              (1),
                  protocolError                (2),
                  timeLimitExceeded            (3),
                  sizeLimitExceeded            (4),
                  compareFalse                 (5),
                  compareTrue                  (6),
                  authMethodNotSupported       (7),
                  strongAuthRequired           (8),
                    -- 9 reserved --
                  referral                     (10), -- new
                  adminLimitExceeded           (11), -- new
                  unavailableCriticalExtension (12), -- new
                  confidentialityRequired      (13), -- new
                  saslBindInProgress           (14), -- new
                  noSuchAttribute              (16),
                  undefinedAttributeType       (17),
                  inappropriateMatching        (18),
                  constraintViolation          (19),
                  attributeOrValueExists       (20),
                  invalidAttributeSyntax       (21),
                    -- 22-31 unused --
                  noSuchObject                 (32),
                  aliasProblem                 (33),
                  invalidDNSyntax              (34),
                    -- 35 reserved for undefined isLeaf --
                  aliasDereferencingProblem    (36),
                    -- 37-47 unused --
                  inappropriateAuthentication  (48),
                  invalidCredentials           (49),
                  insufficientAccessRights     (50),
                  busy                         (51),
                  unavailable                  (52),
                  unwillingToPerform           (53),
                  loopDetect                   (54),
                    -- 55-63 unused --
                  namingViolation              (64),
                  objectClassViolation         (65),
                  notAllowedOnNonLeaf          (66),
                  notAllowedOnRDN              (67),
                  entryAlreadyExists           (68),
                  objectClassModsProhibited    (69),
                    -- 70 reserved for CLDAP --
                  affectsMultipleDSAs          (71), -- new
                    -- 72-79 unused --
                  other                        (80) },
                    -- 81-90 reserved for APIs --
  matchedDN     LDAPDN,
  errorMessage  LDAPString,
  referral      [3] Referral OPTIONAL,
  -- COMPONENTS OF LDAPResult,
  serverSaslCreds  [7] OCTET STRING OPTIONAL }

UnbindRequest ::= [APPLICATION 2] NULL

SearchRequest ::= [APPLICATION 3] SEQUENCE {
  baseObject    LDAPDN,
  scope         ENUMERATED {
                  baseObject   (0),
                  singleLevel  (1),
                  wholeSubtree (2) },
  derefAliases  ENUMERATED {
                  neverDerefAliases   (0),
                  derefInSearching    (1),
                  derefFindingBaseObj (2),
                  derefAlways         (3) },
  sizeLimit     INTEGER (0 .. maxInt),
  timeLimit     INTEGER (0 .. maxInt),
  typesOnly     BOOLEAN,
  filter        Filter,
  attributes    AttributeDescriptionList }

Filter ::= CHOICE {
  and              [0] SET OF Filter,
  or               [1] SET OF Filter,
  not              [2] Filter,
  equalityMatch    [3] AttributeValueAssertion,
  substrings       [4] SubstringFilter,
  greaterOrEqual   [5] AttributeValueAssertion,
  lessOrEqual      [6] AttributeValueAssertion,
  present          [7] AttributeDescription,
  approxMatch      [8] AttributeValueAssertion,
  extensibleMatch  [9] MatchingRuleAssertion }

SubstringFilter ::= SEQUENCE {
  type        AttributeDescription,
                -- at least one must be present
  substrings  SEQUENCE OF CHOICE {
                initial  [0] LDAPString,
                any      [1] LDAPString,
                final    [2] LDAPString } }

MatchingRuleAssertion ::= SEQUENCE {
  matchingRule  [1] MatchingRuleId OPTIONAL,
  type          [2] AttributeDescription OPTIONAL,
  matchValue    [3] AssertionValue,
  dnAttributes  [4] BOOLEAN DEFAULT FALSE }

SearchResultEntry ::= [APPLICATION 4] SEQUENCE {
  objectName  LDAPDN,
  attributes  PartialAttributeList }

PartialAttributeList ::= SEQUENCE OF SEQUENCE {
  type  AttributeDescription,
  vals  SET OF AttributeValue }

SearchResultReference ::= [APPLICATION 19] SEQUENCE OF LDAPURL

SearchResultDone ::= [APPLICATION 5] LDAPResult

ModifyRequest ::= [APPLICATION 6] SEQUENCE {
  object        LDAPDN,
  modification  SEQUENCE OF SEQUENCE {
                  operation     ENUMERATED {
                                  add     (0),
                                  delete  (1),
                                  replace (2) },
                  modification  AttributeTypeAndValues } }

AttributeTypeAndValues ::= SEQUENCE {
  type  AttributeDescription,
  vals  SET OF AttributeValue }

ModifyResponse ::= [APPLICATION 7] LDAPResult

AddRequest ::= [APPLICATION 8] SEQUENCE {
  entry       LDAPDN,
  attributes  AttributeList }

AttributeList ::= SEQUENCE OF SEQUENCE {
  type  AttributeDescription,
  vals  SET OF AttributeValue }

AddResponse ::= [APPLICATION 9] LDAPResult

DelRequest ::= [APPLICATION 10] LDAPDN

DelResponse ::= [APPLICATION 11] LDAPResult

ModifyDNRequest ::= [APPLICATION 12] SEQUENCE {
  entry         LDAPDN,
  newrdn        RelativeLDAPDN,
  deleteoldrdn  BOOLEAN,
  newSuperior   [0] LDAPDN OPTIONAL }

ModifyDNResponse ::= [APPLICATION 13] LDAPResult

CompareRequest ::= [APPLICATION 14] SEQUENCE {
  entry  LDAPDN,
  ava    AttributeValueAssertion }

CompareResponse ::= [APPLICATION 15] LDAPResult

AbandonRequest ::= [APPLICATION 16] MessageID

ExtendedRequest ::= [APPLICATION 23] SEQUENCE {
  requestName   [0] LDAPOID,
  requestValue  [1] OCTET STRING OPTIONAL }

ExtendedResponse ::= [APPLICATION 24] SEQUENCE {
  resultCode    ENUMERATED {
                  success                      (0),
                  operationsError              (1),
                  protocolError                (2),
                  timeLimitExceeded            (3),
                  sizeLimitExceeded            (4),
                  compareFalse                 (5),
                  compareTrue                  (6),
                  authMethodNotSupported       (7),
                  strongAuthRequired           (8),
                    -- 9 reserved --
                  referral                     (10), -- new
                  adminLimitExceeded           (11), -- new
                  unavailableCriticalExtension (12), -- new
                  confidentialityRequired      (13), -- new
                  saslBindInProgress           (14), -- new
                  noSuchAttribute              (16),
                  undefinedAttributeType       (17),
                  inappropriateMatching        (18),
                  constraintViolation          (19),
                  attributeOrValueExists       (20),
                  invalidAttributeSyntax       (21),
                    -- 22-31 unused --
                  noSuchObject                 (32),
                  aliasProblem                 (33),
                  invalidDNSyntax              (34),
                    -- 35 reserved for undefined isLeaf --
                  aliasDereferencingProblem    (36),
                    -- 37-47 unused --
                  inappropriateAuthentication  (48),
                  invalidCredentials           (49),
                  insufficientAccessRights     (50),
                  busy                         (51),
                  unavailable                  (52),
                  unwillingToPerform           (53),
                  loopDetect                   (54),
                    -- 55-63 unused --
                  namingViolation              (64),
                  objectClassViolation         (65),
                  notAllowedOnNonLeaf          (66),
                  notAllowedOnRDN              (67),
                  entryAlreadyExists           (68),
                  objectClassModsProhibited    (69),
                    -- 70 reserved for CLDAP --
                  affectsMultipleDSAs          (71), -- new
                    -- 72-79 unused --
                  other                        (80) },
                    -- 81-90 reserved for APIs --
  matchedDN     LDAPDN,
  errorMessage  LDAPString,
  referral      [3] Referral OPTIONAL,
  --  COMPONENTS OF LDAPResult,
  responseName  [10] LDAPOID OPTIONAL,
  response      [11] OCTET STRING OPTIONAL }

END
LDAPEND

my $ldap = parse-ASN($ldap-asn);
say $ldap;
isa-ok $ldap, ASN::Module, 'LDAP spec is parsed';

is 'Lightweight-Directory-Access-Protocol-V3', $ldap.name, 'Name is parsed';
is 'IMPLICIT', $ldap.schema, 'Schema is parsed';

is $ldap.types.elems, 48, 'All types are parsed';

my $values = $ldap.types.grep(* ~~ ASN::ValueAssignment);
is $values.elems, 1, 'One value is parsed';
is $values[0].name, 'maxInt', 'Value type name is parsed';
is $values[0].type, 'INTEGER', 'Value type type is parsed';
is $values[0].value, 2147483647, 'Value type value is parsed';



done-testing;
