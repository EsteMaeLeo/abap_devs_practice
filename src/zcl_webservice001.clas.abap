class ZCL_WEBSERVICE001 definition
  public
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_WEBSERVICE001 IMPLEMENTATION.


  METHOD if_http_extension~handle_request.
    DATA lc_url TYPE string VALUE 'https://rss.nytimes.com/services/xml/rss/nyt/Americas.xml'.

    "create instance
    cl_http_client=>create_by_url(
      EXPORTING
        url                =     lc_url
      IMPORTING
        client             =     DATA(lo_http_client)
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4
    ).
    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      server->response->set_status( code = 500
                              reason = 'HTTP_INTERNAL_SERVER_ERROR' ).
    ELSE.
      "request send to the provice
      lo_http_client->send(
*        EXPORTING
*          timeout                    = co_timeout_default    " Timeout of Answer Waiting Time
        EXCEPTIONS
          http_communication_failure = 1
          http_invalid_state         = 2
          http_processing_failed     = 3
          http_invalid_timeout       = 4
          OTHERS                     = 5
      ).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSE.
        lo_http_client->receive(
          EXCEPTIONS
            http_communication_failure = 1
            http_invalid_state         = 2
            http_processing_failed     = 3
            OTHERS                     = 4
        ).
        IF sy-subrc <> 0.

          lo_http_client->get_last_error(
            IMPORTING
              code           =  DATA(lv_code)   " Return Value, Return Value After ABAP Statements
              message        =  DATA(lv_message)   " Error Message
              ).

          server->response->set_status( code = lv_code
                                        reason = lv_message ).
*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ELSE.
          server->response->set_status(
            EXPORTING
              code   = 200    " HTTP status code
              reason = 'OK'    " HTTP status description
          ).
          server->response->set_content_type( content_type =  'application/xml; charset=utf-8').

          server->response->set_data( lo_http_client->response->get_data( ) ).
        ENDIF.
      ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
