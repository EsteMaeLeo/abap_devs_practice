FUNCTION zfm_person_state_person.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_STATE) TYPE  CHAR1 DEFAULT 'SJ'
*"  EXPORTING
*"     VALUE(EX_TAB_PERSON) TYPE  ZST_UPLOADPERSONCR
*"----------------------------------------------------------------------

  CASE im_state.
    WHEN zcl_global_utils=>c_sj.
    WHEN zcl_global_utils=>c_al.
    WHEN zcl_global_utils=>c_he.
    WHEN zcl_global_utils=>c_ca.
    WHEN zcl_global_utils=>c_pt.
    WHEN zcl_global_utils=>c_gn.
    WHEN zcl_global_utils=>c_lm.
    WHEN zcl_global_utils=>c_08.
    WHEN zcl_global_utils=>c_09.
  ENDCASE.


ENDFUNCTION.
