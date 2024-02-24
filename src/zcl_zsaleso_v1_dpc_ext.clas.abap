CLASS zcl_zsaleso_v1_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zsaleso_v1_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS customersset_create_entity REDEFINITION .
    METHODS customersset_get_entity REDEFINITION .
    METHODS customersset_get_entityset REDEFINITION .
    METHODS ordersset_create_entity REDEFINITION .
    METHODS paymentsset_create_entity REDEFINITION .

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zsaleso_v1_dpc_ext IMPLEMENTATION.


  METHOD customersset_create_entity.

    DATA ls_customers TYPE zcustomers.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_customers ).

    INSERT zcustomers FROM ls_customers.

    IF sy-subrc EQ 0.
      er_entity = ls_customers.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = 002
                                            attr1 = 'Error at Insert into table').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.

  ENDMETHOD.

  METHOD customersset_get_entity.

    IF line_exists( it_key_tab[ name = 'Customerid' ] ).

      DATA(lv_customerid) = it_key_tab[ name = 'Customerid' ]-value.

      SELECT SINGLE FROM zcustomers
      FIELDS *
          WHERE customerid EQ @lv_customerid
          INTO @er_entity.

    ELSE.


    ENDIF.


  ENDMETHOD.

  METHOD customersset_get_entityset.

*CALL METHOD SUPER->CUSTOMERSSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD ordersset_create_entity.

    DATA: ls_orders     TYPE zst_orders_ct,
          ls_orders_ins TYPE zorders.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_orders ).

    ls_orders_ins = VALUE #( orderid      = ls_orders-orderid
                            customerid    = ls_orders-customerid
                            paymentid     = ls_orders-paymentid
                            orderdate     = ls_orders-orderdate
                            shipdate      = ls_orders-shipdate
                            shipvia       = ls_orders-shipvia
                            city          = ls_orders-shipaddress-city
                            street        = ls_orders-shipaddress-street
                            postalcode    = ls_orders-shipaddress-postalcode
                            buildernumber = ls_orders-shipaddress-buildernumber
                            country       = ls_orders-shipaddress-country ).


    INSERT zorders FROM ls_orders_ins.

    IF sy-subrc EQ 0.
      er_entity =  ls_orders.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = 002
                                            attr1 = 'Error at Insert into table').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.
  ENDMETHOD.


  METHOD paymentsset_create_entity.
    DATA ls_payments TYPE zpayments.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_payments ).

    INSERT zpayments FROM ls_payments.

    IF sy-subrc EQ 0.
      er_entity = ls_payments.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = 002
                                            attr1 = 'Error at Insert into table').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
