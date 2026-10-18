*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
class ZCL_BRD_ACG_TREE_GRID definition
  public
  create public .

public section.

  types:
    gty_src         TYPE TABLE OF string .
  types:
    gty_fcat TYPE TABLE OF ztbrd00020 .
  types:
    gty_fcat_tree TYPE TABLE OF ztbrd00021 .
  types:
    gty_alv_fcat TYPE TABLE OF ztbrd00020 .

  methods CONSTRUCTOR
    importing
      !IS_ALV_CONFIG type ZTBRD00010
      !IT_ALV_FCAT type ZYBRD00020
      !IS_TALV_CONFIG type ZTBRD00011
      !IT_TALV_FCAT type ZYBRD00021
      !IS_ACG_CONFIG_TREE type ZSBRD00140
      !IS_ACG_CONFIG_GRID type ZSBRD00140 .
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
  data MV_NODE_ID_FIELD type FIELDNAME .
  data MV_PARENTS_NODE_ID_FIELD type FIELDNAME .
  data MV_SORT_FIELD type FIELDNAME .
  data MV_NODE_TEXT_FIELD type FIELDNAME .
  data MS_FCAT type ZTBRD00020 .
  data MS_CONFIG_TREE type ZTBRD00011 .
  data MT_FCAT_TREE type GTY_FCAT_TREE .
  data MS_FCAT_TREE type ZTBRD00021 .
  data MO_LIB type ref to ZCL_BRD_ACG_LIBRARY .
  data MT_ALV_FCAT type GTY_ALV_FCAT .
  data MS_ACG_CONFIG_TREE type ZSBRD00140 .
  data MS_ACG_CONFIG_GRID type ZSBRD00140 .

  methods GEN_SAVE_DATA .
  methods GEN_NODE_EXPAND .
  methods GEN_ADDR_CLICK .
  methods GEN_CANC_CLICK .
  methods GEN_CHAN_CLICK .
  methods GEN_CHECK_AUTHORITY .
  methods GEN_CHECK_PK .
  methods GEN_CONTEXT_REQUEST .
  methods GEN_CONTEXT_SELECT .
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
  methods GEN_USER_COMMAND .
  methods GEN_VARIABLE .
  methods GEN_VERIFY_DATA .
  methods SET_DEFINE_ITAB
    importing
      !IT_FCAT type GTY_FCAT
      !IV_ITABNAME type CHAR30 .
  methods SET_DEFINE_ITAB_TREE
    importing
      !IT_FCAT type GTY_FCAT_TREE
      !IV_ITABNAME type CHAR30 .
  methods SET_DEFINE_SELECT_SCREEN
    importing
      !IT_FCAT type GTY_FCAT
      !IV_TABNAME type TABNAME .
ENDCLASS.



CLASS ZCL_BRD_ACG_TREE_GRID IMPLEMENTATION.


  METHOD constructor.

    MOVE-CORRESPONDING is_acg_config_tree TO ms_acg_config_tree.
    MOVE-CORRESPONDING is_acg_config_grid TO ms_acg_config_grid.

    MOVE-CORRESPONDING is_alv_config TO ms_config.
    MOVE-CORRESPONDING it_alv_fcat[] TO mt_fcat[].

    MOVE-CORRESPONDING is_talv_config TO ms_config_tree.
    MOVE-CORRESPONDING it_talv_fcat[] TO mt_fcat_tree[].


    CLEAR : ms_acg_config_tree-is_1step, ms_acg_config_grid-is_1step.

    READ TABLE mt_fcat_tree INTO ms_fcat_tree WITH KEY node = 'X'.
    IF sy-subrc EQ 0.
      mv_node_id_field = ms_fcat_tree-fieldname.
    ENDIF.
    READ TABLE mt_fcat_tree INTO ms_fcat_tree WITH KEY parents_node = 'X'.
    IF sy-subrc EQ 0.
      mv_parents_node_id_field = ms_fcat_tree-fieldname.
    ENDIF.
    READ TABLE mt_fcat_tree INTO ms_fcat_tree WITH KEY sortidx = 'X'.
    IF sy-subrc EQ 0.
      mv_sort_field = ms_fcat_tree-fieldname.
    ENDIF.
    READ TABLE mt_fcat_tree INTO ms_fcat_tree WITH KEY node_txt = 'X'.
    IF sy-subrc EQ 0.
      mv_node_text_field = ms_fcat_tree-fieldname.
    ENDIF.

    SORT mt_fcat BY col_pos.
    SORT mt_fcat_tree BY col_pos.


    CLEAR : ms_fcat_tree, ms_fcat.
    LOOP AT mt_fcat_tree INTO ms_fcat_tree.
      MOVE-CORRESPONDING ms_fcat_tree TO ms_fcat.
      APPEND ms_fcat TO mt_alv_fcat.
      CLEAR : ms_fcat_tree, ms_fcat.
    ENDLOOP.

    SORT mt_fcat BY col_pos.
    IF ms_acg_config_tree-is_new EQ abap_true.
      mo_lib = NEW zcl_brd_acg_library_n( is_acg_config = ms_acg_config_tree ).
    ELSE.
      mo_lib = NEW zcl_brd_acg_library( is_acg_config = ms_acg_config_tree ).
    ENDIF.
    MOVE-CORRESPONDING mo_lib->ms_name TO ms_name.
  ENDMETHOD.


  METHOD gen_addr_click.
    CHECK ms_config-zcreate EQ 'X'.
    DATA lt_code TYPE stringtab.
    mo_lib->get_addr_click( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                            RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_canc_click.
    IF ms_config-zexcel EQ 'X'
    OR ms_config-zcreate EQ 'X'
    OR ms_config-zupdate EQ 'X'.
      DATA lt_code TYPE stringtab.
      mo_lib->get_canc_click( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                              RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.


  METHOD gen_chan_click.
    CHECK ms_config-zupdate EQ 'X'.
    DATA lt_code TYPE stringtab.
    mo_lib->get_chan_click( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                            RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_check_authority.

    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_check_authority( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_check_pk.
    IF ms_config-zexcel EQ 'X'
    OR ms_config-zcreate EQ 'X'
    OR ms_config-zupdate EQ 'X'.
      DATA lt_code TYPE stringtab.
      mo_lib->get_check_pk( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                      iv_tabnm = ms_acg_config_grid-tabname
                                      it_fcat = mt_fcat
                            RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.


  METHOD gen_context_request.
    CHECK ms_config_tree-context_menu EQ 'X'.
    DATA lt_code TYPE stringtab.
    mo_lib->get_context_request( EXPORTING iv_alv_key = ms_acg_config_tree-alv_key
                                 RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_context_select.
    CHECK ms_config_tree-context_menu EQ 'X'.
    DATA lt_code TYPE stringtab.
    mo_lib->get_context_select( EXPORTING iv_alv_key = ms_acg_config_tree-alv_key
                                          iv_node_id_field = mv_node_id_field
                                RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_create_click.
    CHECK ms_config-zcreate EQ 'X'.
    DATA lt_code TYPE stringtab.
    mo_lib->get_create_click( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                              RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_data_changed.
    IF ms_config-zupdate EQ 'X'.
      DATA lt_code TYPE stringtab.
      mo_lib->get_data_changed( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key it_fcat = mt_fcat
                                RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.


  METHOD gen_dele_click.
    CHECK ms_config-zdelete EQ 'X'.
    DATA lt_code TYPE stringtab.
    mo_lib->get_dele_click( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                      iv_tabnm = ms_acg_config_grid-tabname
                            RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_delr_click.
    IF ms_config-zexcel EQ 'X'
    OR ms_config-zcreate EQ 'X'
    OR ms_config-zupdate EQ 'X'.
      DATA lt_code TYPE stringtab.
      mo_lib->get_delr_click( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                              RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.


  METHOD gen_double_click.
    DATA lt_code TYPE stringtab.
    IF ms_config_tree-db_click EQ 'X'.
      CLEAR lt_code.
      mo_lib->get_double_click_tree( EXPORTING iv_alv_key = ms_acg_config_tree-alv_key
                                     RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.

    ENDIF.

    IF ms_config-db_click EQ 'X'.
      CLEAR lt_code.
      mo_lib->get_double_click( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
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
    _set1 `      LEAVE TO SCREEN 0.`.
    _set3 `    WHEN ` ms_name-g_constants `_EXIT.`.
    _set1 `      LEAVE TO SCREEN 0.`.
    _set1 `  ENDCASE.`.
    _set3 `  CLEAR ` ms_name-g_data `_OKCODE.`.
    _set1 `ENDMODULE.                 " EXIT_SCREEN  INPUT`.

  ENDMETHOD.


  METHOD gen_field_changed.
    IF ms_config-zexcel EQ 'X'
        OR ms_config-zcreate EQ 'X'
        OR ms_config-zupdate EQ 'X'.

      DATA lt_code TYPE stringtab.
      mo_lib->get_field_changed( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                           it_fcat = mt_fcat
                                 RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.


  METHOD gen_field_f4.

    DATA lt_code TYPE stringtab.
    mo_lib->get_field_f4( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                    it_fcat = mt_fcat
                          RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_field_hotspot_click.

    DATA lt_code TYPE stringtab.
    mo_lib->get_field_hotspot_click( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                               it_fcat = mt_fcat
                                     RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_getdata.
    DATA lt_code TYPE stringtab.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      FORM  GET_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `FORM GET_DATA .`.
    _set1 `  CASE 'X'.`.
    _set3 `    WHEN ` ms_name-parameters `_GRID.`.
    _set3 `      PERFORM GET_` ms_acg_config_grid-alv_key `_DATA.`.
    _set3 `    WHEN ` ms_name-parameters `_TREE.`.
    _set3 `      PERFORM GET_` ms_acg_config_tree-alv_key `_DATA.`.
    _set1 `  ENDCASE.`.
    _set1 `ENDFORM.                    "GET_DATA`.
    CLEAR lt_code.
    mo_lib->get_getdata( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                   it_fcat = mt_fcat
                                   iv_tabnm = ms_acg_config_grid-tabname
                         RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
    CLEAR lt_code.
    mo_lib->get_getdata_tree( EXPORTING iv_alv_key = ms_acg_config_tree-alv_key
                                        it_fcat = mt_alv_fcat
                                        iv_tabnm = ms_acg_config_grid-tabname
                              RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_initialization.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_initialization( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_node_expand.
    DATA lt_code TYPE stringtab.
    mo_lib->get_node_expand( EXPORTING iv_alv_key = ms_acg_config_tree-alv_key
                                       iv_tabnm = ms_acg_config_grid-tabname
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
    CHECK ms_config-zrefresh EQ 'X'.

    DATA lt_code TYPE stringtab.
    mo_lib->get_rfsh_click( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                            RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_save_click.
    IF ms_config-zexcel EQ 'X'
      OR ms_config-zcreate EQ 'X'
      OR ms_config-zupdate EQ 'X'.

      DATA lt_code TYPE stringtab.
      mo_lib->get_save_click( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                        iv_tabnm = ms_acg_config_grid-tabname
                              RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.


  METHOD gen_save_data.

    DATA lt_code TYPE stringtab.
    DATA : ls_alv_tab TYPE mo_lib->gts_alv_tab,
           lt_alv_tab TYPE mo_lib->gtt_alv_tab.

    ls_alv_tab-alv_key = ms_acg_config_grid-alv_key.
    ls_alv_tab-tabnm = ms_acg_config_grid-tabname.
    APPEND ls_alv_tab TO lt_alv_tab.


    mo_lib->get_save_data( EXPORTING it_alv_tab = lt_alv_tab
                            RECEIVING rt_code = lt_code ).

    IF ms_config-zexcel EQ 'X'
      OR ms_config-zcreate EQ 'X'
      OR ms_config-zupdate EQ 'X'.

    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_scr_1000.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&  SELECTION SCREEN`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `SELECTION-SCREEN BEGIN OF LINE .`.
    _set3 `PARAMETERS ` ms_name-parameters `_GRID RADIOBUTTON GROUP R1 USER-COMMAND SET  DEFAULT 'X'.`.
    _set3 `SELECTION-SCREEN COMMENT 4(20) TEXT001 FOR FIELD ` ms_name-parameters `_GRID.`.
    _set3 `PARAMETERS ` ms_name-parameters `_TREE RADIOBUTTON GROUP R1.`.
    _set3 `SELECTION-SCREEN COMMENT (20) TEXT002 FOR FIELD ` ms_name-parameters `_TREE.`.
    _set1 `SELECTION-SCREEN END OF LINE.`.
    _set1 `SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT009.`.
    _set1 ``.

    set_define_select_screen( EXPORTING it_fcat = mt_fcat iv_tabname = ms_acg_config_grid-tabname ).

    _set1 `SELECTION-SCREEN END OF BLOCK B1.`.



  ENDMETHOD.


  METHOD gen_selection_screen.

    _set1 `*----------------------------------------------------------------------*`.
    _set1 `*  AT SELECTION-SCREEN OUTPUT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `*AT SELECTION-SCREEN OUTPUT.`.
    _set1 `*  LOOP AT SCREEN .`.
    _set1 `*    CASE ABAP_TRUE.`.
    _set3 `*      WHEN ` ms_name-parameters `_GRID.`.
    _set1 `*        IF SCREEN-GROUP1 = 'GR' .`.
    _set1 `*          SCREEN-INPUT = 1 .`.
    _set1 `*          SCREEN-INVISIBLE = 0 .`.
    _set1 `*        ENDIF .`.
    _set3 `*      WHEN ` ms_name-parameters `_TREE.`.
    _set1 `*        IF SCREEN-GROUP1 = 'GR' .`.
    _set1 `*          SCREEN-INPUT = 0 .`.
    _set1 `*          SCREEN-INVISIBLE = 1.`.
    _set1 `*        ENDIF .`.
    _set1 `*    ENDCASE.`.
    _set1 `*    MODIFY SCREEN .`.
    _set1 `*  ENDLOOP.`.

  ENDMETHOD.


  METHOD gen_set_alv.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  SET_ALV  OUTPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE SET_ALV OUTPUT.`.
    _set1 `  CASE ABAP_TRUE.`.
    _set3 `    WHEN ` ms_name-parameters `_GRID.`.
    _set3 `      IF ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT IS INITIAL.`.
    _set3 `        CREATE OBJECT ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT`.
    _set1 `          EXPORTING`.
    _set1 `            PARENT  = CL_GUI_CONTAINER=>DEFAULT_SCREEN`.
    _set1 `            ROWS    = 2`.
    _set1 `            COLUMNS = 1 .`.
    _set5 `        ` ms_name-g_obj `_CONTAINER_TITLE = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).`.
    _set7 `        ` ms_name-g_obj `_CONTAINER_` ms_acg_config_grid-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).`.
    _set3 `        ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->SET_ROW_HEIGHT( ID = 1 HEIGHT = 20 ).`.
    _set3 `        CREATE OBJECT ` ms_name-g_obj `_DOCUMENT.`.
    _set1 ``.
    _set1 `        PERFORM SET_TITLE.`.
    _set1 ``.
    _set5 `        ` ms_name-g_obj `_DOCUMENT->DISPLAY_DOCUMENT( PARENT = ` ms_name-g_obj `_CONTAINER_TITLE ).`.
    _set1 `      ENDIF.`.
    _set5 `      IF ` ms_name-g_obj `_` ms_acg_config_grid-alv_key ` IS INITIAL.`.
    _set4 `        CREATE OBJECT ` ms_name-g_obj `_` ms_acg_config_grid-alv_key.
    _set1 `          EXPORTING`.
    _set5 `            IO_PARENT = ` ms_name-g_obj `_CONTAINER_` ms_acg_config_grid-alv_key ` `.
    IF ms_acg_config_grid-alv_key <> 'BALV'.
      _set3 `            IV_ALV_KEY = '` ms_acg_config_grid-alv_key `'`.
    ENDIF.
    IF ms_acg_config_grid-fcat_key <> 'DEFAULT'.
      _set3 `            IV_FCAT_KEY = '` ms_acg_config_grid-fcat_key `'`.
    ENDIF.
    _set1 `         .`.
    _set1 ``.
    _add4 `        ` ms_name-g_obj `_` ms_acg_config_grid-alv_key.
    _add5 `->DISPLAY( CHANGING CT_DATA = ` ms_name-g_itab `_` ms_acg_config_grid-alv_key `[] ).`.
    _append.
    _set1 `      ELSE.`.
    _set5 `        ` ms_name-g_obj `_` ms_acg_config_grid-alv_key `->REFRESH( ).`.
    _set1 `      ENDIF.`.
    _set3 `    WHEN ` ms_name-parameters `_TREE.`.
    _set3 `      IF ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT IS INITIAL.`.
    _set3 `        CREATE OBJECT ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT`.
    _set1 `          EXPORTING`.
    _set1 `            PARENT  = CL_GUI_CONTAINER=>DEFAULT_SCREEN`.
    _set1 `            ROWS    = 2`.
    _set1 `            COLUMNS = 1 .`.
    _set5 `        ` ms_name-g_obj `_CONTAINER_TITLE = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).`.
    _set7 `        ` ms_name-g_obj `_CONTAINER_` ms_acg_config_tree-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).`.
    _set3 `        ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->SET_ROW_HEIGHT( ID = 1 HEIGHT = 20 ).`.
    _set3 `        CREATE OBJECT ` ms_name-g_obj `_DOCUMENT.`.
    _set1 ``.
    _set1 `        PERFORM SET_TITLE.`.
    _set1 ``.
    _set5 `        ` ms_name-g_obj `_DOCUMENT->DISPLAY_DOCUMENT( PARENT = ` ms_name-g_obj `_CONTAINER_TITLE ).`.
    _set1 `      ENDIF.`.
    _set5 `      IF ` ms_name-g_obj `_` ms_acg_config_tree-alv_key ` IS INITIAL.`.
    _set4 `        CREATE OBJECT ` ms_name-g_obj `_` ms_acg_config_tree-alv_key.
    _set1 `          EXPORTING`.
    _set5 `            IO_PARENT = ` ms_name-g_obj `_CONTAINER_` ms_acg_config_tree-alv_key ` `.
    IF ms_acg_config_tree-alv_key <> 'TALV'.
      _set3 `            IV_ALV_KEY = '` ms_acg_config_tree-alv_key `'`.
    ENDIF.
    IF ms_acg_config_tree-fcat_key <> 'DEFAULT'.
      _set3 `            IV_FCAT_KEY = '` ms_acg_config_tree-fcat_key `'`.
    ENDIF.
    _set1 `              .`.
    _set1 ``.
    _add4 `        ` ms_name-g_obj `_` ms_acg_config_tree-alv_key.
    _add5 `->DISPLAY( CHANGING CT_DATA = ` ms_name-g_itab `_` ms_acg_config_tree-alv_key `[] ).`.
    _append.
    _set1 `      ELSE.`.
    _set5 `        ` ms_name-g_obj `_` ms_acg_config_tree-alv_key `->REFRESH( ).`.
    _set1 `      ENDIF.`.
    _set1 `    ENDCASE.`.
    _set3 `  CLEAR ` ms_name-g_data `_OKCODE.`.
    _set1 `ENDMODULE.`.

  ENDMETHOD.


  METHOD gen_set_init_value.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA ls_fcat TYPE ztbrd00020.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      FORM  SET_INIT_VALUE`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `FORM SET_INIT_VALUE .`.
    _set5 `  _INIT : ` ms_name-g_itab `_` ms_acg_config_grid-alv_key `, `.
    _set4  ms_name-g_itab `_` ms_acg_config_tree-alv_key `.`.
    IF ms_config-zexcel EQ 'X'.
      _set1 `  TEXT001 = 'Grid View'.`.
      _set1 `  TEXT002 = 'Tree View'.`.
    ENDIF.
    _set1 `  TEXT009 = 'Select Options'.`.
    LOOP AT mt_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'..
      ADD 1 TO lv_cnt.
      _set5 `  TEXT0` lv_cnt ` = '` ls_fcat-reptext `'.`.
    ENDLOOP.
    _set1 ``.
    _set1 `ENDFORM.                    " SET_INIT_VALUE`.
  ENDMETHOD.


  METHOD gen_set_screen.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_screen( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_title.

    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_title( mt_fcat ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_set_toolbar.

    DATA lt_code TYPE stringtab.
    mo_lib->get_set_toolbar( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                             RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_start_of_selection.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*& START-OF-SELECTION.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `START-OF-SELECTION.`.
    _set1 `  PERFORM CHECK_AUTHORITY.`.

    _set1 `  PERFORM GET_DATA.`.

  ENDMETHOD.


  METHOD gen_upld_click.
    CHECK ms_config-zexcel EQ 'X'.

    DATA lt_code TYPE stringtab.
    mo_lib->get_upload_click_form( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                   RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_upload_data.
    CHECK ms_config-zexcel EQ 'X'.
    DATA lt_code TYPE stringtab.
    mo_lib->get_upload_data_form( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                  RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_user_command.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  USER_COMMAND  INPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE USER_COMMAND INPUT.`.
    _set3 `  CASE ` ms_name-g_data `_OKCODE.`.
    _set3 `    WHEN ` ms_name-g_constants `_DB_CLICK.`.
    _set3 `      IF ` ms_name-g_data `_OPERATING_NODE_KEY > 0.`.
    _set7 `        ` ms_name-g_obj `_` ms_acg_config_tree-alv_key `->GET_LINE( EXPORTING I_NODE_KEY = ` ms_name-g_data `_OPERATING_NODE_KEY`.
    _set5 `                           CHANGING C_OUTTAB_LINE = ` ms_name-g_wa `_` ms_acg_config_tree-alv_key ` ).`.
    _set1 `      ENDIF.`.
    _set1 `      `.
    _set1 `  ENDCASE.`.
    _set3 `  CLEAR ` ms_name-g_data `_OKCODE.`.
    _set1 `ENDMODULE.                 " USER_COMMAND  INPUT`.
  ENDMETHOD.


  METHOD gen_variable.
    DATA lv_tabname TYPE tabname.
    DATA lt_code TYPE stringtab.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&  INCLUDE           ` ms_acg_config_tree-progid  `TOP`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 ``.
    _set3 `TABLES : ` ms_acg_config_grid-tabname `.`.
    _set1 ``.

    mo_lib->get_global_variable( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                           it_fcat = mt_fcat "alv fcat
                                 RECEIVING rt_code = lt_code           ).
    APPEND LINES OF lt_code TO mt_code.

    CLEAR lt_code.
    mo_lib->get_global_variable( EXPORTING iv_alv_key = ms_acg_config_tree-alv_key
                                           iv_alv_class = ms_acg_config_tree-alv_class
                                           it_fcat = mt_alv_fcat "tree alv fcat converted
                                 RECEIVING rt_code = lt_code           ).
    APPEND LINES OF lt_code TO mt_code.
    _set3 `CONSTANTS : ` ms_name-g_constants `_DB_CLICK      TYPE SY-UCOMM VALUE 'DBCLK'.`.
    _set3 `DATA : ` ms_name-g_data `_OPERATING_NODE_KEY TYPE LVC_NKEY.`.


    CONCATENATE ms_name-g_itab `_` ms_acg_config_grid-alv_key INTO lv_tabname.
    set_define_itab( EXPORTING it_fcat = mt_fcat
                               iv_itabname = lv_tabname ).

    CONCATENATE ms_name-g_itab `_` ms_acg_config_tree-alv_key INTO lv_tabname.
    set_define_itab_tree( EXPORTING it_fcat = mt_fcat_tree " tree alv fcat
                           iv_itabname = lv_tabname ).


  ENDMETHOD.


  METHOD gen_verify_data.
    IF ms_config-zexcel EQ 'X'
      OR ms_config-zcreate EQ 'X'
      OR ms_config-zupdate EQ 'X'.
      DATA lt_code TYPE stringtab.
      mo_lib->get_verify_data( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key
                                         it_fcat = mt_fcat
                               RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.


  METHOD get_100_attr.
    mo_lib->get_screen_100_attr( EXPORTING it_fcat = mt_alv_fcat
                                IMPORTING et_fields = et_fields
                                          et_container = et_container ).
  ENDMETHOD.


  METHOD get_100_src.
    CLEAR mt_code.
    _set1 `PROCESS BEFORE OUTPUT.`.
    _set1 `  MODULE SET_SCREEN.`.
    _set1 `  MODULE SET_ALV.`.
    _set1 ``.
    _set1 `PROCESS AFTER INPUT.`.
    _set1 `  MODULE EXIT_SCREEN AT EXIT-COMMAND.`.
    _set1 `  MODULE USER_COMMAND.`.
    et_src = mt_code.
  ENDMETHOD.


  METHOD get_f01_src.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&  INCLUDE           ` ms_acg_config_tree-progid `F01`.
    _set1 `*&---------------------------------------------------------------------*`.

    gen_set_screen( ).
    gen_set_alv( ).
    gen_exit_screen( ).
    gen_user_command( ).
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
    gen_delr_click( ).
    gen_upld_click( ).
    gen_double_click( ).
    gen_context_request( ).
    gen_context_select( ).
    gen_node_expand( ).
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
    DATA lt_code TYPE stringtab.
    DATA ls_fcat TYPE ztbrd00021.
    DATA lv_tabname TYPE tabname.
    IF it_fcat IS INITIAL.
      CLEAR lt_code.
      mo_lib->get_itab( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key iv_tabnm = ms_acg_config_grid-tabname
                        RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ELSE.
      CONCATENATE ms_name-g_type '_' ms_acg_config_grid-alv_key INTO lv_tabname.
      _set3 `TYPES : BEGIN OF ` lv_tabname `,`.
      CLEAR lt_code.
      mo_lib->get_struct_line( EXPORTING it_fcat = it_fcat
                               RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.

      _set3 `        END OF ` lv_tabname `.`.
      CLEAR lt_code.
      mo_lib->get_itab( EXPORTING iv_alv_key = ms_acg_config_grid-alv_key iv_tabnm = lv_tabname
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
      mo_lib->get_tree_itab( EXPORTING iv_alv_key = ms_acg_config_tree-alv_key iv_tabnm = ms_acg_config_grid-tabname
                        RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ELSE.
      CONCATENATE ms_name-g_type '_' ms_acg_config_tree-alv_key INTO lv_tabname.
      _set3 `TYPES : BEGIN OF ` lv_tabname `,`.
      CLEAR lt_code.
      mo_lib->get_struct_line( EXPORTING it_fcat = mt_alv_fcat
                               RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.

      _set3 `        END OF ` lv_tabname `.`.
      CLEAR lt_code.
      mo_lib->get_tree_itab( EXPORTING iv_alv_key = ms_acg_config_tree-alv_key iv_tabnm = lv_tabname
                             RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.


  METHOD set_define_select_screen.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lt_name TYPE TABLE OF char05.
    DATA lv_str TYPE string.
    DATA ls_fcat TYPE ztbrd00020.
    LOOP AT it_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'.
      ADD 1 TO lv_cnt.
      _set1 `SELECTION-SCREEN BEGIN OF LINE.`.
      _set3 `SELECTION-SCREEN COMMENT (20) TEXT0` lv_cnt ` MODIF ID GR.`.
      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_fcat-fieldname(5).
      IF sy-subrc EQ 0.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(3) lv_cnt INTO lv_str.
      ELSE.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(5) INTO lv_str.
        APPEND ls_fcat-fieldname(5) TO lt_name.
      ENDIF.
      _set7 `SELECT-OPTIONS ` lv_str ` FOR ` ms_acg_config_grid-tabname `-` ls_fcat-fieldname ` MODIF ID GR.`.
      _set1 `SELECTION-SCREEN END OF LINE.`.
    ENDLOOP.
    LOOP AT it_fcat INTO ls_fcat WHERE zkey NE 'X' AND tech NE 'X'.
      ADD 1 TO lv_cnt.
      _set1 `*SELECTION-SCREEN BEGIN OF LINE.`.
      _set3 `*SELECTION-SCREEN COMMENT (20) TEXT0` lv_cnt ` MODIF ID GR.`.
      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_fcat-fieldname(5).
      IF sy-subrc EQ 0.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(3) lv_cnt INTO lv_str.
      ELSE.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(5) INTO lv_str.
        APPEND ls_fcat-fieldname(5) TO lt_name.
      ENDIF.
      _set7 `*SELECT-OPTIONS ` lv_str ` FOR ` ms_acg_config_grid-tabname `-` ls_fcat-fieldname ` MODIF ID GR.`.
      _set1 `*SELECTION-SCREEN END OF LINE.`.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
