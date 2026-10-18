*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
class ZCL_BRD_ACG_MULTI definition
  public
  final
  create public .

public section.

  types:
    gty_src         TYPE TABLE OF string .
  types:
    gty_fcat TYPE TABLE OF ztbrd00020 .
  types:
    gty_config TYPE TABLE OF ztbrd00010 .
  types:
    BEGIN OF gts_tab_list,
        no       TYPE sy-tabix,
        tabnm    TYPE tabname,
        alv_key  TYPE char10,
        fcat_key TYPE char10,
      END OF gts_tab_list .
  types:
    gty_tab_list TYPE TABLE OF gts_tab_list .

  methods CONSTRUCTOR
    importing
      !IT_TAB_LIST type GTY_TAB_LIST
      !IT_ALV_FCAT type ZYBRD00020
      !IT_ALV_CONFIG type ZYBRD00010
      !IS_ACG_CONFIG type ZSBRD00140 .
  methods GET_100_SRC
    exporting
      !ET_SRC type GTY_SRC .
  methods GET_F01_SRC
    exporting
      !ET_SRC type GTY_SRC .
  methods GET_MAIN_SRC
    exporting
      value(ET_SRC) type GTY_SRC .
  methods GET_TOP_SRC
    exporting
      !ET_SRC type GTY_SRC .
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
  data MT_TAB_LIST type GTY_TAB_LIST .
  data MS_TAB_LIST type GTS_TAB_LIST .
  data MT_CM_FCAT type GTY_FCAT .
  data MV_EXCEL_TOTAL_UPLOAD type CHAR01 .
  data MO_LIB type ref to ZCL_BRD_ACG_LIBRARY .
  data MT_CONFIG type GTY_CONFIG .
  data MS_FCAT type ZTBRD00020 .
  data MS_ACG_CONFIG type ZSBRD00140 .
  data MT_FCAT_ALL type GTY_FCAT .

  methods SET_COMMON_FCAT
    importing
      !IT_FCAT type ZYBRD00020 .
  methods GEN_INST_CLICK .
  methods GEN_SET_SELECT_OPTION .
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
  methods GEN_GET_SELECTED_TAB .
  methods GEN_INITIALIZATION .
  methods GEN_REPORT_HEADER .
  methods GEN_RFSH_CLICK .
  methods GEN_SAVE_CLICK .
  methods GEN_SCR_1000 .
  methods GEN_SELECTION_SCREEN .
  methods GEN_SET_ALV .
  methods GEN_SET_INIT_VALUE .
  methods GEN_SET_SCREEN .
  methods GEN_SET_SELECTED_TAB .
  methods GEN_SET_TITLE .
  methods GEN_SET_TOOLBAR .
  methods GEN_START_OF_SELECTION .
  methods GEN_UPLD_CLICK .
  methods GEN_UPLOAD_DATA .
  methods GEN_VARIABLE .
  methods GEN_VERIFY_DATA .
  methods GET_CONFIG
    importing
      !IV_ALV_KEY type CHAR10
    exporting
      !ES_CONFIG type ZTBRD00010 .
  methods GET_FCAT
    importing
      !IV_ALV_KEY type CHAR10
      !IV_FCAT_KEY type CHAR10
    exporting
      !ET_FCAT type GTY_FCAT .
  methods SET_DEFINE_ITAB
    importing
      !IT_FCAT type GTY_FCAT
      !IV_ITABALIAS type CHAR10
      !IV_TABNAME type TABNAME .
  methods GEN_USER_COMMAND .
  methods GEN_SAVE_DATA .
ENDCLASS.



CLASS ZCL_BRD_ACG_MULTI IMPLEMENTATION.


  METHOD constructor.
    MOVE-CORRESPONDING is_acg_config TO ms_acg_config.

*    CLEAR ms_acg_config-is_1step.

    mt_tab_list = it_tab_list.

    READ TABLE it_alv_config TRANSPORTING NO FIELDS WITH KEY zexcel = abap_false.
    IF sy-dbcnt EQ 0.
      mv_excel_total_upload = 'X'.
    ELSE.
      mv_excel_total_upload = ' '.
    ENDIF.

    MOVE-CORRESPONDING it_alv_config[]  TO mt_config[].
    MOVE-CORRESPONDING it_alv_fcat[] TO mt_fcat_all[].
    SORT mt_fcat_all BY alv_key col_pos.

    set_common_fcat( mt_fcat_all ).

    IF ms_acg_config-is_new EQ abap_true.
      mo_lib = NEW zcl_brd_acg_library_n( is_acg_config = ms_acg_config ).
    ELSE.
      mo_lib = NEW zcl_brd_acg_library( is_acg_config = ms_acg_config ).
    ENDIF.
    MOVE-CORRESPONDING mo_lib->ms_name TO ms_name.
  ENDMETHOD.


  METHOD gen_addr_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).

      CLEAR lt_code.
      mo_lib->get_addr_click( EXPORTING iv_alv_key = ms_config-alv_key
                              RECEIVING rt_code = lt_code ).
      IF ms_config-zcreate NE 'X'.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_canc_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).
      CLEAR lt_code.
      mo_lib->get_canc_click( EXPORTING iv_alv_key = ms_config-alv_key
                              RECEIVING rt_code = lt_code  ).
      IF ms_config-zexcel EQ 'X' OR ms_config-zcreate EQ 'X' OR ms_config-zupdate EQ 'X'.
      ELSE.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_chan_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).

      CLEAR lt_code.
      mo_lib->get_chan_click( EXPORTING iv_alv_key = ms_config-alv_key
                              RECEIVING rt_code = lt_code ).
      IF ms_config-zupdate NE 'X'.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_check_authority.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_check_authority( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_check_pk.
    DATA lv_itabname(30).
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).
      CLEAR lt_code.
      get_fcat( EXPORTING iv_alv_key = ms_tab_list-alv_key
                          iv_fcat_key = ms_tab_list-fcat_key
                IMPORTING et_fcat = mt_fcat ).
      mo_lib->get_check_pk( EXPORTING iv_alv_key = ms_config-alv_key
                                      iv_tabnm = ms_tab_list-tabnm
                                      it_fcat = mt_cm_fcat
                            RECEIVING rt_code = lt_code ).
      IF ms_config-zexcel EQ 'X' OR ms_config-zcreate EQ 'X' OR ms_config-zupdate EQ 'X'.
      ELSE.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_create_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).

      CLEAR lt_code.
      mo_lib->get_create_click( EXPORTING iv_alv_key = ms_config-alv_key
                                RECEIVING rt_code = lt_code ).
      IF ms_config-zcreate NE 'X'.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_data_changed.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).

      CLEAR lt_code.
      get_fcat( EXPORTING iv_alv_key = ms_tab_list-alv_key
                          iv_fcat_key = ms_tab_list-fcat_key
                IMPORTING et_fcat = mt_fcat ).
      mo_lib->get_data_changed( EXPORTING iv_alv_key = ms_config-alv_key
                                          it_fcat = mt_fcat
                                RECEIVING rt_code = lt_code ).
      IF ms_config-zupdate NE 'X'.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.

    ENDLOOP.
  ENDMETHOD.


  METHOD gen_dele_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).

      CLEAR lt_code.
      mo_lib->get_dele_click( EXPORTING iv_alv_key = ms_config-alv_key
                                        iv_tabnm = ms_tab_list-tabnm
                              RECEIVING rt_code = lt_code ).
      IF ms_config-zdelete NE 'X'.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_delr_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).
      CLEAR lt_code.
      mo_lib->get_delr_click( EXPORTING iv_alv_key = ms_config-alv_key
                              RECEIVING rt_code = lt_code ).
      IF ms_config-zexcel EQ 'X' OR ms_config-zcreate EQ 'X' OR ms_config-zupdate EQ 'X'.
      ELSE.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_double_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).


      CLEAR lt_code.
      mo_lib->get_double_click( EXPORTING iv_alv_key = ms_config-alv_key
                                RECEIVING rt_code = lt_code ).
      IF ms_config-db_click NE 'X'.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.

    ENDLOOP.
  ENDMETHOD.


  METHOD gen_end_of_selection.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_end_of_selection( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_exit_screen.
    DATA lv_tabix TYPE string.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&     MODULE  EXIT_SCREEN  INPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE EXIT_SCREEN INPUT.`.
    _set3 `  CASE ` ms_name-g_data `_OKCODE.`.
    _set5 `    WHEN ` ms_name-g_constants `_CANC OR ` ms_name-g_constants `_BACK.`.
    _set3 `      CASE ` ms_name-g_obj `_TABSTRIP-ACTIVETAB.`.
    LOOP AT mt_tab_list INTO ms_tab_list.
      lv_tabix = sy-tabix.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key  IMPORTING es_config = ms_config ).
      _set3 `        WHEN '` ms_tab_list-alv_key `'.`.
      _set5 `          CASE ` ms_name-g_obj `_` ms_tab_list-alv_key `->GET_ALV_MODE( ) .`.
      _set3 `            WHEN ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE.`.
      _set1 `              LEAVE TO SCREEN 0.`.
      IF ms_config-zexcel EQ 'X'.
        _set3 `            WHEN ` ms_acg_config-alv_class `=>MC_UPLOAD_MODE.`.
        _set1 `              LEAVE TO SCREEN 0.`.
      ENDIF.
      IF ms_config-zcreate EQ 'X'.
        _set3 `            WHEN ` ms_acg_config-alv_class `=>MC_CREATE_MODE.`.
        _set3 `              PERFORM ` ms_tab_list-alv_key `_CANC_CLICK.`.
      ENDIF.
      IF ms_config-zupdate EQ 'X'.
        _set3 `            WHEN ` ms_acg_config-alv_class `=>MC_CHANGE_MODE.`.
        _set3 `              PERFORM ` ms_tab_list-alv_key `_CANC_CLICK.`.
      ENDIF.
      _set1 `          ENDCASE.`.
    ENDLOOP.
    _set1 `      ENDCASE.`.
    _set3 `    WHEN ` ms_name-g_constants `_EXIT.`.
    _set1 `      LEAVE TO SCREEN 0.`.
    _set1 `  ENDCASE.`.
    _set3 `  CLEAR ` ms_name-g_data `_OKCODE.`.
    _set1 `ENDMODULE.`.




  ENDMETHOD.


  METHOD gen_field_changed.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).
      get_fcat( EXPORTING iv_alv_key = ms_tab_list-alv_key
                            iv_fcat_key = ms_tab_list-fcat_key
                  IMPORTING et_fcat = mt_fcat ).
      CLEAR lt_code.
      mo_lib->get_field_changed( EXPORTING iv_alv_key = ms_config-alv_key
                                           it_fcat = mt_fcat
                                 RECEIVING rt_code = lt_code ).
      IF ms_config-zexcel EQ 'X' OR ms_config-zcreate EQ 'X' OR ms_config-zupdate EQ 'X'.
      ELSE.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_field_f4.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_fcat( EXPORTING iv_alv_key = ms_tab_list-alv_key
                          iv_fcat_key = ms_tab_list-fcat_key
                IMPORTING et_fcat = mt_fcat ).
      CLEAR lt_code.
      mo_lib->get_field_f4( EXPORTING iv_alv_key = ms_tab_list-alv_key
                                      it_fcat = mt_fcat
                            RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_field_hotspot_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_fcat( EXPORTING iv_alv_key = ms_tab_list-alv_key
                            iv_fcat_key = ms_tab_list-fcat_key
                  IMPORTING et_fcat = mt_fcat ).
      CLEAR lt_code.
      mo_lib->get_field_hotspot_click( EXPORTING iv_alv_key = ms_tab_list-alv_key
                                                 it_fcat = mt_fcat
                                       RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_getdata.

    DATA lt_code TYPE stringtab.
    DATA lt_fcat TYPE gty_fcat.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      FORM  GET_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `FORM GET_DATA .`.
    LOOP AT mt_tab_list INTO ms_tab_list.
      _set3 `PERFORM GET_` ms_tab_list-alv_key `_DATA.`.
    ENDLOOP.
    _set1 `ENDFORM.                    "GET_DATA`.



    LOOP AT mt_tab_list INTO ms_tab_list.

      CLEAR lt_code.
      lt_fcat = mt_fcat_all.
      DELETE lt_fcat WHERE alv_key NE ms_tab_list-alv_key.
      mo_lib->get_getdata( EXPORTING iv_alv_key = ms_tab_list-alv_key
                                     it_fcat = lt_fcat
                                     iv_tabnm = ms_tab_list-tabnm
                           RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.

    ENDLOOP.
  ENDMETHOD.


  METHOD gen_get_selected_tab.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  GET_SELECTED_TAB  INPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE GET_SELECTED_TAB INPUT .`.
    _set5 `  ` ms_name-g_wa `_TAB_LIST-PRESSED_TAB = ` ms_name-g_data `_OKCODE.`.
    _set1 `ENDMODULE.`.



  ENDMETHOD.


  METHOD gen_initialization.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_initialization( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_inst_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).

      CLEAR lt_code.
      mo_lib->get_inst_click( EXPORTING iv_alv_key = ms_config-alv_key
                                RECEIVING rt_code = lt_code ).
      IF ms_config-zcreate NE 'X'.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_report_header.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_report_header( ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_rfsh_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).


      CLEAR lt_code.
      mo_lib->get_rfsh_click( EXPORTING iv_alv_key = ms_config-alv_key
                              RECEIVING rt_code = lt_code ).
      IF ms_config-zrefresh NE 'X'.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.

    ENDLOOP.
  ENDMETHOD.


  METHOD gen_save_click.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).
      CLEAR lt_code.
      mo_lib->get_save_click( EXPORTING iv_alv_key = ms_config-alv_key
                                        iv_tabnm = ms_tab_list-tabnm
                              RECEIVING rt_code = lt_code ).

      IF ms_config-zexcel EQ 'X' OR ms_config-zcreate EQ 'X' OR ms_config-zupdate EQ 'X'.
      ELSE.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD gen_save_data.
    IF ms_acg_config-is_new EQ abap_true.
      DATA lt_code TYPE stringtab.
      DATA : ls_alv_tab TYPE mo_lib->gts_alv_tab,
             lt_alv_tab TYPE mo_lib->gtt_alv_tab.

      LOOP AT mt_tab_list INTO ms_tab_list.
        ls_alv_tab-alv_key = ms_tab_list-alv_key.
        ls_alv_tab-tabnm = ms_tab_list-tabnm.
        APPEND ls_alv_tab TO lt_alv_tab.
        CLEAR ms_tab_list.
      ENDLOOP.

      mo_lib->get_save_data( EXPORTING it_alv_tab = lt_alv_tab
                              RECEIVING rt_code = lt_code ).

      IF ms_config-zexcel EQ 'X'
        OR ms_config-zcreate EQ 'X'
        OR ms_config-zupdate EQ 'X'.
      ELSE.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.


  METHOD gen_scr_1000.

    DATA lt_code TYPE stringtab.
    READ TABLE mt_tab_list INTO ms_tab_list INDEX 1.
    mo_lib->get_scr_1000( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                    iv_tabnm = ms_tab_list-tabnm
                                    iv_zexcel = ' '
                                    it_fcat = mt_cm_fcat
                          RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_selection_screen.


  ENDMETHOD.


  METHOD gen_set_alv.
    DATA lv_tabix TYPE string.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  SET_ALV  OUTPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE SET_ALV OUTPUT.`.
    IF ms_acg_config-is_1step EQ abap_false.
      _set3 `  IF ` ms_name-g_obj `_DOCKING_CONTAINER IS INITIAL.`.
      _set3 `  CREATE OBJECT ` ms_name-g_obj `_DOCKING_CONTAINER`.
      _set1 `    EXPORTING`.
      _set3 `      SIDE      = ` ms_name-g_obj `_DOCKING_CONTAINER->DOCK_AT_TOP`.
      _set1 `      EXTENSION = 50.`.
      _set1 ``.
      _set3 `  CREATE OBJECT ` ms_name-g_obj `_DOCUMENT.`.
      _set1 ``.
      _set1 `  PERFORM SET_TITLE.`.
      _set1 ``.
      _set5 `  ` ms_name-g_obj `_DOCUMENT->DISPLAY_DOCUMENT( PARENT = ` ms_name-g_obj `_DOCKING_CONTAINER ).`.
      _set1 ``.
      _set1 `  ENDIF.`.
    ENDIF.
    LOOP AT mt_tab_list INTO ms_tab_list.
      lv_tabix = sy-tabix.
      CONDENSE lv_tabix NO-GAPS.
      _set5 ` IF ` ms_name-g_obj `_CUSTOM_CONTAINER_` ms_tab_list-alv_key ` IS INITIAL.`.
      _set4 `  CREATE OBJECT ` ms_name-g_obj `_CUSTOM_CONTAINER_` ms_tab_list-alv_key.
      _set1 `    EXPORTING`.
      _set3 `      CONTAINER_NAME = 'CON_` ms_tab_list-alv_key `'`.
      _set1 `      REPID          = SY-REPID`.
      _set1 `      DYNNR          = SY-DYNNR .`.
      _set1 ``.
      _set4 `  CREATE OBJECT ` ms_name-g_obj `_` ms_tab_list-alv_key.
      _set1 `    EXPORTING`.
      _set4 `      IO_PARENT = ` ms_name-g_obj `_CUSTOM_CONTAINER_` ms_tab_list-alv_key .
      IF ms_tab_list-alv_key <> 'BALV'.
        _set3 `      IV_ALV_KEY = '` ms_tab_list-alv_key `'`.
      ENDIF.
      IF ms_tab_list-fcat_key <> 'DEFAULT'.
        _set3 `      IV_FCAT_KEY = '` ms_tab_list-fcat_key `'`.
      ENDIF.
      _set1 `      .`.
      _add4 `  ` ms_name-g_obj `_` ms_tab_list-alv_key.
      _add5 `->DISPLAY( CHANGING CT_DATA = ` ms_name-g_itab `_` ms_tab_list-alv_key `[] ).`.
      _append.
      _set1 ` ELSE.`.
      _set5 `    ` ms_name-g_obj `_` ms_tab_list-alv_key `->REFRESH( ).`.
      _set1 `  ENDIF.`.
    ENDLOOP.

    _set1 `ENDMODULE.`.
  ENDMETHOD.


  METHOD gen_set_init_value.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA ls_fcat LIKE LINE OF mt_cm_fcat.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      FORM  SET_INIT_VALUE`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `FORM SET_INIT_VALUE .`.
    _add1 `  _INIT : `.
    LOOP AT mt_tab_list INTO ms_tab_list.
      IF sy-tabix NE 1.
        _add1 `, `.
      ENDIF.
      _add3 ms_name-g_itab `_` ms_tab_list-alv_key .
    ENDLOOP.
    _add1 `.`.
    _append.
    IF ms_acg_config-is_1step EQ abap_false.
      _set1 `  TEXT009 = 'Select Options'.`.

      DATA lt_fcat TYPE  gty_fcat.

      lt_fcat[] = mt_cm_fcat[].
      SORT lt_fcat BY fieldname.
      DELETE ADJACENT DUPLICATES FROM lt_fcat COMPARING fieldname.
      SORT lt_fcat BY alv_key fcat_key col_pos.

      LOOP AT lt_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'.
        ADD 1 TO lv_cnt.
        _set5 `  TEXT0` lv_cnt ` = '` ls_fcat-reptext `'.`.
      ENDLOOP.
      _set1 ``.
    ENDIF.
    _set3 `  ` ms_name-g_wa `_TAB_LIST-PROG = SY-REPID.`.

    _set1 `ENDFORM.                    " SET_INIT_VALUE`.

  ENDMETHOD.


  METHOD gen_set_screen.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_screen( ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_selected_tab.
    DATA lv_tabix TYPE n LENGTH 2.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  SET_SELECTED_TAB  OUTPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE SET_SELECTED_TAB OUTPUT.`.
    _set5 `  ` ms_name-g_obj `_TABSTRIP-ACTIVETAB = ` ms_name-g_wa `_TAB_LIST-PRESSED_TAB.`.
    _set3 `  CASE ` ms_name-g_wa `_TAB_LIST-PRESSED_TAB.`.
    LOOP AT mt_tab_list INTO ms_tab_list.
      lv_tabix = sy-tabix.
*      IF sy-tabix > 9.
      _set3 `    WHEN '` ms_tab_list-alv_key  `'.`.
      _set5 `      ` ms_name-g_wa `_TAB_LIST-SUBSCREEN = '01` lv_tabix `'.`.
*      ELSE.
*        _set3 `    WHEN 'AB` lv_tabix  `'.`.
*        _set5 `      ` ms_name-g_wa `_TAB_LIST-SUBSCREEN = '010` lv_tabix `'.`.
*      ENDIF.
    ENDLOOP.
    _set1 `    WHEN OTHERS.`.
    _set1 `  ENDCASE.`.
    _set1 `ENDMODULE.`.
  ENDMETHOD.


  METHOD gen_set_select_option.
    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_select_option( EXPORTING it_fcat = mt_fcat ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_set_title.

    DATA lt_code TYPE stringtab.
    lt_code = mo_lib->get_set_title( mt_cm_fcat ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_set_toolbar.
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).
      CLEAR lt_code.
      mo_lib->get_set_toolbar( EXPORTING iv_alv_key = ms_config-alv_key
                               RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.

  ENDMETHOD.


  METHOD gen_start_of_selection.

    CHECK ms_acg_config-is_1step EQ abap_false.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*& START-OF-SELECTION.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `START-OF-SELECTION.`.
    _set1 `  PERFORM CHECK_AUTHORITY.`.
    _set1 `  PERFORM GET_DATA.`.

  ENDMETHOD.


  METHOD gen_upld_click.

    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).

      CLEAR lt_code.
      mo_lib->get_upload_click_form( EXPORTING iv_alv_key = ms_config-alv_key
                                     RECEIVING rt_code = lt_code ).
      IF ms_config-zexcel NE 'X'.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.

    ENDLOOP.
  ENDMETHOD.


  METHOD gen_upload_data.

    DATA lt_code TYPE stringtab.

    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).

      CLEAR lt_code.
      mo_lib->get_upload_data_form( EXPORTING iv_alv_key = ms_config-alv_key
                                    RECEIVING rt_code = lt_code ).
      IF ms_config-zexcel NE 'X'.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.

  ENDMETHOD.


  METHOD gen_user_command.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lt_fcat TYPE gty_fcat.

    mo_lib->delete_dup_fcat( EXPORTING it_fcat = mt_fcat_all
                             IMPORTING et_fcat = lt_fcat ).

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      Module  USER_COMMAND  INPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       text`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE USER_COMMAND INPUT.`.
    _set3 `  CASE ` ms_name-g_data `_OKCODE.`.
    READ TABLE mt_config INTO ms_config INDEX 1.

    IF ms_config-zcreate EQ abap_true
       OR ms_config-zupdate EQ abap_true
       OR ms_config-zdelete EQ abap_true.
      _set3 `    WHEN ` ms_name-g_constants `_UCOMM-SAVE.`.
      _set1 `      PERFORM SAVE_DATA.`.
    ELSE.
      _set3 `*    WHEN ` ms_name-g_constants `_UCOMM-SAVE.`.
      _set1 `*      PERFORM SAVE_DATA.`.
    ENDIF.
    LOOP AT mt_tab_list INTO ms_tab_list.
      _set3 `    WHEN '` ms_tab_list-alv_key `'.`.
      _set1 `      GS_TAB_LIST-PRESSED_TAB = GV_OKCODE.`.
    ENDLOOP.
    IF ms_acg_config-is_1step EQ abap_true.
      _set1 `    WHEN C_UCOMM-ENTER. "Forced PBO Excute`.
      _set1 `    WHEN C_UCOMM-EXCUTE.`.
      _set1 `      PERFORM GET_DATA.`.

      LOOP AT lt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE zkey EQ abap_true AND tech EQ abap_false.

        ADD 1 TO  lv_cnt.
        _set3 `    WHEN 'FC_` <ls_fcat>-fieldname `'.`.
        _add2 `      _SET_RANGE_EXTENSION ` <ls_fcat>-fieldname.
        _add7  ` '` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `' TEXT-T` lv_cnt `.`.
        _append.
      ENDLOOP.
      LOOP AT lt_fcat ASSIGNING <ls_fcat> WHERE zkey EQ abap_false AND tech EQ abap_false.
        ADD 1 TO  lv_cnt.
        _set3 `*    WHEN 'FC_` <ls_fcat>-fieldname `'.`.
        _add2 `*      _SET_RANGE_EXTENSION ` <ls_fcat>-fieldname.
        _add7  ` '` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `' TEXT-T` lv_cnt `.`.
        _append.
      ENDLOOP.
    ENDIF.


    _set1 `  ENDCASE.`.
    _set1 `  CLEAR GV_OKCODE.`.
    _set1 `ENDMODULE.`.

  ENDMETHOD.


  METHOD gen_variable.
    DATA : lt_code        TYPE stringtab,
           lv_default_tab TYPE string.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&  INCLUDE           ` ms_acg_config-progid  `TOP`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 ``.
    _add1 `TABLES : `.
    CLEAR ms_tab_list.
    LOOP AT mt_tab_list INTO ms_tab_list.
      IF sy-tabix NE 1.
        _add1 `, `.
      ELSE.
        lv_default_tab = ms_tab_list-alv_key.
      ENDIF.
      _add1  ms_tab_list-tabnm .
      CLEAR ms_tab_list.
    ENDLOOP.
    _add1 `.`.
    _append.
    _set1 ``.
    _set3 `CONTROLS ` ms_name-g_obj `_tabstrip TYPE TABSTRIP.`.
    _set3 `DATA : BEGIN OF ` ms_name-g_wa `_tab_list,`.
    _set1 `         subscreen   LIKE sy-dynnr,`.
    _set1 `         prog        LIKE sy-repid,`.
    _set3 `         pressed_tab LIKE sy-ucomm VALUE '` lv_default_tab `',`.
    _set3 `       END OF ` ms_name-g_wa `_tab_list.`.

    LOOP AT mt_tab_list INTO ms_tab_list.
      _set5 `DATA ` ms_name-g_obj `_custom_container_` ms_tab_list-alv_key ` TYPE REF TO cl_gui_custom_container.`.

      get_fcat( EXPORTING iv_alv_key = ms_tab_list-alv_key
                          iv_fcat_key = ms_tab_list-fcat_key
                IMPORTING et_fcat = mt_fcat ).

      mo_lib->get_global_variable( EXPORTING iv_alv_key = ms_tab_list-alv_key
                                             it_fcat = mt_fcat
                                   RECEIVING rt_code = lt_code           ).
      APPEND LINES OF lt_code TO mt_code.

      set_define_itab( EXPORTING it_fcat = mt_fcat
                                 iv_tabname = ms_tab_list-tabnm
                                 iv_itabalias = ms_tab_list-alv_key ).

    ENDLOOP.
    mo_lib->get_1step_screen_variable( EXPORTING it_fcat = mt_fcat_all
                                       RECEIVING rt_code = lt_code  ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_verify_data.
    DATA lv_itabname(30).
    DATA lt_code TYPE stringtab.
    LOOP AT mt_tab_list INTO ms_tab_list.
      get_config( EXPORTING iv_alv_key = ms_tab_list-alv_key
                  IMPORTING es_config = ms_config ).
      get_fcat( EXPORTING iv_alv_key = ms_tab_list-alv_key
                            iv_fcat_key = ms_tab_list-fcat_key
                  IMPORTING et_fcat = mt_fcat ).
      CLEAR lt_code.
      mo_lib->get_verify_data( EXPORTING iv_alv_key = ms_config-alv_key
                                         it_fcat = mt_fcat
                               RECEIVING rt_code = lt_code ).
      IF ms_config-zexcel EQ 'X' OR ms_config-zcreate EQ 'X' OR ms_config-zupdate EQ 'X'.
      ELSE.
        mo_lib->set_annotation( CHANGING ct_code = lt_code ).
      ENDIF.
      APPEND LINES OF lt_code TO mt_code.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_100_attr.
    DATA lt_fcat TYPE gty_fcat.
    DATA lt_containers TYPE dycatt_tab.
    DATA lt_fields  TYPE dyfatc_tab.
    DATA lv_line TYPE n LENGTH 3 VALUE '001'.

    IF ms_acg_config-is_1step EQ abap_true.
      lv_line = '008'.
    ENDIF.

    "Screen
    et_container = VALUE #( ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
                              length = '000' height = '000' loop_block = '000' loop_disp = '000'
                              c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
                            ( type = 'STRIP_CTRL' name = 'GO_TABSTRIP' line = lv_line column = '002'
                              length = '250' height = '190' loop_block = '000' loop_disp = '000'
                              c_line_min = '010' c_coln_min = '010' tc_fixcol = '000'
                              c_resize_v = 'X' c_resize_h = 'X' )
                            ( type = 'SUBSCREEN' name = 'SUBSCR_100' element_of = 'GO_TABSTRIP' line = lv_line + 2 column = '003'
                              length = '248' height = '187' loop_block = '000' loop_disp = '000'
                              c_line_min = '003' c_coln_min = '003' tc_fixcol = '000'
                              c_resize_v = 'X' c_resize_h = 'X'
                              c_scroll_v = 'X' c_scroll_h = 'X' ) ).

    "OK Code
    et_fields = VALUE #( ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
                           text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
                           height = '001' input_fld = 'X' format = 'CHAR'  ) ).

    mo_lib->delete_dup_fcat( EXPORTING it_fcat = mt_fcat_all
                             IMPORTING et_fcat = lt_fcat ).

    IF ms_acg_config-is_1step EQ abap_true.
      "Search Button
      APPEND VALUE #( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'PUSH' name = 'SEARCH'
                      text = 'Search' line = '006' column = '245' length = '006' vislength = '006'
                      height = '001' push_fcode = 'EXEC' format = 'CHAR' requ_entry = 'N' ) TO et_fields.
      "Frame
      APPEND VALUE #( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'FRAME' name = ms_acg_config-alv_key && '_BOX'
                      text = 'Select Options' line = '001' column = '001' length = '252' vislength = '252'
                      height = '007' format = 'CHAR' requ_entry = 'N' )  TO et_fields.

      mo_lib->get_screen_fields( EXPORTING it_fcat = lt_fcat
                                 IMPORTING et_fields = lt_fields ).
      APPEND LINES OF lt_fields TO et_fields.

    ENDIF.

    "Sub Screen
    DATA lv_column TYPE n LENGTH 3.
    LOOP AT mt_config ASSIGNING FIELD-SYMBOL(<ls_config>).
      ADD 1 TO lv_column.
      APPEND VALUE #( cont_type = 'STRIP_CTRL' cont_name = 'GO_TABSTRIP' type = 'PUSH' name = <ls_config>-alv_key
                      text = <ls_config>-alv_key line = '001' column = lv_column length = '008' vislength = '004'
                      height = '001' push_fcode = <ls_config>-alv_key input_fld = 'X' format = 'CHAR' requ_entry = 'N' ref_field = 'SUBSCR_100' )
                      TO et_fields.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_100_src.
    DATA lv_tabix TYPE string.
    CLEAR mt_code.
    _set1 `*---------------------------------------------------------------------*`.
    _set1 `* SCREEN 100`.
    _set1 `*---------------------------------------------------------------------*`.
    _set1 `PROCESS BEFORE OUTPUT.`.
    _set1 `  MODULE SET_SELECTED_TAB.`.
    _set1 `  CALL SUBSCREEN SUBSCR_100`.
    _set5 `         INCLUDING ` ms_name-g_wa `_TAB_LIST-PROG ` ms_name-g_wa `_TAB_LIST-SUBSCREEN.`.
    _set1 `  MODULE SET_SCREEN.`.
    _set1 `  MODULE SET_ALV .`.
    _set1 ``.
    _set1 `PROCESS AFTER INPUT.`.
    _set1 `  CALL SUBSCREEN SUBSCR_100.`.
    _set1 `  MODULE EXIT_SCREEN AT EXIT-COMMAND.`.
    _set1 `  MODULE USER_COMMAND.`.

    et_src = mt_code.
  ENDMETHOD.


  METHOD get_config.

    CLEAR es_config.
    READ TABLE mt_config INTO es_config WITH KEY alv_key = iv_alv_key.
*    SELECT SINGLE * INTO es_config
*      FROM ztBRD00010
*      WHERE progid = mv_progid
*        AND alv_key = iv_alv_key.
  ENDMETHOD.


  METHOD get_f01_src.
    CLEAR mt_code.
    mt_code = mo_lib->get_f01_header( ).

    gen_set_screen( ).
    gen_set_selected_tab( ).
*    gen_get_selected_tab( ).
    gen_set_alv( ).
    gen_exit_screen( ).
    gen_user_command( ).
    gen_set_select_option( ).
    gen_set_init_value( ).
    gen_check_authority( ).
    gen_getdata( ).
    gen_upload_data( ).
    gen_set_title( ).
    gen_set_toolbar( ).

    gen_check_pk( ).
    gen_verify_data( ).
    gen_create_click( ).
    gen_chan_click( ).
    gen_canc_click( ).
    gen_rfsh_click( ).
    gen_addr_click( ).
    gen_inst_click( ).
    gen_delr_click( ).
    gen_upld_click( ).

    gen_save_click( ).
    gen_dele_click( ).

    gen_double_click( ).
    gen_data_changed( ).
    gen_field_changed( ).
    gen_field_f4( ).
    gen_field_hotspot_click( ).
    gen_save_data( ).
    et_src = mt_code.
  ENDMETHOD.


  METHOD get_fcat.

    CLEAR : ms_fcat, et_fcat.
    LOOP AT mt_fcat_all INTO ms_fcat WHERE alv_key = iv_alv_key AND fcat_key = iv_fcat_key.
      APPEND ms_fcat TO et_fcat.
      CLEAR ms_fcat.
    ENDLOOP.
*    SELECT * INTO TABLE et_fcat
*    FROM ztBRD00020
*    WHERE progid = mv_progid
*      AND alv_key = iv_alv_key
*      AND fcat_key = iv_fcat_key
*       AND fieldname NE 'BALV_STATUS_ICON'
*      AND fieldname NE 'MANDT'.

    SORT et_fcat BY col_pos.

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


  METHOD set_common_fcat.
    TYPES : BEGIN OF ts_cm_check,
              fieldname TYPE fieldname,
              cnt       TYPE i,
            END OF ts_cm_check.
    DATA : ls_cm_check TYPE ts_cm_check,
           lt_cm_check TYPE TABLE OF ts_cm_check.

    LOOP AT it_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>).
      CLEAR ls_cm_check.
      ls_cm_check-fieldname = <ls_fcat>-fieldname.
      ls_cm_check-cnt = 1.
      COLLECT ls_cm_check INTO lt_cm_check.
    ENDLOOP.

    DELETE lt_cm_check WHERE fieldname EQ 'MANDT'.
    DELETE lt_cm_check WHERE fieldname EQ 'BALV_STATUS_ICON'.
    DELETE lt_cm_check WHERE cnt < lines( mt_tab_list ).

    LOOP AT lt_cm_check INTO ls_cm_check.
      LOOP AT it_fcat ASSIGNING <ls_fcat> WHERE fieldname = ls_cm_check-fieldname.
        APPEND <ls_fcat> TO mt_cm_fcat.
      ENDLOOP.
      CLEAR ls_cm_check.
    ENDLOOP.
    SORT mt_cm_fcat BY alv_key col_pos.


  ENDMETHOD.


  METHOD set_define_itab.
    DATA lv_len TYPE string.
    DATA lv_dec TYPE string.
    DATA ls_fcat TYPE LINE OF gty_fcat.
    DATA lt_code TYPE stringtab.
    DATA lv_tabname TYPE tabname.
    IF it_fcat IS INITIAL.
      CLEAR lt_code.
      mo_lib->get_itab( EXPORTING iv_alv_key = iv_itabalias
                                  iv_tabnm = iv_tabname
                        RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ELSE.
      _set5 `TYPES : BEGIN OF ` ms_name-g_type `_` iv_itabalias `,`.

      CLEAR lt_code.
      mo_lib->get_struct_line( EXPORTING it_fcat = it_fcat
                               RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.


      _set5 `        END OF ` ms_name-g_type `_` iv_itabalias `.`.
      CLEAR lt_code.
      CONCATENATE ms_name-g_type '_' iv_itabalias INTO lv_tabname.
      mo_lib->get_itab( EXPORTING iv_alv_key = iv_itabalias
                                  iv_tabnm = lv_tabname
                        RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
