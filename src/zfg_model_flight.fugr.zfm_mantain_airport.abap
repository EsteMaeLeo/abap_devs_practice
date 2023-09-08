FUNCTION zfm_mantain_airport.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_SAIRPORT) TYPE  SAIRPORT OPTIONAL
*"     REFERENCE(IM_ZSAIRPORT_TAB) TYPE  ZSAIRPORT_TAB OPTIONAL
*"     REFERENCE(IM_IDAIRPORT) TYPE  S_AIRPORT
*"     REFERENCE(IM_FUNCTION) TYPE  CHAR1
*"  EXPORTING
*"     REFERENCE(EX_RESULT) TYPE  BAPIRET2_TAB
*"     REFERENCE(EX_SAIRPORT) TYPE  SAIRPORT
*"     REFERENCE(EX_ZSAIRPORT_TAB) TYPE  ZSAIRPORT_TAB
*"----------------------------------------------------------------------
  DATA: lwa_message TYPE symsg,
        lv_subrc    LIKE sy-subrc.

  CASE im_function.
    WHEN zcl_global_utils=>c_a. "Recreate all data Airport
      PERFORM f_recreate_all_airport.
    WHEN zcl_global_utils=>c_c. "Create new entries in Airport

      PERFORM f_insert_airport USING    im_sairport
                                        im_zsairport_tab
                               CHANGING lv_subrc .

      CASE lv_subrc.

        WHEN 0. " insert successful
          lwa_message-msgty = zcl_global_utils=>c_s.
          lwa_message-msgid = |ZGLOBAL_MSG|.
          lwa_message-msgno = 004.
          lwa_message-msgv1 = |SAIRPORT|.
          lwa_message-msgv2 = im_sairport-name.

          PERFORM  f_create_msg USING    lwa_message
                                CHANGING ex_result.
        WHEN 4. " duplicate keys occurred
          lwa_message-msgty = zcl_global_utils=>c_e.
          lwa_message-msgid = |ZGLOBAL_MSG|.
          lwa_message-msgno = 005.
          lwa_message-msgv1 = |SAIRPORT|.
          lwa_message-msgv2 = im_sairport-name.
          lwa_message-msgv3 = im_sairport-id.

          PERFORM  f_create_msg USING    lwa_message
                                CHANGING ex_result.
        WHEN OTHERS. " error
          lwa_message-msgty = zcl_global_utils=>c_e.
          lwa_message-msgid = |ZGLOBAL_MSG|.
          lwa_message-msgno = 003.
          lwa_message-msgv1 = |SAIRPORT|.
          lwa_message-msgv2 = im_sairport-name.

          PERFORM  f_create_msg USING    lwa_message
                                CHANGING ex_result.
      ENDCASE.

    WHEN zcl_global_utils=>c_r. "Read Airport
      PERFORM f_read_airport USING    im_idairport
                             CHANGING ex_sairport
                                      ex_zsairport_tab
                                      ex_result.

    WHEN zcl_global_utils=>c_u. "Update
    WHEN zcl_global_utils=>c_d. "delete
  ENDCASE.



ENDFUNCTION.
