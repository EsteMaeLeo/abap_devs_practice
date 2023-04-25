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
 AT SELECTION-SCREEN OUTPUT.
   PERFORM f_modify_screen.

AT SELECTION-SCREEN ON p_lpath.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.


START-OF-SELECTION.
BREAK-POINT.
  PERFORM f_open_appfile.
