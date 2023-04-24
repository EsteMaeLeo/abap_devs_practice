*&---------------------------------------------------------------------*
*&  Include           ZUPLOAD_PERSONCLASIC_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE TEXT-t01.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK block2 WITH FRAME TITLE TEXT-t02.

"Application or Desktop file
PARAMETERS: p_server RADIOBUTTON GROUP file,
            p_desk   RADIOBUTTON GROUP file.

SELECTION-SCREEN END OF BLOCK block2.

SELECTION-SCREEN BEGIN OF BLOCK block3 WITH FRAME TITLE TEXT-t02.

"CRUD
PARAMETERS: p_spath TYPE filename-fileintern DEFAULT 'ZUPLOAD_PEOPLE'.
PARAMETERS: p_file TYPE rlgrap-filename.

SELECTION-SCREEN END OF BLOCK block3.
SELECTION-SCREEN END OF BLOCK block1.
