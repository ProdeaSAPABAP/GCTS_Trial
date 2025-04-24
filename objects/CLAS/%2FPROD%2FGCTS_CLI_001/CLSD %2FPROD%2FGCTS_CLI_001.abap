class-pool .
*"* class pool for class /PROD/GCTS_CLI_001

*"* local type definitions
include /PROD/GCTS_CLI_001============ccdef.

*"* class /PROD/GCTS_CLI_001 definition
*"* public declarations
  include /PROD/GCTS_CLI_001============cu.
*"* protected declarations
  include /PROD/GCTS_CLI_001============co.
*"* private declarations
  include /PROD/GCTS_CLI_001============ci.
endclass. "/PROD/GCTS_CLI_001 definition

*"* macro definitions
include /PROD/GCTS_CLI_001============ccmac.
*"* local class implementation
include /PROD/GCTS_CLI_001============ccimp.

*"* test class
include /PROD/GCTS_CLI_001============ccau.

class /PROD/GCTS_CLI_001 implementation.
*"* method's implementations
  include methods.
endclass. "/PROD/GCTS_CLI_001 implementation
