FUNCTION zfm_mantain_airport.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_SAIRPORT) TYPE  SAIRPORT OPTIONAL
*"     REFERENCE(IM_ZSAIRPORT_TAB) TYPE  ZSAIRPORT_TAB OPTIONAL
*"     REFERENCE(IM_IDAIRPORT) TYPE  S_AIRPORT OPTIONAL
*"     REFERENCE(IM_FUNCTION) TYPE  CHAR1
*"  EXPORTING
*"     REFERENCE(EX_RESULT) TYPE  BAPIRET2_TAB
*"     REFERENCE(EX_SAIRPORT) TYPE  SAIRPORT
*"     REFERENCE(EX_ZSAIRPORT_TAB) TYPE  ZSAIRPORT_TAB
*"----------------------------------------------------------------------
  DATA: lwa_message TYPE symsg,
        lv_subrc    LIKE sy-subrc.


  IF im_function NE zcl_global_utils=>c_r.
    CALL FUNCTION 'ENQUEUE_EZAIRPORT'
      EXPORTING
        mandt          = sy-mandt
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

  CASE im_function.
    WHEN zcl_global_utils=>c_a. "Recreate all data Airport
      PERFORM f_recreate_all_airport CHANGING ex_result.
    WHEN zcl_global_utils=>c_c. "Create new entries in Airport

      PERFORM f_insert_airport USING    im_sairport
                                        im_zsairport_tab
                               CHANGING ex_result.

    WHEN zcl_global_utils=>c_r. "Read Airport
      PERFORM f_read_airport USING    im_idairport
                             CHANGING ex_sairport
                                      ex_zsairport_tab
                                      ex_result.

    WHEN zcl_global_utils=>c_u. "Update
      PERFORM f_update_byid USING     im_sairport
                                      im_zsairport_tab
                            CHANGING  ex_result.

    WHEN zcl_global_utils=>c_d. "delete
      PERFORM f_delete_byid USING     im_idairport
                            CHANGING  ex_result.
    WHEN zcl_global_utils=>c_w. "wipe delete all data on airport
      PERFORM f_delete_all_airport CHANGING ex_result.
  ENDCASE.

  IF im_function NE zcl_global_utils=>c_r.
    CALL FUNCTION 'DEQUEUE_EZAIRPORT'
      EXPORTING
        mandt          = sy-mandt
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

ENDFUNCTION.
