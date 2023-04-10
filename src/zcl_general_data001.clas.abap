CLASS zcl_general_data001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: gt_excel TYPE filetable.
    INTERFACES if_oo_adt_classrun.
    METHODS:
      load_file IMPORTING iv_file TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_general_data001 IMPLEMENTATION.

  METHOD load_file.
    DATA: lv_return_code TYPE i.
    cl_gui_frontend_services=>file_open_dialog(
      EXPORTING
        window_title            = 'Upload Excel'
        default_filename        = ''
        initial_directory       = iv_file
        multiselection          = ''
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
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    me->load_file( 'C:\sap\spfli.csv' ).
    out->write( 'Hello world!' ).
  ENDMETHOD.
ENDCLASS.
