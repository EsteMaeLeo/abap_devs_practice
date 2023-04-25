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

  PERFORM f_get_filename USING    p_lfile
                         CHANGING lv_file.

  PERFORM f_get_pathwrite USING    lv_file
                                   p_lpath
                          CHANGING lv_path.

ENDFORM.
*&---------------------------------------------------------------------*
FORM f_open_deskfile.

ENDFORM.
*&---------------------------------------------------------------------*
FORM f_get_filename USING us_path    TYPE filename-fileintern
                    CHANGING us_file TYPE string.

  CALL FUNCTION 'FILE_GET_NAME_AND_LOGICAL_PATH'
    EXPORTING
*     CLIENT                     = SY-MANDT
      logical_filename           = us_path
      operating_system           = sy-opsys
*     PARAMETER_1                = ' '
*     PARAMETER_2                = ' '
*     PARAMETER_3                = ' '
*     USE_PRESENTATION_SERVER    = ' '
*     WITH_FILE_EXTENSION        = ' '
*     USE_BUFFER                 = ' '
*     ELEMINATE_BLANKS           = 'X'
    IMPORTING
*     FILE_FORMAT                =
      file_name                  = us_file
*     LOGICAL_PATH               =
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
*return path and file name according passing the logical path
FORM f_get_pathwrite USING    us_file TYPE string
                              us_lpath TYPE filepath-pathintern
                     CHANGING ch_path TYPE string.

  DATA(lv_logic) = zcl_global_utils=>path_upload_peole.

  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      logical_path               = us_lpath
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
