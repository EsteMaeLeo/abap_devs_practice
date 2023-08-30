*&---------------------------------------------------------------------*
*& Report ZPG_CONSUME_AIRPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpg_consume_airport.

DATA: cl_proxy_airport TYPE REF TO zco_zwbs_wb_get_airports, " Proxy Class
      lwa_input        TYPE zfm_airport, " Proxy Input
      lwa_output       TYPE zfm_airportresponse, " Proxy Output
      fault            TYPE REF TO cx_root. " Generic Fault

*Input move the values in case WBS has input require values
*lwa_input-airportcode = 'JFK'.
TRY.
    cl_proxy_airport = NEW #( logical_port_name = 'ZWBS_AIRPORT' ).

    cl_proxy_airport->zfm_airport( EXPORTING input = lwa_input
                                   IMPORTING output = lwa_output ).
  CATCH cx_root INTO fault.
    WRITE / fault->get_text( ).
ENDTRY.
BREAK-POINT.
