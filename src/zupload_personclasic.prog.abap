*&---------------------------------------------------------------------*
*& Report ZUPLOAD_PERSONCLASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zupload_personclasic.

INCLUDE  zupload_personclasic_top.
INCLUDE  zupload_personclasic_sel.
INCLUDE zupload_personclasic_forms.

INITIALIZATION.


*----------------------------------------------------------------------*
*     AT SELECTION-SCREEN ON VALUE-REQUEST
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_spath.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.


START-OF-SELECTION.
