*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
class ZCL_BRD_ACG_TREE_GRID_DOUBLE definition
  public
  final
  create public .

public section.

  types:
    gty_src         TYPE TABLE OF string .
  types:
    gty_h_fcat TYPE TABLE OF ztbrd00021 .
  types:
    gty_i_fcat TYPE TABLE OF ztbrd00020 .
  types:
    gty_fcat_tree TYPE TABLE OF ztbrd00021 .
  types:
    gty_alv_fcat TYPE TABLE OF ztbrd00020 .
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
      !IT_KEY_MAP type GTY_KEY_MAP
      !IS_I_CONFIG type ZTBRD00010
      !IT_I_FCAT type ZYBRD00020
      !IS_H_CONFIG type ZTBRD00011
      !IT_H_FCAT type ZYBRD00021
      !IS_ACG_CONFIG_HEADER type ZSBRD00140
      !IS_ACG_CONFIG_ITEM type ZSBRD00140 .
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

  data MS_H_CONFIG type ZTBRD00011 .
  data MT_CODE type GTY_SRC .
  data MV_CODE type STRING .
  data MT_H_FCAT type GTY_H_FCAT .
  data MS_I_CONFIG type ZTBRD00010 .
  data MT_I_FCAT type GTY_I_FCAT .
  data MT_KEY_MAP type GTY_KEY_MAP .
  data MO_LIB type ref to ZCL_BRD_ACG_LIBRARY .
  data MO_LIB_TREE type ref to ZCL_BRD_ACG_LIBRARY .
  data MV_NODE_ID_FIELD type FIELDNAME .
  data MT_ALV_FCAT type GTY_ALV_FCAT .
  data MS_FCAT type ZTBRD00020 .
  data MS_FCAT_TREE type ZTBRD00021 .
  data MV_PARENTS_NODE_ID_FIELD type FIELDNAME .
  data MS_ACG_CONFIG_HEADER type ZSBRD00140 .
  data MS_ACG_CONFIG_ITEM type ZSBRD00140 .

  methods GEN_SET_SELECT_OPTION .
  methods GEN_SET_CURSOR .
  methods GEN_GET_CURSOR .
  methods GEN_INST_CLICK .
  methods GEN_SET_TITLE .
  methods GEN_SAVE_DATA .
  methods GEN_USER_COMMAND .
  methods GEN_NODE_EXPAND .
  methods GEN_SCR_1000 .
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
  methods GEN_SET_ALV .
  methods GEN_SET_INIT_VALUE .
  methods GEN_SET_SCREEN .
  methods GEN_SET_TOOLBAR .
  methods GEN_START_OF_SELECTION .
  methods GEN_UPLD_CLICK .
  methods GEN_UPLOAD_DATA .
  methods GEN_VARIABLE .
  methods GEN_VERIFY_DATA .
  methods SET_DEFINE_ITAB
    importing
      !IT_FCAT type GTY_I_FCAT
      !IV_ITABALIAS type CHAR10
      !IV_TABNAME type TABNAME .
  methods SET_DEFINE_ITAB_TREE
    importing
      !IT_FCAT type GTY_H_FCAT
      !IV_ITABALIAS type CHAR10 optional
      !IV_TABNAME type TABNAME .
  methods GEN_CONTEXT_REQUEST .
  methods GEN_CONTEXT_SELECT .
ENDCLASS.



CLASS ZCL_BRD_ACG_TREE_GRID_DOUBLE IMPLEMENTATION.


  METHOD constructor.
    DATA ls_h_fcat TYPE ztbrd00021.

    MOVE-CORRESPONDING is_acg_config_header TO ms_acg_config_header.
    MOVE-CORRESPONDING is_acg_config_item TO ms_acg_config_item.

*    CLEAR : ms_acg_config_header-is_1step, ms_acg_config_item-is_1step.

    mt_key_map[] = it_key_map[].

    DELETE mt_key_map WHERE h_field IS INITIAL OR i_field IS INITIAL.

    MOVE-CORRESPONDING is_i_config TO ms_i_config.
    MOVE-CORRESPONDING it_i_fcat[] TO mt_i_fcat[].
    MOVE-CORRESPONDING is_h_config TO ms_h_config.
    MOVE-CORRESPONDING it_h_fcat[] TO mt_h_fcat[].


    READ TABLE mt_h_fcat INTO ls_h_fcat WITH KEY node = 'X'.
    IF sy-subrc EQ 0.
      mv_node_id_field = ls_h_fcat-fieldname.
    ENDIF.

    READ TABLE mt_h_fcat INTO ls_h_fcat WITH KEY parents_node = 'X'.
    IF sy-subrc EQ 0.
      mv_parents_node_id_field = ls_h_fcat-fieldname.
    ENDIF.

    SORT mt_h_fcat BY col_pos.
    SORT mt_i_fcat BY col_pos.

    CLEAR : ms_fcat_tree, ms_fcat.
    LOOP AT mt_h_fcat INTO ms_fcat_tree.
      MOVE-CORRESPONDING ms_fcat_tree TO ms_fcat.
      APPEND ms_fcat TO mt_alv_fcat.
      CLEAR : ms_fcat_tree, ms_fcat.
    ENDLOOP.

*
*    CREATE OBJECT mo_lib_tree
*      EXPORTING
*        is_acg_config = is_acg_config_header.

    IF is_acg_config_header-is_new EQ abap_true.
      mo_lib_tree = NEW zcl_brd_acg_library_n( is_acg_config = is_acg_config_header ).
      mo_lib = NEW zcl_brd_acg_library_n( is_acg_config = is_acg_config_item ).
    ELSE.
      mo_lib_tree = NEW zcl_brd_acg_library( is_acg_config = is_acg_config_header ).
      mo_lib = NEW zcl_brd_acg_library( is_acg_config = is_acg_config_item ).
    ENDIF.
    MOVE-CORRESPONDING mo_lib->ms_name TO ms_name.
  ENDMETHOD.


  METHOD gen_addr_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_addr_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                            RECEIVING rt_code = lt_code  ).

    IF ms_i_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_canc_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_canc_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                            RECEIVING rt_code = lt_code ).

    IF ms_i_config-zexcel EQ 'X'
     OR ms_i_config-zcreate EQ 'X'
     OR ms_i_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_chan_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_chan_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_i_config-zupdate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_check_authority.

    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_check_authority( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_check_pk.

    DATA lt_code TYPE stringtab.
    mo_lib->get_check_pk( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                    iv_tabnm = ms_acg_config_item-tabname
                                    it_fcat = mt_i_fcat
                          RECEIVING rt_code = lt_code ).
    IF ms_i_config-zexcel EQ 'X'
     OR ms_i_config-zcreate EQ 'X'
     OR ms_i_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_context_request.

    DATA lt_code TYPE stringtab.
    mo_lib_tree->get_context_request( EXPORTING iv_alv_key = ms_acg_config_header-alv_key
                                      RECEIVING rt_code = lt_code ).
    IF ms_h_config-context_menu NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_context_select.

    DATA lt_code TYPE stringtab.
    mo_lib_tree->get_context_select( EXPORTING iv_alv_key = ms_acg_config_header-alv_key
                                               iv_node_id_field = mv_node_id_field
                                     RECEIVING rt_code = lt_code ).
    IF ms_h_config-context_menu NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_create_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_create_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                              RECEIVING rt_code = lt_code ).

    IF ms_i_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_data_changed.

    DATA lt_code TYPE stringtab.
    mo_lib->get_data_changed( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                        it_fcat = mt_i_fcat
                              RECEIVING rt_code = lt_code ).
    IF ms_i_config-zupdate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_dele_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_dele_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                      iv_tabnm = ms_acg_config_item-tabname
                            RECEIVING rt_code = lt_code ).

    IF ms_i_config-zdelete NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_delr_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_delr_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                            RECEIVING rt_code = lt_code ).
    IF ms_i_config-zexcel EQ 'X'
     OR ms_i_config-zcreate EQ 'X'
     OR ms_i_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_double_click.
    DATA lt_code TYPE stringtab.
    DATA lv_star.

    IF ms_h_config-db_click NE 'X'.
      lv_star = '*'.
    ENDIF.

    _set2 lv_star `*&---------------------------------------------------------------------*`.
    _set4 lv_star `*&      FORM  ` ms_acg_config_header-alv_key `_DOUBLE_CLICK`.
    _set2 lv_star `*&---------------------------------------------------------------------*`.
    _set2 lv_star `*       TEXT`.
    _set2 lv_star `*----------------------------------------------------------------------*`.
    _set6 lv_star `FORM ` ms_acg_config_header-alv_key `_DOUBLE_CLICK USING ` ms_name-form_iv `_FIELDNAME TYPE LVC_FNAME`.
    _set4 lv_star `                                       ` ms_name-form_iv `_NODE_KEY TYPE LVC_NKEY.`.
    _set6 lv_star `  ` ms_name-g_data `_OPERATING_NODE_KEY = ` ms_name-form_iv `_NODE_KEY.`.
    _add5 lv_star `  ` ms_name-g_obj `_` ms_acg_config_header-alv_key.
    _add3 `->GET_LINE( EXPORTING I_NODE_KEY = ` ms_name-g_data `_OPERATING_NODE_KEY`.
    _append.
    _set6 lv_star `                     CHANGING C_OUTTAB_LINE = ` ms_name-g_wa `_` ms_acg_config_header-alv_key ` ).`.
    _set2 lv_star `  IF SY-SUBRC EQ 0.`.
    _set4 lv_star `    PERFORM GET_` ms_acg_config_item-alv_key `_DATA.`.
    _add5 lv_star `    ` ms_name-g_obj `_` ms_acg_config_item-alv_key.
    _add3 `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config_item-alv_class `=>MC_DISPLAY_MODE`.
    _append.
    _set6 lv_star `                           CHANGING CT_DATA  = ` ms_name-g_itab `_` ms_acg_config_item-alv_key `[] ).`.
    _set2 lv_star `  ENDIF.`.
    _set2 lv_star `ENDFORM.`.


    CLEAR lt_code.
    mo_lib->get_double_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                              RECEIVING rt_code = lt_code ).
    IF ms_i_config-db_click NE 'X'.
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
    _set7 `      IF ` ms_name-g_obj `_` ms_acg_config_item-alv_key `->GET_ALV_MODE( ) EQ ` ms_acg_config_item-alv_class `=>MC_DISPLAY_MODE.`.
    _set1 `        LEAVE TO SCREEN 0.`.
    _set1 `      ELSE.`.
    _set7 `      IF ` ms_name-g_obj `_` ms_acg_config_item-alv_key `->GET_ALV_MODE( ) EQ ` ms_acg_config_item-alv_class `=>MC_DISPLAY_MODE.`.
    _set3 `            PERFORM ` ms_acg_config_item-alv_key `_CANC_CLICK.`.
    _set1 `        ENDIF.`.
    _set1 `      ENDIF.`.
    _set3 `    WHEN ` ms_name-g_constants `_EXIT.`.
    _set1 `      LEAVE TO SCREEN 0.`.
    _set1 `  ENDCASE.`.
    _set3 `  CLEAR ` ms_name-g_data `_OKCODE.`.
    _set1 `ENDMODULE.                 " EXIT_SCREEN  INPUT`.
  ENDMETHOD.


  METHOD gen_field_changed.


    DATA lt_code TYPE stringtab.
    mo_lib->get_field_changed( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                         it_fcat = mt_i_fcat
                               RECEIVING rt_code = lt_code ).
    IF ms_i_config-zexcel EQ 'X'
      OR ms_i_config-zcreate EQ 'X'
      OR ms_i_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_field_f4.

    DATA lt_code TYPE stringtab.
    mo_lib->get_field_f4( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                    it_fcat = mt_i_fcat
                          RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_field_hotspot_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_field_hotspot_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                               it_fcat = mt_i_fcat
                                     RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_getdata.
    DATA lt_code TYPE stringtab.
    DATA : lv_index TYPE sy-tabix.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lt_name TYPE TABLE OF char05.
    DATA lv_str TYPE string.
    DATA ls_key_map TYPE LINE OF gty_key_map.

    CLEAR lt_code.
    mo_lib->get_getdata_tree( EXPORTING iv_alv_key = ms_acg_config_header-alv_key
                                        iv_tabnm = ms_acg_config_header-tabname
                                        it_fcat = mt_alv_fcat
                              RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.


*
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  GET_` ms_acg_config_item-alv_key `_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM GET_` ms_acg_config_item-alv_key `_DATA .`.
    _set5 `  _INIT : ` ms_name-g_itab `_` ms_acg_config_item-alv_key `.`.
    _set3 `  MESSAGE 'Implementate GET_` ms_acg_config_item-alv_key `_DATA to get BALV data' TYPE 'I' DISPLAY LIKE 'E'.`.
    _set7 `*  IF ` ms_name-g_wa `_` ms_acg_config_header-alv_key `-` mv_parents_node_id_field ` IS INITIAL.` .
    _set1 `*  SELECT *`.
    _set5 `*    INTO CORRESPONDING FIELDS OF TABLE ` ms_name-g_itab `_` ms_acg_config_item-alv_key ``.
    _set2 `*    FROM ` ms_acg_config_item-tabname.
    _add1 `*    WHERE `.
    CLEAR lv_index.
    LOOP AT mt_key_map INTO ls_key_map.
      ADD 1 TO lv_cnt.
      ADD 1 TO lv_index.
      IF lv_index GT 1.
        _add1 `*      AND `.
      ENDIF.
      _add7 ls_key_map-i_field ` EQ ` ms_name-g_wa `_` ms_acg_config_header-alv_key `-` ls_key_map-h_field.
      _append.
      CLEAR ls_key_map.
    ENDLOOP.
    _set1 `.`.
    _set1 `*ESLE.`.
    _set1 `*  SELECT *`.
    _set5 `*    INTO CORRESPONDING FIELDS OF TABLE ` ms_name-g_itab `_` ms_acg_config_item-alv_key ``.
    _set2 `*    FROM ` ms_acg_config_item-tabname.
    _add1 `*    WHERE `.
    CLEAR lv_index.
    LOOP AT mt_key_map INTO ls_key_map.
      ADD 1 TO lv_cnt.
      ADD 1 TO lv_index.
      IF lv_index GT 1.
        _add1 `*      AND `.
      ENDIF.
      _add7 ls_key_map-i_field ` EQ ` ms_name-g_wa `_` ms_acg_config_header-alv_key `-` ls_key_map-h_field.
      _append.
      CLEAR ls_key_map.
    ENDLOOP.
    _set1 `.`.
    _set1 `*ENDIF.`.
    _set3 `ENDFORM.                    "GET_` ms_acg_config_item-alv_key `_DATA`.
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


  METHOD gen_inst_click.
    DATA lt_code TYPE stringtab.
    mo_lib->get_inst_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                            RECEIVING rt_code = lt_code ).

    IF ms_i_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_node_expand.
    DATA lt_code TYPE stringtab.
    mo_lib->get_node_expand( EXPORTING iv_alv_key = ms_acg_config_header-alv_key
                                       iv_tabnm = ms_acg_config_header-tabname
                                       iv_node_id_field = mv_node_id_field
                                       iv_pnode_id_field = mv_parents_node_id_field
                             RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_report_header.

    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_report_header( ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_rfsh_click.


    DATA lt_code TYPE stringtab.
    mo_lib->get_rfsh_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                            RECEIVING rt_code = lt_code ).

    IF ms_i_config-zrefresh NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_save_click.


    DATA lt_code TYPE stringtab.
    mo_lib->get_save_click( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                      iv_tabnm = ms_acg_config_item-tabname
                            RECEIVING rt_code = lt_code ).
    IF ms_i_config-zexcel EQ 'X'
     OR ms_i_config-zcreate EQ 'X'
     OR ms_i_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_save_data.

    DATA lt_code TYPE stringtab.
    DATA : ls_alv_tab TYPE mo_lib->gts_alv_tab,
           lt_alv_tab TYPE mo_lib->gtt_alv_tab.

    ls_alv_tab-alv_key = ms_acg_config_item-alv_key.
    ls_alv_tab-tabnm = ms_acg_config_item-tabname.
    APPEND ls_alv_tab TO lt_alv_tab.


    mo_lib->get_save_data( EXPORTING it_alv_tab = lt_alv_tab
                            RECEIVING rt_code = lt_code ).

    IF ms_i_config-zexcel EQ 'X'
      OR ms_i_config-zcreate EQ 'X'
      OR ms_i_config-zupdate EQ 'X'.

    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_scr_1000.
    DATA lt_code TYPE stringtab.

    mo_lib->get_scr_1000( EXPORTING iv_alv_key = ms_acg_config_header-alv_key
                                    iv_tabnm = ms_acg_config_header-tabname
                                    it_fcat = mt_alv_fcat
                          RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
*    DATA lv_cnt(2) TYPE n VALUE 9.
*    DATA lt_name TYPE TABLE OF char05.
*    DATA lv_str TYPE string.
*
*    _set1 `*&---------------------------------------------------------------------*`.
*    _set1 `*&  SELECTION SCREEN`.
*    _set1 `*&---------------------------------------------------------------------*`.
*    _set1 `SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT009.`.
*    _set1 ``.
*
*    LOOP AT mt_h_fcat INTO DATA(ls_fcat) WHERE zkey EQ 'X' AND tech NE 'X'.
*      ADD 1 TO lv_cnt.
*
*      _set1 `SELECTION-SCREEN BEGIN OF LINE.`.
*      _set3 `SELECTION-SCREEN COMMENT (20) TEXT0` lv_cnt `.`.
*      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_fcat-fieldname(5).
*      IF sy-subrc EQ 0.
*        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(3) lv_cnt INTO lv_str.
*      ELSE.
*        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(5) INTO lv_str.
*        APPEND ls_fcat-fieldname(5) TO lt_name.
*      ENDIF.
*      _set7 `SELECT-OPTIONS ` lv_str ` FOR ` ms_acg_config_header-tabname `-` ls_fcat-fieldname `.`.
*      _set1 `SELECTION-SCREEN END OF LINE.`.
*    ENDLOOP.
*    _set1 `SELECTION-SCREEN END OF BLOCK B1.`.



  ENDMETHOD.


  METHOD gen_set_alv.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  SET_ALV  OUTPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE SET_ALV OUTPUT.`.
    IF ms_acg_config_header-is_1step EQ abap_true.
      _set3 `  IF ` ms_name-g_obj `_CUSTOM_CONTAINER_OUT IS INITIAL.`.
      _set3 `    CREATE OBJECT ` ms_name-g_obj `_CUSTOM_CONTAINER_OUT`.
      _set1 `      EXPORTING`.
      "TREE, ITEM은 ITEM 기준으로 CONTAINER가 만들어짐
      _set3 `        CONTAINER_NAME = 'CON_` ms_acg_config_item-alv_key `'.`.
      _set3 `  CREATE OBJECT ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT`.
      _set1 `     EXPORTING`.
      _set1 `       PARENT  = GO_CUSTOM_CONTAINER_OUT`.
      _set1 `       ROWS    = 1`.
      _set1 `       COLUMNS = 2 .`.

      _set7 `  ` ms_name-g_obj `_CONTAINER_` ms_acg_config_header-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).`.
      _set7 `  ` ms_name-g_obj `_CONTAINER_` ms_acg_config_item-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 2 ).`.
      _set3 `  ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->SET_WIDTH( WIDTH = 50 ).`.
      _set3 `  ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->SET_WIDTH( WIDTH = 50 ).`.
      _set1 `  ENDIF.`.
    ELSE.
      _set3 `  IF ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT IS INITIAL.`.
      _set3 `  CREATE OBJECT ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT`.
      _set1 `    EXPORTING`.
      _set1 `      PARENT  = CL_GUI_CONTAINER=>DEFAULT_SCREEN`.
      _set1 `      ROWS    = 2`.
      _set1 `      COLUMNS = 1 .`.
      _set5 `  ` ms_name-g_obj `_CONTAINER_TITLE = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).`.
      _set5 `  ` ms_name-g_obj `_CONTAINER_FOR_INNER_SP = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).`.
      _set3 `  CREATE OBJECT ` ms_name-g_obj `_SPLITTER_CONTAINER_IN`.
      _set1 `    EXPORTING`.
      _set3 `      PARENT  = ` ms_name-g_obj `_CONTAINER_FOR_INNER_SP`.
      _set1 `      ROWS    = 1`.
      _set1 `      COLUMNS = 2 .`.
      _set7 `  ` ms_name-g_obj `_CONTAINER_` ms_acg_config_header-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_IN->GET_CONTAINER( ROW = 1 COLUMN = 1 ).`.
      _set7 `  ` ms_name-g_obj `_CONTAINER_` ms_acg_config_item-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_IN->GET_CONTAINER( ROW = 1 COLUMN = 2 ).`.

      _set3 `  ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->SET_ROW_HEIGHT( ID = 1 HEIGHT = 20 ).`.
      _set3 `  ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->SET_ROW_HEIGHT( ID = 2 HEIGHT = 80 ).`.

      _set3 `  ` ms_name-g_obj `_SPLITTER_CONTAINER_IN->SET_COLUMN_WIDTH( ID = 1 WIDTH = 30 ).`.
      _set3 `  ` ms_name-g_obj `_SPLITTER_CONTAINER_IN->SET_COLUMN_WIDTH( ID = 2 WIDTH = 70 ).`.
      _set1 ``.
      _set3 `  CREATE OBJECT ` ms_name-g_obj `_DOCUMENT.`.
      _set1 `  PERFORM SET_TITLE.`.
      _set5 `  ` ms_name-g_obj `_DOCUMENT->DISPLAY_DOCUMENT( PARENT = ` ms_name-g_obj `_CONTAINER_TITLE ).`.
      _set1 `ENDIF.`.
    ENDIF.
    _set5 `  IF ` ms_name-g_obj `_` ms_acg_config_item-alv_key ` IS INITIAL.`.
    _set4 `    CREATE OBJECT ` ms_name-g_obj `_` ms_acg_config_item-alv_key.
    _set1 `      EXPORTING`.
    _set5 `        IO_PARENT = ` ms_name-g_obj `_CONTAINER_` ms_acg_config_item-alv_key ` `.
    IF ms_acg_config_item-alv_key <> 'BALV'.
      _set3 `        IV_ALV_KEY = '` ms_acg_config_item-alv_key `'`.
    ENDIF.
    IF ms_acg_config_item-fcat_key <> 'DEFAULT'.
      _set3 `        IV_FCAT_KEY = '` ms_acg_config_item-fcat_key `'`.
    ENDIF.
    _set1 `        .`.
    _set1 ``.
    _add4 `    ` ms_name-g_obj `_` ms_acg_config_item-alv_key.
    _add5 `->DISPLAY( CHANGING CT_DATA = ` ms_name-g_itab `_` ms_acg_config_item-alv_key `[] ).`.
    _append.
    _set1 `  ELSE.`.
    _set5 `    ` ms_name-g_obj `_` ms_acg_config_item-alv_key `->REFRESH( ).`.
    _set1 `  ENDIF.`.
    _set5 `  IF ` ms_name-g_obj `_` ms_acg_config_header-alv_key ` IS INITIAL.`.
    _set4 `    CREATE OBJECT ` ms_name-g_obj `_` ms_acg_config_header-alv_key.
    _set1 `      EXPORTING`.
    _set5 `        IO_PARENT = ` ms_name-g_obj `_CONTAINER_` ms_acg_config_header-alv_key ` `.
    IF ms_acg_config_header-alv_key <> 'TALV'.
      _set3 `        IV_ALV_KEY = '` ms_acg_config_header-alv_key `'`.
    ENDIF.
    IF ms_acg_config_header-fcat_key <> 'DEFAULT'.
      _set3 `        IV_FCAT_KEY = '` ms_acg_config_header-fcat_key `'`.
    ENDIF.
    _set1 `        .`.
    _set1 ``.
    _add4 `    ` ms_name-g_obj `_` ms_acg_config_header-alv_key.
    _add5 `->DISPLAY( CHANGING CT_DATA = ` ms_name-g_itab `_` ms_acg_config_header-alv_key `[] ).`.
    _append.
    _set1 `  ELSE.`.
    _set3 `    IF ` ms_name-g_data `_TREE_RELOAD = ABAP_TRUE.`.
    _add5 `      ` ms_name-g_obj `_` ms_acg_config_header-alv_key `->RELOAD( CHANGING CT_DATA = `.
    _add4 ms_name-g_itab `_` ms_acg_config_header-alv_key `[] ).`.
    _append.
    _set1 `    ELSE.`.
    _set5 `    ` ms_name-g_obj `_` ms_acg_config_header-alv_key `->REFRESH( ).`.
    _set1 `    ENDIF.`.
    _set3 `    CLEAR ` ms_name-g_data `_TREE_RELOAD.`.
    _set1 `  ENDIF.`.

    _set1 `ENDMODULE.`.
  ENDMETHOD.


  METHOD gen_set_cursor.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_cursor( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_init_value.
    DATA lt_code TYPE stringtab.
    mo_lib->get_set_init_value_double( EXPORTING iv_alv_key = ms_acg_config_header-alv_key
                                                 it_fcat = mt_alv_fcat
                                                 it_key_map = mt_key_map
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
    lt_code = mo_lib->get_set_select_option( EXPORTING it_fcat = mt_alv_fcat ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_title.

    DATA lt_code TYPE stringtab.
    mo_lib->get_set_title_double( EXPORTING it_key_map = mt_key_map
                                            it_fcat = mt_alv_fcat
                                  RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_set_toolbar.

    DATA lt_code TYPE stringtab.
    mo_lib->get_set_toolbar( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                             RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_start_of_selection.

    DATA lt_code TYPE stringtab.
    mo_lib->get_start_of_selection( EXPORTING iv_alv_key = ms_acg_config_header-alv_key
                                              iv_excel_upload = ' '
                                    RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_upld_click.


    DATA lt_code TYPE stringtab.
    mo_lib->get_upload_click_form( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                   RECEIVING rt_code = lt_code ).

    IF ms_i_config-zexcel NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_upload_data.

    DATA lt_code TYPE stringtab.
    mo_lib->get_upload_data_form( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                  RECEIVING rt_code = lt_code ).

    IF ms_i_config-zexcel NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.


    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_user_command.
    DATA lv_cnt(2) TYPE n VALUE 9.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  USER_COMMAND  INPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE USER_COMMAND INPUT.`.
    _set3 `  CASE ` ms_name-g_data `_OKCODE.`.
    _set3 `    WHEN ` ms_name-g_constants `_DB_CLICK.`.
    _set3 `      IF ` ms_name-g_data `_OPERATING_NODE_KEY > 0.`.
    _set7 `        ` ms_name-g_obj `_` ms_acg_config_header-alv_key `->GET_LINE( EXPORTING I_NODE_KEY = ` ms_name-g_data `_OPERATING_NODE_KEY`.
    _set5 `                           CHANGING C_OUTTAB_LINE = ` ms_name-g_wa `_` ms_acg_config_header-alv_key ` ).`.
    _set1 `      ENDIF.`.
    IF ms_acg_config_header-is_1step EQ abap_true.
      _set1 `    WHEN C_UCOMM-ENTER. "Forced PBO Excute`.
      _set1 `    WHEN C_UCOMM-EXCUTE.`.
      _set3 `      PERFORM GET_` ms_acg_config_header-alv_key `_DATA.`.
      _set3 `      ` ms_name-g_data `_TREE_RELOAD = ABAP_TRUE.`.
      LOOP AT mt_alv_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE zkey EQ abap_true AND tech EQ abap_false.

        ADD 1 TO  lv_cnt.
        _set3 `    WHEN 'FC_` <ls_fcat>-fieldname `'.`.
        _add2 `      _SET_RANGE_EXTENSION ` <ls_fcat>-fieldname.
        _add7  ` '` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `' TEXT-T` lv_cnt `.`.
        _append.
      ENDLOOP.
      LOOP AT mt_alv_fcat ASSIGNING <ls_fcat> WHERE zkey EQ abap_false AND tech EQ abap_false.
        ADD 1 TO  lv_cnt.
        _set3 `*    WHEN 'FC_` <ls_fcat>-fieldname `'.`.
        _add2 `*      _SET_RANGE_EXTENSION ` <ls_fcat>-fieldname.
        _add7  ` '` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `' TEXT-T` lv_cnt `.`.
        _append.
      ENDLOOP.
    ENDIF.
    _set1 `      `.
    _set1 `  ENDCASE.`.
    _set1 `  CLEAR GV_OKCODE.`.
    _set1 `ENDMODULE.                 " USER_COMMAND  INPUT`.
  ENDMETHOD.


  METHOD gen_variable.
    DATA lt_code TYPE stringtab.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&  INCLUDE           ` ms_acg_config_header-progid  `TOP`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 ``.
    IF ms_acg_config_header-tabname EQ ms_acg_config_item-tabname.
      _set3 `TABLES : ` ms_acg_config_header-tabname `.`.
    ELSE.
      _set5 `TABLES : ` ms_acg_config_header-tabname `, ` ms_acg_config_item-tabname `.`.
    ENDIF.
    _set1 ``.
    IF ms_acg_config_header-is_1step EQ abap_true.
      _set1 `DATA : go_custom_container_out TYPE REF TO cl_gui_custom_container.`.
    ENDIF.
    CLEAR lt_code.
    mo_lib->get_global_variable( EXPORTING iv_alv_key = ms_acg_config_header-alv_key
                                           iv_alv_class = ms_acg_config_header-alv_class
                                           it_fcat = mt_alv_fcat
                                  RECEIVING rt_code = lt_code           ).
    APPEND LINES OF lt_code TO mt_code.
    _set3 `CONSTANTS : ` ms_name-g_constants `_DB_CLICK      TYPE SY-UCOMM VALUE 'DBCLK'.`.
    _set3 `DATA : ` ms_name-g_data `_OPERATING_NODE_KEY TYPE LVC_NKEY,`.
    _set3 `       ` ms_name-g_data `_TREE_RELOAD TYPE FLAG.`.
    CLEAR lt_code.
    mo_lib->get_global_variable( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                       it_fcat = mt_i_fcat
                              RECEIVING rt_code = lt_code           ).
    APPEND LINES OF lt_code TO mt_code.

    set_define_itab_tree( EXPORTING it_fcat = mt_h_fcat " tree alv fcat
                                    iv_tabname = ms_acg_config_header-tabname ).


    set_define_itab( EXPORTING iv_itabalias = ms_acg_config_item-alv_key
                               it_fcat = mt_i_fcat
                               iv_tabname = ms_acg_config_item-tabname
                                ).

    mo_lib->get_1step_screen_variable( EXPORTING it_fcat = mt_alv_fcat
                                       RECEIVING rt_code = lt_code  ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_verify_data.

    DATA lt_code TYPE stringtab.
    mo_lib->get_verify_data( EXPORTING iv_alv_key = ms_acg_config_item-alv_key
                                       it_fcat = mt_i_fcat
                             RECEIVING rt_code = lt_code ).
    IF ms_i_config-zexcel EQ 'X'
     OR ms_i_config-zcreate EQ 'X'
     OR ms_i_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD get_100_attr.
    mo_lib->get_screen_100_attr( EXPORTING it_fcat = mt_alv_fcat
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
    gen_set_toolbar( ).


    gen_create_click( ).
    gen_chan_click( ).
    gen_canc_click( ).
    gen_rfsh_click( ).
    gen_addr_click( ).
    gen_inst_click( ).
    gen_delr_click( ).
    gen_upld_click( ).
    gen_upload_data( ).
    gen_check_pk( ).
    gen_verify_data( ).
    gen_save_click( ).
    gen_dele_click( ).

    gen_double_click( ).
    gen_context_request( ).
    gen_context_select( ).
    gen_node_expand( ).

    gen_data_changed( ).
    gen_field_changed( ).
    gen_field_f4( ).
    gen_field_hotspot_click( ).
    gen_save_data( ).

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
    DATA ls_fcat TYPE ztbrd00021.
    DATA lv_tabname TYPE tabname.
    IF it_fcat IS INITIAL.
      CLEAR lt_code.
      mo_lib->get_itab( EXPORTING iv_alv_key = iv_itabalias iv_tabnm = iv_tabname
                        RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ELSE.
      CONCATENATE ms_name-g_type '_' iv_itabalias INTO lv_tabname.
      _set3 `TYPES : BEGIN OF ` lv_tabname `,`.
      CLEAR lt_code.
      mo_lib->get_struct_line( EXPORTING it_fcat = it_fcat
                               RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.

      _set3 `        END OF ` lv_tabname `.`.
      CLEAR lt_code.
      mo_lib->get_itab( EXPORTING iv_alv_key = iv_itabalias iv_tabnm = lv_tabname
                             RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.

  ENDMETHOD.


  METHOD set_define_itab_tree.
    DATA lt_code TYPE stringtab.
    DATA ls_fcat TYPE ztbrd00021.
    DATA lv_tabname TYPE tabname.
    IF it_fcat IS INITIAL.
      CLEAR lt_code.
      mo_lib->get_tree_itab( EXPORTING iv_alv_key = ms_acg_config_header-alv_key iv_tabnm = ms_acg_config_header-tabname
                        RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ELSE.
      CONCATENATE ms_name-g_type '_' ms_acg_config_header-alv_key INTO lv_tabname.
      _set3 `TYPES : BEGIN OF ` lv_tabname `,`.
      CLEAR lt_code.
      mo_lib->get_struct_line( EXPORTING it_fcat = mt_alv_fcat
                               RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.

      _set3 `        END OF ` lv_tabname `.`.
      CLEAR lt_code.
      mo_lib->get_tree_itab( EXPORTING iv_alv_key = ms_acg_config_header-alv_key iv_tabnm = lv_tabname
                             RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
