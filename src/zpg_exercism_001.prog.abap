*&---------------------------------------------------------------------*
*& Report zpg_exercism_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpg_exercism_001.

"&-------------------------------------------------------------*
"& Classes Definition
"&-------------------------------------------------------------*

CLASS zcl_itab_basics DEFINITION
    FINAL
    CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES group TYPE c LENGTH 1.


    TYPES: BEGIN OF initial_type,
             group       TYPE group,
             number      TYPE i,
             description TYPE string,
           END OF initial_type,
           itab_data_type TYPE STANDARD TABLE OF initial_type WITH EMPTY KEY.

    METHODS fill_itab
      RETURNING
        VALUE(initial_data) TYPE itab_data_type.

    METHODS add_to_itab
      IMPORTING initial_data        TYPE itab_data_type
      RETURNING
                VALUE(updated_data) TYPE itab_data_type.

    METHODS sort_itab
      IMPORTING initial_data        TYPE itab_data_type
      RETURNING
                VALUE(updated_data) TYPE itab_data_type.

    METHODS search_itab
      IMPORTING initial_data        TYPE itab_data_type
      RETURNING
                VALUE(result_index) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
"&-------------------------------------------------------------*
CLASS lcl_solution DEFINITION
    CREATE PUBLIC.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_scrabble_score DEFINITION
    CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS score
      IMPORTING
        input         TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE i.
    METHODS score_improve
      IMPORTING
        input         TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_type,
             letter TYPE group,
             point  TYPE i,
           END OF initial_type,
           itab_data_type TYPE STANDARD TABLE OF initial_type WITH EMPTY KEY.


ENDCLASS.
"&-------------------------------------------------------------*
CLASS zcl_itab_basics IMPLEMENTATION.
  METHOD fill_itab.

    initial_data = VALUE itab_data_type( ( group = 'A' number = '10'  description = 'Group A-2' )
                                         ( group = 'B' number = '5'   description = 'Group B' )
                                         ( group = 'A' number = '6'   description = 'Group A-1' )
                                         ( group = 'C' number = '22'  description = 'Group C-1' )
                                         ( group = 'A' number = '13'  description = 'Group A-3' )
                                         ( group = 'C' number = '500' description = 'Group C-2' ) ).

    "add solution here
  ENDMETHOD.

  METHOD add_to_itab.
    updated_data = initial_data.
    APPEND VALUE #( group = 'A' number = '19'  description = 'Group A-4' ) TO updated_data.

    "add solution here
  ENDMETHOD.

  METHOD sort_itab.
    updated_data = initial_data.
    "add solution here
    SORT updated_data BY group ASCENDING AS TEXT number DESCENDING.
  ENDMETHOD.

  METHOD search_itab.
    DATA(temp_data) = initial_data.

    result_index = line_index( temp_data[ number = '6' ] ).
    "add solution here
  ENDMETHOD.

ENDCLASS.
"&-------------------------------------------------------------*
CLASS zcl_scrabble_score IMPLEMENTATION.
  METHOD score.
    " add solution here
    DATA(it_points) = VALUE itab_data_type( ( letter = 'A' point = 1 )
                                         ( letter = 'E' point = 1 )
                                         ( letter = 'I' point = 1 )
                                         ( letter = 'O' point = 1 )
                                         ( letter = 'U' point = 1 )
                                         ( letter = 'L' point = 1 )
                                         ( letter = 'N' point = 1 )
                                         ( letter = 'R' point = 1 )
                                         ( letter = 'S' point = 1 )
                                         ( letter = 'T' point = 1 )
                                         ( letter = 'D' point = 2 )
                                         ( letter = 'G' point = 2 )
                                         ( letter = 'B' point = 3 )
                                         ( letter = 'C' point = 3 )
                                         ( letter = 'M' point = 3 )
                                         ( letter = 'P' point = 3 )
                                         ( letter = 'F' point = 4 )
                                         ( letter = 'H' point = 4 )
                                         ( letter = 'V' point = 4 )
                                         ( letter = 'W' point = 4 )
                                         ( letter = 'Y' point = 4 )
                                         ( letter = 'K' point = 5 )
                                         ( letter = 'J' point = 8 )
                                         ( letter = 'X' point = 8 )
                                         ( letter = 'Q' point = 10 )
                                         ( letter = 'Z' point = 10 ) ).

    "using for using new stament check is not initial
    IF lines( it_points ) NE 0.
      DATA(lv_count) = REDUCE i( INIT lv_x = 0 FOR wa_points IN it_points NEXT lv_x = lv_x + wa_points-point ).
      DATA(lv_count2) = strlen( input  ).
      DATA(lv_upper) = to_upper( input ).
      DATA(lv_times) = 0.
      DATA(lv_totalpoints) = 0.
      DO lv_count2 TIMES.
        DATA(str) = lv_upper+lv_times(1).
        DATA(ls_points) = it_points[ letter = str ].
        lv_totalpoints = lv_totalpoints + ls_points-point.
        lv_times = lv_times + 1.
      ENDDO.
      result = lv_totalpoints.
    ENDIF.
    BREAK-POINT.
  ENDMETHOD.

  METHOD score_improve.
*    result =
*  REDUCE string( INIT s = 0
*                 FOR  i = 0 WHILE i < strlen( input )
*                 NEXT s += COND i( LET current_val = to_upper( input+i(1) ) IN
*                 WHEN contains( val = 'AEIOULNRST' sub = current_val ) THEN 1
*                 WHEN contains( val = 'DG' sub = current_val ) THEN 2
*                 WHEN contains( val = 'BCMP' sub = current_val ) THEN 3
*                 WHEN contains( val = 'FHVWY' sub = current_val ) THEN 4
*                 WHEN contains( val = 'K' sub = current_val ) THEN 5
*                 WHEN contains( val = 'JX' sub = current_val ) THEN 8
*                 WHEN contains( val = 'QZ' sub = current_val ) THEN 10
*                 ELSE 0
*                 ) ).
  ENDMETHOD.

ENDCLASS.
"&-------------------------------------------------------------*
CLASS lcl_solution IMPLEMENTATION.

ENDCLASS.
"&-------------------------------------------------------------*
"& Declarations
"&-------------------------------------------------------------*

START-OF-SELECTION.

  BREAK-POINT.
  DATA(lcl_new_itab) = NEW zcl_itab_basics(  ).

  DATA(lcl_new_scramble) = NEW zcl_scrabble_score(  ).
  DATA(result) = lcl_new_scramble->score( 'cabbage' ).
  BREAK-POINT.
