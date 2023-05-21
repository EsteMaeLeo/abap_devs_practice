CLASS zcl_person_operation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA technical_message TYPE string.

    "return Person according ID
    METHODS:
      get_person IMPORTING id            TYPE zidcr
                 EXPORTING message       TYPE bapiret2
                 RETURNING VALUE(person) TYPE zstperson,
      check_person IMPORTING id            TYPE zidcr
                   RETURNING VALUE(exists) TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_person_operation IMPLEMENTATION.
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

  METHOD check_person.
    "method will use select single @ABAP_TRUE return data will be boolean.
    SELECT SINGLE @abap_true
        FROM zuploadpersoncr
        INTO @DATA(lv_bool)
        WHERE id EQ @id.

    exists = lv_bool.

  ENDMETHOD.

ENDCLASS.
