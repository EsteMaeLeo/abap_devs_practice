*&---------------------------------------------------------------------*
*&  Include           ZEXA_ALV001_SEL
*&---------------------------------------------------------------------*
TABLES: spfli.
SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE TEXT-001.

SELECTION-SCREEN BEGIN OF BLOCK block2 WITH FRAME TITLE TEXT-002.

SELECT-OPTIONS: so_carr FOR spfli-carrid.

SELECTION-SCREEN END OF BLOCK block2.

SELECTION-SCREEN BEGIN OF BLOCK block3 WITH FRAME TITLE TEXT-003.

PARAMETERS: p_normal RADIOBUTTON GROUP cat USER-COMMAND com MODIF ID r11,
            p_all    RADIOBUTTON GROUP cat.


SELECTION-SCREEN END OF BLOCK block3.

SELECTION-SCREEN BEGIN OF BLOCK block4 WITH FRAME TITLE TEXT-004.

PARAMETERS: p_list RADIOBUTTON GROUP alv,
            p_grid RADIOBUTTON GROUP alv,
            p_hier RADIOBUTTON GROUP alv.

SELECTION-SCREEN END OF BLOCK block4.

SELECTION-SCREEN BEGIN OF BLOCK block5 WITH FRAME TITLE TEXT-005.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_op1 TYPE c AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN COMMENT (22) TEXT-t01.
PARAMETERS p_op2 TYPE c AS CHECKBOX .
SELECTION-SCREEN COMMENT (22) TEXT-t02.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK block5.

SELECTION-SCREEN END OF BLOCK block1.
