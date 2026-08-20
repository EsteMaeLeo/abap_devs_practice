CLASS ztravel_fill_data_lmj22 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS ztravel_fill_data_lmj22 IMPLEMENTATION.
 METHOD if_oo_adt_classrun~main.

*   clear data
    DELETE FROM ztravel_lmj22.

    "insert travel demo data

    INSERT ztravel_lmj22 FROM (
    SELECT
      FROM /dmo/travel AS travel
      FIELDS
      travel~travel_id AS travel_id,
      travel~total_price AS total_price,
      travel~currency_code AS currency_code,
      travel~description AS description
    ).
    COMMIT WORK.
    out->write( | Data generated for table ztravel_lmj22 | ).
  ENDMETHOD.
ENDCLASS.
