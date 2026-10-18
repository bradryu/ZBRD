*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
class ZCL_BRD_ACG_DOUBLE_SIMPLE definition
  public
  final
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

  data MS_NAME type ZTBRD00120 .

  methods CONSTRUCTOR
    importing
      !IT_KEY_MAP type GTY_KEY_MAP
      !IS_ALV_L_CONFIG type ZTBRD00010
      !IT_ALV_L_FCAT type ZYBRD00020
      !IS_ALV_R_CONFIG type ZTBRD00010
      !IT_ALV_R_FCAT type ZYBRD00020
      !IS_ACG_CONFIG_LEFT type ZSBRD00140
      !IS_ACG_CONFIG_RIGHT type ZSBRD00140 .
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
private section.

  data MS_L_CONFIG type ZTBRD00010 .
  data MT_CODE type GTY_SRC .
  data MV_CODE type STRING .
  data MT_L_FCAT type GTY_FCAT .
  data MS_R_CONFIG type ZTBRD00010 .
  data MT_R_FCAT type GTY_FCAT .
  data MT_KEY_MAP type GTY_KEY_MAP .
  data MO_LIB type ref to ZCL_BRD_ACG_LIBRARY .
  data MS_ACG_CONFIG_LEFT type ZSBRD00140 .
  data MS_ACG_CONFIG_RIGHT type ZSBRD00140 .

  methods GEN_SET_SELECT_OPTION .
  methods GEN_SET_CURSOR .
  methods GEN_GET_CURSOR .
  methods GEN_INST_CLICK .
  methods GEN_ADDR_CLICK .
  methods GEN_CANC_CLICK .
  methods GEN_CHAN_CLICK .
  methods GEN_CHECK_AUTHORITY .
  methods GEN_CHECK_PK .
  methods GEN_CREATE_CLICK .
  methods GEN_DATA_CHANGED .
  methods GEN_DELE_CLICK .
  methods GEN_DELR_CLICK .
  methods GEN_DOUBLE_CLICK .
  methods GEN_END_OF_SELECTION .
  methods GEN_EXIT_SCREEN .
  methods GEN_FIELD_CHANGED .
  methods GEN_FIELD_F4 .
  methods GEN_FIELD_HOTSPOT_CLICK .
  methods GEN_GETDATA .
  methods GEN_INITIALIZATION .
  methods GEN_REPORT_HEADER .
  methods GEN_RFSH_CLICK .
  methods GEN_SAVE_CLICK .
  methods GEN_SCR_1000 .
  methods GEN_SELECTION_SCREEN .
  methods GEN_SET_ALV .
  methods GEN_SET_INIT_VALUE .
  methods GEN_SET_SCREEN .
  methods GEN_SET_TITLE .
  methods GEN_SET_TOOLBAR .
  methods GEN_START_OF_SELECTION .
  methods GEN_UPLD_CLICK .
  methods GEN_UPLOAD_DATA .
  methods GEN_VARIABLE .
  methods GEN_VERIFY_DATA .
  methods SET_DEFINE_ITAB
    importing
      !IT_FCAT type GTY_FCAT
      !IV_ALV_KEY type CHAR10
      !IV_TABNAME type TABNAME .
  methods GEN_SAVE_DATA .
  methods GEN_USER_COMMAND .
ENDCLASS.



CLASS ZCL_BRD_ACG_DOUBLE_SIMPLE IMPLEMENTATION.


  METHOD constructor.

    MOVE-CORRESPONDING is_acg_config_left TO ms_acg_config_left.
    MOVE-CORRESPONDING is_acg_config_right TO ms_acg_config_right.

*    CLEAR ms_acg_config_left-is_1step.

    mt_key_map[] = it_key_map[].

    DELETE mt_key_map WHERE h_field IS INITIAL.

    MOVE-CORRESPONDING is_alv_l_config TO ms_l_config.
    MOVE-CORRESPONDING it_alv_l_fcat[] TO mt_l_fcat[].
    MOVE-CORRESPONDING is_alv_r_config TO ms_r_config.
    MOVE-CORRESPONDING it_alv_r_fcat[] TO mt_r_fcat[].


    SORT mt_l_fcat BY col_pos.
    SORT mt_r_fcat BY col_pos.

    IF ms_acg_config_left-is_new EQ abap_true.
      mo_lib = NEW zcl_brd_acg_library_n( is_acg_config = ms_acg_config_left ).
    ELSE.
      mo_lib = NEW zcl_brd_acg_library( is_acg_config = ms_acg_config_left ).
    ENDIF.
    MOVE-CORRESPONDING mo_lib->ms_name TO ms_name.
  ENDMETHOD.


  METHOD gen_addr_click.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_addr_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                            RECEIVING rt_code = lt_code  ).
    IF ms_l_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

    CLEAR lt_code.
    mo_lib->get_addr_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_r_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_canc_click.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_canc_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_l_config-zexcel EQ 'X'
    OR ms_l_config-zcreate EQ 'X'
    OR ms_l_config-zupdate EQ 'X'.

    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_canc_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_r_config-zexcel EQ 'X'
    OR ms_r_config-zcreate EQ 'X'
    OR ms_r_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_chan_click.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_chan_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_l_config-zupdate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

    CLEAR lt_code.
    mo_lib->get_chan_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                            RECEIVING rt_code = lt_code ).

    IF ms_r_config-zupdate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_check_authority.
    DATA lt_code TYPE string_table.
    lt_code = mo_lib->get_check_authority( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_check_pk.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_check_pk( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                                    iv_tabnm = ms_acg_config_left-tabname
                                    it_fcat = mt_l_fcat
                          RECEIVING rt_code = lt_code ).
    IF ms_l_config-zexcel EQ 'X'
    OR ms_l_config-zcreate EQ 'X'
    OR ms_l_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

    CLEAR lt_code.
    mo_lib->get_check_pk( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                                    iv_tabnm = ms_acg_config_right-tabname
                                    it_fcat = mt_r_fcat
                          RECEIVING rt_code = lt_code ).
    IF ms_r_config-zexcel EQ 'X'
    OR ms_r_config-zcreate EQ 'X'
    OR ms_r_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_create_click.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_create_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                              RECEIVING rt_code = lt_code ).
    IF ms_l_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_create_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                              RECEIVING rt_code = lt_code ).
    IF ms_r_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_data_changed.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_data_changed( EXPORTING iv_alv_key = ms_acg_config_left-alv_key it_fcat = mt_l_fcat
                              RECEIVING rt_code = lt_code ).
    IF ms_l_config-zupdate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_data_changed( EXPORTING iv_alv_key = ms_acg_config_right-alv_key it_fcat = mt_r_fcat
                              RECEIVING rt_code = lt_code ).
    IF ms_r_config-zupdate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_dele_click.
    DATA lt_code TYPE string_table.

    mo_lib->get_dele_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key iv_tabnm = ms_acg_config_left-tabname
                            RECEIVING rt_code = lt_code ).
    IF ms_l_config-zdelete NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    mo_lib->get_dele_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key iv_tabnm = ms_acg_config_right-tabname
                                  RECEIVING rt_code = lt_code ).
    IF ms_r_config-zdelete NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_delr_click.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_delr_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_l_config-zexcel EQ 'X'
    OR ms_l_config-zcreate EQ 'X'
    OR ms_l_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_delr_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_r_config-zexcel EQ 'X'
    OR ms_r_config-zcreate EQ 'X'
    OR ms_r_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_double_click.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_double_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                              RECEIVING rt_code = lt_code ).
    IF ms_l_config-db_click NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_double_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                              RECEIVING rt_code = lt_code ).
    IF ms_r_config-db_click NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_end_of_selection.
    DATA lt_code TYPE string_table.
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
    _set7 `      IF ` ms_name-g_obj `_` ms_acg_config_left-alv_key `->GET_ALV_MODE( ) EQ ` ms_acg_config_left-alv_class `=>MC_DISPLAY_MODE`.
    _set7 `        AND ` ms_name-g_obj `_` ms_acg_config_right-alv_key `->GET_ALV_MODE( ) EQ ` ms_acg_config_left-alv_class `=>MC_DISPLAY_MODE.`.
    _set1 `        LEAVE TO SCREEN 0.`.
    _set1 `      ELSE.`.
    _set7 `        IF ` ms_name-g_obj `_` ms_acg_config_left-alv_key `->GET_ALV_MODE( ) NE ` ms_acg_config_left-alv_class `=>MC_DISPLAY_MODE.`.
    _set3 `          PERFORM ` ms_acg_config_left-alv_key `_CANC_CLICK.`.
    _set1 `        ENDIF.`.
    _set7 `        IF ` ms_name-g_obj `_` ms_acg_config_right-alv_key `->GET_ALV_MODE( ) NE ` ms_acg_config_left-alv_class `=>MC_DISPLAY_MODE.`.
    _set3 `          PERFORM ` ms_acg_config_right-alv_key `_CANC_CLICK.`.
    _set1 `        ENDIF.`.
    _set1 `      ENDIF.`.
    _set3 `    WHEN ` ms_name-g_constants `_EXIT.`.
    _set1 `      LEAVE TO SCREEN 0.`.
    _set1 `  ENDCASE.`.
    _set3 `  CLEAR ` ms_name-g_data `_OKCODE.    `.
    _set1 `ENDMODULE.                 " EXIT_SCREEN  INPUT`.
  ENDMETHOD.


  METHOD gen_field_changed.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_field_changed( EXPORTING iv_alv_key = ms_acg_config_left-alv_key it_fcat = mt_l_fcat
                               RECEIVING rt_code = lt_code ).
    IF ms_l_config-zexcel EQ 'X'
        OR ms_l_config-zcreate EQ 'X'
        OR ms_l_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_field_changed( EXPORTING iv_alv_key = ms_acg_config_right-alv_key it_fcat = mt_r_fcat
                               RECEIVING rt_code = lt_code ).
    IF ms_r_config-zexcel EQ 'X'
        OR ms_r_config-zcreate EQ 'X'
        OR ms_r_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_field_f4.

    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_field_f4( EXPORTING iv_alv_key = ms_acg_config_left-alv_key it_fcat = mt_l_fcat
                          RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

    CLEAR lt_code.
    mo_lib->get_field_f4( EXPORTING iv_alv_key = ms_acg_config_right-alv_key it_fcat = mt_r_fcat
                          RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_field_hotspot_click.
    DATA lt_code TYPE string_table.
    CLEAR lt_code.
    mo_lib->get_field_hotspot_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key it_fcat = mt_l_fcat
                                     RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

    CLEAR lt_code.
    mo_lib->get_field_hotspot_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key it_fcat = mt_r_fcat
                                     RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_getdata.
    DATA : lv_index TYPE sy-tabix.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lt_name TYPE TABLE OF char05.
    DATA lv_str TYPE string.
    DATA ls_key_map TYPE LINE OF gty_key_map.

    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  GET_` ms_acg_config_left-alv_key `_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM GET_` ms_acg_config_left-alv_key `_DATA .`.
    _set5 `  _INIT : ` ms_name-g_itab `_` ms_acg_config_left-alv_key `.`.
    IF ms_acg_config_left-is_1step EQ abap_true.
      _set1 `  CLEAR GS_FILTER.`.
      _set1 `  _SET_FILTER : `.
      CLEAR lv_index.
      LOOP AT mt_key_map INTO ls_key_map.
        ADD 1 TO lv_index.
        IF lv_index GT 1.
          _add1 `,`.
        ENDIF.
        _add1 ls_key_map-h_field .
        _append.
      ENDLOOP.
      _set1 `.`.
    ENDIF.
    _set1 `  SELECT *`.
    _set5 `    INTO CORRESPONDING FIELDS OF TABLE ` ms_name-g_itab `_` ms_acg_config_left-alv_key ``.
    _set2 `    FROM ` ms_acg_config_left-tabname.
    _add1 `    WHERE `.
    CLEAR : lv_cnt, lv_index, lt_name[].
    LOOP AT mt_key_map INTO ls_key_map.
      ADD 1 TO lv_cnt.
      ADD 1 TO lv_index.
      IF lv_index GT 1.
        _add1 `      AND `.
      ENDIF.
      lv_str = mo_lib->get_where_query_string( EXPORTING iv_cnt = lv_cnt
                                                         iv_fieldname = ls_key_map-h_field ).
      _add3 ls_key_map-h_field ` IN ` lv_str.
      _append.

      CLEAR ls_key_map.

    ENDLOOP.
    _set1 `.`.
    _set3 `ENDFORM.                    "GET_` ms_acg_config_left-alv_key `_DATA`.

    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  GET_` ms_acg_config_right-alv_key `_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM GET_` ms_acg_config_right-alv_key `_DATA .`.
    _set5 `  _INIT : ` ms_name-g_itab `_` ms_acg_config_right-alv_key `.`.
    _set1 `  SELECT *`.
    _set5 `    INTO CORRESPONDING FIELDS OF TABLE ` ms_name-g_itab `_` ms_acg_config_right-alv_key ``.
    _set2 `    FROM ` ms_acg_config_right-tabname.
    _add1 `    WHERE `.
    CLEAR : lv_cnt, lv_index, lt_name[].
    LOOP AT mt_key_map INTO ls_key_map.
      ADD 1 TO lv_cnt.
      ADD 1 TO lv_index.
      IF lv_index GT 1.
        _add1 `      AND `.
      ENDIF.
      lv_str = mo_lib->get_where_query_string( EXPORTING iv_cnt = lv_cnt
                                                         iv_fieldname = ls_key_map-h_field ).
      _add3 ls_key_map-h_field ` IN ` lv_str.
      _append.

      CLEAR ls_key_map.

    ENDLOOP.
    _set1 `.`.
    _set3 `ENDFORM.                    "GET_` ms_acg_config_right-alv_key `_DATA`.
  ENDMETHOD.


  METHOD gen_get_cursor.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_get_cursor( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_initialization.
    DATA lt_code TYPE string_table.
    lt_code = mo_lib->get_initialization( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_inst_click.
    DATA lt_code TYPE stringtab.

    CLEAR lt_code.
    mo_lib->get_inst_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                            RECEIVING rt_code = lt_code ).


    IF ms_l_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_inst_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_r_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_report_header.
    DATA lt_code TYPE string_table.
    lt_code = mo_lib->get_report_header( ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_rfsh_click.
    DATA lt_code TYPE string_table.
    CLEAR lt_code.
    mo_lib->get_rfsh_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_l_config-zrefresh NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_rfsh_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_r_config-zrefresh NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_save_click.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_save_click( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                                      iv_tabnm = ms_acg_config_left-tabname
                            RECEIVING rt_code = lt_code ).
    IF ms_l_config-zexcel EQ 'X'
    OR ms_l_config-zcreate EQ 'X'
    OR ms_l_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_save_click( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                                      iv_tabnm = ms_acg_config_right-tabname
                            RECEIVING rt_code = lt_code ).
    IF ms_r_config-zexcel EQ 'X'
    OR ms_r_config-zcreate EQ 'X'
    OR ms_r_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_save_data.
    DATA lt_code TYPE stringtab.
    IF ms_acg_config_left-is_new EQ abap_true.
      CLEAR lt_code.

      DATA : ls_alv_tab TYPE mo_lib->gts_alv_tab,
             lt_alv_tab TYPE mo_lib->gtt_alv_tab.

      ls_alv_tab-alv_key = ms_acg_config_left-alv_key.
      ls_alv_tab-tabnm = ms_acg_config_left-tabname.
      APPEND ls_alv_tab TO lt_alv_tab.

      ls_alv_tab-alv_key = ms_acg_config_right-alv_key.
      ls_alv_tab-tabnm = ms_acg_config_right-tabname.
      APPEND ls_alv_tab TO lt_alv_tab.


      mo_lib->get_save_data( EXPORTING it_alv_tab = lt_alv_tab
                              RECEIVING rt_code = lt_code ).
      IF ms_l_config-zexcel EQ 'X'
      OR ms_l_config-zcreate EQ 'X'
      OR ms_l_config-zupdate EQ 'X'
      OR ms_r_config-zexcel EQ 'X'
      OR ms_r_config-zcreate EQ 'X'
      OR ms_r_config-zupdate EQ 'X'.

      ELSE.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.

    ENDIF.
  ENDMETHOD.


  METHOD gen_scr_1000.
    CHECK ms_acg_config_left-is_1step EQ abap_false.

    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lt_name TYPE TABLE OF char05.
    DATA lv_str TYPE string.
    DATA ls_key_map TYPE gts_key_map.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&  SELECTION SCREEN`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT009  .`.
    LOOP AT mt_key_map INTO ls_key_map.
      ADD 1 TO lv_cnt.

      _set1 `SELECTION-SCREEN BEGIN OF LINE.`.
      _set3 `SELECTION-SCREEN COMMENT (20) TEXT0` lv_cnt `.`.
      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_key_map-h_field(5).
      IF sy-subrc EQ 0.
        CONCATENATE ms_name-selectoption '_' ls_key_map-h_field(3) lv_cnt INTO lv_str.
      ELSE.
        CONCATENATE ms_name-selectoption '_' ls_key_map-h_field(5) INTO lv_str.
        APPEND ls_key_map-h_field(5) TO lt_name.
      ENDIF.
      _set7 `SELECT-OPTIONS ` lv_str ` FOR ` ms_acg_config_left-tabname `-` ls_key_map-h_field `.`.
      _set1 `SELECTION-SCREEN END OF LINE.`.
    ENDLOOP.
    _set1 `SELECTION-SCREEN END OF BLOCK B1 .`.
  ENDMETHOD.


  METHOD gen_selection_screen.
  ENDMETHOD.


  METHOD gen_set_alv.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  SET_ALV  OUTPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE SET_ALV OUTPUT.`.
    IF ms_acg_config_left-is_1step EQ abap_true.
      _set3 `  IF ` ms_name-g_obj `_CUSTOM_CONTAINER_OUT IS INITIAL.`.
      _set3 `    CREATE OBJECT ` ms_name-g_obj `_CUSTOM_CONTAINER_OUT`.
      _set1 `      EXPORTING`.
      _set3 `        CONTAINER_NAME = 'CON_` ms_acg_config_left-alv_key `'.`.
      _set3 `  CREATE OBJECT ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT`.
      _set1 `     EXPORTING`.
      _set1 `       PARENT  = GO_CUSTOM_CONTAINER_OUT`.
      _set1 `       ROWS    = 1`.
      _set1 `       COLUMNS = 2 .`.

      _set7 `  ` ms_name-g_obj `_CONTAINER_` ms_acg_config_left-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).`.
      _set7 `  ` ms_name-g_obj `_CONTAINER_` ms_acg_config_right-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 2 ).`.
      _set3 `  ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->SET_WIDTH( WIDTH = 50 ).`.
      _set3 `  ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->SET_WIDTH( WIDTH = 50 ).`.
    ELSE.
      _set3 `  IF ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT IS INITIAL.`.
      _set3 `  CREATE OBJECT ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT`.
      _set1 `    EXPORTING`.
      _set1 `      PARENT  = CL_GUI_CONTAINER=>DEFAULT_SCREEN`.
      _set1 `      ROWS    = 2`.
      _set1 `      COLUMNS = 1 .`.
      _set5 `  ` ms_name-g_obj `_CONTAINER_TITLE = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).`.
      _set5 `  ` ms_name-g_obj `_CONTAINER = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).`.
      _set3 `  CREATE OBJECT ` ms_name-g_obj `_SPLITTER_CONTAINER_IN`.
      _set1 `    EXPORTING`.
      _set3 `      PARENT  = ` ms_name-g_obj `_CONTAINER`.
      _set1 `      ROWS    = 1`.
      _set1 `      COLUMNS = 2 .`.
      _set7 `  ` ms_name-g_obj `_CONTAINER_` ms_acg_config_left-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_IN->GET_CONTAINER( ROW = 1 COLUMN = 1 ).`.
      _set7 `  ` ms_name-g_obj `_CONTAINER_` ms_acg_config_right-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_IN->GET_CONTAINER( ROW = 1 COLUMN = 2 ).`.
      _set3 `  ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->SET_ROW_HEIGHT( ID = 1 HEIGHT = 20 ).`.
      _set3 `  CREATE OBJECT ` ms_name-g_obj `_DOCUMENT.`.
      _set1 ``.
      _set1 `  PERFORM SET_TITLE.`.
      _set1 ``.
      _set5 `  ` ms_name-g_obj `_DOCUMENT->DISPLAY_DOCUMENT( PARENT = ` ms_name-g_obj `_CONTAINER_TITLE ).`.
    ENDIF.

    _set4 `  CREATE OBJECT ` ms_name-g_obj `_` ms_acg_config_left-alv_key.
    _set1 `    EXPORTING`.
    _set5 `      IO_PARENT = ` ms_name-g_obj `_CONTAINER_` ms_acg_config_left-alv_key ` `.
    IF ms_acg_config_left-alv_key <> 'BALV'.
      _set3 `      IV_ALV_KEY = '` ms_acg_config_left-alv_key `'`.
    ENDIF.
    IF ms_acg_config_left-fcat_key <> 'DEFAULT'.
      _set3 `      IV_FCAT_KEY = '` ms_acg_config_left-fcat_key `'`.
    ENDIF.
    _set1 `        .`.
    _set1 ``.
    _add4 `  ` ms_name-g_obj `_` ms_acg_config_left-alv_key.
    _add5 `->DISPLAY( CHANGING CT_DATA = ` ms_name-g_itab `_` ms_acg_config_left-alv_key `[] ).`.
    _append.


    _set4 `  CREATE OBJECT ` ms_name-g_obj `_` ms_acg_config_right-alv_key.
    _set1 `    EXPORTING`.
    _set5 `      IO_PARENT = ` ms_name-g_obj `_CONTAINER_` ms_acg_config_right-alv_key ` `.
    IF ms_acg_config_right-alv_key <> 'BALV'.
      _set3 `      IV_ALV_KEY = '` ms_acg_config_right-alv_key `'`.
    ENDIF.
    IF ms_acg_config_right-fcat_key <> 'DEFAULT'.
      _set3 `      IV_FCAT_KEY = '` ms_acg_config_right-fcat_key `'`.
    ENDIF.
    _set1 `        .`.
    _set1 ``.
    _add4 `  ` ms_name-g_obj `_` ms_acg_config_right-alv_key.
    _add5 `->DISPLAY( CHANGING CT_DATA = ` ms_name-g_itab `_` ms_acg_config_right-alv_key `[] ).`.
    _append.
    _set1 `ELSE.`.
    _set5 `  ` ms_name-g_obj `_` ms_acg_config_left-alv_key `->REFRESH( ).`.
    _set5 `  ` ms_name-g_obj `_` ms_acg_config_right-alv_key `->REFRESH( ).`.
    _set1 `ENDIF.`.

    _set1 `ENDMODULE.`.
  ENDMETHOD.


  METHOD gen_set_cursor.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_cursor( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_init_value.
    DATA lt_code TYPE stringtab.
    mo_lib->get_set_init_value_double( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                                                 it_fcat = mt_l_fcat
                                                 it_key_map = mt_key_map
                                       RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_screen.
    DATA lt_code TYPE string_table.
    lt_code = mo_lib->get_set_screen( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_select_option.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_select_option( EXPORTING it_fcat = mt_l_fcat ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_title.
    DATA lt_code TYPE stringtab.
    mo_lib->get_set_title_double( EXPORTING it_key_map = mt_key_map
                                            it_fcat = mt_l_fcat
                                  RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_toolbar.
    DATA lt_code TYPE string_table.
    CLEAR lt_code.
    mo_lib->get_set_toolbar( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                             RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

    CLEAR lt_code.
    mo_lib->get_set_toolbar( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                             RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_start_of_selection.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*& START-OF-SELECTION.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `START-OF-SELECTION.`.
    _set1 `  PERFORM CHECK_AUTHORITY.`.

    _set3 `  PERFORM GET_` ms_acg_config_left-alv_key `_DATA.`.
    _set3 `  PERFORM GET_` ms_acg_config_right-alv_key `_DATA.`.
  ENDMETHOD.


  METHOD gen_upld_click.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_upload_click_form( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                                   RECEIVING rt_code = lt_code ).
    IF ms_l_config-zexcel NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_upload_click_form( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                                   RECEIVING rt_code = lt_code ).
    IF ms_r_config-zexcel NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).

    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_upload_data.
    DATA lt_code TYPE string_table.
    CLEAR lt_code.
    mo_lib->get_upload_data_form( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                                  RECEIVING rt_code = lt_code ).

    IF ms_l_config-zexcel NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_upload_data_form( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                                  RECEIVING rt_code = lt_code ).
    IF ms_r_config-zexcel NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_user_command.
    DATA lv_cnt(2) TYPE n VALUE 9.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      Module  USER_COMMAND  INPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       text`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE USER_COMMAND INPUT.`.
    _set3 `  CASE ` ms_name-g_data `_OKCODE.`.
    IF ms_acg_config_left-is_1step EQ abap_true.
      _set1 `    WHEN C_UCOMM-ENTER. "Forced PBO Excute`.
      _set1 `    WHEN C_UCOMM-EXCUTE.`.
      _set3 `      PERFORM ` ms_l_config-alv_key `_CANC_CLICK.`.
      _set3 `      PERFORM ` ms_r_config-alv_key `_CANC_CLICK.`.
      _set3 `      PERFORM GET_` ms_l_config-alv_key `_DATA.`.
      _set3 `      PERFORM GET_` ms_r_config-alv_key `_DATA.`.
      LOOP AT mt_l_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE zkey EQ abap_true AND tech EQ abap_false.

        ADD 1 TO  lv_cnt.
        _set3 `    WHEN 'FC_` <ls_fcat>-fieldname `'.`.
        _add2 `      _SET_RANGE_EXTENSION ` <ls_fcat>-fieldname.
        _add7  ` '` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `' TEXT-T` lv_cnt `.`.
        _append.
      ENDLOOP.
      LOOP AT mt_l_fcat ASSIGNING <ls_fcat> WHERE zkey EQ abap_false AND tech EQ abap_false.
        ADD 1 TO  lv_cnt.
        _set3 `*    WHEN 'FC_` <ls_fcat>-fieldname `'.`.
        _add2 `*      _SET_RANGE_EXTENSION ` <ls_fcat>-fieldname.
        _add7  ` '` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `' TEXT-T` lv_cnt `.`.
        _append.
      ENDLOOP.
    ENDIF.
    IF ms_l_config-zcreate EQ abap_true
       OR ms_l_config-zupdate EQ abap_true
       OR ms_l_config-zdelete EQ abap_true.
      _set3 `    WHEN ` ms_name-g_constants `_UCOMM-SAVE.`.
      _set1 `      PERFORM SAVE_DATA.`.
    ELSE.
      _set3 `*    WHEN ` ms_name-g_constants `_UCOMM-SAVE.`.
      _set1 `*      PERFORM SAVE_DATA.`.
    ENDIF.
    _set1 `  ENDCASE.`.
    _set1 `  CLEAR GV_OKCODE.`.
    _set1 `ENDMODULE.`.

  ENDMETHOD.


  METHOD gen_variable.
    DATA lt_code TYPE stringtab.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&  INCLUDE           ` ms_acg_config_left-progid  `TOP`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 ``.
    _set5 `TABLES : ` ms_acg_config_left-tabname `, ` ms_acg_config_right-tabname `.`.
    _set1 ``.

    IF ms_acg_config_left-is_1step EQ abap_true.
      _set1 `DATA : go_custom_container_out TYPE REF TO cl_gui_custom_container.`.
    ENDIF.

    CLEAR lt_code.
    mo_lib->get_global_variable( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                                           it_fcat = mt_l_fcat
                                 RECEIVING rt_code = lt_code           ).
    APPEND LINES OF lt_code TO mt_code.

    CLEAR lt_code.
    mo_lib->get_global_variable( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                                           it_fcat = mt_r_fcat
                                 RECEIVING rt_code = lt_code           ).
    APPEND LINES OF lt_code TO mt_code.

    set_define_itab( EXPORTING iv_alv_key = ms_acg_config_left-alv_key
                               it_fcat = mt_l_fcat
                               iv_tabname = ms_acg_config_left-tabname
                                ).

    set_define_itab( EXPORTING iv_alv_key = ms_acg_config_right-alv_key
                               it_fcat = mt_r_fcat
                               iv_tabname = ms_acg_config_right-tabname
                                ).

    mo_lib->get_1step_screen_variable( EXPORTING it_fcat = mt_l_fcat
                                   RECEIVING rt_code = lt_code  ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_verify_data.
    DATA lt_code TYPE string_table.

    CLEAR lt_code.
    mo_lib->get_verify_data( EXPORTING iv_alv_key = ms_acg_config_left-alv_key it_fcat = mt_l_fcat
                             RECEIVING rt_code = lt_code ).
    IF ms_l_config-zexcel EQ 'X'
      OR ms_l_config-zcreate EQ 'X'
      OR ms_l_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.


    CLEAR lt_code.
    mo_lib->get_verify_data( EXPORTING iv_alv_key = ms_acg_config_right-alv_key it_fcat = mt_r_fcat
                             RECEIVING rt_code = lt_code ).
    IF ms_r_config-zexcel EQ 'X'
      OR ms_r_config-zcreate EQ 'X'
      OR ms_r_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD get_100_attr.
    mo_lib->get_screen_100_attr( EXPORTING it_fcat = mt_l_fcat
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
    gen_upload_data( ).
    gen_set_title( ).
    gen_create_click( ).
    gen_chan_click( ).
    gen_canc_click( ).
    gen_rfsh_click( ).
    gen_addr_click( ).
    gen_inst_click( ).
    gen_delr_click( ).
    gen_upld_click( ).
    gen_double_click( ).
    gen_save_click( ).
    gen_verify_data( ).
    gen_dele_click( ).
    gen_data_changed( ).
    gen_field_changed( ).
    gen_check_pk( ).
    gen_set_toolbar( ).
    gen_field_f4( ).
    gen_field_hotspot_click( ).
    gen_save_data( ).
    et_src = mt_code.
  ENDMETHOD.


  METHOD get_main_src.
    CLEAR mt_code.

    gen_report_header( ).
    gen_initialization( ).
    gen_selection_screen( ).
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
    DATA lt_code TYPE string_table.
    DATA lv_tabname TYPE tabname.
    DATA ls_fcat TYPE ztbrd00020.

    IF it_fcat IS INITIAL.
      CLEAR lt_code.
      mo_lib->get_itab( EXPORTING iv_alv_key = iv_alv_key iv_tabnm = iv_tabname
        RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ELSE.
      CONCATENATE ms_name-g_type '_' iv_alv_key INTO lv_tabname.
      _set3 `TYPES : BEGIN OF ` lv_tabname `,`.
      CLEAR lt_code.
      mo_lib->get_struct_line( EXPORTING it_fcat = it_fcat
                               RECEIVING rt_code = lt_code  ).
      APPEND LINES OF lt_code TO mt_code.

      _set3 `        END OF ` lv_tabname `.`.

      CLEAR lt_code.

      mo_lib->get_itab( EXPORTING iv_alv_key = iv_alv_key iv_tabnm = lv_tabname
                        RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
