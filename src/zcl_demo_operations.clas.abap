CLASS zcl_demo_operations DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tt_demo TYPE STANDARD TABLE OF demo_update WITH EMPTY KEY.

    DATA: it_demo        TYPE STANDARD TABLE OF demo_update,
          wa_demo_update TYPE demo_update.

    METHODS random_string
      IMPORTING
        !number_string TYPE i DEFAULT 1
      EXPORTING
        !random_string TYPE string .

    METHODS generate_workarea.

    METHODS modify_demo.

    METHODS insert_demo.

    METHODS delete_demo.

    METHODS update_demo
      IMPORTING
                wa_demo       TYPE demo_update
                it_demo       TYPE tt_demo
                option        TYPE c
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS commit_work.

    CLASS-METHODS generate_char_hexadecimal
      IMPORTING
        ascii TYPE x
      EXPORTING
        char  TYPE char10.

    CLASS-METHODS generate_char_number
      IMPORTING
                ascii       TYPE i
      RETURNING VALUE(char) TYPE char10.

    CLASS-METHODS: generate_data_demo
      RETURNING VALUE(it_demo) TYPE tt_demo.

    CLASS-METHODS: generate_data_while
      RETURNING VALUE(it_demo) TYPE tt_demo.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEMO_OPERATIONS IMPLEMENTATION.


  METHOD commit_work.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDMETHOD.


  METHOD delete_demo.
    DELETE FROM demo_update.
  ENDMETHOD.


  METHOD generate_char_hexadecimal.
    DATA: class_convert TYPE REF TO cl_abap_conv_in_ce.

    class_convert = cl_abap_conv_in_ce=>create( encoding = 'UTF-8' ).

    class_convert->convert( EXPORTING input = ascii
                            IMPORTING data  = char ).

  ENDMETHOD.


  METHOD  generate_char_number.

    char = cl_abap_conv_in_ce=>uccpi( ascii ).

  ENDMETHOD.


  METHOD generate_data_demo.

    it_demo = VALUE #( FOR j = 65 THEN j + 1 UNTIL j > 90
                 ( id =  zcl_global_utils=>generate_char_number( j )
                   col1 = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 1
                                                                                              max    = 10
                                                                                          )
                    col2 = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 1
                                                                                              max    = 100
                                                                                          )
                    col3 = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 1
                                                                                              max    = 1000
                                                                                          )
                    col4 = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 1
                                                                                              max    = 10
                                                                                          )  ) ).

  ENDMETHOD.


  METHOD generate_data_while.
    DATA lv_count  TYPE i VALUE 65.
    WHILE lv_count  <= 90.

      APPEND VALUE #( id = zcl_global_utils=>generate_char_number( lv_count )
                    col1 = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 1
                                                                                              max    = 10
                                                                                          )
                    col2 = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 1
                                                                                              max    = 100
                                                                                          )
                    col3 = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 1
                                                                                              max    = 1000
                                                                                          )
                    col4 = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 1
                                                                                              max    = 10
                                                                                          )
                    ) TO it_demo.

      lv_count = lv_count + 1.

    ENDWHILE.
  ENDMETHOD.


  METHOD generate_workarea.
    CLEAR wa_demo_update.
    wa_demo_update-col1 = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                      min    = 1
                                                                      max    = 10
                                                                  ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA(ld_text) = |Output CLASS DEMO Operations|.
    out->write( ld_text ).

    FREE it_demo.
    it_demo = me->generate_data_demo( ).
    out->write( it_demo ).
    it_demo = me->generate_data_while(  ).
    out->write( it_demo ).
    out->write( |Modify DEMO Operations| ).
    me->delete_demo(  ).
    me->modify_demo(  ).


  ENDMETHOD.


  METHOD insert_demo.
    DATA :lx_root TYPE REF TO cx_root,
          err_msg TYPE char200.
    TRY.
        INSERT demo_update FROM TABLE it_demo.
      CATCH cx_root INTO lx_root.

        err_msg = lx_root->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD modify_demo.
    DATA :lx_root TYPE REF TO cx_root,
          err_msg TYPE char200.
    TRY.
        MODIFY demo_update FROM TABLE it_demo.
      CATCH cx_root INTO lx_root.

        err_msg = lx_root->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD random_string.

    CALL FUNCTION 'GENERAL_GET_RANDOM_STRING'
      EXPORTING
        number_chars  = number_string
      IMPORTING
        random_string = random_string.
  ENDMETHOD.


  METHOD update_demo.

    CASE option.
      WHEN '1'.
        UPDATE demo_update FROM wa_demo.
        IF sy-subrc EQ 0.
          result = abap_true.
        ENDIF.
      WHEN '2'.
        UPDATE demo_update FROM TABLE it_demo.
        IF sy-subrc EQ 0.
          result = abap_true.
        ENDIF.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
