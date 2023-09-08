*&---------------------------------------------------------------------*
*&  Include           ZFG_MODEL_FLIGHTT001
*&---------------------------------------------------------------------*

*SET EXTENDED CHECK OFF.
* Europe
  wa_sairport-id = 'FRA'.
  wa_sairport-name = 'Frankfurt/Main, FRG'.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO  gt_sairport.

  wa_sairport-id = 'HAM'.
  wa_sairport-name = 'Hamburg, FRG             '.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'MUC'.
  wa_sairport-name = 'Munich, FRG              '.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

* wa_sairport-id = 'BER'.
* wa_sairport-name = 'Berlin, FRG              '.
* APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'SXF'.
  wa_sairport-name = 'Berlin Schonefeld Apt,FRG'.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'THF'.
  wa_sairport-name = 'Berlin Tempelhof Apt, FRG'.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'TXL'.
  wa_sairport-name = 'Berlin Tegel Apt, FRG    '.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'CDG'.
  wa_sairport-name = 'Paris Charles de Gaulle,F'.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'ORY'.
  wa_sairport-name = 'Paris Orly Apt, France   '.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'VIE'.
  wa_sairport-name = 'Vienna, Austria          '.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'ZRH'.
  wa_sairport-name = 'Zurich, Switzerland      '.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'RTM'.
  wa_sairport-name = 'Rotterdam Apt, NL        '.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'FCO'.
  wa_sairport-name = 'Rome Leonardo Da Vinci, I'.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'VCE'.
  wa_sairport-name = 'Venice Marco Polo Apt, I '.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'LCY'.
  wa_sairport-name = 'London City Apt, UK      '.
  wa_sairport-time_zone = 'UTC'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'LGW'.
  wa_sairport-name = 'London Gatwick Apt, UK   '.
  wa_sairport-time_zone = 'UTC'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'LHR'.
  wa_sairport-name = 'London Heathrow Apt, UK  '.
  wa_sairport-time_zone = 'UTC'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'MAD'.
  wa_sairport-name = 'Madrid Barajas Apt, Spain'.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'STO'.
  wa_sairport-name = 'Stockholm, Sweden        '.
  wa_sairport-time_zone = 'UTC+1'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'VKO'.
  wa_sairport-name = 'Moscow Vnukovo Apt, R    '.
  wa_sairport-time_zone = 'UTC+3'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'SVO'.
  wa_sairport-name = 'Moscow Sheremetyevo Apt,R'.
  wa_sairport-time_zone = 'UTC+3'.
  APPEND wa_sairport TO gt_sairport.


* America
  wa_sairport-id = 'JFK'.
  wa_sairport-name = 'New York JF Kennedy, USA '.
  wa_sairport-time_zone = 'UTC-5'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'AIY'.
  wa_sairport-name = 'Atlantic City, USA       '.
  wa_sairport-time_zone = 'UTC-5'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'BNA'.
  wa_sairport-name = 'Nashville, USA           '.
  wa_sairport-time_zone = 'UTC-5'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'BOS'.
  wa_sairport-name = 'Boston Logan Int, USA    '.
  wa_sairport-time_zone = 'UTC-5'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'ELP'.
  wa_sairport-name = 'El Paso Int., USA        '.
  wa_sairport-time_zone = 'UTC-7'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'DEN'.
  wa_sairport-name = 'Denver Int., USA         '.
  wa_sairport-time_zone = 'UTC-7'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'HOU'.
  wa_sairport-name = 'Houston Hobby Apt, USA   '.
  wa_sairport-time_zone = 'UTC-6'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'LAS'.
  wa_sairport-name = 'Las Vegas Mc Carran, USA '.
  wa_sairport-time_zone = 'UTC-8'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'LAX'.
  wa_sairport-name = 'Los Angeles Int Apt, USA '.
  wa_sairport-time_zone = 'UTC-8'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'MCI'.
  wa_sairport-name = 'Kansas City Int Apt, USA '.
  wa_sairport-time_zone = 'UTC-6'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'MIA'.
  wa_sairport-name = 'Miami Int Apt, USA       '.
  wa_sairport-time_zone = 'UTC-5'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'SFO'.
  wa_sairport-name = 'San Francisco Int Apt,USA'.
  wa_sairport-time_zone = 'UTC-8'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'PID'.
  wa_sairport-name = 'Nassau Paradise IS,Bahama'.
  wa_sairport-time_zone = 'UTC-5'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'EWR'.
  wa_sairport-name = 'New York Newark Int., USA'.
  wa_sairport-time_zone = 'UTC-5'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'YEG'.
  wa_sairport-name = 'Edmonton Int Apt, CDN    '.
  wa_sairport-time_zone = 'UTC-7'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'YOW'.
  wa_sairport-name = 'Ottawa Uplands Int., CDN '.
  wa_sairport-time_zone = 'UTC-5'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'ACA'.
  wa_sairport-name = 'Acapulco, Mexico         '.
  wa_sairport-time_zone = 'UTC-6'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'GIG'.
  wa_sairport-name = 'Rio De Janeiro Int., BRA '.
  wa_sairport-time_zone = 'UTC-3'.
  APPEND wa_sairport TO gt_sairport.

* Australia
  wa_sairport-id = 'ASP'.
  wa_sairport-name = 'Alice Springs, AUS       '.
  wa_sairport-time_zone = 'UTC+9'.
  APPEND wa_sairport TO gt_sairport.

* Africa
  wa_sairport-id = 'ACE'.
  wa_sairport-name = 'Lanzarote, Canary IS     '.
  wa_sairport-time_zone = 'UTC'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'HRE'.
  wa_sairport-name = 'Harare, Zimbabwe         '.
  wa_sairport-time_zone = 'UTC+2'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'GCJ'.
  wa_sairport-name = 'Johannesburg Grand C., SA'.
  wa_sairport-time_zone = 'UTC+2'.
  APPEND wa_sairport TO gt_sairport.

* Asia
  wa_sairport-id = 'SEL'.
  wa_sairport-name = 'Seoul Kimpo Int, ROK     '.
  wa_sairport-time_zone = 'UTC+9'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'TYO'.
  wa_sairport-name = 'Tokyo, JAPAN             '.
  wa_sairport-time_zone = 'UTC+9'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'NRT'.
  wa_sairport-name = 'Tokyo Narita, Japan      '.
  wa_sairport-time_zone = 'UTC+9'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'ITM'.
  wa_sairport-name = 'Osaka Itami Apt, Japan   '.
  wa_sairport-time_zone = 'UTC+9'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'KIX'.
  wa_sairport-name = 'Osaka Kansai Int., Japan '.
  wa_sairport-time_zone = 'UTC+9'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'HIJ'.
  wa_sairport-name = 'Hiroshima, Japan         '.
  wa_sairport-time_zone = 'UTC+9'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'JKT'.
  wa_sairport-name = 'Jakarta, Indonesia       '.
  wa_sairport-time_zone = 'UTC+7'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'SIN'.
  wa_sairport-name = 'Singapore                '.
  wa_sairport-time_zone = 'UTC+8'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'KUL'.
  wa_sairport-name = 'Kuala Lumpur, Malaysia   '.
  wa_sairport-time_zone = 'UTC+8'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'HKG'.
  wa_sairport-name = 'Hongkong                 '.
  wa_sairport-time_zone = 'UTC+8'.
  APPEND wa_sairport TO gt_sairport.

  wa_sairport-id = 'BKK'.
  wa_sairport-name = 'Bangkok, Thailand        '.
  wa_sairport-time_zone = 'UTC+7'.
  APPEND wa_sairport TO gt_sairport.

"SET EXTENDED CHECK ON.
