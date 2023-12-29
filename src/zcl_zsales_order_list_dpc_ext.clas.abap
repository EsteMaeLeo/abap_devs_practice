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

    DATA: ls_maxrows      TYPE  bapi_epm_max_rows,
          lt_soheaderdata TYPE TABLE OF  bapi_epm_so_header.

    ls_maxrows-bapimaxrow = 20.

    CALL FUNCTION 'BAPI_EPM_SO_GET_LIST'
      EXPORTING
        max_rows     = ls_maxrows
      TABLES
        soheaderdata = lt_soheaderdata.

    et_entityset[] = lt_soheaderdata[].
  ENDMETHOD.
ENDCLASS.
