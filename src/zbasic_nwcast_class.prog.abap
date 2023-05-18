*&---------------------------------------------------------------------*
*& Report ZBASIC_NWCAST_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbasic_nwcast_class.

CLASS vehicle DEFINITION.

  PUBLIC SECTION.
    METHODS: gofaster.

  PROTECTED SECTION.
    DATA speed TYPE i.

  PRIVATE SECTION.
ENDCLASS.
*&---------------------------------------------------------------------*
CLASS car DEFINITION INHERITING FROM vehicle.

  PUBLIC SECTION.
    METHODS: gofaster REDEFINITION,
      writespeed .

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.

*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
CLASS vehicle IMPLEMENTATION.

  METHOD gofaster.
    speed = speed + 1.
    WRITE: /, |The vehicle speed is |, speed.
  ENDMETHOD.

ENDCLASS.
*&---------------------------------------------------------------------*
CLASS car IMPLEMENTATION.
  METHOD gofaster.
    speed = speed + 10.
    WRITE: /, |The Car speed is |, speed.
  ENDMETHOD.

  METHOD writespeed.
    WRITE: /, |My car grease lightning |, speed.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA vehicle1 TYPE REF TO vehicle.
  DATA car1     TYPE REF TO car.

* VEHICLE object without any NARROWING CAST
  WRITE: / 'VEHICLE object without any NARROWING CAST'.
  "CREATE OBJECT vehicle1.
  vehicle1 = NEW #( ).
  vehicle1->gofaster( ).
  CLEAR vehicle1.

* VEHICLE object with NARROWING CAST
  ULINE.
  WRITE: / 'VEHICLE - NARROWING CAST from CAR'.
  "CREATE OBJECT car1.
  car1 = NEW #( ).
  vehicle1 = car1.
  vehicle1->gofaster( ).

* Demonstrate WIDENING CAST
* At this point we have used a NARROWING cast on VEHICLE1
* Create an obj ref to catch the error. You don't need to do this. You can just
* use CATCH SYSTEM-EXCEPTIONS  move_cast_error = 4.

  DATA: my_cast_error TYPE REF TO cx_sy_move_cast_error,
        car2          TYPE REF TO car.
* Note, we haven't created an object for car2... it is an empty ref variable

  TRY.
* Do a WIDENING CAST to move the ref from VEHICLE TO CAR (more specific)
      car2 ?= vehicle1.
    CATCH cx_sy_move_cast_error INTO my_cast_error.
      WRITE: / 'The WIDENING CAST failed'.
  ENDTRY.
  IF car2 IS NOT INITIAL.
    car2->gofaster( ).
    car2->writespeed( ).
  ENDIF.

* Now, lets generate an error

  CLEAR: car1, car2, vehicle1, my_cast_error.
  "CREATE OBJECT vehicle1.
  vehicle1 = NEW #( ).
  TRY.
      car1 ?= vehicle1.
    CATCH cx_sy_move_cast_error INTO my_cast_error.
      WRITE: / 'The WIDENING CAST failed'.
  ENDTRY.
  IF car1 IS NOT INITIAL.
    car1->gofaster( ).
    car1->writespeed( ).
  ENDIF.
