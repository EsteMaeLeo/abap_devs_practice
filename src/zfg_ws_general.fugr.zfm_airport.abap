FUNCTION zfm_airport.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(AIRPORTS) TYPE  ZSAIRPORT_TAB
*"     VALUE(RESULT) TYPE  TEXT80
*"----------------------------------------------------------------------

  SELECT FROM sairport
    FIELDS *
    INTO TABLE @airports.

  IF sy-subrc EQ 0.
    result = |OK|.
  ELSE.
    result = |Not airports found|.
  ENDIF.



ENDFUNCTION.
