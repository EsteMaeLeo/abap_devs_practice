*&---------------------------------------------------------------------*
*& Report ZEXA_ALV001
*&---------------------------------------------------------------------*
*& Example ALV using Function Modules
*&---------------------------------------------------------------------*
REPORT zexa_alv001.

INCLUDE zexa_alv001_top.

INCLUDE zexa_alv001_sel.

INCLUDE zexa_alv001_form01.

START-OF-SELECTION.

  PERFORM f_get_data.

  PERFORM f_build_fieldcat.

  CASE abap_true.
    WHEN p_list.
      PERFORM f_display_alv_list.
    WHEN p_grid.
    WHEN p_hier.
  ENDCASE.
