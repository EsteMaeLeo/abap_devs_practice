*&---------------------------------------------------------------------*
*&  Include           ZFG_MODEL_FLIGHTF001
*&---------------------------------------------------------------------*

FORM f_insert_airport USING    us_sairport     TYPE  sairport
                               us_sairport_tab TYPE  zsairport_tab
                      CHANGING ch_msg          TYPE bapiret2_tab.

  IF us_sairport IS NOT INITIAL.
    INSERT sairport FROM us_sairport.
  ELSE.
    INSERT sairport FROM TABLE us_sairport_tab ACCEPTING DUPLICATE KEYS.
  ENDIF.

ENDFORM.

FORM f_create_msg CHANGING ch_msg TYPE bapiret2_tab..

ENDFORM.
