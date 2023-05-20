*&---------------------------------------------------------------------*
*& Report ZBASIC_GLOBAL_EVENT_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbasic_global_event_class.

START-OF-SELECTION.

  DATA(o_chef) = NEW zcl_chef1( ).
  DATA(o_customer1) = NEW zcl_customer1( i_table_number = 2 ).
  DATA(o_customer2) = NEW zcl_customer1( i_table_number = 3 ).
  DATA(o_head_waiter) = NEW zcl_waiter1( 'Sara the head waiter' ).
  DATA(o_waiter) = NEW zcl_waiter1( 'Bob the waiter' ).

  "register handler
  SET HANDLER: o_head_waiter->go_see_the_chef FOR o_chef,
               o_waiter->go_see_the_customer FOR ALL INSTANCES.

  o_chef->call_for_service( ).
  o_customer1->call_for_assitance( ).
  o_customer2->call_for_assitance( ).
