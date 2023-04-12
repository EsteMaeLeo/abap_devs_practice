*&---------------------------------------------------------------------*
*& Report zpg_selectionscreen01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpg_selectionscreen01.

TABLES: trdir,
        tstc.

SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE TEXT-t04.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK block7 WITH FRAME TITLE TEXT-t10.

"CRUD
PARAMETERS: p_create RADIOBUTTON GROUP crud,
            p_read   RADIOBUTTON GROUP crud.

SELECTION-SCREEN END OF BLOCK block7.


SELECTION-SCREEN BEGIN OF BLOCK block2 WITH FRAME TITLE TEXT-t05.
PARAMETERS: p_ape1   TYPE c LENGTH 30 , " First Lastname
            p_ape2   TYPE c LENGTH 30 , "second lastname
            p_nombre TYPE c LENGTH 30 . "name

SELECTION-SCREEN SKIP.

"Birth date
PARAMETERS: p_fecha TYPE sydatum.

"Social or ID Number
PARAMETERS: p_dni TYPE zemployee_001-id OBLIGATORY.

"address
PARAMETERS: p_domi TYPE c LENGTH 50.

"email address
PARAMETERS p_email TYPE c LENGTH 30 OBLIGATORY.


SELECTION-SCREEN END OF BLOCK block2.

SELECTION-SCREEN BEGIN OF BLOCK block3 WITH FRAME TITLE TEXT-t06.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK block4 WITH FRAME TITLE TEXT-t07.

"type contract
PARAMETERS: p_cntr_l RADIOBUTTON GROUP cntr, "long ccontract
            p_cntr_t RADIOBUTTON GROUP cntr DEFAULT 'X', "temporal contract
            p_cntr_p RADIOBUTTON GROUP cntr. "practice contract

SELECTION-SCREEN END OF BLOCK block4.

SELECTION-SCREEN SKIP.

"benefits
SELECTION-SCREEN BEGIN OF BLOCK block5 WITH FRAME TITLE TEXT-t08.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_tik_r TYPE c AS CHECKBOX. "food benefit
SELECTION-SCREEN COMMENT (22) c_food.
PARAMETERS p_seg_m TYPE c AS CHECKBOX DEFAULT 'X'. "medicar
SELECTION-SCREEN COMMENT (22) c_medic.
PARAMETERS p_frm_p TYPE c AS CHECKBOX. "education benefit
SELECTION-SCREEN COMMENT (22) c_educa.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK block5.

SELECTION-SCREEN SKIP.

PARAMETERS: p_horas TYPE i, "hours per week
            p_sal_m TYPE i. " salary per month

PARAMETERS: p_fechaa TYPE sydatum.

SELECTION-SCREEN SKIP.

"access
SELECTION-SCREEN BEGIN OF BLOCK block6 WITH FRAME TITLE TEXT-t09.

SELECT-OPTIONS: s_prog  FOR trdir-name, " programs
                s_tcode FOR tstc-tcode.

SELECTION-SCREEN END OF BLOCK block6.

SELECTION-SCREEN END OF BLOCK block3.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN END OF BLOCK block1.
"initialization variables

INITIALIZATION.
  p_fechaa = sy-datum.
  c_food   = TEXT-t01. "food benefit
  c_medic  = TEXT-t02. "medicar
  c_educa  = TEXT-t03. "education benefit
  "event when put value on field and then do a enter

AT SELECTION-SCREEN ON p_ape1.

  IF p_ape1 CA '0123456789'.

    MESSAGE e000(zcustom001).

  ENDIF.

AT SELECTION-SCREEN ON p_ape2.

  IF p_ape2 CA '0123456789'.

    MESSAGE e000(zcustom001).

  ENDIF.

AT SELECTION-SCREEN ON p_nombre.

  IF p_nombre CA '0123456789'.

    MESSAGE e000(zcustom001).

  ENDIF.

START-OF-SELECTION.

  CASE abap_true.
    WHEN p_create.
      PERFORM f_create_user.
    WHEN p_read.
      PERFORM f_select_user USING p_dni.
    WHEN OTHERS.

  ENDCASE.


FORM f_create_user.
  DATA wa_employee TYPE zemployee_001.

  " move to the work area
  wa_employee-id              = p_dni.
  wa_employee-email           = p_email.
  wa_employee-name            = p_nombre.
  wa_employee-lastname1       = p_ape1.
  wa_employee-lastname2       = p_ape2.
  wa_employee-date_birth      = p_fecha.
  wa_employee-date_activation = p_fechaa.


  INSERT zemployee_001 FROM wa_employee.

  IF sy-subrc EQ 0.

    MESSAGE i002(zcustom001).

  ELSE.

    MESSAGE i003(zcustom001).

  ENDIF.

ENDFORM.

FORM f_select_user USING us_id TYPE zemployee_001-id.

    data wa_employee TYPE zemployee_001.

  SELECT SINGLE *
    INTO wa_employee
    FROM zemployee_001
   WHERE id EQ us_id.

  IF sy-subrc EQ 0.

    WRITE: / 'ID: ', wa_employee-id,
           / 'Email: ', wa_employee-email,
           / 'Name: ',  wa_employee-name,
           / 'Last name ', wa_employee-lastname1,
           / 'Last name ', wa_employee-lastname2,
           / 'Date birth ', wa_employee-date_birth,
           / 'Date activation ',  wa_employee-date_activation.

  ELSE.

    MESSAGE e004(zcustom001) WITH us_id .

  ENDIF.
ENDFORM.
