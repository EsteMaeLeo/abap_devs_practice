CLASS zcl_person_operation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA technical_message TYPE string.

    "return Person according ID
    METHODS:
      get_person                 IMPORTING id            TYPE zidcr
                                 EXPORTING message       TYPE bapiret2
                                 RETURNING VALUE(person) TYPE zstperson,
      check_person_single_bool   IMPORTING id            TYPE zidcr
                                 RETURNING VALUE(exists) TYPE abap_bool,
      check_person_single_clasic IMPORTING id            TYPE zidcr
                                 RETURNING VALUE(exists) TYPE abap_bool,
      check_person_uptorows      IMPORTING id            TYPE zidcr
                                 RETURNING VALUE(exists) TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_person_operation IMPLEMENTATION.


  METHOD check_person_single_bool.
    "method will use select single @ABAP_TRUE return data will be boolean.
    SELECT SINGLE @abap_true
        FROM zuploadpersoncr
        INTO @DATA(lv_bool)
        WHERE id EQ @id.

    exists = lv_bool.

  ENDMETHOD.


  METHOD check_person_single_clasic.
    "select single
    SELECT SINGLE id
      FROM zuploadpersoncr
      INTO @DATA(lv_id)
      WHERE id EQ @id.

    exists = COND #( WHEN lv_id NE 0 AND sy-subrc EQ 0 THEN abap_true
                     ELSE abap_false  ) .

  ENDMETHOD.


  METHOD check_person_uptorows.

    SELECT id
    FROM zuploadpersoncr
    WHERE id EQ @id
    ORDER BY id
    INTO @DATA(lv_id)
    UP TO 1 ROWS.

    ENDSELECT.

    SELECT id
    FROM zuploadpersoncr
    WHERE id EQ @id
    ORDER BY id
    INTO TABLE @DATA(it_id)
    UP TO 1 ROWS.

    exists = COND #( WHEN lv_id NE 0 AND sy-subrc EQ 0 THEN abap_true
                 ELSE abap_false  ) .

  ENDMETHOD.


  METHOD get_person.

    CLEAR technical_message.

    IF id NE 0.

      CLEAR person.

      SELECT SINGLE id
                    code_electoral
                    expire_date
                    committee_vote
                    name
                    first_last_name
                    second_last_name
               FROM zuploadpersoncr
               INTO person
              WHERE id EQ id.

      IF sy-subrc NE 0.
        message-type = zcl_global_utils=>c_e.
        message-number = 000.
        message-message_v1 = id.
      ELSE.
        message-type = zcl_global_utils=>c_s.
        message-number = 002.
        message-message_v1 = id.
      ENDIF.

    ELSE.
      message-type = zcl_global_utils=>c_e.
      message-number = 001.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
