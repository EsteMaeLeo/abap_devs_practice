*&---------------------------------------------------------------------*
*&  Include           ZEXA_ALV001_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

  PARAMETERS: p_carr type s_carr_id.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.

  PARAMETERS: p_list RADIOBUTTON GROUP alv,
              p_grid RADIOBUTTON GROUP alv,
              p_hier RADIOBUTTON GROUP alv.

SELECTION-SCREEN END OF BLOCK b2.
