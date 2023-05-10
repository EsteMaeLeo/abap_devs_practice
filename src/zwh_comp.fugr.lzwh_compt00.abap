*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZWH_COMP........................................*
DATA:  BEGIN OF STATUS_ZWH_COMP                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZWH_COMP                      .
CONTROLS: TCTRL_ZWH_COMP
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZWH_COMP                      .
TABLES: ZWH_COMP                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
