*&---------------------------------------------------------------------*
*&  Include           ZEXA_ALV001_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Include           ZEXA_ALV001_FORM01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fieldcat CHANGING ch_fieldcat TYPE slis_t_fieldcat_alv.

  CASE abap_true.
    WHEN p_normal.
      PERFORM f_catprogram CHANGING ch_fieldcat.
    WHEN p_all.
      PERFORM f_alv_merge_cat CHANGING ch_fieldcat.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_catprogram
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_catprogram CHANGING ch_fieldcat TYPE slis_t_fieldcat_alv.
  DATA ls_fieldcat TYPE slis_fieldcat_alv.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CARRID'.
  ls_fieldcat-seltext_l = 'Airline Code'.
  ls_fieldcat-key = abap_true.
  INSERT ls_fieldcat INTO TABLE ch_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CONNID'.
  ls_fieldcat-seltext_l = 'Connection Number'.
  ls_fieldcat-key = abap_true.
  INSERT ls_fieldcat INTO TABLE ch_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CITYFROM'.
  ls_fieldcat-seltext_l = 'Departure city'.
  INSERT ls_fieldcat INTO TABLE ch_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CITYTO'.
  ls_fieldcat-seltext_l = 'Arrival city'.
  INSERT ls_fieldcat INTO TABLE ch_fieldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ALV_MERGE_CAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_alv_merge_cat CHANGING ch_fieldcat TYPE slis_t_fieldcat_alv.

*merge FIELD catalog
  DATA lv_structure TYPE dd02l-tabname.
  lv_structure = zcl_global_utils=>c_str_flight.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = lv_structure
    CHANGING
      ct_fieldcat            = ch_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv_list.

  DATA: it_event  TYPE slis_t_event.

  PERFORM f_add_eventes CHANGING it_event.

  CASE abap_true.
    WHEN p_normal.
      PERFORM f_list_flights USING gt_flights
                                   it_event.
    WHEN p_all.
      PERFORM f_list_flights_dict USING gt_flights_field
                                        it_event.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_list_flights
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_list_flights USING us_flights TYPE tt_flights
                          us_events  TYPE slis_t_event.

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER =
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET       = ' '
*     I_CALLBACK_USER_COMMAND        = ' '
*     I_STRUCTURE_NAME   =
*     IS_LAYOUT          =
      it_fieldcat        = gt_fieldcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
      it_events          = us_events
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN          = 0
*     I_SCREEN_START_LINE            = 0
*     I_SCREEN_END_COLUMN            = 0
*     I_SCREEN_END_LINE  = 0
*     IR_SALV_LIST_ADAPTER           =
*     IT_EXCEPT_QINFO    =
*     I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER        =
*     ES_EXIT_CAUSED_BY_USER         =
    TABLES
      t_outtab           = us_flights
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_list_flights_dict
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_list_flights_dict USING us_flights TYPE tt_flights_field
                               us_events  TYPE slis_t_event.

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER =
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET       = ' '
*     I_CALLBACK_USER_COMMAND        = ' '
*     I_STRUCTURE_NAME   =
*     IS_LAYOUT          =
      it_fieldcat        = gt_fieldcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
      it_events          = us_events
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN          = 0
*     I_SCREEN_START_LINE            = 0
*     I_SCREEN_END_COLUMN            = 0
*     I_SCREEN_END_LINE  = 0
*     IR_SALV_LIST_ADAPTER           =
*     IT_EXCEPT_QINFO    =
*     I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER        =
*     ES_EXIT_CAUSED_BY_USER         =
    TABLES
      t_outtab           = us_flights
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .

  CASE abap_true.
    WHEN p_normal.
      PERFORM f_data_program CHANGING gt_flights.
    WHEN p_all.
      PERFORM f_data_allfields CHANGING  gt_flights_field.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_data_program
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_data_program CHANGING us_flights TYPE tt_flights.

  SELECT carrid
          connid
          cityfrom
          cityto
     FROM spfli
     INTO TABLE us_flights
          WHERE carrid IN so_carr.

  IF sy-subrc EQ 0.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_data_allfields
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_data_allfields CHANGING us_flights TYPE tt_flights_field.

  DATA lv_fields TYPE string.

  PERFORM f_generate_fields USING   gt_fieldcat
                            CHANGING lv_fields.

  SELECT (lv_fields)
    FROM spfli
    INTO TABLE us_flights
   WHERE carrid IN so_carr.

  IF sy-subrc EQ 0.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form f_generate_fields
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_generate_fields USING    us_table TYPE slis_t_fieldcat_alv
                       CHANGING ch_fields TYPE string.

*Instead using loop and concatenate Using Reduce.
*  data lv_line type string.
*  LOOP AT us_table ASSIGNING FIELD-SYMBOL(<fs_table>).
*
*    lv_line = |{ lv_line } { <fs_table>-fieldname } |.
*
*  ENDLOOP.
*  SHIFT lv_line LEFT DELETING LEADING '*'.CONDENSE: lv_line.
  "USing new sintax 7.4 instead using loop using REDUCE

  ch_fields =
        REDUCE string( INIT text = `` sep = ``
         FOR  wa_table IN us_table
          NEXT text = |{ text }{ sep }{ wa_table-fieldname }| sep = ` ` ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV_GRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv_grid .

  DATA: lv_layout TYPE slis_layout_alv,
        it_event  TYPE slis_t_event.

  PERFORM f_build_layout CHANGING lv_layout.

  PERFORM f_add_eventes CHANGING it_event.

  CASE abap_true.
    WHEN p_normal.
      PERFORM f_list_flights_grid USING gt_flights
                                        lv_layout
                                        it_event.
    WHEN p_all.
      PERFORM f_list_flights_dict_grid USING gt_flights_field
                                             lv_layout
                                             it_event.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LIST_FLIGHTS_GRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FLIGHTS  text
*----------------------------------------------------------------------*
FORM f_list_flights_grid  USING us_flights TYPE tt_flights
                                us_layout  TYPE slis_layout_alv
                                us_event   TYPE slis_t_event.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'SET_PF_STATUS '
      i_callback_user_command  = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE   = '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
*     I_GRID_SETTINGS          =
      is_layout                = us_layout
      it_fieldcat              = gt_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS        =
*     IT_SORT                  =
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
*     I_SAVE                   = ' '
*     IS_VARIANT               =
      it_events                = us_event
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = us_flights
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LIST_FLIGHTS_DICT_GRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FLIGHTS_FIELD  text
*----------------------------------------------------------------------*
FORM f_list_flights_dict_grid  USING us_flights TYPE tt_flights_field
                                     us_layout  TYPE slis_layout_alv
                                     us_event   TYPE slis_t_event.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'SET_PF_STATUS '
      i_callback_user_command  = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE   = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
*     I_GRID_SETTINGS          =
      is_layout                = us_layout
      it_fieldcat              = gt_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS        =
*     IT_SORT                  =
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
*     I_SAVE                   = ' '
*     IS_VARIANT               =
      it_events                = us_event
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = us_flights
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_layout CHANGING ch_layout TYPE slis_layout_alv.

  ch_layout-zebra = abap_true.
  ch_layout-edit = abap_true.

ENDFORM.

*Create form standard for ALV
FORM user_command  USING r_ucomm LIKE sy-ucomm
                                   rs_selfield TYPE slis_selfield.
  CASE r_ucomm.
    WHEN '&INF'.
      MESSAGE 'FLIGHTS Details' TYPE 'I'.
  ENDCASE.
ENDFORM.
*set new pf ststus copy the firm
FORM set_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZSTANDARD'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_EVENTES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_IT_EVENT  text
*----------------------------------------------------------------------*
FORM f_add_eventes  CHANGING ch_event TYPE slis_t_event .

  DATA: wa_events TYPE slis_alv_event.

  wa_events-name = 'TOP_OF_PAGE'.
  wa_events-form = 'TOP_OF_PAGE'.
  INSERT wa_events INTO TABLE ch_event.

  "You can get all event using the FM  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'

ENDFORM.

FORM top_of_page.

  DATA: it_listheader TYPE slis_t_listheader,
        wa_listheader TYPE slis_listheader.

  CASE abap_true.
    WHEN p_list.
      WRITE: / |Hour|, sy-uzeit ENVIRONMENT TIME FORMAT,
             / |User|, sy-uname.
    WHEN p_grid.

      wa_listheader-typ = |H|.
      wa_listheader-info = |Avalable Flights|.
      INSERT wa_listheader INTO TABLE it_listheader.

      CLEAR wa_listheader.
      wa_listheader-typ = |S|.
      wa_listheader-info = | User: { sy-uname } |.
      INSERT wa_listheader INTO TABLE it_listheader.

      CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
        EXPORTING
          it_list_commentary = it_listheader
*         I_LOGO             =
*         I_END_OF_LIST_GRID =
*         I_ALV_FORM         =
        .

  ENDCASE.
ENDFORM.
