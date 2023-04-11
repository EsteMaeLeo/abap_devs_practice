*&---------------------------------------------------------------------*
*& Report zpg_selectionscreen01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpg_selectionscreen01.

PARAMETERS: p_ape1   TYPE c LENGTH 30, " First Lastname
            p_ape2   TYPE c LENGTH 30, "second lastname
            p_nombre TYPE c LENGTH 30. "name

SELECTION-SCREEN SKIP.

"Birth date
PARAMETERS: p_fecha TYPE d.

"Social or ID Number
PARAMETERS: p_dni TYPE c LENGTH 15.

"address
PARAMETERS: p_domi TYPE c LENGTH 50.

"email address
PARAMETERS p_email TYPE c LENGTH 30.

SELECTION-SCREEN SKIP.
"type contract
PARAMETERS: p_cntr_l RADIOBUTTON GROUP cntr, "long ccontract
            p_cntr_t RADIOBUTTON GROUP cntr DEFAULT 'X', "temporal contract
            p_cntr_p RADIOBUTTON GROUP cntr. "practice contract

SELECTION-SCREEN SKIP.
"benefits
PARAMETERS p_tik_r TYPE c AS CHECKBOX. "food benefit
PARAMETERS p_seg_m TYPE c AS CHECKBOX DEFAULT 'X'. "medicar
PARAMETERS p_frm_p TYPE c AS CHECKBOX. "education benefit
