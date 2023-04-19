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
CLASS lcl_practice DEFINITION
    CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS: m_inline.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

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

ENDCLASS.
"&-------------------------------------------------------------*
"& Selection-screen
"&-------------------------------------------------------------*

START-OF-EDITING.

BREAK-POINT.

DATA(lv_new) = NEW lcl_practice(  ).
lv_new->m_inline(  ).
