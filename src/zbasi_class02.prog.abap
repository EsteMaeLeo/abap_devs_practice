*&---------------------------------------------------------------------*
*& Report ZBASI_CLASS02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbasi_class02.
*&---------------------------------------------------------------------*
*& CLASS Definition
*&---------------------------------------------------------------------*
*&--------student------------------------------------------------------*
CLASS lcl_student DEFINITION.
  PUBLIC SECTION.

    CLASS-DATA: counter TYPE i.

    DATA: name   TYPE string READ-ONLY,
          age    TYPE i,
          gender TYPE c LENGTH 1 READ-ONLY,
          status TYPE c LENGTH 1.

    METHODS:
      setname
        IMPORTING namein TYPE string,

      getname
        EXPORTING nameout TYPE string,

      setstatus
        CHANGING newstatus TYPE c,

      get_status_text
        IMPORTING VALUE(statuscode) TYPE c
        RETURNING VALUE(statustext) TYPE string.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: loginid TYPE c LENGTH 20,
          pwd     TYPE c LENGTH 15.
ENDCLASS.
*&--------car----------------------------------------------------------*
CLASS lcl_car DEFINITION
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-DATA: numberofcars TYPE i.

    METHODS:
      setnumsetas
        IMPORTING numberseats TYPE i,

      gofaster
        IMPORTING speed    TYPE i
        EXPORTING newspeed TYPE i,

      goslower
        IMPORTING speed    TYPE i
        RETURNING VALUE(newspeed) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: make        TYPE string,
          model       TYPE string,
          numberseats TYPE i,
          speed       TYPE i,
          max_speed   TYPE i.
ENDCLASS.
*&---------------------------------------------------------------------*
*& CLASS Implementation
*&---------------------------------------------------------------------*
CLASS lcl_student IMPLEMENTATION.

  METHOD setname.
    name = namein.
  ENDMETHOD.

  METHOD getname.
    nameout = name.
  ENDMETHOD.

  METHOD setstatus.
    IF newstatus CO 'MFNT'.
      status = newstatus.
      newstatus = '1'. "set newstatus to 1 was successfull
    ELSE.
      newstatus = '2'. "status not set
    ENDIF.
  ENDMETHOD.

  METHOD get_status_text.

    statustext = SWITCH #( statuscode
                            WHEN '1' THEN |Male|
                            WHEN '2' THEN |Female|
                            WHEN '3' THEN |NonBinary|
                            WHEN '4' THEN |Transgender|
                            WHEN '5' THEN |Queer| ).

  ENDMETHOD.

ENDCLASS.

*&--------car----------------------------------------------------------*
CLASS lcl_car IMPLEMENTATION.

  METHOD setnumsetas.

    me->numberseats = numberseats.

  ENDMETHOD.

  METHOD gofaster.
     me->speed = speed + me->speed.

    newspeed = COND i(
        WHEN me->speed >= max_speed THEN max_speed
        WHEN me->speed < max_speed THEN me->speed ).

    me->speed = newspeed.

ENDMETHOD.

METHOD goslower.

ENDMETHOD.

ENDCLASS.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  BREAK-POINT.
  DATA(lo_student) = NEW lcl_student( ).
  DATA(lv_gender) = lo_student->get_status_text('1').

  "---- NEW CAR ---
  DATA(lo_car) = NEW lcl_car( ).
  DATA(lv_speed) = 0.
  DATA(increment_speed) = 10.
  lo_car->gofaster( EXPORTING speed = increment_speed
                    IMPORTING  newspeed = lv_speed ).

  cl_demo_output=>new(
  )->begin_section( |Text Program for Local Class|
  )->write_text( |Local Class|
  )->write_data( lv_gender
  )->display( ).
