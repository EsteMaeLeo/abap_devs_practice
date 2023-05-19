*&---------------------------------------------------------------------*
*& Report ZBASIC_EVENT_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbasic_event_class.

CLASS chef DEFINITION.
  PUBLIC SECTION.
    METHODS: call_for_service.
    EVENTS: call_for_waiter.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS customer DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING VALUE(i_table_number) TYPE i,
      call_for_assitance.
    EVENTS: call_for_waiter EXPORTING VALUE(e_table_number) TYPE i.
  PROTECTED SECTION.
    DATA table_numer TYPE i.
  PRIVATE SECTION.
ENDCLASS.

CLASS chef IMPLEMENTATION.
  METHOD call_for_service.
    WRITE: / |Chef calling waiter event|.
    RAISE EVENT call_for_waiter.
    WRITE: / |Chef calling waiter event complete|.
    ULINE.
  ENDMETHOD.
ENDCLASS.

CLASS customer IMPLEMENTATION.

  METHOD constructor.
    table_numer = i_table_number.
  ENDMETHOD.

  METHOD call_for_assitance.
    WRITE: / |Customer calling waiter event|.
    RAISE EVENT call_for_waiter EXPORTING e_table_number = table_numer.
    WRITE: / |Customer calling waiter event complete|.
    ULINE.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(o_chef) = NEW chef( ).
  DATA(o_customer1) = NEW customer( i_table_number = 2 ).
  DATA(o_customer2) = NEW customer( i_table_number = 3 ).

  o_chef->call_for_service( ).
  o_customer1->call_for_assitance( ).
  o_customer2->call_for_assitance( ).
