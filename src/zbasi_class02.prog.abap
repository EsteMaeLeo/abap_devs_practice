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
        IMPORTING status    TYPE c
        CHANGING  newstatus TYPE c,

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

    CLASS-METHODS: class_constructor. " static constructor

    METHODS:
      constructor
        IMPORTING make        TYPE string
                  model       TYPE string
                  max_speed   TYPE i
                  numberseats TYPE i,

      viewcar,

      setnumsetas
        IMPORTING numberseats TYPE i,

      original_gofaster
        IMPORTING speed    TYPE i
        EXPORTING newspeed TYPE i,
      gofaster
        IMPORTING speed    TYPE i
        EXPORTING newspeed TYPE i,

      goslower
        IMPORTING speed           TYPE i
        RETURNING VALUE(newspeed) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: make        TYPE string,
          model       TYPE string,
          numberseats TYPE i,
          speed       TYPE i,
          max_speed   TYPE i.

    CLASS-DATA: carlog TYPE string.
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
      me->status = status.
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

  METHOD class_constructor.
    carlog = |Car class_contructor|.
    WRITE carlog.
  ENDMETHOD.

  METHOD constructor.

    me->make   = make.
    me->model  = model.
    me->numberseats = numberseats.
    me->max_speed = max_speed.
    me->numberofcars = me->numberofcars + 1.

  ENDMETHOD.

  METHOD viewcar.
    WRITE : /,
     me->make,
     me->model,
     me->numberseats,
     me->speed,
     me->max_speed,
     me->numberofcars.
  ENDMETHOD.

  METHOD setnumsetas.

    me->numberseats = numberseats.

  ENDMETHOD.

  METHOD gofaster.
*this method diferent if you increse the speed will set to max_speed if speed More than max_speed.
    DATA(lv_temp) = speed + me->speed.

    newspeed = COND i(
        WHEN me->speed >= max_speed THEN max_speed
        WHEN me->speed < max_speed THEN lv_temp ).

    me->speed = newspeed.

  ENDMETHOD.

  METHOD original_gofaster.

    DATA(lv_temp) = speed + me->speed.

    IF lv_temp <= max_speed.
      me->speed = lv_temp.
    ENDIF.

    newspeed = me->speed.

  ENDMETHOD.

  METHOD goslower.

    me->speed = me->speed - speed.
    IF me->speed < 0.
      me->speed = 0.
    ENDIF.

    newspeed = me->speed.

  ENDMETHOD.

ENDCLASS.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  BREAK-POINT.
  DATA(lo_student) = NEW lcl_student( ).
  lo_student->setname( 'Charles').
  DATA(l_status) = 'M'.
  lo_student->setstatus( EXPORTING status    = l_status
                         CHANGING  newstatus = l_status ).
  DATA(lv_gender) = lo_student->get_status_text('1').

  " --- Old Ways Create Class ---
  DATA lo_car_old TYPE REF TO lcl_car.
  CREATE OBJECT lo_car_old
    EXPORTING
      make        = 'BMW'
      model       = 'X6'
      max_speed   = 260
      numberseats = 6.

  lo_car_old->viewcar( ).
  ULINE.
  lo_car_old->setnumsetas( 7 ).
  lo_car_old->viewcar( ).

  DATA(lv_resultspeed) = 0.
  lo_car_old->gofaster( EXPORTING speed = 50
                        IMPORTING  newspeed = lv_resultspeed ).

  lo_car_old->viewcar( ).
  WRITE:/, |Result goFaster: |, lv_resultspeed.
  ULINE.

  "FUNCTION METHOD USING RECEIVING
  lo_car_old->goslower( EXPORTING speed = 5
                        RECEIVING newspeed = lv_resultspeed ).
  lo_car_old->viewcar( ).
  WRITE:/, |Result goslower: |, lv_resultspeed.
  ULINE.

  "Assiging the value to variable
  lv_resultspeed = lo_car_old->goslower( 10 ).
  lo_car_old->viewcar( ).
  WRITE:/, |Result goslower (Assign Function method): |, lv_resultspeed.
  ULINE.



  WRITE: /, |Number of cars created: |, lcl_car=>numberofcars. "Access tthe static attribute
  "---- NEW CAR ---
  DATA(lo_car) = NEW lcl_car( make = 'Audi'
                              model = 'A4'
                              max_speed = 240
                              numberseats = 4 ).
  DATA(lv_speed) = 0.
  DATA(increment_speed) = 10.
  lo_car->gofaster( EXPORTING speed = increment_speed
                    IMPORTING  newspeed = lv_speed ).

  cl_demo_output=>new(
  )->begin_section( |Text Program for Local Class|
  )->write_text( |Local Class|
  )->write_data( lv_gender
  )->display( ).
