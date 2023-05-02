*&---------------------------------------------------------------------*
*& Report ZUPLOAD_PERSONCLASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zupload_personclasic.

INCLUDE zupload_personclasic_top.
INCLUDE zupload_personclasic_sel.
INCLUDE zupload_personclasic_forms.

INITIALIZATION.


*----------------------------------------------------------------------*
*     AT SELECTION-SCREEN ON VALUE-REQUEST
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  PERFORM f_modify_screen.

AT SELECTION-SCREEN ON p_lpath.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_dialog_desktop.

START-OF-SELECTION.
  BREAK-POINT.
  CASE abap_true.
    WHEN p_server.
      PERFORM f_process_appfile.
    WHEN p_desk.
      PERFORM f_process_desk.
  ENDCASE.

  "display ALV
  PERFORM f_alv_merge_cat CHANGING gt_fieldcat.

  PERFORM f_add_eventes CHANGING gt_event.

  PERFORM f_list_flights_dict_grid USING got_person
                                         gwa_layout
                                         gt_event.
