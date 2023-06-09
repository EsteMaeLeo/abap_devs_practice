*&---------------------------------------------------------------------*
*&  Include           ZUPLOAD_PERSONCLASIC_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE TEXT-t01.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK block2 WITH FRAME TITLE TEXT-t02.

"Application or Desktop file
PARAMETERS: p_server RADIOBUTTON GROUP file USER-COMMAND uc DEFAULT 'X',
            p_desk   RADIOBUTTON GROUP file.

SELECTION-SCREEN END OF BLOCK block2.

SELECTION-SCREEN BEGIN OF BLOCK block3 WITH FRAME TITLE TEXT-t05.
SELECTION-SCREEN SKIP.
"CRUD
PARAMETERS: p_lfile TYPE filename-fileintern DEFAULT 'ZUPLOAD_FILE' MODIF ID gr1.
PARAMETERS: p_lpath TYPE filepath-pathintern DEFAULT 'ZUPLOAD_PEOPLE' MODIF ID gr1.
PARAMETERS: p_file TYPE rlgrap-filename MODIF ID gr2.

SELECTION-SCREEN END OF BLOCK block3.

SELECTION-SCREEN BEGIN OF BLOCK block4 WITH FRAME TITLE TEXT-t06.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_crea TYPE c AS CHECKBOX DEFAULT abap_true. "Read file
SELECTION-SCREEN COMMENT (18) TEXT-t03.
PARAMETERS p_writ TYPE c AS CHECKBOX. "Write CSV file
SELECTION-SCREEN COMMENT (18) TEXT-t04.
PARAMETERS p_buff TYPE c AS CHECKBOX  USER-COMMAND cx . "Max lines
SELECTION-SCREEN COMMENT (18) TEXT-t07.
PARAMETERS p_dele TYPE c AS CHECKBOX .
SELECTION-SCREEN COMMENT (18) TEXT-t09.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK block4.

SELECTION-SCREEN BEGIN OF BLOCK block5 WITH FRAME TITLE TEXT-t08.
SELECTION-SCREEN SKIP.
"CRUD
PARAMETERS: p_lines TYPE dip0205 DEFAULT '10' MODIF ID gr3.

SELECTION-SCREEN END OF BLOCK block5.

SELECTION-SCREEN END OF BLOCK block1.
