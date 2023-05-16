class ZCL_GLOBAL_UTILS definition
  public
  final
  create public .

public section.

  constants C_PATH_UPLOAD_PEOLE type CHAR30 value 'ZUPLOAD_PEOPLE' ##NO_TEXT.
  constants C_LOG_FILE_PEOPLE type CHAR30 value 'ZUPLOAD_FILE' ##NO_TEXT.
  constants C_COMMA type CHAR1 value ',' ##NO_TEXT.
  constants C_SEMICOLON type CHAR1 value ';' ##NO_TEXT.
  constants C_SLASH type CHAR1 value '/' ##NO_TEXT.
  constants C_HASTAG type CHAR1 value '#' ##NO_TEXT.
  constants C_AT type CHAR1 value '@' ##NO_TEXT.
  constants C_PERSON type CHAR5 value 'person' ##NO_TEXT.
  constants C_TXT type CHAR4 value '.txt' ##NO_TEXT.
  constants C_SPACE type CHAR1 value ' ' ##NO_TEXT.
  constants C_STR_FLIGHT type DD02L-TABNAME value 'ZSPFLI' ##NO_TEXT.
  constants C_TABLE_FLIGHT type DD02L-TABNAME value 'SPFLI' ##NO_TEXT.
  constants C_STR_CONNID type DD02L-TABNAME value 'ZCONNID_REPORT' ##NO_TEXT.
  constants C_STR_UPPERSON type DD02L-TABNAME value 'ZUPLOADPERSONCR' ##NO_TEXT.
  constants C_TABLE_FLIGHTS type DD02L-TABNAME value 'SFLIGHT' ##NO_TEXT.
  constants C_E type C value 'E' ##NO_TEXT.
  constants C_W type C value 'W' ##NO_TEXT.
  constants C_I type C value 'I' ##NO_TEXT.
  constants C_S type C value 'S' ##NO_TEXT.
  constants C_SJ type C value '1' ##NO_TEXT.
  constants C_AL type C value '2' ##NO_TEXT.
  constants C_HE type C value '3' ##NO_TEXT.
  constants C_CA type C value '4' ##NO_TEXT.
  constants C_PT type C value '5' ##NO_TEXT.
  constants C_GN type C value '6' ##NO_TEXT.
  constants C_LM type C value '7' ##NO_TEXT.
  constants C_08 type C value '8' ##NO_TEXT.
  constants C_09 type C value '9' ##NO_TEXT.
  constants C_EMAIL_REGEX type C value '\w+(\.\w+)*@(\w+\.)+(\w{2,4})' ##NO_TEXT.

  class-methods GET_LIST_FIELDS
    importing
      !STR_TABLE type DD02L-TABNAME
    returning
      value(RT_FIELDS) type STRING .
  class-methods VALIDATE_EMAIL
    importing
      !EMAIL type AD_SMTPADR
    returning
      value(TYPE_MSG) type Char1 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GLOBAL_UTILS IMPLEMENTATION.


  METHOD get_list_fields.

    DATA lt_catalog TYPE slis_t_fieldcat_alv.
    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = str_table
      CHANGING
        ct_fieldcat            = lt_catalog
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    rt_fields = REDUCE string(  INIT text = `` sep = ``
                    FOR wa_table IN lt_catalog
                    NEXT text = |{ text }{ sep }{ wa_table-fieldname }| sep = ` ` ).

  ENDMETHOD.


  method VALIDATE_EMAIL.

DATA: lo_regex   TYPE REF TO cl_abap_regex,
      lo_matcher TYPE REF TO cl_abap_matcher.

  lo_regex = NEW #( pattern     = c_email_regex
                    ignore_case = abap_true ).

  lo_matcher = lo_regex->create_matcher( text = email ).

  IF lo_matcher->match( ) IS INITIAL.
    type_msg = zcl_global_utils=>c_e.
  ELSE.
    type_msg = zcl_global_utils=>c_s.
  ENDIF.

  endmethod.
ENDCLASS.
