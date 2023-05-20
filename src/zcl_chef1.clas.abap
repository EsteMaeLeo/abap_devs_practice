class ZCL_CHEF1 definition
  public
  create public .

public section.

  events CALL_FOR_WAITER .

  methods CALL_FOR_SERVICE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CHEF1 IMPLEMENTATION.


  method CALL_FOR_SERVICE.

    WRITE: / |Chef calling waiter event|.
    RAISE EVENT call_for_waiter.
    WRITE: / |Chef calling waiter event complete|.
    ULINE.

  endmethod.
ENDCLASS.
