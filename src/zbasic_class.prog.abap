*&---------------------------------------------------------------------*
*& Report zbasic_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbasic_class.
TYPES: BEGIN OF str_conn,
         cityfrom  TYPE   s_from_cit,
         countryfr TYPE   land1,
         cityto    TYPE   s_to_city,
         countryto TYPE   land1,
         fltime    TYPE   s_fltime,
         distance  TYPE   s_distance,
       END OF str_conn.

DATA wa_conn TYPE str_conn.

*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE TEXT-001.

SELECTION-SCREEN BEGIN OF BLOCK block2 WITH FRAME TITLE TEXT-t02.
PARAMETERS: p_all  RADIOBUTTON GROUP alv USER-COMMAND ur1 DEFAULT 'X',
            p_conn RADIOBUTTON GROUP alv,
            p_numf RADIOBUTTON GROUP alv,
            p_aip  RADIOBUTTON GROUP alv,
            p_time RADIOBUTTON GROUP alv,
            p_zpfl RADIOBUTTON GROUP alv.
SELECTION-SCREEN END OF BLOCK block2.

SELECTION-SCREEN BEGIN OF BLOCK block3 WITH FRAME TITLE TEXT-t05.
SELECTION-SCREEN SKIP.
PARAMETERS: p_con TYPE spfli-connid MODIF ID mcn,
            p_air TYPE s_airport MODIF ID mai,
            p_ade TYPE s_fromairp MODIF ID air,
            p_afr TYPE s_toairp MODIF ID air.
SELECTION-SCREEN END OF BLOCK block3.

SELECTION-SCREEN END OF BLOCK block1.


*------CLASS SECTION---------------------------------------------------*
CLASS lcl_flight_model DEFINITION.

  PUBLIC SECTION.
    TYPES: tt_connid TYPE STANDARD TABLE OF spfli-connid.

    METHODS:
      constructor IMPORTING wa_tablename     TYPE dd02l-tabname,

      show_message IMPORTING l_msg1 TYPE any
                             l_msg2 TYPE any
                             l_msg3 TYPE any OPTIONAL,

      showalldata,

      showconniddata IMPORTING conn TYPE spfli-connid,

      numflightsto IMPORTING aircode           TYPE s_airport
                   RETURNING VALUE(numflights) TYPE i,

      getconnid IMPORTING airpfrom      TYPE s_fromairp
                          airpto        TYPE s_toairp
                EXPORTING it_connid     TYPE tt_connid
                RETURNING VALUE(connid) TYPE s_conn_id,

      getflighttime IMPORTING connid      TYPE s_conn_id
                    RETURNING VALUE(time) TYPE spfli-fltime,

      getallconnectionfacts IMPORTING connid          TYPE s_conn_id
                            RETURNING VALUE(wa_spfli) TYPE zspfli.

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
*&---------------------------------------------------------------------*

CLASS lcl_flight_model IMPLEMENTATION.

  METHOD constructor.

    DATA(lv_fields) = me->get_fields_list( wa_tablename ).

    SELECT (lv_fields)
        FROM spfli
        INTO TABLE gt_spfli_sorted.

    IF sy-subrc NE 0.

    ENDIF.

  ENDMETHOD.
*&---------------------------------------------------------------------*
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
*&---------------------------------------------------------------------*
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
*&---------------------------------------------------------------------*
  METHOD showconniddata.
    BREAK-POINT.

    DATA lv_output  TYPE zconnid_report.

    IF line_exists( gt_spfli_sorted[ connid = conn ] ).

      DATA(ls_result) = gt_spfli_sorted[ connid = conn ].

      lv_output = CORRESPONDING #( ls_result ).

      me->show_message( l_msg1 = |Connection Information| l_msg2 = lv_output ).

    ELSE.
      DATA(lv_msg) = |No record found matching connid: { conn }|.
      MESSAGE lv_msg  TYPE 'I'.

    ENDIF.

  ENDMETHOD.
*&---------------------------------------------------------------------*

  METHOD numflightsto.

    "TO Airport
    numflights = REDUCE i( INIT lv_cont = 0 FOR wa_flight IN gt_spfli_sorted
                           WHERE ( airpto = aircode ) NEXT lv_cont = lv_cont + 1 ).

  ENDMETHOD.
*&---------------------------------------------------------------------*
  METHOD show_message.

    cl_demo_output=>new(
    )->begin_section( l_msg1
    )->write_data( l_msg2
    )->write_data( l_msg3
    )->display( ).
  ENDMETHOD.
*&---------------------------------------------------------------------*
  METHOD getconnid.

    IF lines( gt_spfli_sorted ) NE 0.

      "return one record
      connid = gt_spfli_sorted[ airpfrom = airpfrom airpto = airpto ]-connid.
      "return table with the matching keys
      it_connid = VALUE #( FOR wa_spfli IN gt_spfli_sorted
                           WHERE ( airpfrom = airpfrom AND airpto = airpto )
                                 ( wa_spfli-connid ) ).

      IF connid IS INITIAL.

        connid = 0.
      ENDIF.

    ENDIF.

  ENDMETHOD.
*&---------------------------------------------------------------------*
  METHOD getflighttime.

    time = gt_spfli_sorted[ connid = connid ]-fltime.

  ENDMETHOD.
*&---------------------------------------------------------------------*
  METHOD getallconnectionfacts.
    wa_spfli = gt_spfli_sorted[ connid = connid ].
  ENDMETHOD.

ENDCLASS.
*&---------------------------------------------------------------------*
INITIALIZATION.

  DATA lv_ucomm TYPE sy-ucomm.
  lv_ucomm = 'UR1'.

  DATA(lo_flight_mode) = NEW lcl_flight_model( zcl_global_utils=>c_str_flight ).
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN.
  lv_ucomm = sy-ucomm.

*&---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  CASE lv_ucomm.
    WHEN 'UR1'.
      IF  p_all EQ abap_true.
        LOOP AT SCREEN.
          IF screen-group1 = 'MCN'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
          IF screen-group1 = 'MAI'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
          IF screen-group1 = 'AIR'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF p_conn EQ abap_true OR p_time EQ abap_true OR p_zpfl EQ abap_true.
        LOOP AT SCREEN.
          IF screen-group1 = 'MCN'.
            screen-active = 1.
            MODIFY SCREEN.
          ENDIF.
          IF screen-group1 = 'MAI'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
          IF screen-group1 = 'AIR'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF p_numf EQ abap_true.
        LOOP AT SCREEN.
          IF screen-group1 = 'MCN'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
          IF screen-group1 = 'MAI'.
            screen-active = 1.
            MODIFY SCREEN.
          ENDIF.
          IF screen-group1 = 'AIR'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF p_aip EQ abap_true.
        LOOP AT SCREEN.
          IF screen-group1 = 'MCN'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
          IF screen-group1 = 'MAI'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
          IF screen-group1 = 'AIR'.
            screen-active = 1.
            MODIFY SCREEN.
          ENDIF.
        ENDLOOP.
      ENDIF.
  ENDCASE.

*&---------------------------------------------------------------------*
START-OF-SELECTION.

  BREAK-POINT.

  CASE abap_true.
    WHEN p_all.
      lo_flight_mode->showalldata( ).
    WHEN p_conn.
      lo_flight_mode->showconniddata( p_con ).
    WHEN p_numf.
      DATA(lv_numflights) = lo_flight_mode->numflightsto( p_air ).
      lo_flight_mode->show_message( l_msg1 = |Flight numbers| l_msg2 = lv_numflights ).
    WHEN p_aip.
      DATA it_connid TYPE STANDARD TABLE OF spfli-connid.

      DATA(lv_conid) = lo_flight_mode->getconnid( EXPORTING airpfrom = p_ade
                                                            airpto = p_afr
                                                  IMPORTING it_connid = it_connid ).
      lo_flight_mode->show_message( l_msg1 = |Connection ID| l_msg2 = lv_conid l_msg3 = it_connid ).

    WHEN p_time.
      DATA(lv_time) = lo_flight_mode->getflighttime( p_con ).
      lo_flight_mode->show_message( l_msg1 = |Time flight| l_msg2 = lv_time ).
    WHEN p_zpfl.
      DATA(wa_zspli) = lo_flight_mode->getallconnectionfacts( p_con ).
      lo_flight_mode->show_message( l_msg1 = |Connection Facts| l_msg2 = wa_zspli ).
  ENDCASE.
