*&---------------------------------------------------------------------*
*& Report zbasic_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbasic_class.
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE TEXT-001.

PARAMETERS: p_all  RADIOBUTTON GROUP alv,
            p_conn RADIOBUTTON GROUP alv,
            p_numf RADIOBUTTON GROUP alv.

SELECTION-SCREEN END OF BLOCK block1.


*------CLASS SECTION---------------------------------------------------*
CLASS lcl_flight_model DEFINITION.

  PUBLIC SECTION.
    METHODS: constructor IMPORTING wa_tablename     TYPE dd02l-tabname,
      showalldata.

  PROTECTED SECTION.

  PRIVATE SECTION.
    TYPES: tt_spfli_sorted   TYPE SORTED TABLE OF zspfli,
           tt_spfli_hash     TYPE HASHED TABLE OF zspfli,
           tt_spfli_standard TYPE STANDARD TABLE OF zspfli.

    DATA: gt_spfli_sorted   TYPE SORTED TABLE OF zspfli  WITH UNIQUE KEY carrid connid,
          gt_spfli_hash     TYPE HASHED TABLE OF zspfli WITH UNIQUE KEY carrid connid,
          gt_splfi_standard TYPE STANDARD TABLE OF zspfli.

    METHODS: get_fields_list IMPORTING wa_tablename     TYPE dd02l-tabname
                             RETURNING VALUE(rt_fields) TYPE string.


ENDCLASS.


CLASS lcl_flight_model IMPLEMENTATION.

  METHOD constructor.
    BREAK-POINT.
    DATA(lv_fields) = me->get_fields_list( wa_tablename ).

    SELECT (lv_fields)
        FROM spfli
        INTO TABLE gt_spfli_sorted.

    IF sy-subrc NE 0.

    ENDIF.

  ENDMETHOD.

  METHOD get_fields_list.

    DATA lt_catalog TYPE slis_t_fieldcat_alv.
    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = wa_tablename
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

  METHOD showalldata.
    DATA: gr_table   TYPE REF TO cl_salv_table.
    TRY.
        gt_splfi_standard[] = gt_spfli_sorted[].

        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = gr_table
          CHANGING
            t_table      = gt_splfi_standard ).
      CATCH cx_salv_msg.                                "#EC NO_HANDLER
    ENDTRY.

    DATA: lr_functions TYPE REF TO cl_salv_functions_list.

    lr_functions = gr_table->get_functions( ).
    lr_functions->set_default( abap_true ).

*... set the columns technical
    DATA: lr_columns TYPE REF TO cl_salv_columns.

    lr_columns = gr_table->get_columns( ).
    lr_columns->set_optimize( abap_true ).
    gr_table->display( ).
  ENDMETHOD.

ENDCLASS.


INITIALIZATION.

  DATA(lo_flight_mode) = NEW lcl_flight_model( zcl_global_utils=>c_str_flight ).

START-OF-SELECTION.

  BREAK-POINT.

  CASE abap_true.
    WHEN p_all.
      lo_flight_mode->showalldata( ).
  ENDCASE.
