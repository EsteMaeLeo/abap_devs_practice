*&---------------------------------------------------------------------*
*& Report zph_hana_01_sql_con
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zph_hana_01_sql_con.

SELECT * FROM SPFLI USING CLIENT '000'
    CONNECTION hanavmdb
    INTO TABLE @DATA(gt_flights).

IF sy-subrc EQ 0.
  cl_demo_output=>display( gt_flights ).
ENDIF.
