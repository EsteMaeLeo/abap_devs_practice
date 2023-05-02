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

  class-methods GET_LIST_FIELDS
    importing
      !STR_TABLE type DD02L-TABNAME
    returning
      value(RT_FIELDS) type STRING .
protected section.
private section.
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
ENDCLASS.
