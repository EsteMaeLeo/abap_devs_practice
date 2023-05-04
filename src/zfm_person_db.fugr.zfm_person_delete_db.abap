FUNCTION ZFM_PERSON_DELETE_DB.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_DELETEALL) TYPE  CHAR1 OPTIONAL
*"----------------------------------------------------------------------


"You can delete all the records in a cross-client database table by using the following syntax:
"DELETE FROM <dbtab> WHERE <field> LIKE '%'.


ENDFUNCTION.
