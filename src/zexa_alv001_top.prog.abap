*&---------------------------------------------------------------------*
*&  Include           ZEXA_ALV001_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS slis.

TYPES: BEGIN OF ty_flights,
         carrid   TYPE s_carrid,
         connid   TYPE s_conn_id,
         cityfrom TYPE s_from_cit,
         cityto   TYPE s_to_city,
       END OF ty_flights.

DATA: gt_flights  TYPE TABLE OF ty_flights,
      gt_fieldcat TYPE slis_t_fieldcat_alv.
