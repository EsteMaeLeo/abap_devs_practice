FUNCTION-POOL zfg_model_flight.             "MESSAGE-ID ..

DATA: wa_msg      TYPE bapiret2,
      wa_sairport TYPE sairport.

DATA: gt_msg      TYPE bapiret2_tab,
      gt_sairport TYPE STANDARD TABLE OF sairport.


* INCLUDE LZFG_MODEL_FLIGHTD...              " Local class definition
