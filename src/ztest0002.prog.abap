*&---------------------------------------------------------------------*
*& Report ztest0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest0002.
TABLES: spfli.
"&-------------------------------------------------------------*
"& Classes Definition

"&-------------------------------------------------------------*
"&-------------------------------------------------------------*
"& Declarations
"&-------------------------------------------------------------*

DATA: gt_excel TYPE filetable.
DATA: lv_return_code TYPE i.

"&-------------------------------------------------------------*

CLASS lcl_vehicle DEFINITION
    CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS: constructor IMPORTING iv_company TYPE string
                                   iv_model   TYPE string,

      show_vehicle.

  PROTECTED SECTION.
  PRIVATE SECTION.
   CLASS-DATA: iv_count TYPE i.
    DATA: company  TYPE string,
          model    TYPE string.
ENDCLASS.
"&-------------------------------------------------------------*
CLASS lcl_practice DEFINITION
    CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS: m_inline,
      using_new.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

"&-------------------------------------------------------------*
CLASS lcl_vehicle IMPLEMENTATION.

  METHOD constructor.
    WRITE: / |HELLO CONSTRUCTOR|.
    company = iv_company.
    model = iv_model.
    iv_count = iv_count + 1.
  ENDMETHOD.

  METHOD show_vehicle.
    WRITE: / |Vehicle data: |, company, model.
    WRITE: / |Object number: |, iv_count.
  ENDMETHOD.

ENDCLASS.


"&-------------------------------------------------------------*

CLASS lcl_practice IMPLEMENTATION.

  METHOD m_inline.
**** Variables ****
    "classic declaration
    DATA lv_integer TYPE i.
    "inline declaration
    DATA(lv_int) = 0.

**** Work Areas ****
    "classic
    DATA wa_spfli TYPE spfli.
    DATA it_spfli TYPE STANDARD TABLE OF spfli.

    SELECT *
        FROM spfli
        INTO TABLE it_spfli.

    IF sy-subrc EQ 0.

      LOOP AT it_spfli INTO wa_spfli.

        WRITE: / wa_spfli-carrid, wa_spfli-connid, wa_spfli-cityfrom, wa_spfli-cityto.
      ENDLOOP.

    ENDIF.
    WRITE: / 'NEW inline table declaration'.

    "NEW inline declaration internal and work area
    SELECT *
        FROM spfli
        INTO TABLE @DATA(it_spfli2).

    IF sy-subrc EQ 0.

      LOOP AT it_spfli2 INTO DATA(wa_spfli2).

        WRITE: / wa_spfli2-carrid, wa_spfli2-connid, wa_spfli2-cityfrom, wa_spfli2-cityto.
      ENDLOOP.

      "Read Inline Declaration
      WRITE: / 'NEW read work area'.
      READ TABLE it_spfli2 INTO DATA(wa_inread) INDEX 1.

      IF sy-subrc EQ 0.
        WRITE: / wa_inread-carrid, wa_inread-connid, wa_inread-cityfrom, wa_inread-cityto.
      ENDIF.

      WRITE: / 'NEW field symbol'.
      READ TABLE it_spfli2 ASSIGNING FIELD-SYMBOL(<fs_inline>) INDEX 1.
      IF <fs_inline> IS ASSIGNED.
        WRITE: / <fs_inline>-carrid, <fs_inline>-connid, <fs_inline>-cityfrom, <fs_inline>-cityto.
      ENDIF.

      WRITE: / 'Old ways Describe table'.
      DATA lv_lines TYPE i.

      DESCRIBE TABLE it_spfli2 LINES lv_lines.

      WRITE:/ lv_lines.

      WRITE: / 'NEW ways Describe table using inline'.

      DESCRIBE TABLE  it_spfli2 LINES DATA(lv_lines2).
      WRITE: / lv_lines2.

      WRITE: / 'NEW ways using LINES table'.

      DATA(lv_lines3) = lines( it_spfli2 ).
      WRITE: / lv_lines3.

    ENDIF.


  ENDMETHOD.

  METHOD using_new.

****DATA OBJECTS****
****Before 7.4 ****
    FIELD-SYMBOLS <fs> TYPE data.
    DATA dref TYPE REF TO data.

    CREATE DATA dref TYPE i.
    ASSIGN dref->* TO <fs>.
    <fs> = 100.

****AFter****

    DATA dref2 TYPE REF TO data.
    dref2 = NEW i( 100 ).

****INSTANCE CLASS****
****before****
    DATA lo_vehicle1 TYPE REF TO lcl_vehicle.
    CREATE OBJECT lo_vehicle1
      EXPORTING
        iv_company = 'BMW'
        iv_model   = 'X6'.
    lo_vehicle1->show_vehicle( ).

****AFter****
    DATA(lo_vehicle2)  = NEW lcl_vehicle( iv_company = 'BMW'
                                          iv_model  = 'X3' ).

    lo_vehicle2->show_vehicle(  ).

    "usgin implicit reference
    DATA lo_vehicle3 TYPE REF TO lcl_vehicle.

    lo_vehicle3 = NEW #( iv_company = 'BMW'
                         iv_model   = 'X2' ).

    lo_vehicle3->show_vehicle(  ).

    "without reference
    NEW lcl_vehicle( iv_company = 'BMW'
                     iv_model = 'Series 3')->show_vehicle(  ).

  ENDMETHOD.



ENDCLASS.
"&-------------------------------------------------------------*
"& Selection-screen
"&-------------------------------------------------------------*

START-OF-EDITING.

BREAK-POINT.

DATA(lv_new) = NEW lcl_practice(  ).
lv_new->m_inline(  ).
lv_new->using_new(  ).
