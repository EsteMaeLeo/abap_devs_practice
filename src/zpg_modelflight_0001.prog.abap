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
*&      Module  STATUS_0090  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0090 OUTPUT.
  SET PF-STATUS 'ZSTANDARD'.
  SET TITLEBAR 'ZSTATUS'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0090  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0090 INPUT.

  CASE ok_code.
    WHEN 'BNSPS'.
      CALL SCREEN 100.
    WHEN 'BNSF'.
      CALL SCREEN 200.
    WHEN '&F03' OR '&F15'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
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
      LEAVE TO SCREEN 90.
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

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'ZSTANDARD'.
  SET TITLEBAR 'ZSTATUS'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_sflight INPUT.
  CASE ok_code.
    WHEN 'ONLI'.
      PERFORM f_get_data_sflight.
    WHEN 'BNTIME'.
      CALL SCREEN 250 STARTING AT 10 10
      ENDING AT 50 20.
    WHEN '&F03' OR '&F15'.
      LEAVE TO SCREEN 90.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*----------------------------------------------------------------------*

FORM f_get_data_sflight.

  SELECT SINGLE price,
                currency,
                planetype,
                seatsmax,
                seatsocc,
                paymentsum
           FROM sflight
           WHERE carrid EQ @sdyn_conn-carrid
             AND connid EQ @sdyn_conn-connid
             AND fldate EQ @sdyn_conn-fldate
           INTO CORRESPONDING FIELDS OF @sdyn_conn.

    IF sy-subrc NE 0.
        MESSAGE i007(bc410).
    ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0250  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0250 INPUT.
 CASE ok_code.
    WHEN 'BNEXIT'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
