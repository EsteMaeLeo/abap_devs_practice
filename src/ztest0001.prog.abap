*&---------------------------------------------------------------------*
*& Report ZTEST0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest0001.

*Test program to write code about new sintaxis and practice coding

*&-------------------------------CLASS---------------------------------*
***DEFINITION***
CLASS lcl_report001 DEFINITION
    FINAL
    CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES: BEGIN OF table_buzzfuzz,
             number TYPE i,
             desc   TYPE string,
           END OF table_buzzfuzz,

           ittype_buzzfuzz TYPE SORTED TABLE OF table_buzzfuzz WITH UNIQUE KEY number,
           itype           TYPE SORTED TABLE OF i WITH UNIQUE KEY table_line.

    METHODS: constructor,

      fill_sort_intable  "use the internal table from Data declaration
        IMPORTING
          iv_num TYPE i,

      get_int_table
        RETURNING
          VALUE(irv_int) TYPE itype,

      fill_sort_buzzfuzz " method using return
        IMPORTING
          iv_num         TYPE i
        RETURNING
          VALUE(irv_tab) TYPE ittype_buzzfuzz.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA: iv_counter TYPE i,
          it_int     TYPE itype.

ENDCLASS.


***IMPLEMENT**
CLASS lcl_report001 IMPLEMENTATION.
  METHOD constructor.

  ENDMETHOD.

  METHOD fill_sort_intable.

    it_int = VALUE #( FOR i = 0 THEN i + 1 UNTIL i > iv_num
                    ( i ) ).

  ENDMETHOD.

  METHOD get_int_table.
    irv_int = it_int.
  ENDMETHOD.

  METHOD fill_sort_buzzfuzz.
  ENDMETHOD.

ENDCLASS.


*&---------------------------------------------------------------------*

START-OF-SELECTION.

  BREAK-POINT.

  SELECT *
    FROM spfli
    INTO TABLE @DATA(it_spfli).


  DATA(lcl_new1) = NEW  lcl_report001(  ).
  lcl_new1->fill_sort_intable( 50 ).
  DATA(lit_int) =  lcl_new1->get_int_table(  ).
  cl_demo_output=>display( lit_int ).
