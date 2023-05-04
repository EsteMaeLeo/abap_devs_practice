FUNCTION zfm_person_read_person.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_ID) TYPE  ZIDCR
*"  EXPORTING
*"     VALUE(EX_PERSON) TYPE  ZSTPERSON
*"     VALUE(EX_MESSAGE) TYPE  BAPIRET2
*"  EXCEPTIONS
*"      ID_EMPTY
*"      NOT_RECORD_FOUND
*"----------------------------------------------------------------------

  IF im_id NE 0.

    CLEAR ex_person.

    SELECT SINGLE id
                  code_electoral
                  expire_date
                  committee_vote
                  name
                  first_last_name
                  second_last_name
             FROM zuploadpersoncr
             INTO ex_person
            WHERE id EQ im_id.

    IF sy-subrc NE 0.
      ex_message-type = zcl_global_utils=>c_e.
      ex_message-number = 000.
      ex_message-message_v1 = im_id.
    ELSE.
      ex_message-type = zcl_global_utils=>c_s.
      ex_message-number = 002.
      ex_message-message_v1 = im_id.
    ENDIF.

  ELSE.
    ex_message-type = zcl_global_utils=>c_e.
    ex_message-number = 001.
  ENDIF.

ENDFUNCTION.
