class ZCL_GLOBAL_UTILS definition
  public
  final
  create public .

public section.

  interfaces IF_OO_ADT_CLASSRUN .

  types:
    tt_inttab TYPE STANDARD TABLE OF i WITH EMPTY KEY .

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
  constants C_C type C value 'C' ##NO_TEXT.
  constants C_R type C value 'R' ##NO_TEXT.
  constants C_U type C value 'U' ##NO_TEXT.
  constants C_D type C value 'D' ##NO_TEXT.
  constants C_A type C value 'A' ##NO_TEXT.

  class-methods GET_LIST_FIELDS
    importing
      !STR_TABLE type DD02L-TABNAME
    returning
      value(RT_FIELDS) type STRING .
  class-methods VALIDATE_EMAIL
    importing
      !EMAIL type AD_SMTPADR
    returning
      value(TYPE_MSG) type CHAR1 .
  class-methods GET_RANDM_STRING
    importing
      !NUMBER_STRING type I default 1
    returning
      value(RANDOM_STRING) type STRING .
  class-methods GET_RANDOM_NUMBERS
    importing
      !OPTION type C default 'I'
      !MIN type I
      !MAX type I
      !TIME_D type I
    exporting
      !INTTAB type TT_INTTAB
      !INT8 type INT8
      !FLOAT type F
      !PACKED type P .
  class-methods GET_RANDOM_NUMBERS_INT
    importing
      !MIN type I
      !MAX type I
    returning
      value(NUMBER) type I .
  class-methods GENERATE_CHAR_NUMBER
    importing
      !ASCII type I
    returning
      value(CHAR) type CHAR10 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GLOBAL_UTILS IMPLEMENTATION.


  METHOD  generate_char_number.

    char = cl_abap_conv_in_ce=>uccpi( ascii ).

  ENDMETHOD.


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


  METHOD get_random_numbers.

    IF option EQ c_i.
      DATA(lo_random) = cl_abap_random_int=>create( seed = cl_abap_random=>seed( )
                                                    min  = min
                                                    max = max ).

      DO  time_d  TIMES.
        DATA(lv_random_num) = lo_random->get_next( ).
        INSERT lv_random_num INTO TABLE inttab.

      ENDDO.
    ENDIF.

  ENDMETHOD.


  METHOD get_random_numbers_int.

    DATA(lo_random) = cl_abap_random_int=>create( seed = cl_abap_random=>seed( )
                                                  min  = min
                                                  max = max ).

    number = lo_random->get_next( ).

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA(ld_text) = |Output implementaion interface if_oo_adt_classrun~main|.
    out->write( ld_text ).
    DATA(random) = me->get_randm_string( 2 ).
    out->write( random ).
    DATA it_int TYPE tt_inttab.
    me->get_random_numbers(
      EXPORTING
        option = 'I'
        min    = 1
        max    = 100
        time_d = 10
      IMPORTING
        inttab = it_int ).
    out->write( it_int ).

    DATA(lv_int) = me->get_random_numbers_int(
                   min    =  1
                   max    =  100
               ).
    out->write( lv_int ).
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
ENDCLASS.
