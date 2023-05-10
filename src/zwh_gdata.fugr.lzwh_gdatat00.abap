*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZWH_GDATA.......................................*
DATA:  BEGIN OF STATUS_ZWH_GDATA                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZWH_GDATA                     .
CONTROLS: TCTRL_ZWH_GDATA
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZWH_GDATA                     .
TABLES: ZWH_GDATA                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
