FUNCTION zfm_mantain_airport.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(SAIRPORT) TYPE  SAIRPORT OPTIONAL
*"     REFERENCE(ZSAIRPORT_TAB) TYPE  ZSAIRPORT_TAB OPTIONAL
*"     REFERENCE(ID_AIRPORT) TYPE  S_AIRPORT
*"     REFERENCE(FUNCTION) TYPE  CHAR1
*"  EXPORTING
*"     REFERENCE(RESULT) TYPE  BAPIRET2_TAB
*"----------------------------------------------------------------------

  CASE function.
    WHEN zcl_global_utils=>c_c.
    WHEN zcl_global_utils=>c_r.
    WHEN zcl_global_utils=>c_u.
    WHEN zcl_global_utils=>c_d.
  ENDCASE.



ENDFUNCTION.
