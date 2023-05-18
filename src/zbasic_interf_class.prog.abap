*&---------------------------------------------------------------------*
*& Report ZBASIC_INTERF_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbasic_interf_class.

"interfaces
INTERFACE intf_speed.
  METHODS: writespeed.
ENDINTERFACE.

CLASS train DEFINITION.
  PUBLIC SECTION.
    INTERFACES intf_speed.
    ALIASES writespeed FOR intf_speed~writespeed. " using aliases
    METHODS: gofaster.
  PROTECTED SECTION.
    DATA speed TYPE i.
ENDCLASS.

CLASS train IMPLEMENTATION.
  METHOD intf_speed~writespeed. " still use full name
    WRITE: /, |Train speed is: |, speed LEFT-JUSTIFIED.
  ENDMETHOD.

  METHOD gofaster.
    speed = speed + 10.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(lo_train) = NEW train( ).
  lo_train->gofaster( ).
  lo_train->writespeed( ). "calling program use the aliases
