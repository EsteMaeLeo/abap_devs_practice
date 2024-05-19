*&---------------------------------------------------------------------*
*& Include ZPG_MODELFLIGHT_0001TOP                           Module Pool      ZPG_MODELFLIGHT_0001
*&
*&---------------------------------------------------------------------*
PROGRAM zpg_modelflight_0001.

TABLES: sdyn_conn,
        zstr_spfli.

DATA wa_spfli TYPE spfli.

DATA: g_dynnr TYPE sy-dynnr,
      ok_code TYPE sy-ucomm,
      io_comm TYPE c LENGTH 1.
