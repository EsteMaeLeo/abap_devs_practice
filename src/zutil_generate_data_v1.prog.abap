*&---------------------------------------------------------------------*
*& Report ZUTIL_GENERATE_DATA_V1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zutil_generate_data_v1.

SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE TEXT-t04.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK block2 WITH FRAME TITLE TEXT-t10.

"CRUD
PARAMETERS: p_creat1 RADIOBUTTON GROUP crud.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS  p_creat2 RADIOBUTTON  GROUP crud.
SELECTION-SCREEN COMMENT 3(70) TEXT-t01 FOR FIELD p_creat2.
SELECTION-SCREEN END OF LINE.

PARAMETERS: p_update RADIOBUTTON GROUP crud,
            p_delete RADIOBUTTON GROUP crud,
            p_modify RADIOBUTTON GROUP crud.

SELECTION-SCREEN END OF BLOCK block2.

SELECTION-SCREEN END OF BLOCK block1.


CLASS lcl_sales_v1 DEFINITION FINAL.

  PUBLIC SECTION.

    CLASS-DATA: lv_rows TYPE i.

    METHODS: create_mock_zcustomer,
      create_refdata,
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

  METHOD create_refdata.

    lcl_sales_v1=>lv_rows = 10.

    SELECT FROM zuploadpersoncr
      FIELDS id, code_electoral, name, first_last_name
      INTO TABLE @DATA(it_person)
      UP TO @lcl_sales_v1=>lv_rows ROWS.

    IF LINES( it_person ) NE 0.



    ENDIF.
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

INITIALIZATION.
  DATA(lc_sales_v1) = NEW lcl_sales_v1( ).
  lcl_sales_v1=>lv_rows = 0.

START-OF-SELECTION.

  CASE abap_true.
    WHEN p_creat1.
      lc_sales_v1->create_mock_zcustomer( ).
    WHEN p_creat2.
      lc_sales_v1->create_refdata( ).
  ENDCASE.
