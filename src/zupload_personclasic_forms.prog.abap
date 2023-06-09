*&---------------------------------------------------------------------*
*&  Include           ZUPLOAD_PERSONCLASIC_FORMS
*&---------------------------------------------------------------------*
FORM f_modify_screen.
  IF p_server = abap_true.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR2'.
        screen-active = 0.
      ELSE.
        screen-active = 1.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ELSE.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR1'.
        screen-active = 0.
      ELSE.
        screen-active = 1.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.

  IF p_buff EQ abap_true.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR3'.
        screen-active = 1.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ELSE.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR3'.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*form for F4 files in the application server
FORM f_f4_appserver USING    us_path TYPE string
                    CHANGING ch_file TYPE string.
*F4 help for file name on SAP application server
  DATA: lv_path TYPE string.
  IF us_path IS INITIAL.
    "default path in the server.
    lv_path = TEXT-p01.
  ELSE.
    lv_path = us_path.
  ENDIF.

  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = lv_path
    IMPORTING
      serverfile       = ch_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
    MESSAGE 'Error Message' TYPE 'I'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
FORM f_process_appfile.

  DATA: lv_file TYPE string,
        lv_path TYPE string.

  "get file name
  PERFORM f_get_filename USING    p_lfile
                         CHANGING lv_file.
  "get the path and file name
  PERFORM f_get_path USING    lv_file
                              p_lpath
                     CHANGING lv_path.

  PERFORM f_opendataset USING lv_path.

  IF p_writ EQ abap_true.

    PERFORM f_writedata_set USING got_person
                                  lv_file.
  ENDIF.

  CALL FUNCTION 'ENQUEUE_EZUPLOADPERSONCR'
*   EXPORTING
*     MODE_ZUPLOADPERSONCR       = 'E'
*     ID                         =
*     X_ID                       = ' '
*     _SCOPE                     = '2'
*     _WAIT                      = ' '
*     _COLLECT                   = ' '
*   EXCEPTIONS
*     FOREIGN_LOCK               = 1
*     SYSTEM_FAILURE             = 2
*     OTHERS                     = 3
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_dele EQ abap_true. " select delte all entries table
    PERFORM f_delete_all.
  ENDIF.


  IF p_crea EQ abap_true.
    PERFORM f_insert_data.
  ENDIF.

  "PERFORM f_opendata_class USING g_filepath.

  CALL FUNCTION 'DEQUEUE_EZUPLOADPERSONCR'
* EXPORTING
*   MODE_ZUPLOADPERSONCR       = 'E'
*   ID                         =
*   X_ID                       = ' '
*   _SCOPE                     = '3'
*   _SYNCHRON                  = ' '
*   _COLLECT                   = ' '
    .
ENDFORM.

*&---------------------------------------------------------------------*
"Get file name using the logica path
FORM f_get_filename USING us_path    TYPE filename-fileintern
                    CHANGING us_file TYPE string.

  CALL FUNCTION 'FILE_GET_NAME_AND_LOGICAL_PATH'
    EXPORTING
      logical_filename           = us_path
      operating_system           = sy-opsys
    IMPORTING
      file_name                  = us_file
    EXCEPTIONS
      file_not_found             = 1
      operating_system_not_found = 2
      file_system_not_found      = 3
      OTHERS                     = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*return path and file name according passing the logical path
FORM f_get_path USING    us_file TYPE string
                         us_lpath TYPE filepath-pathintern
                CHANGING ch_path TYPE string.
  DATA lv_logic TYPE filepath-pathintern.
  IF us_lpath IS INITIAL.
    lv_logic = zcl_global_utils=>c_path_upload_peole. "default logic path
  ELSE.
    lv_logic = us_lpath.
  ENDIF.

  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      logical_path               = lv_logic
      parameter_1                = sy-mandt
      file_name                  = us_file
    IMPORTING
      file_name_with_path        = ch_path
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
FORM f_opendataset USING us_file TYPE string.

  DATA: lv_line  TYPE string.

  DATA(lv_lowercase_path) = to_lower( us_file ).

  FREE got_person.

  TRY.
      OPEN DATASET lv_lowercase_path FOR INPUT IN TEXT MODE ENCODING UTF-8 IGNORING CONVERSION ERRORS.
      IF sy-subrc = 0.
        DO.
          CLEAR gwa_person.
          READ DATASET lv_lowercase_path INTO lv_line.
          IF sy-subrc <> 0.
            EXIT.
          ELSE.
            PERFORM f_split_line USING lv_line.
            "WRITE: / lv_line.
          ENDIF.
        ENDDO.
        CLOSE DATASET lv_lowercase_path.
      ENDIF.
    CATCH cx_root INTO DATA(e_txt).
      WRITE: / e_txt->get_text( ).
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
FORM f_split_line USING us_line.

  DATA:  lv_space TYPE string.

  CLEAR gwa_person.
  SPLIT us_line AT zcl_global_utils=>c_comma INTO gwa_person-id
                                                           gwa_person-code_electoral
                                                           lv_space
                                                           gwa_person-expire_date
                                                           gwa_person-committee_vote
                                                           gwa_person-name
                                                           gwa_person-first_last_name
                                                           gwa_person-second_last_name.

  gwa_person-mandt = sy-mandt.

  "NEXT CODE INSTED USING IF string CA '#'.IF CA AND REPLACE '#' WITH 'N' in v_string.
  "USING COND AND REPLACE STRING FUNCTION
  gwa_person-first_last_name = COND #(
                                      WHEN contains( val = gwa_person-first_last_name sub = zcl_global_utils=>c_hastag )
                                        THEN replace( val = gwa_person-first_last_name sub = zcl_global_utils=>c_hastag with = 'N' occ = 1 )
                                        ELSE gwa_person-first_last_name ).

  gwa_person-second_last_name = COND #(
                          WHEN contains( val = gwa_person-second_last_name sub = zcl_global_utils=>c_hastag )
                            THEN replace( val = gwa_person-second_last_name sub = zcl_global_utils=>c_hastag with = 'N' occ = 1 )
                            ELSE gwa_person-second_last_name ).

  APPEND gwa_person TO got_person.

ENDFORM.
*&---------------------------------------------------------------------*
FORM f_opendata_class USING us_file TYPE string.

  DATA(lv_lowercase_path) = to_lower( us_file ).
  DATA it_rsanm_file_table TYPE STANDARD TABLE OF rsanm_file_line.

  FREE got_person.
  CALL METHOD cl_rsan_ut_appserv_file_reader=>appserver_file_read
    EXPORTING
      i_filename   = lv_lowercase_path
    CHANGING
      c_data_tab   = it_rsanm_file_table
    EXCEPTIONS
      open_failed  = 1
      read_failed  = 2
      close_failed = 3
      OTHERS       = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
FORM f_writedata_set USING us_table TYPE zot_uploadpersoncr
                           us_file  TYPE string.
  DATA: lv_path TYPE string,
        lv_line TYPE string.

  PERFORM f_get_path USING    us_file
                              p_lpath
                     CHANGING lv_path.

  DATA(lv_lowercase_path) = to_lower( lv_path ).
  "replace string function
  lv_lowercase_path = replace( val = lv_lowercase_path sub = zcl_global_utils=>c_txt with = zcl_global_utils=>c_space occ = 1 ).

  lv_lowercase_path = |{ lv_lowercase_path }| & |{ sy-mandt }| & |{ sy-uzeit }| & |{ zcl_global_utils=>c_txt }|.
  g_filepath = lv_lowercase_path.

  TRY.
      OPEN DATASET lv_lowercase_path FOR OUTPUT IN TEXT MODE ENCODING UTF-8 IGNORING CONVERSION ERRORS.
      IF sy-subrc = 0.
        LOOP AT us_table ASSIGNING FIELD-SYMBOL(<fs_table>).
          lv_line = |{ <fs_table>-id };{ <fs_table>-code_electoral };{ <fs_table>-expire_date };{ <fs_table>-committee_vote };{ <fs_table>-committee_vote };{ <fs_table>-name };{ <fs_table>-first_last_name };{ <fs_table>-second_last_name }|.
          TRANSFER lv_line TO lv_lowercase_path.
        ENDLOOP.
        CLOSE DATASET lv_lowercase_path.
      ENDIF.
    CATCH cx_root INTO DATA(e_txt).
      WRITE: / e_txt->get_text( ).
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DIALOG_DESKTOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_dialog_desktop .
  DATA: lt_tab    TYPE filetable,
        lv_count  TYPE i,
        lv_action TYPE i.

  cl_gui_frontend_services=>file_open_dialog( EXPORTING window_title = 'Select File'
                                                        initial_directory = 'D:\code\data'
                                              CHANGING  file_table = lt_tab
                                                        rc = lv_count
                                                        user_action = lv_action
                                              EXCEPTIONS file_open_dialog_failed = 1
                                                         cntl_error = 2
                                                         error_no_gui = 3
                                                         not_supported_by_gui = 4
                                                         OTHERS = 5 ).
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    IF lv_action NE 9.
      READ TABLE lt_tab ASSIGNING FIELD-SYMBOL(<fs_file>) INDEX 1.
      p_file = <fs_file>-filename.
    ELSE.
      MESSAGE 'User Canceled' TYPE 'I'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DESK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_process_desk .

  PERFORM f_open_deskfile.

  IF p_writ EQ abap_true.
    PERFORM f_writedata_desktop USING got_person.
  ENDIF.

  PERFORM f_upload_table.
ENDFORM.

*&---------------------------------------------------------------------*
FORM f_open_deskfile.

  DATA: gt_line TYPE TABLE OF string,
        lv_file TYPE string,
        lv_line TYPE string.

  IF p_file IS NOT INITIAL.

    lv_file = p_file.

    cl_gui_frontend_services=>gui_upload(
      EXPORTING
        filename                = lv_file
        filetype                = 'ASC'
        has_field_separator     = abap_true
      CHANGING
        data_tab                = gt_line
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19 ).

    IF sy-subrc EQ 0.
      FREE got_person.
      LOOP AT gt_line ASSIGNING FIELD-SYMBOL(<fs_line>).
        PERFORM f_split_line USING <fs_line>.
      ENDLOOP.

    ENDIF.

  ELSE.
    MESSAGE 'Path is empty' TYPE 'I'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upload_table .
  "set lock table
  CALL FUNCTION 'ENQUEUE_EZUPLOADPERSONCR'
*   EXPORTING
*     MODE_ZUPLOADPERSONCR       = 'E'
*     ID                         =
*     X_ID                       = ' '
*     _SCOPE                     = '2'
*     _WAIT                      = ' '
*     _COLLECT                   = ' '
*   EXCEPTIONS
*     FOREIGN_LOCK               = 1
*     SYSTEM_FAILURE             = 2
*     OTHERS                     = 3
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_dele EQ abap_true. " select delte all entries table
    PERFORM f_delete_all.
  ENDIF.

  IF p_crea EQ abap_true.
    PERFORM f_insert_data.
  ENDIF.

  CALL FUNCTION 'DEQUEUE_EZUPLOADPERSONCR'
* EXPORTING
*   MODE_ZUPLOADPERSONCR       = 'E'
*   ID                         =
*   X_ID                       = ' '
*   _SCOPE                     = '3'
*   _SYNCHRON                  = ' '
*   _COLLECT                   = ' '
    .

ENDFORM.

*&---------------------------------------------------------------------*
FORM f_delete_all.

  DATA ls_return TYPE bapiret2.
  DATA message TYPE string.

  DELETE FROM zuploadpersoncr." WHERE id LIKE '%'.
  IF sy-subrc NE 0.

    message = |Lines deleted: { sy-dbcnt } Error when try to delete all table|.
    MESSAGE message TYPE 'I'.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
      IMPORTING
        return = ls_return.

  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait   = abap_true
      IMPORTING
        return = ls_return.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
FORM f_insert_data.

  DATA lt_person TYPE zot_uploadpersoncr.
  DATA ls_return TYPE bapiret2.

  IF p_buff EQ abap_true.
    DATA(lv_totalines) = lines( got_person ).
    p_lines = p_lines + 1.
    DELETE got_person FROM p_lines TO lv_totalines.
    MODIFY zuploadpersoncr FROM TABLE @got_person.

    IF sy-subrc EQ 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = abap_true
        IMPORTING
          return = ls_return.

    ELSE.
      MESSAGE 'Error on create entries' TYPE 'I'.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
        IMPORTING
          return = ls_return.
    ENDIF.

  ELSE.
    "Choose using MODIFY
    "Inserts one or more rows into a database table specified or overwrites existing ones.
    MODIFY zuploadpersoncr FROM TABLE @got_person.
    IF sy-subrc EQ 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = abap_true
        IMPORTING
          return = ls_return.

    ELSE.
      MESSAGE 'Error on create entries' TYPE 'I'.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
        IMPORTING
          return = ls_return.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
FORM f_writedata_desktop USING us_table TYPE zot_uploadpersoncr.
  DATA: it_file     TYPE STANDARD TABLE OF string,
        lv_line     TYPE string,
        lv_path     TYPE string,
        lv_filename TYPE string,
        lv_fullpath TYPE string,
        lv_result   TYPE i.

  LOOP AT us_table ASSIGNING FIELD-SYMBOL(<fs_table>).
    lv_line = |{ <fs_table>-id };{ <fs_table>-code_electoral };{ <fs_table>-expire_date };{ <fs_table>-committee_vote };{ <fs_table>-committee_vote };{ <fs_table>-name };{ <fs_table>-first_last_name };{ <fs_table>-second_last_name }|.
    APPEND lv_line TO it_file.
  ENDLOOP.

  cl_gui_frontend_services=>file_save_dialog( EXPORTING window_title = 'File Directory'
                                                      initial_directory = 'D:\code\data'
                                            CHANGING  filename = lv_filename
                                                      path = lv_path
                                                      fullpath = lv_fullpath
                                                      user_action = lv_result ).
  IF lv_result NE 9.
    cl_gui_frontend_services=>gui_download(
      EXPORTING
      filename = lv_fullpath
      filetype = 'ASC'
      IMPORTING
        filelength = DATA(lv_len)
      CHANGING
        data_tab = it_file
      ).
  ELSE.
    MESSAGE 'User Canceled' TYPE 'I'.
  ENDIF.

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
  lv_structure = zcl_global_utils=>c_str_upperson.

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
*&      Form  F_BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_layout CHANGING ch_layout TYPE slis_layout_alv.

  ch_layout-zebra = abap_true.
  ch_layout-edit = abap_false.

ENDFORM.
*----------------------------------------------------------------------*
*Create form standard for ALV
FORM user_command  USING r_ucomm LIKE sy-ucomm
                                   rs_selfield TYPE slis_selfield.
  CASE r_ucomm.
    WHEN '&INF'.
      MESSAGE 'Person Details' TYPE 'I'.
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

  wa_listheader-typ = |H|.
  wa_listheader-info = |Person Uploaded|.
  INSERT wa_listheader INTO TABLE it_listheader.

  CLEAR wa_listheader.
  wa_listheader-typ = |S|.
  wa_listheader-info = | User: { sy-uname } |.
  INSERT wa_listheader INTO TABLE it_listheader.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_listheader
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_LIST_FLIGHTS_DICT_GRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FLIGHTS_FIELD  text
*----------------------------------------------------------------------*
FORM f_list_flights_dict_grid  USING us_personcr TYPE zot_uploadpersoncr
                                     us_layout  TYPE slis_layout_alv
                                     us_event   TYPE slis_t_event.
  gst_person[] = got_person[].
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
      t_outtab                 = gst_person
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
