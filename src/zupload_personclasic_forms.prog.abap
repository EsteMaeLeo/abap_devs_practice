*&---------------------------------------------------------------------*
*&  Include           ZUPLOAD_PERSONCLASIC_FORMS
*&---------------------------------------------------------------------*
FORM f_open_appfile.

ENDFORM.

FORM f_open_deskfile.

ENDFORM.

*return path and file name according passing the logical path
FORM f_get_pathwrite USING    us_file TYPE string
                     CHANGING ch_path TYPE string.

  DATA(lv_logic) = zcl_global_utils=>path_upload_peole.

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

*form for F4 files in the application server
FORM f_f4_appserver USING    us_path TYPE string
                    CHANGING ch_file TYPE string.
*F4 help for file name on SAP application server

  if us_path is INITIAL.
    "default path in the server.
    us_path = text-p01.
  ENDIF.

  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = us_path
    IMPORTING
      serverfile       = ch_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
    MESSAGE 'Error Message' TYPE 'I'.
  ENDIF.

ENDFORM.
