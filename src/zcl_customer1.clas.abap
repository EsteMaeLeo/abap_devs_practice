class ZCL_CUSTOMER1 definition
  public
  create public .

public section.

  events CALL_FOR_WAITER
    exporting
      value(E_TABLE_NUMBER) type I .

  methods CONSTRUCTOR
    importing
      value(I_TABLE_NUMBER) type I .
  methods CALL_FOR_ASSITANCE .
protected section.

  data TABLE_NUMER type I .
private section.
ENDCLASS.



CLASS ZCL_CUSTOMER1 IMPLEMENTATION.


  method CALL_FOR_ASSITANCE.

    WRITE: / |Customer calling waiter event|.
    RAISE EVENT call_for_waiter EXPORTING e_table_number = table_numer.
    WRITE: / |Customer calling waiter event complete|.
    ULINE.

  endmethod.


  method CONSTRUCTOR.

    table_numer = i_table_number.

  endmethod.
ENDCLASS.
