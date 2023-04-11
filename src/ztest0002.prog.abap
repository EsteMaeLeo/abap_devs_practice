*&---------------------------------------------------------------------*
*& Report ztest0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest0002.

"&-------------------------------------------------------------*
"& Declarations
"&-------------------------------------------------------------*

DATA: gt_excel TYPE filetable.
DATA: lv_return_code TYPE i.
"&-------------------------------------------------------------*
"& Selection-screen
"&-------------------------------------------------------------*
PARAMETERS: p_file TYPE file_table-filename .
SELECTION-SCREEN SKIP.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.



  cl_gui_frontend_services=>file_open_dialog(
    EXPORTING
      window_title            = 'Upload Excel'
      "default_filename        = ''
      "initial_directory       = iv_file
      "multiselection          = ''
    CHANGING
      file_table              = gt_excel
      rc                      = lv_return_code
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5
  ).
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  START-OF-EDITING.

  BREAK-POINT.
