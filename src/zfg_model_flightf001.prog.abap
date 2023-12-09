*&---------------------------------------------------------------------*
*&  Include           ZFG_MODEL_FLIGHTF001
*&---------------------------------------------------------------------*

FORM f_recreate_all_airport CHANGING ch_message TYPE bapiret2_tab.

  DATA: lwa_message TYPE symsg,
        lv_subrc    LIKE sy-subrc.

  CLEAR: wa_msg,
         wa_sairport.

  FREE: gt_sairport,
        gt_msg.

  PERFORM f_delete_all_airport CHANGING ch_message.
  FREE ch_message.

  INCLUDE zfg_model_flightt001." Airport Data.

  CLEAR wa_sairport.

  PERFORM f_insert_airport USING     wa_sairport
                                     gt_sairport
                            CHANGING ch_message.


ENDFORM.
*&---------------------------------------------------------------------*
FORM f_insert_airport USING    us_sairport     TYPE  sairport
                               us_sairport_tab TYPE  zsairport_tab
                      CHANGING ch_message TYPE bapiret2_tab.

  DATA: lwa_message TYPE symsg.
  IF us_sairport IS NOT INITIAL.
    INSERT sairport FROM us_sairport.

    CASE sy-subrc.

      WHEN 0. " insert successful
        lwa_message-msgty = zcl_global_utils=>c_s.
        lwa_message-msgid = |ZGLOBAL_MSG|.
        lwa_message-msgno = 004.
        lwa_message-msgv1 = |SAIRPORT|.
        lwa_message-msgv2 = wa_sairport-name.

      WHEN 4. " duplicate keys occurred
        lwa_message-msgty = zcl_global_utils=>c_e.
        lwa_message-msgid = |ZGLOBAL_MSG|.
        lwa_message-msgno = 005.
        lwa_message-msgv1 = |SAIRPORT|.
        lwa_message-msgv2 = wa_sairport-name.
        lwa_message-msgv3 = wa_sairport-id.

      WHEN OTHERS. " error
        lwa_message-msgty = zcl_global_utils=>c_e.
        lwa_message-msgid = |ZGLOBAL_MSG|.
        lwa_message-msgno = 003.
        lwa_message-msgv1 = |SAIRPORT|.
        lwa_message-msgv2 = wa_sairport-name.

    ENDCASE.
    PERFORM  f_create_msg USING    lwa_message
                          CHANGING gt_msg.
  ELSE.

    IF us_sairport_tab IS NOT INITIAL.
      INSERT sairport FROM TABLE us_sairport_tab ACCEPTING DUPLICATE KEYS.
      CASE sy-subrc.

        WHEN 0. " insert successful
          lwa_message-msgty = zcl_global_utils=>c_s.
          lwa_message-msgid = |ZGLOBAL_MSG|.
          lwa_message-msgno = 018.

        WHEN 4. " duplicate keys occurred
          lwa_message-msgty = zcl_global_utils=>c_e.
          lwa_message-msgid = |ZGLOBAL_MSG|.
          lwa_message-msgno = 019.

        WHEN OTHERS. " error
          lwa_message-msgty = zcl_global_utils=>c_e.
          lwa_message-msgid = |ZGLOBAL_MSG|.
          lwa_message-msgno = 020.

      ENDCASE.
      PERFORM  f_create_msg USING    lwa_message
                            CHANGING ch_message.
    ELSE.
      lwa_message-msgty = zcl_global_utils=>c_s.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 021.
      lwa_message-msgv1 = |IM_ZSAIRPORT_TAB|.
      PERFORM  f_create_msg USING    lwa_message
                  CHANGING ch_message.
    ENDIF.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
FORM f_read_airport USING    us_idairport    TYPE  s_airport
                    CHANGING ch_sairport     TYPE  sairport
                             ch_sairport_tab TYPE  zsairport_tab
                             ch_message      TYPE bapiret2_tab.

  DATA: lwa_message TYPE symsg.

  IF us_idairport IS NOT INITIAL.

*    SELECT SINGLE id
*           name
*           time_zone
*      INTO ch_sairport
*      FROM sairport
*      WHERE id EQ us_idairport.
    SELECT SINGLE FROM sairport
      FIELDS id, name, time_zone
      WHERE id = @us_idairport
      INTO CORRESPONDING FIELDS OF @ch_sairport.

    IF sy-subrc EQ 0.

      lwa_message-msgty = zcl_global_utils=>c_s.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 006.
      lwa_message-msgv1 = ch_sairport-name.

    ELSE.

      lwa_message-msgty = zcl_global_utils=>c_s.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 007.
      lwa_message-msgv1 = ch_sairport-name.

    ENDIF.
    PERFORM  f_create_msg USING    lwa_message
                          CHANGING ch_message.

  ELSE.

    SELECT FROM sairport
      FIELDS mandt, id, name, time_zone
      INTO TABLE @ch_sairport_tab.

    IF sy-subrc EQ 0.

      lwa_message-msgty = zcl_global_utils=>c_s.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 008.
      lwa_message-msgv1 = ch_sairport-name.

    ELSE.

      lwa_message-msgty = zcl_global_utils=>c_s.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 009.
      lwa_message-msgv1 = |SAIRPORT|.

    ENDIF.
    PERFORM  f_create_msg USING    lwa_message
                      CHANGING ch_message.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
FORM f_update_byid USING     us_sairport     TYPE  sairport
                             us_sairport_tab TYPE  zsairport_tab
                   CHANGING  ch_message      TYPE bapiret2_tab.

  DATA: lwa_message TYPE symsg.

  IF us_sairport IS NOT INITIAL.

    UPDATE sairport FROM us_sairport.

    IF sy-subrc EQ 0.
      lwa_message-msgty = zcl_global_utils=>c_s.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 014.
      lwa_message-msgv1 = us_sairport-name.

    ELSE.
      lwa_message-msgty = zcl_global_utils=>c_e.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 015.
      lwa_message-msgv1 =  us_sairport-name.

    ENDIF.
    PERFORM  f_create_msg USING    lwa_message
                          CHANGING ch_message.
  ELSE.
    UPDATE sairport FROM TABLE us_sairport_tab.
    IF sy-subrc EQ 0.
      lwa_message-msgty = zcl_global_utils=>c_s.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 016.
      lwa_message-msgv1 = |SAIRPORT|.

    ELSE.
      lwa_message-msgty = zcl_global_utils=>c_e.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 017.
      lwa_message-msgv1 =  |SAIRPORT|.

    ENDIF.
    PERFORM  f_create_msg USING    lwa_message
                      CHANGING ch_message.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
FORM f_delete_byid USING     us_idairport TYPE  s_airport
                   CHANGING  ch_message   TYPE bapiret2_tab.

  DATA: lwa_message TYPE symsg.

  IF us_idairport IS NOT INITIAL.

    DELETE FROM sairport WHERE id EQ us_idairport.

    IF sy-subrc EQ 0.
      lwa_message-msgty = zcl_global_utils=>c_s.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 012.
      lwa_message-msgv1 =  us_idairport.

    ELSE.
      lwa_message-msgty = zcl_global_utils=>c_e.
      lwa_message-msgid = |ZGLOBAL_MSG|.
      lwa_message-msgno = 011.
      lwa_message-msgv1 =  us_idairport.

    ENDIF.

    PERFORM  f_create_msg USING    lwa_message
                          CHANGING ch_message.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
FORM f_delete_all_airport CHANGING  ch_message TYPE bapiret2_tab.
  DATA: lwa_message TYPE symsg.

  DELETE FROM sairport.
  IF sy-subrc EQ 0.
    lwa_message-msgty = zcl_global_utils=>c_s.
    lwa_message-msgid = |ZGLOBAL_MSG|.
    lwa_message-msgno = 013.
    lwa_message-msgv1 = |SAIRPORT|.

  ELSE.
    lwa_message-msgty = zcl_global_utils=>c_e.
    lwa_message-msgid = |ZGLOBAL_MSG|.
    lwa_message-msgno = 010.
    lwa_message-msgv1 = |SAIRPORT|.

  ENDIF.
  PERFORM  f_create_msg USING    lwa_message
                        CHANGING ch_message.
ENDFORM.

*&---------------------------------------------------------------------*
FORM f_create_msg USING    us_message TYPE symsg
                  CHANGING ch_message TYPE bapiret2_tab.

  CLEAR: wa_msg.

  CALL FUNCTION 'BALW_BAPIRETURN_GET2'
    EXPORTING
      type   = us_message-msgty
      cl     = us_message-msgid
      number = us_message-msgno
      par1   = us_message-msgv1
      par2   = us_message-msgv2
      par3   = us_message-msgv3
      par4   = us_message-msgv4
    IMPORTING
      return = wa_msg
    EXCEPTIONS
      OTHERS = 0.

  APPEND wa_msg TO ch_message.
ENDFORM.
