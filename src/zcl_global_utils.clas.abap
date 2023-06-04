CLASS zcl_global_utils DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS c_path_upload_peole TYPE char30 VALUE 'ZUPLOAD_PEOPLE' ##NO_TEXT.
    CONSTANTS c_log_file_people TYPE char30 VALUE 'ZUPLOAD_FILE' ##NO_TEXT.
    CONSTANTS c_comma TYPE char1 VALUE ',' ##NO_TEXT.
    CONSTANTS c_semicolon TYPE char1 VALUE ';' ##NO_TEXT.
    CONSTANTS c_slash TYPE char1 VALUE '/' ##NO_TEXT.
    CONSTANTS c_hastag TYPE char1 VALUE '#' ##NO_TEXT.
    CONSTANTS c_at TYPE char1 VALUE '@' ##NO_TEXT.
    CONSTANTS c_person TYPE char5 VALUE 'person' ##NO_TEXT.
    CONSTANTS c_txt TYPE char4 VALUE '.txt' ##NO_TEXT.
    CONSTANTS c_space TYPE char1 VALUE ' ' ##NO_TEXT.
    CONSTANTS c_str_flight TYPE dd02l-tabname VALUE 'ZSPFLI' ##NO_TEXT.
    CONSTANTS c_table_flight TYPE dd02l-tabname VALUE 'SPFLI' ##NO_TEXT.
    CONSTANTS c_str_connid TYPE dd02l-tabname VALUE 'ZCONNID_REPORT' ##NO_TEXT.
    CONSTANTS c_str_upperson TYPE dd02l-tabname VALUE 'ZUPLOADPERSONCR' ##NO_TEXT.
    CONSTANTS c_table_flights TYPE dd02l-tabname VALUE 'SFLIGHT' ##NO_TEXT.
    CONSTANTS c_e TYPE c VALUE 'E' ##NO_TEXT.
    CONSTANTS c_w TYPE c VALUE 'W' ##NO_TEXT.
    CONSTANTS c_i TYPE c VALUE 'I' ##NO_TEXT.
    CONSTANTS c_s TYPE c VALUE 'S' ##NO_TEXT.
    CONSTANTS c_sj TYPE c VALUE '1' ##NO_TEXT.
    CONSTANTS c_al TYPE c VALUE '2' ##NO_TEXT.
    CONSTANTS c_he TYPE c VALUE '3' ##NO_TEXT.
    CONSTANTS c_ca TYPE c VALUE '4' ##NO_TEXT.
    CONSTANTS c_pt TYPE c VALUE '5' ##NO_TEXT.
    CONSTANTS c_gn TYPE c VALUE '6' ##NO_TEXT.
    CONSTANTS c_lm TYPE c VALUE '7' ##NO_TEXT.
    CONSTANTS c_08 TYPE c VALUE '8' ##NO_TEXT.
    CONSTANTS c_09 TYPE c VALUE '9' ##NO_TEXT.
    CONSTANTS c_email_regex TYPE c VALUE '\w+(\.\w+)*@(\w+\.)+(\w{2,4})' ##NO_TEXT.

    CLASS-METHODS get_list_fields
      IMPORTING
        !str_table       TYPE dd02l-tabname
      RETURNING
        VALUE(rt_fields) TYPE string .
    CLASS-METHODS validate_email
      IMPORTING
        !email          TYPE ad_smtpadr
      RETURNING
        VALUE(type_msg) TYPE char1 .
    CLASS-METHODS get_randm_string
      IMPORTING
        number_string TYPE i DEFAULT 1
      RETURNING
        VALUE(random_string) TYPE string.

    INTERFACES if_oo_adt_classrun.
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


  METHOD get_randm_string.
    CALL FUNCTION 'GENERAL_GET_RANDOM_STRING'
      EXPORTING
        number_chars  = number_string
      IMPORTING
        random_string = random_string.
  ENDMETHOD.

  METHOD validate_email.

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

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA(ld_text) = |Output implementaion interface if_oo_adt_classrun~main|.
    out->write( ld_text ).
    data(random) = me->get_randm_string( 2 ).
     out->write( random ).
  ENDMETHOD.
ENDCLASS.
