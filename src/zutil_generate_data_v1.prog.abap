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

    TYPES: BEGIN OF ty_data,
             mandt TYPE vbak-mandt, "v~vbeln, v~telf1, v~kunnr, k~adrnr
             vbeln TYPE vbak-vbeln,
             telf1 TYPE vbak-telf1,
             kunnr TYPE kna1-kunnr,
             adrnr TYPE kna1-adrnr,
           END OF ty_data.

    TYPES tt_data TYPE TABLE OF ty_data WITH EMPTY KEY.

    TYPES tt_zcustomers TYPE TABLE OF zcustomers WITH EMPTY KEY.

    CLASS-DATA: lv_rows TYPE i.

    METHODS:
      constructor,
      get_sales_data IMPORTING rows TYPE i,
      get_sales_datav2 IMPORTING rows          TYPE i
                       RETURNING VALUE(t_data) TYPE tt_data,
      insert_zcustomer IMPORTING t_zcustomers TYPE tt_zcustomers,
      insert_zorder,
      get_address IMPORTING t_data TYPE tt_data,
      create_mock_zcustomer,
      create_refdata_zcustomer,
      reference_integer.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA: lt_customers TYPE tt_zcustomers.


ENDCLASS.

CLASS lcl_sales_v1 IMPLEMENTATION.

  METHOD constructor.

    FREE lt_customers.
    CLEAR lv_rows.

  ENDMETHOD.

  METHOD get_sales_data.

    DATA lv_client TYPE sy-mandt.

    lv_client = '800'.

    SELECT FROM vbak USING CLIENT @lv_client
      FIELDS mandt, vbeln, telf1, kunnr
      INTO TABLE @DATA(it_vbak)
      UP TO @rows ROWS.

    IF sy-subrc = 0.

      SELECT FROM kna1 USING CLIENT  @lv_client
        FIELDS kunnr, adrnr
        FOR ALL ENTRIES IN @it_vbak
        WHERE kunnr EQ @it_vbak-kunnr
        INTO TABLE @DATA(lt_ka1).

      IF sy-subrc = 0.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD get_sales_datav2.

    DATA lv_client TYPE sy-mandt.

    lv_client = '800'.

    SELECT v~mandt, v~vbeln, v~telf1, v~kunnr, k~adrnr
      FROM vbak AS v
      INNER JOIN kna1 AS k ON v~kunnr = k~kunnr
      USING CLIENT  @lv_client
      INTO TABLE @t_data
      UP TO @rows ROWS .

    IF sy-subrc EQ 0.

    ENDIF.

  ENDMETHOD.

  METHOD insert_zcustomer.
    DATA :lx_root TYPE REF TO cx_root,
          err_msg TYPE char200.
    TRY.
        INSERT zcustomers FROM TABLE  t_zcustomers.
      CATCH cx_root INTO lx_root.

        err_msg = lx_root->get_text( ).
    ENDTRY.
  ENDMETHOD.

  METHOD insert_zorder.

  ENDMETHOD.

  METHOD get_address.

    TYPES: tt_adrnr TYPE TABLE OF adrnr WITH EMPTY KEY.

    DATA(lt_adrnr) = VALUE tt_adrnr( FOR wa_data IN t_data
                              ( wa_data-adrnr ) ).



  ENDMETHOD.

  METHOD create_mock_zcustomer.

    me->get_sales_data( 20  ).
    data(t_data) = me->get_sales_datav2( 20  ).

    lt_customers = VALUE tt_zcustomers( FOR i = 1 UNTIL i > 10
                                     "let lv_orderid = t_data[ i ]-vbeln in orderid = lv_orderid
                                     ( customerid = i
                                       orderid    = t_data[ i ]-vbeln
                                       name       = zcl_global_utils=>get_randm_string( 10 )
                                       address    = |Address 1|
                                       city       = |Springfield|
                                       country    = |USA|
                                       postalcode = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 1000
                                                                                              max    = 9999 )
                                       phone = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                              min    = 1000000
                                                                                              max    = 9999999 ) ) ).

    cl_demo_output=>display( lt_customers ).

    DELETE FROM zcustomers.

    me->insert_zcustomer( lt_customers  ).


  ENDMETHOD.

  METHOD create_refdata_zcustomer.

    DATA :lx_root TYPE REF TO cx_root,
          err_msg TYPE char200.

    lcl_sales_v1=>lv_rows = 10.

    SELECT FROM zuploadpersoncr
      FIELDS id, code_electoral, name, first_last_name
      INTO TABLE @DATA(it_person)
      UP TO @lcl_sales_v1=>lv_rows ROWS.

    IF lines( it_person ) NE 0.

      DELETE FROM zcustomers.
      lcl_sales_v1=>lv_rows = 1.

      lt_customers = VALUE tt_zcustomers( FOR wa_personcr IN it_person INDEX INTO lv_index
                                          (
                                            customerid = wa_personcr-id
                                            orderid    = lv_index "wa_personcr-id + 1
                                            name       = |{ wa_personcr-name }| & | | & |{ wa_personcr-first_last_name }|
                                            address    = |Address 1|
                                            city       = |Springfield|
                                            country    = |USA|
                                            postalcode = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                                   min    = 10000
                                                                                                   max    = 99999 )
                                            phone = zcl_global_utils=>get_random_numbers_int( EXPORTING
                                                                                                   min    = 1000000
                                                                                                   max    = 9999999 ) ) ).
      IF lines( lt_customers ) NE 0.
        me->insert_zcustomer( lt_customers  ).
      ENDIF.
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
  BREAK-POINT.
  CASE abap_true.
    WHEN p_creat1.
      lc_sales_v1->create_mock_zcustomer( ).
    WHEN p_creat2.
      lc_sales_v1->create_refdata_zcustomer( ).
  ENDCASE.
