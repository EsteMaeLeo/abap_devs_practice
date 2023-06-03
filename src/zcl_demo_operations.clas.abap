class ZCL_DEMO_OPERATIONS definition
  public
  create public .

public section.

  methods RANDOM_STRING
    importing
      !NUMBER_STRING type I default 1
    exporting
      !RANDOM_STRING type STRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEMO_OPERATIONS IMPLEMENTATION.


  METHOD random_string.

    CALL FUNCTION 'GENERAL_GET_RANDOM_STRING'
      EXPORTING
        number_chars  = number_string
      IMPORTING
        random_string = random_string.
  ENDMETHOD.
ENDCLASS.
