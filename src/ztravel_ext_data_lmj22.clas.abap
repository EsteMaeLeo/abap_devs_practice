CLASS ztravel_ext_data_lmj22 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ztravel_ext_data_lmj22 IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.
    DATA: lt_travel TYPE TABLE OF ztravel_lmj22,
          ls_travel TYPE ztravel_lmj22.

    " Select existing data from the table
    SELECT * FROM ztravel_lmj22 INTO TABLE @lt_travel.

    " Loop through the data and update the new field based on the logic
    LOOP AT lt_travel INTO ls_travel.
      IF ls_travel-total_price > 4500.
        ls_travel-zztraveltype_zac = 'Business'.
      ELSEIF ls_travel-total_price > 3000 AND ls_travel-total_price < 4500.
        ls_travel-zzTravelType_zac = 'Premium Economy'.
      ELSE.
        ls_travel-zzTravelType_zac = 'Economy'.
      ENDIF.

      " Update the table with the new value
      MODIFY ztravel_lmj22 FROM @ls_travel.
    ENDLOOP.
    out->write( |Table updated| ).
  ENDMETHOD.
ENDCLASS.
