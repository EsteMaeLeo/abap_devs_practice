*&---------------------------------------------------------------------*
*& Report ZBASIC_ABS_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbasic_abs_class.
*&---------------------------------------------------------------------*
CLASS vehicle DEFINITION ABSTRACT.

  PUBLIC SECTION.
    METHODS: gofaster,
      writespeed ABSTRACT.

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
***static example
CLASS car1 DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: numcars TYPE i.
ENDCLASS.

CLASS car2 DEFINITION INHERITING FROM car1.
ENDCLASS.
*&---------------------------------------------------------------------*
"constructor
CLASS ford DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.  " static constructor

    METHODS constructor
      IMPORTING
        p_model TYPE string.
  PROTECTED SECTION.
    DATA model TYPE string.
    CLASS-DATA carlog TYPE string.
ENDCLASS.

CLASS mercedes DEFINITION INHERITING FROM ford.
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS audi DEFINITION INHERITING FROM mercedes.
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.

    METHODS constructor
      IMPORTING
        p_model  TYPE string
        p_wheels TYPE i.
  PROTECTED SECTION.
    DATA wheels TYPE i.
ENDCLASS.

CLASS ford IMPLEMENTATION.

  METHOD class_constructor.
    carlog = |Ford class constructor has been used|.
    WRITE: /, carlog.
  ENDMETHOD.

  METHOD constructor.
    model = p_model.
  ENDMETHOD.

ENDCLASS.

CLASS mercedes IMPLEMENTATION.
  METHOD class_constructor."redefine class constructor
    carlog = |Mercedes class constructor has been used|.
    WRITE: /, carlog.
  ENDMETHOD.
ENDCLASS.

CLASS audi IMPLEMENTATION.
  METHOD class_constructor. "redefine class constructor
    carlog = |Audi class constructor has been used|.
    WRITE: /, carlog.
  ENDMETHOD.

  METHOD constructor.
    super->constructor( p_model ).
    wheels = p_wheels.
  ENDMETHOD.
ENDCLASS.
*&---------------------------------------------------------------------*
CLASS vehicle IMPLEMENTATION.

  METHOD gofaster.
    speed = speed + 1.
  ENDMETHOD.
**remove now is abstract
*  METHOD writespeed.
*    WRITE: /, |The vehicle speed is |, speed.
*  ENDMETHOD.

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
    "super->writespeed( ).
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

  "static
  car2=>numcars = 2.
  WRITE: /, car1=>numcars.

  "constructor INHERITING
  DATA(myaudi) = NEW audi( p_model = 'A4' p_wheels = 4 ).
  DATA(myford) = NEW ford( 'Focus' ).
  DATA(mymercedes) = NEW mercedes( 'C-CLASS' ).
