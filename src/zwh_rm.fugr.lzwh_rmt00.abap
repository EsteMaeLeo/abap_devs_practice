*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZWH_RM..........................................*
DATA:  BEGIN OF STATUS_ZWH_RM                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZWH_RM                        .
CONTROLS: TCTRL_ZWH_RM
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZWH_RM                        .
TABLES: ZWH_RM                         .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
