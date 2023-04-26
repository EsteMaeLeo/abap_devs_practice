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
ENDFORM.
*&---------------------------------------------------------------------*
FORM f_open_appfile.

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

  PERFORM f_writedata_set USING got_person
                                lv_file.

  PERFORM f_opendata_class USING g_filepath.

ENDFORM.
*&---------------------------------------------------------------------*
FORM f_open_deskfile.

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
FORM f_opendataset USING us_file TYPE string.

  DATA: lv_line  TYPE string,
        lv_space TYPE string.

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
            SPLIT lv_line AT zcl_global_utils=>c_comma INTO gwa_person-id
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
