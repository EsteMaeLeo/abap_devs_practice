class ZCL_WAITER1 definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !I_WHO type STRING .
  methods GO_SEE_THE_CHEF
    for event CALL_FOR_WAITER of ZCL_CHEF1 .
  methods GO_SEE_THE_CUSTOMER
    for event CALL_FOR_WAITER of ZCL_CUSTOMER1
    importing
      !E_TABLE_NUMBER .
  methods GO_SEE_UBER .
protected section.

  data WHO type STRING .
private section.
ENDCLASS.



CLASS ZCL_WAITER1 IMPLEMENTATION.


  method CONSTRUCTOR.

    who = i_who.

  endmethod.


  method GO_SEE_THE_CHEF.

    WRITE: / who, |goest to see the chef|.

  endmethod.


  method GO_SEE_THE_CUSTOMER.

    WRITE: / who, |goest to see the customer at table|, e_table_number LEFT-JUSTIFIED.

  endmethod.


  method GO_SEE_UBER.
  endmethod.
ENDCLASS.
