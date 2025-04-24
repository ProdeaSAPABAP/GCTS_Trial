CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TABLE_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                         ( entity = 'GctsTable' table = '/PROD/GCTS_A_001' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_/PROD/GCTS_IS_001 DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR GctsTableAll
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR GctsTableAll
        RESULT result.
ENDCLASS.

CLASS LHC_/PROD/GCTS_IS_001 IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: edit_flag            TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled.

    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
        iv_objectname = '/PROD/GCTS_A_001'
        iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( FOR key in keys (
               %TKY = key-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_GctsTable = edit_flag ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD '/PROD/GCTS_I_001' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_/PROD/GCTS_IS_001 DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION.
ENDCLASS.

CLASS LSC_/PROD/GCTS_IS_001 IMPLEMENTATION.
  METHOD SAVE_MODIFIED ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_/PROD/GCTS_I_001 DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR GctsTable
        RESULT result,
      COPYGCTSTABLE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION GctsTable~CopyGctsTable,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR GctsTable
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR GctsTable
        RESULT result.
ENDCLASS.

CLASS LHC_/PROD/GCTS_I_001 IMPLEMENTATION.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = '/PROD/GCTS_A_001'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
  METHOD COPYGCTSTABLE.
    DATA new_GctsTable TYPE TABLE FOR CREATE /PROD/GCTS_IS_001\_GctsTable.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-GctsTable = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF /PROD/GCTS_IS_001 IN LOCAL MODE
      ENTITY GctsTable
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_GctsTable)
        FAILED DATA(read_failed).

    IF ref_GctsTable IS NOT INITIAL.
      ASSIGN ref_GctsTable[ 1 ] TO FIELD-SYMBOL(<ref_GctsTable>).
      DATA(key) = keys[ KEY draft %TKY = <ref_GctsTable>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_GctsTable>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_GctsTable>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_GctsTable> EXCEPT
          SingletonID
        ) ) )
      ) TO new_GctsTable ASSIGNING FIELD-SYMBOL(<new_GctsTable>).
      <new_GctsTable>-%TARGET[ 1 ]-Name1 = to_upper( key-%PARAM-Name1 ).

      MODIFY ENTITIES OF /PROD/GCTS_IS_001 IN LOCAL MODE
        ENTITY GctsTableAll CREATE BY \_GctsTable
        FIELDS (
                 Name1
                 Name2
               ) WITH new_GctsTable
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-GctsTable = mapped_create-GctsTable.
    ENDIF.

    INSERT LINES OF read_failed-GctsTable INTO TABLE failed-GctsTable.

    IF failed-GctsTable IS INITIAL.
      reported-GctsTable = VALUE #( FOR created IN mapped-GctsTable (
                                                 %CID = created-%CID
                                                 %ACTION-CopyGctsTable = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-GctsTableAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-GctsTableAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD '/PROD/GCTS_I_001' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyGctsTable = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyGctsTable = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
    ) ).
  ENDMETHOD.
ENDCLASS.