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

    DATA ls_customers TYPE zcustomers.

    DATA lv_count TYPE i.

    lv_count = 1.
    ls_customers-customerid = lv_count.

    ls_customers-customerid = |{ ls_customers-customerid  ALPHA = IN }|.

    TYPES l_zcustomers TYPE TABLE OF zcustomers WITH EMPTY KEY.

    lt_customers = VALUE l_zcustomers( FOR i = 1 UNTIL i > 10
                                     ( customerid = i
                                       orderid = 1
                                       name = zcl_global_utils=>generate_char_number( i ) ) ).

BREAK-POINT.
    WRITE ls_customers-customerid .


  ENDMETHOD.

  METHOD reference_integer.
    TYPES t_itab TYPE TABLE OF i WITH EMPTY KEY.
    DATA(number) = NEW t_itab( FOR i = 1 UNTIL i > 10
                           ( i ) ).
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(lc_sales_v1) = NEW lcl_sales_v1( ).
  lc_sales_v1->create_mock_zcustomer( ).
