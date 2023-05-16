FUNCTION-POOL zfg_global_utils.             "MESSAGE-ID ..

* INCLUDE LZFG_GLOBAL_UTILSD...              " Local class definition

DATA: go_regex   TYPE REF TO cl_abap_regex,
      go_matcher TYPE REF TO cl_abap_matcher,
      gv_match   TYPE c LENGTH 1.

CONSTANTS: gc_email_regex TYPE string VALUE '\w+(\.\w+)*@(\w+\.)+(\w{2,4})'.
