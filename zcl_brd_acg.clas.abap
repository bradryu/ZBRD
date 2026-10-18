*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
class ZCL_BRD_ACG definition
  public
  final
  create public .

public section.

  types:
    gty_src         TYPE TABLE OF string .
  types:
    gty_fcat TYPE TABLE OF ztbrd00020 .

  methods CONSTRUCTOR
    importing
      !IS_ALV_CONFIG type ZTBRD00010
      !IT_ALV_FCAT type ZYBRD00020
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
protected section.

  data MS_NAME type ZTBRD00120 .
private section.

  data MS_CONFIG type ZTBRD00010 .
  data MT_CODE type STRINGTAB .
  data MV_CODE type STRING .
  data MT_FCAT type GTY_FCAT .
  data MO_LIB type ref to ZCL_BRD_ACG_LIBRARY .
  data MS_ACG_CONFIG type ZSBRD00140 .

  methods GEN_GET_CURSOR .
  methods GEN_SET_ALV_CBO_CONFIG .
  methods GEN_SET_CURSOR .
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
      !IT_FCAT type GTY_FCAT .
  methods GEN_INST_CLICK .
  methods GEN_USER_COMMAND .
  methods GEN_SAVE_DATA .
ENDCLASS.



CLASS ZCL_BRD_ACG IMPLEMENTATION.


  METHOD constructor.

    MOVE-CORRESPONDING is_acg_config TO ms_acg_config.
    MOVE-CORRESPONDING is_alv_config TO ms_config.
    MOVE-CORRESPONDING it_alv_fcat[] TO mt_fcat[].

    SORT mt_fcat BY col_pos.
    IF is_acg_config-is_new EQ abap_true.
      mo_lib = NEW zcl_brd_acg_library_n( is_acg_config = ms_acg_config ).
    ELSE.
      mo_lib = NEW zcl_brd_acg_library( is_acg_config = ms_acg_config ).
    ENDIF.
    MOVE-CORRESPONDING mo_lib->ms_name TO ms_name.
  ENDMETHOD.


  METHOD gen_addr_click.

    DATA : lt_code TYPE stringtab.

    mo_lib->get_addr_click( EXPORTING iv_alv_key = ms_acg_config-alv_key RECEIVING rt_code = lt_code ).

    IF ms_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.


    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_canc_click.
    DATA lt_code TYPE stringtab.


    mo_lib->get_canc_click( EXPORTING iv_alv_key = ms_acg_config-alv_key RECEIVING rt_code = lt_code ).
    IF ms_config-zexcel EQ 'X'
    OR ms_config-zcreate EQ 'X'
    OR ms_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).

    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_chan_click.

    DATA lt_code TYPE stringtab.

    mo_lib->get_chan_click( EXPORTING iv_alv_key = ms_acg_config-alv_key RECEIVING rt_code = lt_code ).

    IF ms_config-zupdate NE 'X'.
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

    mo_lib->get_check_pk( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                iv_tabnm = ms_acg_config-tabname
                                it_fcat = mt_fcat
                     RECEIVING rt_code = lt_code ).
    IF ms_config-zexcel EQ 'X'
    OR ms_config-zcreate EQ 'X'
    OR ms_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_create_click.

    DATA lt_code TYPE stringtab.

    mo_lib->get_create_click( EXPORTING iv_alv_key = ms_acg_config-alv_key RECEIVING rt_code = lt_code ).
    IF ms_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_data_changed.

    DATA lt_code TYPE stringtab.

    mo_lib->get_data_changed( EXPORTING iv_alv_key = ms_acg_config-alv_key it_fcat = mt_fcat RECEIVING rt_code = lt_code ).

    IF ms_config-zupdate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_dele_click.

    DATA lt_code TYPE stringtab.

    mo_lib->get_dele_click( EXPORTING iv_alv_key = ms_acg_config-alv_key iv_tabnm = ms_acg_config-tabname
                            RECEIVING rt_code = lt_code ).
    IF ms_config-zdelete NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_delr_click.

    DATA lt_code TYPE stringtab.

    mo_lib->get_delr_click( EXPORTING iv_alv_key = ms_acg_config-alv_key RECEIVING rt_code = lt_code ).

    IF ms_config-zexcel EQ 'X'
    OR ms_config-zcreate EQ 'X'
    OR ms_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_double_click.

    DATA lt_code TYPE stringtab.

    mo_lib->get_double_click( EXPORTING iv_alv_key = ms_acg_config-alv_key RECEIVING rt_code = lt_code ).

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
    IF ms_config-zcreate EQ 'X'.
      _set3 `        WHEN ` ms_acg_config-alv_class `=>MC_CREATE_MODE.`.
      _set3 `          PERFORM ` ms_acg_config-alv_key `_CANC_CLICK.`.
    ELSE.
      _set3 `*        WHEN ` ms_acg_config-alv_class `=>MC_CREATE_MODE.`.
      _set3 `*          PERFORM ` ms_acg_config-alv_key `_CANC_CLICK.`.
    ENDIF.
    IF ms_config-zupdate EQ 'X'.
      _set3 `        WHEN ` ms_acg_config-alv_class `=>MC_CHANGE_MODE.`.
      _set3 `          PERFORM ` ms_acg_config-alv_key `_CANC_CLICK.`.
    ELSE.
      _set3 `*        WHEN ` ms_acg_config-alv_class `=>MC_CHANGE_MODE.`.
      _set3 `*          PERFORM ` ms_acg_config-alv_key `_CANC_CLICK.`.
    ENDIF.
    _set1 `      ENDCASE.`.
    _set1 `    WHEN C_EXIT.`.
    _set1 `      LEAVE TO SCREEN 0.`.
    _set1 `  ENDCASE.`.
    _set3 `  CLEAR ` ms_name-g_data `_OKCODE.`.
    _set1 `ENDMODULE.                 " EXIT_SCREEN  INPUT`.

  ENDMETHOD.


  METHOD gen_field_changed.
    DATA lt_code TYPE stringtab.

    mo_lib->get_field_changed( EXPORTING iv_alv_key = ms_acg_config-alv_key it_fcat = mt_fcat
                               RECEIVING rt_code = lt_code ).

    IF ms_config-zexcel EQ 'X'
        OR ms_config-zcreate EQ 'X'
        OR ms_config-zupdate EQ 'X'.
    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
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

    DATA lt_code TYPE stringtab.
    mo_lib->get_getdata( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                   it_fcat = mt_fcat
                                   iv_tabnm = ms_acg_config-tabname
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


  METHOD gen_inst_click.

    DATA lt_code TYPE stringtab.

    mo_lib->get_inst_click( EXPORTING iv_alv_key = ms_acg_config-alv_key RECEIVING rt_code = lt_code ).

    IF ms_config-zcreate NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

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


  METHOD gen_save_click.
    DATA lt_code TYPE stringtab.


    mo_lib->get_save_click( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                      iv_tabnm = ms_acg_config-tabname
                            RECEIVING rt_code = lt_code ).
    IF ms_config-zexcel EQ 'X'
      OR ms_config-zcreate EQ 'X'
      OR ms_config-zupdate EQ 'X'.

    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_save_data.
    IF ms_acg_config-is_new EQ abap_true.

      DATA lt_code TYPE stringtab.
      DATA : ls_alv_tab TYPE mo_lib->gts_alv_tab,
             lt_alv_tab TYPE mo_lib->gtt_alv_tab.

      ls_alv_tab-alv_key = ms_acg_config-alv_key.
      ls_alv_tab-tabnm = ms_acg_config-tabname.
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
    ENDIF.
  ENDMETHOD.


  METHOD gen_scr_1000.
    DATA lt_code TYPE stringtab.
    mo_lib->get_scr_1000( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                    iv_tabnm = ms_acg_config-tabname
                                    iv_zexcel = ms_config-zexcel
                                    it_fcat = mt_fcat
                          RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_selection_screen.
    DATA lt_code TYPE stringtab.
    mo_lib->get_selection_screen( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                            iv_fcat_key = ms_acg_config-fcat_key
                                            iv_excel_upload = ms_config-zexcel
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


  METHOD gen_set_alv_cbo_config.
    DATA : lt_code     TYPE stringtab.

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
    lt_code = mo_lib->get_layout_code( EXPORTING is_layout_cbo = ms_config ).
    APPEND LINES OF lt_code TO mt_code.
    _set1 ` `.
    _set1 `* ALV Fieldcatalog`.
    _set3 `CLEAR ` ms_name-l_wa `_FCAT_CBO.`.
    _set5 `` ms_name-l_wa `_FCAT_CBO-PROGID = '` ms_config-progid `'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-ALV_KEY = 'BALV'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-FCAT_KEY = 'DEFAULT'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-COL_POS = '1'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-FIELDNAME = 'BALV_STATUS_ICON'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-ZKEY = 'X'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-ICON = 'X'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-OUTPUTLEN = '000004'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-JUST = 'C'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-EMPHASIZE = 'K41'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-DATATYPE = 'CHAR'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-INTTYPE = 'C'.`.
    _set3 `` ms_name-l_wa `_FCAT_CBO-INTLEN = '000004'.`.
    _set5 `APPEND ` ms_name-l_wa `_FCAT_CBO TO ` ms_name-g_itab `_FIELDCAT_CBO.`.
    LOOP AT mt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>).
      CLEAR lt_code.
      lt_code = mo_lib->get_fcat_code( EXPORTING is_fcat = <ls_fcat> ).
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
                                          iv_excel_upload = ms_config-zexcel
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
                           RECEIVING rt_code = lt_code  ).
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
                                              iv_excel_upload = ms_config-zexcel
                                    RECEIVING rt_code = lt_code ).
    APPEND LINES OF lt_code TO mt_code.
  ENDMETHOD.


  METHOD gen_upld_click.


    DATA lt_code TYPE stringtab.

    mo_lib->get_upload_click_form( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                   RECEIVING rt_code = lt_code ).
    IF ms_config-zexcel NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
    APPEND LINES OF lt_code TO mt_code.

  ENDMETHOD.


  METHOD gen_upload_data.

    DATA lt_code TYPE stringtab.

    mo_lib->get_upload_data_form( EXPORTING iv_alv_key = ms_acg_config-alv_key
                                  RECEIVING rt_code = lt_code ).
    IF ms_config-zexcel NE 'X'.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.

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
    _set3 `TABLES : ` ms_acg_config-tabname `.`.
    _set1 ``.
    DATA lv_container TYPE seoclsname.
    IF ms_acg_config-is_1step EQ abap_true.
      lv_container = 'CL_GUI_CUSTOM_CONTAINER'.
    ENDIF.
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


  METHOD gen_verify_data.
    DATA lt_code TYPE stringtab.

    mo_lib->get_verify_data( EXPORTING iv_alv_key = ms_acg_config-alv_key it_fcat = mt_fcat
                               RECEIVING rt_code = lt_code ).
    IF ms_config-zexcel EQ 'X'
      OR ms_config-zcreate EQ 'X'
      OR ms_config-zupdate EQ 'X'.

    ELSE.
      mo_lib->set_annotation( CHANGING ct_code = lt_code ).
    ENDIF.
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
    gen_set_alv_cbo_config( ).
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
    DATA ls_fcat TYPE ztbrd00020.
    DATA lt_code TYPE stringtab.
    DATA lv_tabname TYPE tabname.
    IF it_fcat IS INITIAL.
      CLEAR lt_code.
      mo_lib->get_itab( EXPORTING iv_alv_key = ms_acg_config-alv_key iv_tabnm = ms_acg_config-tabname
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


      mo_lib->get_itab( EXPORTING iv_alv_key = ms_acg_config-alv_key iv_tabnm = lv_tabname
                        RECEIVING rt_code = lt_code ).
      APPEND LINES OF lt_code TO mt_code.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
