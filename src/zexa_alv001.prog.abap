*&---------------------------------------------------------------------*
*& Report ZEXA_ALV001
*&---------------------------------------------------------------------*
*& Example ALV using Function Modules
*&---------------------------------------------------------------------*
REPORT zexa_alv001.

INCLUDE zexa_alv001_top.

INCLUDE zexa_alv001_sel.

INCLUDE zexa_alv001_f01.

AT SELECTION-SCREEN OUTPUT.
  IF p_normal EQ abap_true.
    LOOP AT SCREEN.
      IF screen-group1 = 'R11'.
      ENDIF.
    ENDLOOP.
  ENDIF.

START-OF-SELECTION.

  IF p_normal EQ abap_true AND p_hier EQ abap_true.
    MESSAGE 'Normal and hierarchy both option can not be executed' TYPE 'I'.
  ELSE.
    PERFORM f_build_fieldcat CHANGING gt_fieldcat.

    PERFORM f_get_data.

    CASE abap_true.
      WHEN p_list.
        PERFORM f_display_alv_list.
      WHEN p_grid.
        PERFORM f_display_alv_grid.
      WHEN p_hier.
        PERFORM f_display_alv_hier.
    ENDCASE.
  ENDIF.
