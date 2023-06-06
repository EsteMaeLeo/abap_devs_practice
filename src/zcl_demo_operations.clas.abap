CLASS zcl_demo_operations DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA: wa_demo_update TYPE demo_update.

    METHODS random_string
      IMPORTING
        !number_string TYPE i DEFAULT 1
      EXPORTING
        !random_string TYPE string .
    CLASS-METHODS generate_char_hexadecimal
      IMPORTING
        ascii TYPE x
      EXPORTING
        char  TYPE char10.

    CLASS-METHODS generate_char_number
      IMPORTING
                ascii       TYPE i
      RETURNING VALUE(char) TYPE char10.

    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_demo_operations IMPLEMENTATION.


  METHOD generate_char_hexadecimal.
    DATA: class_convert TYPE REF TO cl_abap_conv_in_ce.

    class_convert = cl_abap_conv_in_ce=>create( encoding = 'UTF-8' ).

    class_convert->convert( EXPORTING input = ascii
                            IMPORTING data  = char ).

  ENDMETHOD.

  METHOD  generate_char_number.

    char = cl_abap_conv_in_ce=>uccpi( ascii ).

  ENDMETHOD.

  METHOD random_string.

    CALL FUNCTION 'GENERAL_GET_RANDOM_STRING'
      EXPORTING
        number_chars  = number_string
      IMPORTING
        random_string = random_string.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA(ld_text) = |Output implementaion interface if_oo_adt_classrun~main|.
    out->write( ld_text ).

    DATA lv_char TYPE char10.
    DATA lv_count  TYPE i VALUE 65.
    DATA it_demo TYPE STANDARD TABLE OF demo_update.
    WHILE lv_count  <= 90.

      CLEAR wa_demo_update.
      lv_char = me->generate_char_number( lv_count ).
      out->write( lv_char ).
      lv_count = lv_count + 1.

      wa_demo_update-col1 = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                          min    = 1
                                                                          max    = 10
                                                                      ).
      APPEND VALUE #( id = lv_char
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
    ENDWHILE.
    out->write( it_demo ).
    DATA: num TYPE i VALUE 65.


  ENDMETHOD.
ENDCLASS.
