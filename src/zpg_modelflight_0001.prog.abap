*&---------------------------------------------------------------------*
*& Module Pool       ZPG_MODELFLIGHT_0001
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*


INCLUDE zpg_modelflight_0001top                 .    " global Data

* INCLUDE ZPG_MODELFLIGHT_0001O01                 .  " PBO-Modules
* INCLUDE ZPG_MODELFLIGHT_0001I01                 .  " PAI-Modules
* INCLUDE ZPG_MODELFLIGHT_0001F01                 .  " FORM-Routines

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ZSTANDARD'.
  SET TITLEBAR 'ZSTATUS'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  "SY-DYNNR
  CASE ok_code.
    WHEN 'ONLI'.
      PERFORM f_get_data_flight.
    WHEN '&F03' OR '&F15'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
FORM f_get_data_flight.

  IF sdyn_conn-connid IS NOT INITIAL
 AND sdyn_conn-carrid IS NOT INITIAL.

    SELECT SINGLE *
      FROM spfli
      INTO zstr_spfli
      WHERE carrid EQ sdyn_conn-carrid
        AND connid EQ sdyn_conn-connid.

  ENDIF.

ENDFORM.
