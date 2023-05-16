FUNCTION zfm_validate_email.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_EMAIL) TYPE  AD_SMTPADR
*"  EXPORTING
*"     REFERENCE(EX_MSG) TYPE  C
*"----------------------------------------------------------------------


  go_regex = NEW #( pattern     = gc_email_regex
                    ignore_case = abap_true ).

  go_matcher = go_regex->create_matcher( text = im_email ).

  IF go_matcher->match( ) IS INITIAL.
    ex_msg = zcl_global_utils=>c_e.
  ELSE.
    ex_msg = zcl_global_utils=>c_s.
  ENDIF.

ENDFUNCTION.
