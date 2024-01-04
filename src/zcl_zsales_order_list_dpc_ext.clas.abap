class ZCL_ZSALES_ORDER_LIST_DPC_EXT definition
  public
  inheriting from ZCL_ZSALES_ORDER_LIST_DPC
  create public .

public section.
protected section.

  methods SALESORDERSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZSALES_ORDER_LIST_DPC_EXT IMPLEMENTATION.


  METHOD salesorderset_get_entityset.
**TRY.
*CALL METHOD SUPER->SALESORDERSET_GET_ENTITYSET
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
    CONSTANTS: lc_bapi_msg_type_error   TYPE bapi_mtype VALUE 'E'.
*******************************************************************
***                     INSIDE OUT                              ***
*******************************************************************
    DATA: ls_maxrows      TYPE  bapi_epm_max_rows,
          lt_soheaderdata TYPE TABLE OF  bapi_epm_so_header.

    ls_maxrows-bapimaxrow = 20.

    CALL FUNCTION 'BAPI_EPM_SO_GET_LIST'
      EXPORTING
        max_rows     = ls_maxrows
      TABLES
        soheaderdata = lt_soheaderdata.

    et_entityset[] = lt_soheaderdata[].

*******************************************************************
***                     OUTSIDE IN                              ***
*******************************************************************

    DATA: lv_max_rows             TYPE if_epm_bo=>ty_query_max_rows,
          lt_epm_so_id_range      TYPE if_epm_so_header=>tt_sel_par_header_ids,
          lt_epm_buyer_name_range TYPE if_epm_so_header=>tt_sel_par_company_names,
          lt_epm_product_id_range TYPE if_epm_so_header=>tt_sel_par_product_ids,
          lt_epm_so_header_data   TYPE if_epm_so_header=>tt_node_data.

    TRY.

        DATA(li_epm_so_header) = CAST if_epm_so_header( cl_epm_service_facade=>get_bo( if_epm_so_header=>gc_bo_name ) ).
        DATA(li_message_buffer) = CAST if_epm_message_buffer( cl_epm_service_facade=>get_message_buffer( ) ).

        lv_max_rows = 30.

        " retrieve EPM SO header data according to given selection criteria
        li_epm_so_header->query_by_header(
          EXPORTING
            it_sel_par_header_ids    = lt_epm_so_id_range[]
            it_sel_par_company_names = lt_epm_buyer_name_range[]
            it_sel_par_product_ids   = lt_epm_product_id_range[]
            iv_max_rows              = lv_max_rows
          IMPORTING
             et_data                 = lt_epm_so_header_data[] ).

        FREE et_entityset.

        et_entityset = CORRESPONDING #( lt_epm_so_header_data ).
      CATCH cx_epm_exception INTO DATA(lo_ex).

        DATA: ls_message    TYPE bapiret2,
              lt_bapirettab TYPE bapirettab..

        CALL FUNCTION 'BALW_BAPIRETURN_GET2'
          EXPORTING
            type   = lc_bapi_msg_type_error
            cl     = lo_ex->if_t100_message~t100key-msgid
            number = lo_ex->if_t100_message~t100key-msgno
            par1   = lo_ex->mv_var1
            par2   = lo_ex->mv_var2
            par3   = lo_ex->mv_var3
            par4   = lo_ex->mv_var4
          IMPORTING
            return = ls_message.
        APPEND ls_message TO lt_bapirettab[].

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
