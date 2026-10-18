*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
class ZCL_BRD_ACG_TREE definition
  public
  create public .

public section.

  types:
    gty_src         TYPE TABLE OF string .
  types:
    gty_fcat TYPE TABLE OF ztbrd00021 .
  types:
    gty_alv_fcat TYPE TABLE OF ztbrd00020 .

  methods CONSTRUCTOR
    importing
      !IS_ALV_CONFIG type ZTBRD00011
      !IT_ALV_FCAT type ZYBRD00021
      !IS_ACG_CONFIG type ZSBRD00140 .
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

  data MS_CONFIG type ZTBRD00011 .
  data MT_CODE type GTY_SRC .
  data MV_CODE type STRING .
  data MT_FCAT type GTY_FCAT .
  data MV_NODE_ID_FIELD type FIELDNAME .
  data MV_PARENTS_NODE_ID_FIELD type FIELDNAME .
  data MV_SORT_FIELD type FIELDNAME .
  data MV_NODE_TEXT_FIELD type FIELDNAME .
  data MS_FCAT type ZTBRD00021 .
  data MO_LIB type ref to ZCL_BRD_ACG_LIBRARY .
  data MT_ALV_FCAT type GTY_ALV_FCAT .
  data MS_ACG_CONFIG type ZSBRD00140 .

  methods GEN_SET_SELECT_OPTION .
  methods GEN_SET_CURSOR .
  methods GEN_SET_ALV_CBO_CONFIG .
  methods GEN_GET_CURSOR .
  methods GEN_SET_TITLE .
  methods GEN_SCR_1000 .
  methods GEN_NODE_EXPAND .
  methods GEN_CHECK_AUTHORITY .
  methods GEN_CONTEXT_REQUEST .
  methods GEN_CONTEXT_SELECT .
  methods GEN_DOUBLE_CLICK .
  methods GEN_END_OF_SELECTION .
  methods GEN_EXIT_SCREEN .
  methods GEN_GETDATA .
  methods GEN_INITIALIZATION .
  methods GEN_REPORT_HEADER .
  methods GEN_SET_ALV .
  methods GEN_SET_INIT_VALUE .
  methods GEN_SET_SCREEN .
  methods GEN_START_OF_SELECTION .
  methods GEN_USER_COMMAND .
  methods GEN_VARIABLE .
  methods SET_DEFINE_ITAB
    importing
      !IV_ITABNAME type CHAR30
      !IT_FCAT type GTY_ALV_FCAT .
ENDCLASS.



CLASS ZCL_BRD_ACG_TREE IMPLEMENTATION.


  METHOD constructor.
    DATA ls_alv_fcat TYPE LINE OF gty_alv_fcat.

    MOVE-CORRESPONDING is_acg_config TO ms_acg_config.
    MOVE-CORRESPONDING is_alv_config TO ms_config.
    MOVE-CORRESPONDING it_alv_fcat[] TO mt_fcat[].

*    CLEAR ms_acg_config-is_1step.

    READ TABLE mt_fcat INTO ms_fcat WITH KEY node = 'X'.
    IF sy-subrc EQ 0.
      mv_node_id_field = ms_fcat-fieldname.
    ENDIF.
    READ TABLE mt_fcat INTO ms_fcat WITH KEY parents_node = 'X'.
    IF sy-subrc EQ 0.
      mv_parents_node_id_field = ms_fcat-fieldname.
    ENDIF.
    READ TABLE mt_fcat INTO ms_fcat WITH KEY sortidx = 'X'.
    IF sy-subrc EQ 0.
      mv_sort_field = ms_fcat-fieldname.
    ENDIF.
    READ TABLE mt_fcat INTO ms_fcat WITH KEY node_txt = 'X'.
    IF sy-subrc EQ 0.
      mv_node_text_field = ms_fcat-fieldname.
    ENDIF.

    SORT mt_fcat BY col_pos.

    CLEAR : ms_fcat, ls_alv_fcat.
    LOOP AT mt_fcat INTO ms_fcat.
      MOVE-CORRESPONDING ms_fcat TO ls_alv_fcat.
      APPEND ls_alv_fcat TO mt_alv_fcat.
      CLEAR : ms_fcat, ls_alv_fcat.
    ENDLOOP.

*    CREATE OBJECT mo_lib
*      EXPORTING
*        is_acg_config = ms_acg_config.
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


  METHOD gen_context_request.

    DATA lt_code TYPE stringtab.
    mo_lib->get_context_request( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                 RECEIVING rt_code = lt_code ).
    IF ms_config-context_menu NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_context_select.


    DATA lt_code TYPE stringtab.
    mo_lib->get_context_select( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                          iv_node_id_field = mv_node_id_field
                                RECEIVING rt_code = lt_code ).
    IF ms_config-context_menu NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_double_click.

    DATA lt_code TYPE stringtab.

    CLEAR lt_code.
    mo_lib->get_double_click_tree( EXPORTING iv_alv_key = ms_acg_config-alv_key
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
    _set1 `      LEAVE TO SCREEN 0.`.
    _set3 `    WHEN ` ms_name-g_constants `_EXIT.`.
    _set1 `      LEAVE TO SCREEN 0.`.
    _set1 `  ENDCASE.`.
    _set3 `  CLEAR ` ms_name-g_data `_OKCODE.`.
    _set1 `ENDMODULE.                 " EXIT_SCREEN  INPUT`.

  ENDMETHOD.


  METHOD gen_getdata.
    DATA lt_code TYPE stringtab.
    CLEAR lt_code.
    mo_lib->get_getdata_tree( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                        iv_tabnm = ms_acg_config-tabname
                                        it_fcat = mt_alv_fcat
                              RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
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


  METHOD gen_node_expand.
    DATA lt_code TYPE stringtab.
    mo_lib->get_node_expand( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                       iv_tabnm = ms_acg_config-tabname
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


  METHOD gen_scr_1000.
    DATA lt_code TYPE stringtab.

    mo_lib->get_scr_1000( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                    iv_tabnm = ms_acg_config-tabname
                                    it_fcat = mt_alv_fcat
                          RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_alv.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  SET_ALV  OUTPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE SET_ALV OUTPUT.`.
    IF ms_acg_config-is_1step EQ abap_true.
      _set5 `  IF ` ms_name-g_obj `_CONTAINER_` ms_acg_config-alv_key ` IS INITIAL.`.
      _set4 `    CREATE OBJECT ` ms_name-g_obj `_CONTAINER_` ms_acg_config-alv_key .
      _set1 `      EXPORTING`.
      _set3 `        CONTAINER_NAME = 'CON_` ms_acg_config-alv_key `'.`.
      _set1 `  ENDIF.`.
    ELSE.
      _set3 `  IF ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT IS INITIAL.`.
      _set3 `    CREATE OBJECT ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT`.
      _set1 `      EXPORTING`.
      _set1 `        PARENT  = CL_GUI_CONTAINER=>DEFAULT_SCREEN`.
      _set1 `        ROWS    = 2`.
      _set1 `        COLUMNS = 1 .`.
      _set5 `    ` ms_name-g_obj `_CONTAINER_TITLE = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).`.
      _set7 `    ` ms_name-g_obj `_CONTAINER_` ms_acg_config-alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).`.
      _set3 `    ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->SET_ROW_HEIGHT( ID = 1 HEIGHT = 20 ).`.
      _set3 `    CREATE OBJECT ` ms_name-g_obj `_DOCUMENT.`.
      _set1 ``.
      _set1 `    PERFORM SET_TITLE.`.
      _set1 ``.
      _set5 `    ` ms_name-g_obj `_DOCUMENT->DISPLAY_DOCUMENT( PARENT = ` ms_name-g_obj `_CONTAINER_TITLE ).`.
      _set1 `  ENDIF.`.
      _set1 ``.
    ENDIF.
    IF ms_acg_config-is_standalone EQ abap_true.
      _set1 `  PERFORM SET_ALV_CBO_CONFIG.`.
    ENDIF.
    _set5 `  IF ` ms_name-g_obj `_` ms_acg_config-alv_key ` IS INITIAL.`.
    _set4 `    CREATE OBJECT ` ms_name-g_obj `_` ms_acg_config-alv_key.
    _set1 `      EXPORTING`.
    _set4 `        IO_PARENT = ` ms_name-g_obj `_CONTAINER_` ms_acg_config-alv_key .
    IF ms_acg_config-is_standalone EQ abap_true.
      _set3 `        IS_LAYOUT_CBO = ` ms_name-g_wa `_LAYOUT_CBO`.
    ENDIF.
    IF ms_acg_config-alv_key <> 'BALV'.
      _set3 `        IV_ALV_KEY = '` ms_acg_config-alv_key `'`.
    ENDIF.
    IF ms_acg_config-fcat_key <> 'DEFAULT'.
      _set3 `        IV_ALV_KEY = '` ms_acg_config-fcat_key `'`.
    ENDIF.
    _set1 `.`.
    _set1 ``.
    IF ms_acg_config-fcat_key <> 'DEFAULT'.
      _set7 `    ` ms_name-g_obj `_` ms_acg_config-alv_key `->DISPLAY( EXPORTING ms_acg_config-FCAT_key = '` ms_acg_config-fcat_key `'`.
      IF ms_acg_config-is_standalone EQ abap_true.
        _set3 `                                          IS_LAYOUT_CBO = ` ms_name-g_wa `_LAYOUT_CBO`.
      ENDIF.
      _set5 `                                CHANGING CT_DATA = ` ms_name-g_itab `_` ms_acg_config-alv_key `[] ).`.
    ELSE.
      IF ms_acg_config-is_standalone EQ abap_true.
        _set7 `    ` ms_name-g_obj `_` ms_acg_config-alv_key `->DISPLAY( EXPORTING IT_FIELDCAT_CBO = ` ms_name-g_itab `_FIELDCAT_CBO`.
        _set5 `                                CHANGING CT_DATA = ` ms_name-g_itab `_` ms_acg_config-alv_key `[] ).`.
      ELSE.
        _add4 `    ` ms_name-g_obj `_` ms_acg_config-alv_key.
        _add5 `->DISPLAY( CHANGING CT_DATA = ` ms_name-g_itab `_` ms_acg_config-alv_key `[] ).`.
        _append.
      ENDIF.

    ENDIF.


    _set1 `  ELSE.`.
    _set3 `    IF ` ms_name-g_data `_TREE_RELOAD = ABAP_TRUE.`.
    _add5 `      ` ms_name-g_obj `_` ms_acg_config-alv_key `->RELOAD( CHANGING CT_DATA = `.
    _add4 ms_name-g_itab `_` ms_acg_config-alv_key `[] ).`.
    _append.
    _set1 `    ELSE.`.
    _set5 `    ` ms_name-g_obj `_` ms_acg_config-alv_key `->REFRESH( ).`.
    _set1 `    ENDIF.`.
    _set3 `    CLEAR ` ms_name-g_data `_TREE_RELOAD.`.

    _set1 `  ENDIF.`.

    _set1 `ENDMODULE.`.


  ENDMETHOD.


  METHOD gen_set_alv_cbo_config.
    DATA : lt_code     TYPE stringtab,
           lt_code_pre TYPE stringtab.

    CHECK ms_acg_config-is_standalone EQ abap_true.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*& Form SET_ALV_CBO_CONFIG`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*& text`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*& -->  p1        text`.
    _set1 `*& <--  p2        text`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `FORM SET_ALV_CBO_CONFIG .`.
    _set5 `  DATA ` ms_name-l_wa `_FCAT_CBO TYPE ` ms_acg_config-alv_class `=>TS_FCAT_CONFIG.`.
    _set3 `  CLEAR ` ms_name-g_itab `_FIELDCAT_CBO[].`.
    _set1 ` `.

    _set1 `* ALV Layout`.
    lt_code_pre = mt_code.
    lt_code = mo_lib->get_tree_layout_code( EXPORTING is_layout_cbo = ms_config ).
    CLEAR mt_code.
    APPEND LINES OF lt_code_pre TO mt_code.
    APPEND LINES OF lt_code TO mt_code.
    _set1 ` `.
    _set1 `* ALV Fieldcatalog`.

    LOOP AT mt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>).
      CLEAR lt_code_pre.
      lt_code_pre = mt_code.
      CLEAR lt_code.
      lt_code = mo_lib->get_tree_fcat_code( EXPORTING is_fcat = <ls_fcat> ).
      CLEAR mt_code.
      APPEND LINES OF lt_code_pre TO mt_code.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.


    _set1 `ENDFORM.`.

  ENDMETHOD.


  METHOD gen_set_cursor.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_cursor( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_init_value.
    DATA lt_code TYPE stringtab.
    mo_lib->get_set_init_value( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                          iv_excel_upload = abap_false
                                          it_fcat = mt_alv_fcat
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
    mo_lib->get_set_title( EXPORTING it_fcat = mt_alv_fcat
                           RECEIVING rt_code = lt_code  ).
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
    _set7 `        ` ms_name-g_obj `_` ms_acg_config-alv_key `->GET_LINE( EXPORTING I_NODE_KEY = ` ms_name-g_data `_OPERATING_NODE_KEY`.
    _set5 `                           CHANGING C_OUTTAB_LINE = ` ms_name-g_wa `_` ms_acg_config-alv_key ` ).`.
    _set1 `      ENDIF.`.
    IF ms_acg_config-is_1step EQ abap_true.
      _set1 `    WHEN C_UCOMM-ENTER. "Forced PBO Excute`.
      _set1 `    WHEN C_UCOMM-EXCUTE.`.
      _set3 `      PERFORM GET_` ms_acg_config-alv_key `_DATA.`.
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
    DATA lv_tabnm TYPE char30.
    DATA lt_code TYPE stringtab.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&  INCLUDE           ` ms_acg_config-progid  `TOP`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 ``.
    _set3 `TABLES : ` ms_acg_config-tabname `.`.
    _set1 ``.

    mo_lib->get_global_variable( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                           it_fcat = mt_alv_fcat
                                 RECEIVING rt_code = lt_code           ).
    APPEND LINES OF lt_code TO mt_code.
    _set3 `CONSTANTS : ` ms_name-g_constants `_DB_CLICK      TYPE SY-UCOMM VALUE 'DBCLK'.`.
    _set3 `DATA : ` ms_name-g_data `_OPERATING_NODE_KEY TYPE LVC_NKEY,`.
    _set3 `       ` ms_name-g_data `_TREE_RELOAD TYPE FLAG.`.

    CONCATENATE  ms_name-g_itab '_' ms_acg_config-alv_key INTO lv_tabnm.

    set_define_itab( EXPORTING it_fcat = mt_alv_fcat
                               iv_itabname = lv_tabnm ).

    mo_lib->get_1step_screen_variable( EXPORTING it_fcat = mt_alv_fcat
                                       RECEIVING rt_code = lt_code  ).
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
    gen_double_click( ).
    gen_context_request( ).
    gen_context_select( ).
    gen_node_expand( ).
    gen_set_alv_cbo_config( ).
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
      mo_lib->get_tree_itab( EXPORTING iv_alv_key = ms_acg_config-alv_key iv_tabnm = ms_acg_config-tabname
                        RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ELSE.
      CONCATENATE ms_name-g_type '_' ms_acg_config-alv_key INTO lv_tabname.
      _set3 `TYPES : BEGIN OF ` lv_tabname `,`.
      CLEAR lt_code.
      mo_lib->get_struct_line( EXPORTING it_fcat = it_fcat
                               RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.

      _set3 `        END OF ` lv_tabname `.`.
      CLEAR lt_code.
      mo_lib->get_tree_itab( EXPORTING iv_alv_key = ms_acg_config-alv_key iv_tabnm = lv_tabname
                             RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
