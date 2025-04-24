class-pool .
*"* class pool for class /PROD/GCTS_CL_001

*"* local type definitions
include /PROD/GCTS_CL_001=============ccdef.

*"* class /PROD/GCTS_CL_001 definition
*"* public declarations
  include /PROD/GCTS_CL_001=============cu.
*"* protected declarations
  include /PROD/GCTS_CL_001=============co.
*"* private declarations
  include /PROD/GCTS_CL_001=============ci.
endclass. "/PROD/GCTS_CL_001 definition

*"* macro definitions
include /PROD/GCTS_CL_001=============ccmac.
*"* local class implementation
include /PROD/GCTS_CL_001=============ccimp.

*"* test class
include /PROD/GCTS_CL_001=============ccau.

class /PROD/GCTS_CL_001 implementation.
*"* method's implementations
  include methods.
endclass. "/PROD/GCTS_CL_001 implementation
