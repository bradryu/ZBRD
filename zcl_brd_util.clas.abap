*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
CLASS zcl_brd_util DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
types:
    TT_HELP_VALUE type TABLE OF HELP_VALUE .

  class-data MC_IT_ADMIN_EMAIL type CHAR40 value 'noreply.sg82@sg82.com' ##NO_TEXT.
  constants MC_IT_ADMIN_PHONE type CHAR30 value '0100000000' ##NO_TEXT.
    TYPES:
      BEGIN OF ts_module,
        code(3),
        text(20),
      END OF ts_module .
    TYPES:
      tt_module TYPE TABLE OF ts_module .

    CLASS-METHODS get_domain_value
      IMPORTING
        VALUE(iv_domname)    TYPE domname
        VALUE(iv_ddlaguage)  TYPE ddlanguage DEFAULT sy-langu
        VALUE(iv_domvalue_l) TYPE domvalue_l
      RETURNING
        VALUE(rv_value)      TYPE val_text .
    CLASS-METHODS get_module_master
      EXPORTING
        VALUE(et_data) TYPE tt_module .
    CLASS-METHODS set_range_with_icon
      IMPORTING
        !iv_pbo   TYPE char01 OPTIONAL
      CHANGING
        !ct_range TYPE STANDARD TABLE
        !cv_low   TYPE data OPTIONAL
        !cv_high  TYPE data OPTIONAL
        !cv_more  TYPE icons-text OPTIONAL
        !cv_stat  TYPE icons-text OPTIONAL .
    CLASS-METHODS set_range_extension
      IMPORTING
        !it_range      TYPE REF TO data
        !iv_help_field TYPE rsscr-dbfield
        !iv_text       TYPE rsselint-text
        !iv_ok         TYPE sy-ucomm
      CHANGING
        !cv_low        TYPE any
        !cv_high       TYPE any OPTIONAL
        !cv_icon       TYPE char4
        !cv_ex_icon    TYPE char4 .
    CLASS-METHODS get_amount_output
      IMPORTING
        !iv_amt              TYPE wrbtr OPTIONAL
        !iv_waers            TYPE waers
        !iv_number_format    TYPE char01 DEFAULT 'X'
        !iv_no_decimal       TYPE char01
        !iv_amt_15           TYPE bapicurr_d OPTIONAL
      RETURNING
        VALUE(rv_amt_string) TYPE string .
    CLASS-METHODS get_domain_text
      IMPORTING
        !iv_domname    TYPE domname
        !iv_langu      TYPE sy-langu DEFAULT sy-langu
        !iv_value      TYPE any
      RETURNING
        VALUE(rv_text) TYPE val_text .
    CLASS-METHODS get_f4_value
      IMPORTING
        !it_tab          TYPE table
        !iv_cprog        TYPE sy-cprog DEFAULT sy-cprog
        !iv_dynnr        TYPE sy-dynnr DEFAULT sy-dynnr
        !it_f4_field     TYPE tt_help_value
        !it_update_field TYPE dynpread_tabtype OPTIONAL
      EXPORTING
        !ev_value        TYPE data .
    CLASS-METHODS get_screen_value
      IMPORTING
        !iv_repid       TYPE syrepid DEFAULT sy-cprog
        !iv_dynnr       TYPE sydynnr DEFAULT sy-dynnr
        !iv_field       TYPE dynfnam
        !iv_stepl       TYPE systepl OPTIONAL
        !iv_upper_case  TYPE flag DEFAULT 'X'
        !iv_input_conv  TYPE flag DEFAULT 'X'
      RETURNING
        VALUE(rv_value) TYPE dynfieldvalue .
    CLASS-METHODS get_screen_values
      IMPORTING
        !iv_repid      TYPE syrepid DEFAULT sy-repid
        !iv_dynnr      TYPE sydynnr DEFAULT sy-dynnr
        !iv_field      TYPE dynfnam
        !iv_stepl      TYPE systepl OPTIONAL
        !iv_upper_case TYPE flag DEFAULT 'X'
        !iv_input_conv TYPE flag DEFAULT 'X'
      CHANGING
        !ct_dynpfields TYPE dynpread_tabtype .
    CLASS-METHODS call_browser
      IMPORTING
        !iv_url TYPE string .
    CLASS-METHODS confirm_msg
      IMPORTING
        !iv_title        TYPE char255 DEFAULT 'Confirm'
        !iv_question     TYPE char255 DEFAULT 'Confirm?'
        !iv_btn1         TYPE char10 DEFAULT 'YES'
        !iv_btn2         TYPE char10 DEFAULT 'NO'
      RETURNING
        VALUE(rv_return) TYPE char1 .
    CLASS-METHODS add_file_open_dialog
      IMPORTING
        !iv_filter      TYPE string DEFAULT '*.*'
        !iv_extension   TYPE string DEFAULT ''
        !iv_title       TYPE string DEFAULT 'Select File'
      CHANGING
        !cs_file        TYPE zsbrd00050
      RETURNING
        VALUE(rv_subrc) TYPE sy-subrc .
    CLASS-METHODS split_path
      CHANGING
        !cs_file_struc TYPE zsbrd00050 .
    CLASS-METHODS add_file_save_dialog
      IMPORTING
        !iv_extension   TYPE string DEFAULT ''
        !iv_title       TYPE string DEFAULT 'File save'
        !iv_directory   TYPE string DEFAULT 'C:/'
      CHANGING
        !cv_filename    TYPE string OPTIONAL
        !cv_path        TYPE string OPTIONAL
        !cv_fullpath    TYPE string
      RETURNING
        VALUE(rv_subrc) TYPE sy-subrc .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BRD_UTIL IMPLEMENTATION.


  METHOD add_file_open_dialog.
    DATA: lt_file TYPE filetable,
          ls_file LIKE LINE OF lt_file,
          lv_rc   TYPE i.
    CLEAR : cs_file.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title      = iv_title
        file_filter       = iv_filter
        default_extension = iv_extension
      CHANGING
        file_table        = lt_file
        rc                = lv_rc.

    IF  sy-subrc EQ 0 AND lv_rc EQ 1.
      READ TABLE lt_file INTO ls_file INDEX 1.
      MOVE  ls_file-filename   TO  cs_file-fullname.

      split_path( CHANGING cs_file_struc = cs_file ).
      rv_subrc = 0.
    ELSE.
      rv_subrc = 8.
    ENDIF.
  ENDMETHOD.


  METHOD add_file_save_dialog.
    DATA: lv_fullpath TYPE string,
          lv_path     TYPE string,
          lv_rc       TYPE i.


    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
        window_title      = iv_title
        default_extension = iv_extension
        default_file_name = cv_filename
        initial_directory = iv_directory
      CHANGING
        filename          = cv_filename
        path              = lv_path
        fullpath          = lv_fullpath
        user_action       = lv_rc.


    IF  sy-subrc EQ 0 AND lv_rc EQ 0 AND lv_fullpath IS NOT INITIAL.
      cv_fullpath = lv_fullpath.
      cv_path = lv_path.
      rv_subrc = 0.
    ELSE.
      rv_subrc = 8.
    ENDIF.
  ENDMETHOD.


  METHOD CALL_BROWSER.
    DATA lv_url TYPE char1792.
    lv_url = iv_url.

    CALL FUNCTION 'CALL_BROWSER'
      EXPORTING
        url                    = lv_url
        new_window             = 'X'
      EXCEPTIONS
        frontend_not_supported = 1
        frontend_error         = 2
        prog_not_found         = 3
        no_batch               = 4
        unspecified_error      = 5
        OTHERS                 = 6.

  ENDMETHOD.


  METHOD CONFIRM_MSG.
    DATA:lt_spar TYPE TABLE OF spar.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = iv_title
        diagnose_object       = space
        text_question         = iv_question
        text_button_1         = iv_btn1
        icon_button_1         = space
        text_button_2         = iv_btn2
        icon_button_2         = space
        default_button        = '1'
        display_cancel_button = 'X'
        userdefined_f1_help   = space
        start_column          = 25
        start_row             = 6
        popup_type            = space
        iv_quickinfo_button_1 = space
        iv_quickinfo_button_2 = space
      IMPORTING
        answer                = rv_return
      TABLES
        parameter             = lt_spar
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.
    CASE rv_return.
      WHEN '1'. rv_return = abap_true.
      WHEN OTHERS. rv_return = abap_false.
    ENDCASE.
  ENDMETHOD.


  METHOD GET_AMOUNT_OUTPUT.

    DATA : lv_str      TYPE string,
           lv_str2     TYPE string,
           lv_char(15),
           lv_amt      TYPE p LENGTH 16 DECIMALS 2,
           lv_return   TYPE bapicurr-bapicurr.
    IF iv_amt IS NOT INITIAL.
      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
        EXPORTING
          currency        = iv_waers
          amount_internal = iv_amt
        IMPORTING
          amount_external = lv_return.
    ELSEIF iv_amt_15 IS NOT INITIAL.
      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
        EXPORTING
          currency        = iv_waers
          amount_internal = iv_amt_15
        IMPORTING
          amount_external = lv_return.
    ENDIF.

    lv_amt = lv_return.

    IF iv_number_format EQ abap_true.
      CALL FUNCTION 'HRCM_AMOUNT_TO_STRING_CONVERT'
        EXPORTING
          betrg                   = lv_amt
          new_decimal_separator   = '.'
          new_thousands_separator = ','
        IMPORTING
          string                  = lv_char.
      lv_str = lv_char.
      CONDENSE lv_str NO-GAPS.
    ELSE.
      lv_str = lv_amt.
    ENDIF.

    IF iv_no_decimal EQ abap_true.
      SPLIT lv_str AT '.' INTO lv_str lv_str2.
    ENDIF.
    rv_amt_string = lv_str.
  ENDMETHOD.


  METHOD GET_DOMAIN_TEXT.

    SELECT SINGLE ddtext
    INTO rv_text
    FROM dd07v
    WHERE domname = iv_domname
      AND ddlanguage = iv_langu
      AND domvalue_l = iv_value.

  ENDMETHOD.


  METHOD get_domain_value.
  ENDMETHOD.


  METHOD GET_F4_VALUE.
    "$. Region Sample Code
*SELECT-OPTIONS so_bukrs FOR t001-bukrs.
*SELECT-OPTIONS so_butxt FOR t001-butxt.
*SELECT-OPTIONS so_land1 FOR t001-land1.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_bukrs-low.
*  DATA lt_value TYPE TABLE OF t001.
*  DATA : lt_f4_field     TYPE wlf_tt_help_value,
*         ls_f4_field     TYPE help_value,
*         lt_update_field TYPE dynpread_t,
*         ls_update_field TYPE dynpread.
*
*  SELECT * FROM t001
*  INTO CORRESPONDING FIELDS OF TABLE lt_value.
*
*  CLEAR : lt_f4_field, ls_f4_field.
*  ls_f4_field-tabname = 'T001'.
*  ls_f4_field-fieldname = 'BUKRS'.
*  APPEND ls_f4_field TO lt_f4_field.
*  CLEAR : lt_update_field, ls_update_field.
*  ls_update_field-fieldname = 'PA_BUKRS'.
*  ls_update_field-fieldvalue = 'BUKRS'.
*  APPEND ls_update_field TO lt_update_field.
*
*  ZCL_BRD_common=>get_f4_value( EXPORTING it_tab = lt_value
*                                          it_f4_field =  lt_f4_field
*                                          it_update_field = lt_update_field
*                                 IMPORTING ev_value = so_bukrs-low ).
    "$. Endregion Sample Code
    DATA : lv_selectfield  TYPE fieldname,
           lv_select_value TYPE dynfieldvalue,
           lv_tabix        TYPE sy-tabix.
    DATA : lt_f4_field     TYPE tt_help_value,
           lt_update_field TYPE dynpread_tabtype.
    DATA lv_itab_nm TYPE string.
    FIELD-SYMBOLS <lv_value> TYPE any.
    FIELD-SYMBOLS <ls_f4_field> TYPE help_value.
    FIELD-SYMBOLS <ls_tab> TYPE any.
    FIELD-SYMBOLS <ls_update_field> TYPE dynpread.

    CHECK it_tab[] IS NOT INITIAL.
    CHECK it_f4_field[] IS NOT INITIAL.

    lt_f4_field[] = it_f4_field[].
    "선택 필드 세팅
    READ TABLE lt_f4_field ASSIGNING <ls_f4_field> WITH KEY selectflag = abap_true.
    IF sy-subrc NE 0.
      READ TABLE lt_f4_field ASSIGNING <ls_f4_field> INDEX 1.
      <ls_f4_field>-selectflag = abap_true.
    ENDIF.
    lv_selectfield = <ls_f4_field>-fieldname.

    " F4 호출
    CALL FUNCTION 'HELP_VALUES_GET_NO_DD_NAME'
      EXPORTING
        selectfield                  = lv_selectfield
      IMPORTING
        ind                          = lv_tabix
        select_value                 = lv_select_value
      TABLES
        fields                       = lt_f4_field
        full_table                   = it_tab
      EXCEPTIONS
        full_table_empty             = 1
        no_tablestructure_given      = 2
        no_tablefields_in_dictionary = 3
        more_then_one_selectfield    = 4
        no_selectfield               = 5
        OTHERS                       = 6.

    "선택값을 화면에 DISPLAY
    CHECK sy-subrc EQ 0.
    CHECK lv_tabix IS NOT INITIAL.
    ev_value = lv_select_value.           "표시될 화면 필드

    "다른 필드 업데이트
    CHECK it_update_field[] IS NOT INITIAL.
    lt_update_field[] = it_update_field[].
    READ TABLE it_tab ASSIGNING <ls_tab> INDEX lv_tabix.

    LOOP AT lt_update_field ASSIGNING <ls_update_field>.
      ASSIGN COMPONENT <ls_update_field>-fieldvalue OF STRUCTURE <ls_tab> TO <lv_value>.
      IF sy-subrc EQ 0.
        CLEAR <ls_update_field>-fieldvalue.
        <ls_update_field>-fieldvalue = <lv_value>.
      ENDIF.
    ENDLOOP.

    CALL FUNCTION 'DYNP_VALUES_UPDATE'
      EXPORTING
        dyname               = iv_cprog
        dynumb               = iv_dynnr
      TABLES
        dynpfields           = lt_update_field
      EXCEPTIONS
        invalid_abapworkarea = 1
        invalid_dynprofield  = 2
        invalid_dynproname   = 3
        invalid_dynpronummer = 4
        invalid_request      = 5
        no_fielddescription  = 6
        undefind_error       = 7
        OTHERS               = 8.
  ENDMETHOD.


  METHOD get_module_master.

    SELECT domvalue_l  AS code ddtext AS text
    INTO CORRESPONDING FIELDS OF TABLE et_data
    FROM dd07v
    WHERE domname = 'ZDSG_MODULE'.

  ENDMETHOD.


  METHOD GET_SCREEN_VALUE.

    DATA: lt_dynpread TYPE dynpread_tabtype,
          ls_dynpread TYPE dynpread.

    ls_dynpread-fieldname = iv_field.
    ls_dynpread-stepl     = iv_stepl.
    APPEND ls_dynpread TO lt_dynpread.

    "화면 필드값 얻기
    CALL FUNCTION 'DYNP_VALUES_READ'
      EXPORTING
        dyname                   = iv_repid
        dynumb                   = iv_dynnr
        translate_to_upper       = iv_upper_case
        perform_input_conversion = iv_input_conv
      TABLES
        dynpfields               = lt_dynpread
      EXCEPTIONS
        invalid_abapworkarea     = 1
        invalid_dynprofield      = 2
        invalid_dynproname       = 3
        invalid_dynpronummer     = 4
        invalid_request          = 5
        no_fielddescription      = 6
        invalid_parameter        = 7
        undefind_error           = 8
        double_conversion        = 9
        stepl_not_found          = 10
        OTHERS                   = 11.

    READ TABLE lt_dynpread INTO ls_dynpread INDEX 1.
    CHECK sy-subrc EQ 0.
    rv_value = ls_dynpread-fieldvalue.


  ENDMETHOD.


  METHOD GET_SCREEN_VALUES.

    CHECK ct_dynpfields[] IS NOT INITIAL.

    CALL FUNCTION 'DYNP_VALUES_READ'
      EXPORTING
        dyname                   = iv_repid
        dynumb                   = iv_dynnr
        translate_to_upper       = iv_upper_case
        perform_input_conversion = iv_input_conv
      TABLES
        dynpfields               = ct_dynpfields
      EXCEPTIONS
        invalid_abapworkarea     = 1
        invalid_dynprofield      = 2
        invalid_dynproname       = 3
        invalid_dynpronummer     = 4
        invalid_request          = 5
        no_fielddescription      = 6
        invalid_parameter        = 7
        undefind_error           = 8
        double_conversion        = 9
        stepl_not_found          = 10
        OTHERS                   = 11.

  ENDMETHOD.


  METHOD set_range_extension.

    FIELD-SYMBOLS <lft_itab> TYPE STANDARD TABLE.
    ASSIGN it_range->* TO <lft_itab>.

    IF <lft_itab> IS INITIAL.
      IF cv_low IS NOT INITIAL OR cv_high IS NOT INITIAL.
        APPEND INITIAL LINE TO <lft_itab> ASSIGNING FIELD-SYMBOL(<ls_itab>).
        ASSIGN COMPONENT 'SIGN'   OF STRUCTURE <ls_itab> TO FIELD-SYMBOL(<lv_sign>).
        ASSIGN COMPONENT 'OPTION' OF STRUCTURE <ls_itab> TO FIELD-SYMBOL(<lv_option>).
        ASSIGN COMPONENT 'LOW'    OF STRUCTURE <ls_itab> TO FIELD-SYMBOL(<lv_low>).
        ASSIGN COMPONENT 'HIGH'   OF STRUCTURE <ls_itab> TO FIELD-SYMBOL(<lv_high>).

        <lv_sign>   = 'I'.
        <lv_option> = COND #( WHEN cv_high IS INITIAL THEN  'EQ' ELSE 'BT' ).
        <lv_low>    = cv_low.
        <lv_high>   = cv_high.
      ENDIF.
    ELSE.
      IF cv_low IS NOT INITIAL OR cv_high IS NOT INITIAL.
        READ TABLE <lft_itab> ASSIGNING <ls_itab> INDEX 1.
        ASSIGN COMPONENT 'SIGN'   OF STRUCTURE <ls_itab> TO <lv_sign>.
        ASSIGN COMPONENT 'OPTION' OF STRUCTURE <ls_itab> TO <lv_option>.
        ASSIGN COMPONENT 'LOW'    OF STRUCTURE <ls_itab> TO <lv_low>.
        ASSIGN COMPONENT 'HIGH'   OF STRUCTURE <ls_itab> TO <lv_high>.

        CASE <lv_sign>.
          WHEN 'I'.
            CASE <lv_option>.
              WHEN 'EQ'.
                IF cv_high IS NOT INITIAL.
                  <lv_option> = 'BT'.
                ENDIF.
              WHEN 'BT'.
                IF cv_high IS INITIAL.
                  <lv_option> = 'EQ'.
                ENDIF.
            ENDCASE.
        ENDCASE.

        <lv_low>    = cv_low.
        <lv_high>   = cv_high.
      ELSE.
        DELETE <lft_itab> INDEX 1.
      ENDIF.
    ENDIF.


    IF iv_ok IS NOT INITIAL.
      CALL FUNCTION 'COMPLEX_SELECTIONS_DIALOG'
        EXPORTING
          title          = 'Select Multiple Value'
          text           = iv_text
          help_field     = iv_help_field
*         tab_and_field  = is_tab_and_field
        TABLES
          range          = <lft_itab>
        EXCEPTIONS
          no_range_tab   = 1
          cancelled      = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
    ENDIF.

    IF <lft_itab> IS NOT INITIAL.
      READ TABLE <lft_itab> ASSIGNING FIELD-SYMBOL(<ls_line>) INDEX 1.

      ASSIGN COMPONENT 'SIGN'   OF STRUCTURE <ls_line> TO <lv_sign>.
      ASSIGN COMPONENT 'OPTION' OF STRUCTURE <ls_line> TO <lv_option>.
      ASSIGN COMPONENT 'LOW'    OF STRUCTURE <ls_line> TO <lv_low>.
      ASSIGN COMPONENT 'HIGH'   OF STRUCTURE <ls_line> TO <lv_high>.

      cv_low  = <lv_low>.
      cv_high = <lv_high>.

      CASE <lv_sign>.
        WHEN 'I'.
          cv_icon = COND #( WHEN lines( <lft_itab> ) > 1 AND <lv_option> = 'EQ' THEN '@1G@'
                            WHEN <lv_option> = 'GE' THEN '@1K@'
                            WHEN <lv_option> = 'LE' THEN '@1L@'
                            WHEN <lv_option> = 'GT' THEN '@1I@'
                            WHEN <lv_option> = 'LT' THEN '@1J@'
                            WHEN <lv_option> = 'NE' THEN '@1H@'
                            ELSE '' ).
        WHEN 'E'.
          cv_icon  = COND #( WHEN <lv_option> = 'EQ' THEN '@2A@'
                             WHEN <lv_option> = 'GE' THEN '@2E@'
                             WHEN <lv_option> = 'LE' THEN '@2F@'
                             WHEN <lv_option> = 'GT' THEN '@2C@'
                             WHEN <lv_option> = 'LT' THEN'@2D@'
                             WHEN <lv_option> = 'NE' THEN '@2B@'
                             WHEN <lv_option> = 'BT' THEN '@2G@'
                             ELSE '' ).
      ENDCASE.

    ELSE.
      CLEAR: cv_low, cv_high, cv_icon.
    ENDIF.

    cv_ex_icon = COND #( WHEN lines( <lft_itab> ) > 1 THEN  '@1E@' ELSE '@1F@' ).

  ENDMETHOD.


  METHOD set_range_with_icon.
    DATA lv_cls_eq.
    DATA lv_idx TYPE i.
    DATA ld_ranges TYPE REF TO data.
    DATA ld_range  TYPE REF TO data.
    FIELD-SYMBOLS <l_ranges> TYPE ANY TABLE.
    FIELD-SYMBOLS <l_range>  TYPE any.
    FIELD-SYMBOLS <l_sign>   TYPE any.
    FIELD-SYMBOLS <l_option> TYPE any.
    FIELD-SYMBOLS <l_low>    TYPE any.
    FIELD-SYMBOLS <l_high>   TYPE any.
    DATA lv_more_name TYPE icons-text.
    DATA lv_stat_name TYPE icons-text.

    "---[S] initialization.
    DATA(lv_lines)     = lines( ct_range ).
    DATA : lv_input_l TYPE tvarv_val,
           lv_input_h TYPE tvarv_val.
    lv_input_l   = cv_low.
    lv_input_h   = cv_high.
    DATA(lv_option) = cv_stat+2(1).

    GET REFERENCE OF ct_range INTO ld_ranges.
    ASSIGN ld_ranges->* TO <l_ranges>.
    "---[E] initialization.

    FIELD-SYMBOLS <ls_wa> TYPE any.
    DATA ld_struc TYPE REF TO data.
    DATA: lv_field.
    CREATE DATA ld_struc LIKE LINE OF <l_ranges>.
    ASSIGN ld_struc->* TO <ls_wa>.
    ASSIGN COMPONENT 'LOW'    OF STRUCTURE <ls_wa> TO FIELD-SYMBOL(<l_value>).
    DESCRIBE FIELD <l_value> TYPE lv_field.
    IF lv_field = 'N' OR lv_field = 'D'.
      SHIFT lv_input_l LEFT DELETING LEADING '0'.
      CONDENSE lv_input_l.
      SHIFT lv_input_h LEFT DELETING LEADING '0'.
      CONDENSE lv_input_h.
    ENDIF.

    "---[S] set ranges in PAI.
    IF iv_pbo <> 'X'.

      IF lv_lines < 1.
        IF lv_input_l IS INITIAL AND lv_input_h IS INITIAL.
        ELSE.
          INSERT INITIAL LINE INTO TABLE <l_ranges> ASSIGNING <l_range>.
          ASSIGN COMPONENT 'SIGN'   OF STRUCTURE <l_range> TO <l_sign>.
          ASSIGN COMPONENT 'OPTION' OF STRUCTURE <l_range> TO <l_option>.
          ASSIGN COMPONENT 'LOW'    OF STRUCTURE <l_range> TO <l_low>.
          ASSIGN COMPONENT 'HIGH'   OF STRUCTURE <l_range> TO <l_high>.

          <l_sign> = CONV #( 'I' ).
          <l_low>  = COND #( WHEN lv_input_l IS NOT INITIAL THEN lv_input_l ).
          <l_high> = COND #( WHEN lv_input_h IS NOT INITIAL THEN lv_input_h ).

          IF <l_high> IS INITIAL.
            IF <l_low> CA '*'.
              <l_option> = 'CP'.
            ELSE.
              <l_option> = 'EQ'.
            ENDIF.
          ELSE.
            <l_option> = 'BT'.
          ENDIF.
        ENDIF.

      ELSEIF lv_lines >= 1.
        CLEAR: lv_idx.
        lv_idx = 1.
        LOOP AT <l_ranges> ASSIGNING <l_range>.
          IF lv_idx > 1.
            EXIT.
          ENDIF.

          ASSIGN COMPONENT 'SIGN'   OF STRUCTURE <l_range> TO <l_sign>.
          ASSIGN COMPONENT 'OPTION' OF STRUCTURE <l_range> TO <l_option>.
          ASSIGN COMPONENT 'LOW'    OF STRUCTURE <l_range> TO <l_low>.
          ASSIGN COMPONENT 'HIGH'   OF STRUCTURE <l_range> TO <l_high>.

          IF lv_input_l IS INITIAL AND lv_input_h IS INITIAL.
            IF <l_option> = 'BT' OR <l_option> = 'NB'.
              DELETE ct_range INDEX 1.
            ELSE.
              IF lv_option IS INITIAL.
                DELETE ct_range INDEX 1.
              ELSEIF lv_option <> '0' AND <l_low> IS NOT INITIAL.
                DELETE ct_range INDEX 1.
              ENDIF.
            ENDIF.

          ELSE.
            IF lv_input_h IS INITIAL.
              IF lv_input_l CA '*'.
                <l_option> = 'CP'.
              ELSE.
                IF <l_option> = 'BT' OR <l_option> = 'NB'.
                  <l_option> = 'EQ'.
                ENDIF.
              ENDIF.
              IF lv_option = '0'.
                lv_cls_eq = 'X'.
              ENDIF.

            ELSE.
              IF <l_option> = 'NB'.
                <l_option> = 'NB'.
              ELSE.
                <l_option> = 'BT'.
              ENDIF.
            ENDIF.

            <l_low>  = CONV #( lv_input_l ).
            <l_high> = CONV #( lv_input_h ).

          ENDIF.

          ADD 1 TO lv_idx.
        ENDLOOP.
      ENDIF.

      IF <l_range> IS ASSIGNED.
        UNASSIGN: <l_range>.
      ENDIF.

      IF <l_sign> IS ASSIGNED.
        UNASSIGN: <l_sign>.
      ENDIF.

      IF <l_option> IS ASSIGNED.
        UNASSIGN: <l_option>.
      ENDIF.

      IF <l_low> IS ASSIGNED.
        UNASSIGN: <l_low>.
      ENDIF.

      IF <l_high> IS ASSIGNED.
        UNASSIGN: <l_high>.
      ENDIF.
    ENDIF.
    "---[E] set ranges in PAI.

    "---[S] set screen field & icons.
    CLEAR: lv_lines.
    lv_lines = lines( ct_range ).
    IF lv_lines <= 1.
      lv_more_name = '@1F@'."ICON_ENTER_MORE.
    ELSE.
      lv_more_name = '@1E@'."ICON_DISPLAY_MORE.
    ENDIF.

    CLEAR: lv_idx.
    lv_idx = 1.
    LOOP AT <l_ranges> ASSIGNING <l_range>.
      IF lv_idx > 1.
        EXIT.
      ENDIF.
      ASSIGN COMPONENT 'SIGN'   OF STRUCTURE <l_range> TO <l_sign>.
      ASSIGN COMPONENT 'OPTION' OF STRUCTURE <l_range> TO <l_option>.
      ASSIGN COMPONENT 'LOW'    OF STRUCTURE <l_range> TO <l_low>.
      ASSIGN COMPONENT 'HIGH'   OF STRUCTURE <l_range> TO <l_high>.

      IF <l_option> IS NOT INITIAL.
        IF <l_sign> = 'I'.
          CASE <l_option>.
            WHEN 'EQ'. lv_stat_name = '0'.
            WHEN 'NE'. lv_stat_name = '1'.
            WHEN 'GT'. lv_stat_name = '2'.
            WHEN 'LT'. lv_stat_name = '3'.
            WHEN 'GE'. lv_stat_name = '4'.
            WHEN 'LE'. lv_stat_name = '5'.
            WHEN 'BT'. lv_stat_name = '6'.
            WHEN 'NB'. lv_stat_name = '7'.
            WHEN 'CP'. lv_stat_name = '8'.
            WHEN 'NP'. lv_stat_name = '9'.
          ENDCASE.
        ELSE.
          CASE <l_option>.
            WHEN 'EQ'. lv_stat_name = 'A'.
            WHEN 'NE'. lv_stat_name = 'B'.
            WHEN 'GT'. lv_stat_name = 'C'.
            WHEN 'LT'. lv_stat_name = 'D'.
            WHEN 'GE'. lv_stat_name = 'E'.
            WHEN 'LE'. lv_stat_name = 'F'.
            WHEN 'BT'. lv_stat_name = 'G'.
            WHEN 'NB'. lv_stat_name = 'H'.
            WHEN 'CP'. lv_stat_name = 'I'.
            WHEN 'NP'. lv_stat_name = 'J'.
          ENDCASE.
        ENDIF.
      ENDIF.
      lv_stat_name = '@2' && lv_stat_name && '@'.

      " clear status icon.
      IF lv_input_l IS NOT INITIAL AND lv_stat_name = '@20@'.
        CLEAR: lv_stat_name.
      ENDIF.

      IF lv_option = '0' AND lv_input_l IS NOT INITIAL.
        CLEAR: lv_stat_name.
      ENDIF.

      IF lv_cls_eq = 'X'.
        CLEAR: lv_stat_name.
      ENDIF.

      IF lv_stat_name = '@26@'.
        CLEAR: lv_stat_name.
      ENDIF.


      cv_low  = CONV #( <l_low> ).
      cv_high = CONV #( <l_high> ).
      ADD 1 TO lv_idx.
    ENDLOOP.
    "---[E] set screen field & icons.

    "---[S] create icons.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name                  = lv_more_name
      IMPORTING
        result                = cv_more
      EXCEPTIONS
        icon_not_found        = 1
        outputfield_too_short = 2
        OTHERS                = 3.

    IF lv_stat_name IS INITIAL.
      CLEAR: cv_stat.
    ELSE.
      CALL FUNCTION 'ICON_CREATE'
        EXPORTING
          name                  = lv_stat_name
        IMPORTING
          result                = cv_stat
        EXCEPTIONS
          icon_not_found        = 1
          outputfield_too_short = 2
          OTHERS                = 3.
      IF strlen( cv_stat ) > 4.
        cv_stat = cv_stat+0(3) && '@'.
      ENDIF.
    ENDIF.
    "---[E] create icons
  ENDMETHOD.


  METHOD split_path.


    DATA: lv_path(1024),
          lv_directory     TYPE c LENGTH 510,
          lv_filename      TYPE c LENGTH 510,
          lv_title         TYPE c LENGTH 510,
          lv_filenames     TYPE string,
          lv_extension(05),
          lv_size          TYPE i.

* File 명과 Directiroy 분리
    lv_path = cs_file_struc-fullname.
    CALL FUNCTION 'CV120_SPLIT_PATH'
      EXPORTING
        pf_path  = lv_path
      IMPORTING
        pfx_path = lv_directory
        pfx_file = lv_filename.

    cs_file_struc-directory = lv_directory.
    cs_file_struc-filename  = lv_filename.


*  확장자.
    CALL FUNCTION 'CV120_SPLIT_FILE'
      EXPORTING
        pf_file       = lv_filename
      IMPORTING
        pfx_file      = lv_title
        pfx_extension = lv_extension.

    cs_file_struc-title = lv_title.
    TRANSLATE lv_extension TO UPPER CASE.
    cs_file_struc-extension = lv_extension.

* File Size .

    lv_filenames = lv_path.
    CALL METHOD cl_gui_frontend_services=>file_get_size
      EXPORTING
        file_name            = lv_filenames
      IMPORTING
        file_size            = lv_size
      EXCEPTIONS
        file_get_size_failed = 1
        cntl_error           = 2
        error_no_gui         = 3
        not_supported_by_gui = 4
        OTHERS               = 5.

    cs_file_struc-doc_len = lv_size.

    CALL METHOD cl_gui_cfw=>flush.


  ENDMETHOD.
ENDCLASS.
