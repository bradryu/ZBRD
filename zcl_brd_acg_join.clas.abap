*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
class ZCL_BRD_ACG_JOIN definition
  public
  create public .

public section.

  types:
    gty_src         TYPE TABLE OF string .
  types:
    gty_fcat TYPE TABLE OF ztbrd00020 .
  types:
    BEGIN OF gts_key_map,
        h_field TYPE fieldname,
        icon    TYPE icon-id,
        i_field TYPE fieldname,
      END OF gts_key_map .
  types:
    gty_key_map TYPE TABLE OF gts_key_map .

  methods CONSTRUCTOR
    importing
      !IT_KEY_MAP type ZYBRD00110
      !IS_ALV_CONFIG type ZTBRD00010
      !IT_ALV_FCAT type ZYBRD00020
      !IS_ACG_CONFIG type ZSBRD00140
      !IS_ACG_CONFIG_JOIN type ZSBRD00140 .
  methods GET_100_SRC
    exporting
      value(ET_SRC) type GTY_SRC .
  methods GET_F01_SRC
    exporting
      value(ET_SRC) type GTY_SRC .
  methods GET_MAIN_SRC
    exporting
      value(ET_SRC) type GTY_SRC .
  methods GET_TOP_SRC
    exporting
      value(ET_SRC) type GTY_SRC .
  methods GET_100_ATTR
    exporting
      value(ET_FIELDS) type DYFATC_TAB
      value(ET_CONTAINER) type DYCATT_TAB .
  PROTECTED SECTION.

    DATA ms_name TYPE ztbrd00120 .
private section.

  data MS_CONFIG type ZTBRD00010 .
  data MT_CODE type GTY_SRC .
  data MV_CODE type STRING .
  data MT_FCAT type GTY_FCAT .
  data MV_JOIN_TYPE type CHAR1 .
  data MT_KEY_MAP type GTY_KEY_MAP .
  data MO_LIB type ref to ZCL_BRD_ACG_LIBRARY .
  data MS_ACG_CONFIG type ZSBRD00140 .
  data MS_ACG_CONFIG_JOIN type ZSBRD00140 .

  methods GEN_GET_CURSOR .
  methods GEN_USER_COMMAND .
  methods GEN_SET_SELECT_OPTION .
  methods GEN_SET_CURSOR .
  methods GEN_CHECK_AUTHORITY .
  methods GEN_DOUBLE_CLICK .
  methods GEN_END_OF_SELECTION .
  methods GEN_EXIT_SCREEN .
  methods GEN_FIELD_F4 .
  methods GEN_FIELD_HOTSPOT_CLICK .
  methods GEN_GETDATA .
  methods GEN_INITIALIZATION .
  methods GEN_REPORT_HEADER .
  methods GEN_RFSH_CLICK .
  methods GEN_SCR_1000 .
  methods GEN_SELECTION_SCREEN .
  methods GEN_SET_ALV .
  methods GEN_SET_INIT_VALUE .
  methods GEN_SET_SCREEN .
  methods GEN_SET_TITLE .
  methods GEN_SET_TOOLBAR .
  methods GEN_START_OF_SELECTION .
  methods GEN_VARIABLE .
  methods SET_DEFINE_ITAB
    importing
      !IT_FCAT type GTY_FCAT .
ENDCLASS.



CLASS ZCL_BRD_ACG_JOIN IMPLEMENTATION.


  METHOD constructor.
    MOVE-CORRESPONDING is_acg_config TO ms_acg_config.
    MOVE-CORRESPONDING is_acg_config_join TO ms_acg_config_join.

*    CLEAR ms_acg_config-is_1step.
    "join은 crud없음
    CLEAR : ms_config-zcreate, ms_config-zupdate, ms_config-zdelete, ms_config-zexcel.

    mv_join_type = ms_acg_config-param1.
    mt_key_map = it_key_map.

    DELETE mt_key_map WHERE h_field IS INITIAL.


    MOVE-CORRESPONDING is_alv_config TO ms_config.
    MOVE-CORRESPONDING it_alv_fcat[] TO mt_fcat[].
    SORT mt_fcat BY col_pos.

    SORT mt_fcat BY col_pos.
    IF ms_acg_config-is_new EQ abap_true.
      mo_lib = NEW zcl_brd_acg_library_n( is_acg_config = ms_acg_config ).
    ELSE.
      mo_lib = NEW zcl_brd_acg_library( is_acg_config = ms_acg_config ).
    ENDIF.
    MOVE-CORRESPONDING mo_lib->ms_name TO ms_name.
  ENDMETHOD.


  METHOD gen_check_authority.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_check_authority( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_double_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_double_click( EXPORTING iv_alv_key = ms_acg_config-alv_key
                              RECEIVING rt_code = lt_code ).
    IF ms_config-db_click NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_end_of_selection.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_end_of_selection( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_exit_screen.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  EXIT_SCREEN  INPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE EXIT_SCREEN INPUT.`.
    _set3 `  CASE ` ms_name-g_data `_OKCODE.`.
    _set5 `    WHEN ` ms_name-g_constants `_CANC OR ` ms_name-g_constants `_BACK.`.
    _set5 `      CASE ` ms_name-g_obj `_` ms_acg_config-alv_key `->GET_ALV_MODE( ).`.
    _set3 `        WHEN ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE.`.
    _set1 `          LEAVE TO SCREEN 0.`.
    IF ms_config-zexcel EQ 'X'.
      _set3 `        WHEN ` ms_acg_config-alv_class `=>MC_UPLOAD_MODE.`.
      _set1 `          LEAVE TO SCREEN 0.`.
    ELSE.
      _set3 `*        WHEN ` ms_acg_config-alv_class `=>MC_UPLOAD_MODE.`.
      _set1 `*          LEAVE TO SCREEN 0.`.
    ENDIF.

    _set1 `      ENDCASE.`.
    _set3 `    WHEN ` ms_name-g_constants `_EXIT.`.
    _set1 `      LEAVE TO SCREEN 0.`.
    _set1 `  ENDCASE.`.
    _set3 `  CLEAR ` ms_name-g_data `_OKCODE.`.
    _set1 `ENDMODULE.                 " EXIT_SCREEN  INPUT`.

  ENDMETHOD.


  METHOD gen_field_f4.

    DATA lt_code TYPE stringtab.
    mo_lib->get_field_f4( EXPORTING iv_alv_key = ms_acg_config-alv_key it_fcat = mt_fcat
                          RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_field_hotspot_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_field_hotspot_click( EXPORTING iv_alv_key = ms_acg_config-alv_key it_fcat = mt_fcat
                                     RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_getdata.
    DATA : lv_index TYPE sy-tabix.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lt_name TYPE TABLE OF char05.
    DATA lv_str TYPE string.
    DATA ls_fcat TYPE ztbrd00020.
    DATA ls_key_map TYPE gts_key_map.

    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  GET_` ms_acg_config-alv_key `_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM GET_` ms_acg_config-alv_key `_DATA .`.
    _set5 `  _INIT : ` ms_name-g_itab `_` ms_acg_config-alv_key `.`.
    _set1 `* SQL 및 데이터 가공 로직은 아래 주석을 제거 하고 수정하여 구현하세요.  `.
    _set1 `*  SELECT `.
    LOOP AT mt_fcat INTO ls_fcat.
      IF ls_fcat-ref_table EQ ms_acg_config-tabname.
        _set2 `*         T1~` ls_fcat-fieldname.
      ENDIF.
      IF ls_fcat-ref_table EQ ms_acg_config_join-tabname.
        _set2 `*         T2~` ls_fcat-fieldname.
      ENDIF.
    ENDLOOP.
    _set4 `*    INTO CORRESPONDING FIELDS OF TABLE ` ms_name-g_itab `_` ms_acg_config-alv_key.
    IF mv_join_type EQ 'I'.
      _set5 `*    FROM ` ms_acg_config-tabname ` AS T1 INNER JOIN ` ms_acg_config_join-tabname ` AS T2 `.
    ELSE.
      _set5 `*    FROM ` ms_acg_config-tabname ` AS T1 LEFT OUTER JOIN ` ms_acg_config_join-tabname ` AS T2 `.
    ENDIF.
    LOOP AT mt_key_map INTO ls_key_map.
      IF sy-tabix EQ 1.
        _set4 `*      ON T1~` ls_key_map-h_field ` = T2~` ls_key_map-i_field.
      ELSE.
        _set4 `*      AND T1~` ls_key_map-h_field ` = T2~` ls_key_map-i_field.
      ENDIF.
    ENDLOOP.

    _add1 `*    WHERE `.
    CLEAR lv_index.
    LOOP AT mt_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'.
      ADD 1 TO lv_cnt.
      ADD 1 TO lv_index.
      IF lv_index GT 1.
        _add1 `*      AND `.
      ENDIF.
      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_fcat-fieldname(5).
      IF sy-subrc EQ 0.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(3) lv_cnt INTO lv_str.
      ELSE.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(5) INTO lv_str.
        APPEND ls_fcat-fieldname(5) TO lt_name.
      ENDIF.
      _add4 `T1~` ls_fcat-fieldname ` IN ` lv_str.
      _append.
      CLEAR ls_fcat.

    ENDLOOP.
    _set1 `*.`.
    _set3 `ENDFORM.                    "GET_` ms_acg_config-alv_key `DATA`.
  ENDMETHOD.


  METHOD gen_get_cursor.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_get_cursor( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_initialization.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_initialization( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_report_header.

    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_report_header( ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_rfsh_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_rfsh_click( EXPORTING iv_alv_key = ms_acg_config-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_config-zrefresh NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_scr_1000.
    DATA lt_code TYPE stringtab.
    mo_lib->get_scr_1000( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                    iv_tabnm = ms_acg_config-tabname
                                    iv_zexcel = ms_config-zexcel
                                    it_fcat = mt_fcat
                          RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

*    DATA lv_cnt(2) TYPE n VALUE 9.
*    DATA lt_name TYPE TABLE OF char05.
*    DATA lv_str TYPE string.
*    DATA ls_fcat TYPE ztbrd00020.
*    _set1 `*&---------------------------------------------------------------------*`.
*    _set1 `*&  SELECTION SCREEN`.
*    _set1 `*&---------------------------------------------------------------------*`.
*
*    _set1 `SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT009.`.
*    LOOP AT mt_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'.
*      ADD 1 TO lv_cnt.
*      _set1 `SELECTION-SCREEN BEGIN OF LINE.`.
*      _set3 `SELECTION-SCREEN COMMENT (20) TEXT0` lv_cnt ` MODIF ID DP.`.
*      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_fcat-fieldname(5).
*      IF sy-subrc EQ 0.
*        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(3) lv_cnt INTO lv_str.
*      ELSE.
*        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(5) INTO lv_str.
*        APPEND ls_fcat-fieldname(5) TO lt_name.
*      ENDIF.
*      _set7 `SELECT-OPTIONS ` lv_str ` FOR ` ms_acg_config-tabname `-` ls_fcat-fieldname ` MODIF ID DP.`.
*      _set1 `SELECTION-SCREEN END OF LINE.`.
*    ENDLOOP.
*    _set1 `SELECTION-SCREEN END OF BLOCK B1.`.

  ENDMETHOD.


  METHOD gen_selection_screen.
    DATA lt_code TYPE stringtab.
    mo_lib->get_selection_screen( EXPORTING iv_excel_upload = ms_config-zexcel
                                  RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_alv.
    DATA lt_code TYPE stringtab.
    mo_lib->get_set_alv( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                   iv_fcat_key = ms_acg_config-fcat_key
                         RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_set_cursor.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_cursor( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_init_value.
    DATA lt_code TYPE stringtab.
    mo_lib->get_set_init_value( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                          iv_excel_upload = ' '
                                          it_fcat = mt_fcat
                                RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_screen.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_screen( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_select_option.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_select_option( EXPORTING it_fcat = mt_fcat ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_title.

    DATA lt_code TYPE stringtab.
    mo_lib->get_set_title( EXPORTING it_fcat = mt_fcat
                           RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_set_toolbar.

    DATA lt_code TYPE stringtab.
    mo_lib->get_set_toolbar( EXPORTING iv_alv_key = ms_acg_config-alv_key
                             RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_start_of_selection.

    DATA lt_code TYPE stringtab.
    mo_lib->get_start_of_selection( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                              iv_excel_upload = ' '
                                    RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_user_command.
    DATA lt_code TYPE stringtab.

    lt_code = mo_lib->get_user_command( EXPORTING is_alv_config = ms_config
                                                  it_fcat = mt_fcat ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_variable.
    DATA lt_code TYPE stringtab.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&  INCLUDE           ` ms_acg_config-progid  `TOP`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 ``.
    _set5 `TABLES : ` ms_acg_config-tabname `,` ms_acg_config_join-tabname `.`.
    _set1 ``.
    DATA lv_container TYPE seoclsname.
    IF ms_acg_config-is_1step EQ abap_true.
      lv_container = 'CL_GUI_CUSTOM_CONTAINER'.
    ENDIF.
    CLEAR lt_code.
    mo_lib->get_global_variable( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                           it_fcat = mt_fcat
                                           iv_container = lv_container
                                  RECEIVING rt_code = lt_code           ).
    APPEND LINES OF lt_code TO mt_code.


    set_define_itab( EXPORTING it_fcat = mt_fcat ).


    mo_lib->get_1step_screen_variable( EXPORTING it_fcat = mt_fcat
                                       RECEIVING rt_code = lt_code  ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD get_100_attr.

    mo_lib->get_screen_100_attr( EXPORTING it_fcat = mt_fcat
                                 IMPORTING et_fields = et_fields
                                           et_container = et_container ).

  ENDMETHOD.


  METHOD get_100_src.
    CLEAR mt_code.
    mt_code = mo_lib->get_screen_100( ).
    et_src = mt_code.
  ENDMETHOD.


  METHOD get_f01_src.
    CLEAR mt_code.
    mt_code = mo_lib->get_f01_header( ).

    gen_set_screen( ).
    gen_set_cursor( ).
    gen_set_alv( ).
    gen_exit_screen( ).
    gen_get_cursor( ).
    gen_user_command( ).
    gen_set_select_option( ).
    gen_set_init_value( ).
    gen_check_authority( ).
    gen_getdata( ).
    gen_set_title( ).
    gen_rfsh_click( ).
    gen_double_click( ).
    gen_set_toolbar( ).
    gen_field_f4( ).
    gen_field_hotspot_click( ).

    et_src = mt_code.
  ENDMETHOD.


  METHOD get_main_src.
    CLEAR mt_code.

    gen_report_header( ).
    gen_initialization( ).
*    gen_selection_screen( ).
    gen_start_of_selection( ).
    gen_end_of_selection( ).

    et_src = mt_code.
  ENDMETHOD.


  METHOD get_top_src.
    CLEAR mt_code.
    gen_variable( ).
    gen_scr_1000( ).

    et_src = mt_code.
  ENDMETHOD.


  METHOD set_define_itab.

    DATA lt_code TYPE stringtab.
    DATA lv_tabname TYPE tabname.
    DATA ls_fcat TYPE ztbrd00020.
    IF it_fcat IS INITIAL.
      CLEAR lt_code.
      mo_lib->get_itab( EXPORTING iv_alv_key = ms_acg_config-alv_key iv_tabnm = ms_acg_config-tabname
                        RECEIVING rt_code = lt_code  ).
      APPEND LINES OF lt_code TO mt_code.
    ELSE.
      CONCATENATE ms_name-g_type '_' ms_acg_config-alv_key INTO lv_tabname.
      _set3 `TYPES : BEGIN OF ` lv_tabname `,`.
      CLEAR lt_code.
      mo_lib->get_struct_line( EXPORTING it_fcat = it_fcat
                               RECEIVING rt_code = lt_code  ).
      APPEND LINES OF lt_code TO mt_code.

      _set3 `        END OF ` lv_tabname `.`.

      CLEAR lt_code.


      mo_lib->get_itab( EXPORTING iv_alv_key = ms_acg_config-alv_key iv_tabnm = lv_tabname
                        RECEIVING rt_code = lt_code  ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
