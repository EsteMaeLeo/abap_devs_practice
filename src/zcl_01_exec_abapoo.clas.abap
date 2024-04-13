CLASS zcl_01_exec_abapoo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_01_exec_abapoo IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    data lo_contract type REF TO zcl_01_contract_oo.
*
*    create OBJECT lo_contract.
*
*    lo_contract = new #(  ).

    DATA(lo_contract) = NEW zcl_01_contract_oo(  ).

    DATA lv_process TYPE string.

    IF lo_contract IS BOUND.

      lo_contract->set_client(
        EXPORTING
          iv_client   = 'Walmart'
          iv_location = space
        IMPORTING
          ev_status   = DATA(lv_status)
        CHANGING
          cv_process  = lv_process ).

*          CALL METHOD lo_contract->set_client
*            EXPORTING
*              iv_client   =
*              iv_location =
**            IMPORTING
**             ev_status   =
*            CHANGING
*              cv_process  =.

      lo_contract->get_client( IMPORTING ev_client = DATA(lv_client) ).

      lo_contract->region = 'EU'.

    ENDIF.

    zcl_01_contract_oo=>set_cntr_type( iv_cntr_type = 'Construction' ).

    zcl_01_contract_oo=>get_cntr_type(
      IMPORTING
        ev_cntr_type = data(lv_cntr_type)
    ).

    out->write( 'Hello Cloud Trial' ).
    out->write( |{ lv_client }-{ lv_status }-{ lv_process }-{ lo_contract->region } | ).

    out->write( lv_cntr_type ).

  ENDMETHOD.

ENDCLASS.
