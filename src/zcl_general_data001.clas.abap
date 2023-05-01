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

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    me->load_file( 'C:\sap\spfli.csv' ).
    out->write( 'Hello world!' ).
  ENDMETHOD.
ENDCLASS.
