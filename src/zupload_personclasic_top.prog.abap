*&---------------------------------------------------------------------*
*&  Include  zupload_personclasic_top
*&---------------------------------------------------------------------*
"TABLES: zuploadpersoncr.



DATA gwa_person TYPE zuploadpersoncr.

DATA: gst_person TYPE zst_uploadpersoncr,
      got_person TYPE zot_uploadpersoncr,
      ght_person TYPE zht_uploadpersoncr.

DATA: g_filepath TYPE string.

CONSTANTS: c_comma     TYPE c VALUE ',',
           c_semicolon TYPE c VALUE ';',
           c_slash     TYPE c VALUE '/',
           c_hastag    TYPE c VALUE '#',
           c_at        TYPE c VALUE '@',
           c_filename  TYPE c LENGTH 6 VALUE 'person'.
