managed implementation in class /PROD/GCTS_CLI_001 unique;
strict;
with draft;
define behavior for /PROD/GCTS_IS_001 alias GctsTableAll
draft table /PROD/GCTS_DS_01
with unmanaged save
lock master total etag LastChangedAtMax
authorization master( global )

{
  field ( readonly )
   SingletonID;

  field ( notrigger )
   SingletonID,
   LastChangedAtMax;


  update;
  internal create;
  internal delete;

  draft action ( features : instance ) Edit;
  draft action Activate optimized;
  draft action Discard;
  draft action Resume;
  draft determine action Prepare;

  association _GctsTable { create ( features : instance ); with draft; }
}

define behavior for /PROD/GCTS_I_001 alias GctsTable ##UNMAPPED_FIELD
persistent table /PROD/GCTS_A_001
draft table /PROD/GCTS_D_001
lock dependent by _GctsTableAll
authorization dependent by _GctsTableAll

{
  field ( mandatory : create )
   Name1;

  field ( readonly )
   SingletonID;

  field ( readonly : update )
   Name1;

  field ( notrigger )
   SingletonID;


  update( features : global );
  delete( features : global );

  factory action ( features : instance ) CopyGctsTable parameter /PROD/GCTS_I_001_COPY [1];

  mapping for /PROD/GCTS_A_001
  {
    Name1 = NAME1;
    Name2 = NAME2;
  }

  association _GctsTableAll { with draft; }
}