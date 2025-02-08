*&---------------------------------------------------------------------*
*& Report zph_hana_01_sql_con
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zph_hana_01_sql_con.

SELECT * FROM spfli USING CLIENT '000'
"SELECT * FROM spfli
    CONNECTION hanavmdb
    INTO TABLE @DATA(gt_flights).

IF sy-subrc EQ 0.
  cl_demo_output=>display( gt_flights ).
ENDIF.

FREE gt_flights.

*** ADBC with ABAP

DATA: go_connection TYPE REF TO cl_sql_connection,
      go_statement  TYPE REF TO cl_sql_statement,
      go_result     TYPE REF TO cl_sql_result_set,
      gx_sql_excep  TYPE REF TO cx_sql_exception,
      gv_sql        TYPE string,
      gt_flight     TYPE STANDARD TABLE OF sflight,
      gr_flight     TYPE REF TO data.


TRY.

    go_connection = cl_sql_connection=>get_connection( 'HANAVMDB' ).

    go_statement = go_connection->create_statement(  ).

    gv_sql = |SELECT TOP 50 * FROM "SFLIGHT"."SFLIGHT"|.

    go_result = go_statement->execute_query( gv_sql ).

    "GET REFERENCE OF
    gr_flight = REF #( gt_flight ).

    go_result->set_param_table( gr_flight ).

    go_result->next_package(  ).

    go_result->close(  ).

  CATCH cx_sql_exception INTO gx_sql_excep.
    WRITE gx_sql_excep->get_text(  ).
ENDTRY.

IF NOT gr_flight IS INITIAL.
  cl_demo_output=>display( gt_flight ).
ENDIF.
