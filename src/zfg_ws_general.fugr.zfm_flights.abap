FUNCTION zfm_flights.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(AIRLINE_CODE) TYPE  S_CARR_ID
*"  EXPORTING
*"     VALUE(FLIGHTS) TYPE  SPFLI_TAB
*"     VALUE(RESULT) TYPE  TEXT80
*"----------------------------------------------------------------------


  SELECT FROM spfli
    FIELDS *
    WHERE carrid EQ @airline_code
    INTO TABLE @flights.

  IF sy-subrc EQ 0.
    result = |OK|.
  ELSE.
    result = |Not fligths found with the key|.
  ENDIF.


ENDFUNCTION.
