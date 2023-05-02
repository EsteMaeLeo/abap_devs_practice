*&---------------------------------------------------------------------*
*&  Include           ZEXA_ALV001_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS slis.

TYPES: BEGIN OF ty_flights,
         carrid   TYPE s_carrid,
         connid   TYPE s_conn_id,
         cityfrom TYPE s_from_cit,
         cityto   TYPE s_to_city,
       END OF ty_flights,

       tt_flights       TYPE STANDARD TABLE OF ty_flights,
       tt_flights_field TYPE STANDARD TABLE OF zspfli,
       tt_header        TYPE STANDARD TABLE OF spfli,
       tt_item          TYPE STANDARD TABLE OF sflight.

DATA: gt_flights       TYPE tt_flights,
      gt_flights_field TYPE tt_flights_field,
      gt_fieldcat      TYPE slis_t_fieldcat_alv,
      gt_header        TYPE STANDARD TABLE OF spfli,
      gt_item          TYPE STANDARD TABLE OF sflight.


CONSTANTS: c_flight_field TYPE slis_tabname VALUE 'GT_FLIGHTS_FIELD',
           c_header       TYPE slis_tabname VALUE 'GT_HEADER',
           c_item         TYPE slis_tabname VALUE 'GT_ITEM'.
