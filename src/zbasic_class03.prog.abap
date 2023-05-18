*&---------------------------------------------------------------------*
*& Report ZBASIC_CLASS03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbasic_class03.
*&---------------------------------------------------------------------*
CLASS vehicle DEFINITION.

  PUBLIC SECTION.
    METHODS: gofaster,
      writespeed.

  PROTECTED SECTION.
    DATA speed TYPE i.

  PRIVATE SECTION.
ENDCLASS.
*&---------------------------------------------------------------------*
CLASS car DEFINITION INHERITING FROM vehicle.

  PUBLIC SECTION.
    METHODS: refuel,
      writespeed REDEFINITION.

  PROTECTED SECTION.
    DATA fuellevel TYPE i.
  PRIVATE SECTION.
ENDCLASS.
*&---------------------------------------------------------------------*
CLASS boat DEFINITION INHERITING FROM vehicle.
  PUBLIC SECTION.
    METHODS: writespeed REDEFINITION.
ENDCLASS.
*&---------------------------------------------------------------------*
CLASS vehicle IMPLEMENTATION.

  METHOD gofaster.
    speed = speed + 1.
  ENDMETHOD.

  METHOD writespeed.
    WRITE: /, |The vehicle speed is |, speed.
  ENDMETHOD.

ENDCLASS.
*&---------------------------------------------------------------------*
CLASS car IMPLEMENTATION.
  METHOD refuel.
    fuellevel = 60.
    WRITE: /, |You have just filled up your fuel thank|.
  ENDMETHOD.

  METHOD writespeed.
    WRITE: /, |The Car speed is |, speed.
  ENDMETHOD.
ENDCLASS.
*&---------------------------------------------------------------------*
CLASS boat IMPLEMENTATION.
  METHOD writespeed.
    super->writespeed( ).
    WRITE: /, |The Boat speed is |, speed.
  ENDMETHOD.
ENDCLASS.
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  DATA(lc_car) = NEW car( ).
  WRITE: / |CAR CLASS|.
  lc_car->gofaster( ).
  lc_car->writespeed( ).
  lc_car->refuel( ).

  DATA(lc_boat) = NEW boat( ).
  WRITE: / |BOAT CLASS|.
  lc_boat->gofaster( ).
  lc_boat->writespeed( ).
