*&---------------------------------------------------------------------*
*& Report ZUTIL_GENERATE_DATA_V1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zutil_generate_data_v1.

CLASS lcl_sales_v1 DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS: create_mock_zcustomer,
      reference_integer.

  PRIVATE SECTION.
    DATA: lt_customers TYPE STANDARD TABLE OF zcustomers.

ENDCLASS.

CLASS lcl_sales_v1 IMPLEMENTATION.

  METHOD create_mock_zcustomer.

    TYPES tt_zcustomers TYPE TABLE OF zcustomers WITH EMPTY KEY.

    DATA :lx_root TYPE REF TO cx_root,
          err_msg TYPE char200.

    lt_customers = VALUE tt_zcustomers( FOR i = 1 UNTIL i > 10
                                     ( customerid = i
                                       orderid    = 1
                                       name       = zcl_global_utils=>get_randm_string( 10 )
                                       address    = |Address 1|
                                       city       = |Springfield|
                                       country    = |USA|
                                       postalcode = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 999
                                                                                              max    = 999 )
                                       phone = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 99999
                                                                                              max    = 99999 ) ) ).

    cl_demo_output=>display( lt_customers ).

    DELETE FROM zcustomers.

    TRY.
        INSERT zcustomers FROM TABLE  lt_customers.
      CATCH cx_root INTO lx_root.

        err_msg = lx_root->get_text( ).
    ENDTRY.


  ENDMETHOD.

  METHOD reference_integer.
    TYPES t_itab TYPE TABLE OF i WITH EMPTY KEY.
    DATA(number) = NEW t_itab( FOR i = 1 UNTIL i > 10
                           ( i ) ).
    DATA ls_customers TYPE zcustomers.

    DATA lv_count TYPE i.

    lv_count = 1.
    ls_customers-customerid = lv_count.

    ls_customers-customerid = |{ ls_customers-customerid  ALPHA = IN }|.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(lc_sales_v1) = NEW lcl_sales_v1( ).
  lc_sales_v1->create_mock_zcustomer( ).
