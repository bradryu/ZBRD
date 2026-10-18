*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
class ZCL_BRD_ACG_LIBRARY definition
  public
  create public .

public section.

  types:
    BEGIN OF gts_alv_tab,
        alv_key TYPE char10,
        tabnm   TYPE tabname,
      END OF gts_alv_tab .
  types:
    gtt_alv_tab TYPE TABLE OF gts_alv_tab .
  types:
    gtt_src         TYPE TABLE OF string .
  types:
    gtt_fcat TYPE TABLE OF ztbrd00020 .
  types:
    BEGIN OF gty_key_map,
        h_field TYPE fieldname,
        icon    TYPE icon-id,
        i_field TYPE fieldname,
      END OF gty_key_map .
  types:
    gtt_key_map TYPE TABLE OF gty_key_map .

  data MS_NAME type ZTBRD00120 .

  methods GET_USER_COMMAND
    importing
      !IS_ALV_CONFIG type ZTBRD00010
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SET_SELECT_OPTION
    importing
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods CONSTRUCTOR
    importing
      !IS_ACG_CONFIG type ZSBRD00140 .
  methods GET_F01_HEADER
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SCREEN_100
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_ITAB
    importing
      !IV_ALV_KEY type CHAR10
      !IV_TABNM type TABNAME
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_STRUCT_LINE
    importing
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SET_TITLE
    importing
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_UPLOAD_CLICK_FORM
    importing
      !IV_ALV_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_UPLOAD_DATA_FORM
    importing
      !IV_ALV_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_START_OF_SELECTION
    importing
      !IV_ALV_KEY type CHAR10
      !IV_EXCEL_UPLOAD type FLAG optional
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SET_TOOLBAR
    importing
      !IV_ALV_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SET_SCREEN
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SET_INIT_VALUE
    importing
      !IV_ALV_KEY type CHAR10
      !IV_EXCEL_UPLOAD type FLAG optional
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SET_ALV
    importing
      !IV_ALV_KEY type CHAR10
      !IV_FCAT_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SELECTION_SCREEN
    importing
      !IV_EXCEL_UPLOAD type FLAG optional
      !IV_ALV_KEY type CHAR10 optional
      !IV_FCAT_KEY type CHAR10 optional
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SAVE_CLICK
    importing
      !IV_ALV_KEY type CHAR10
      !IV_TABNM type TABNAME
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_ADDR_CLICK
    importing
      !IV_ALV_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_CANC_CLICK
    importing
      !IV_ALV_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_CHAN_CLICK
    importing
      !IV_ALV_KEY type CHAR10
      !IV_PARENT_ALV_KEY type CHAR10 optional
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_CHECK_AUTHORITY
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_CHECK_PK
    importing
      !IV_ALV_KEY type CHAR10
      !IT_FCAT type GTT_FCAT
      !IV_TABNM type TABNAME
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_CREATE_CLICK
    importing
      !IV_ALV_KEY type CHAR10
      !IV_PARENT_ALV_KEY type CHAR10 optional
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_DATA_CHANGED
    importing
      !IV_ALV_KEY type CHAR10
      !IT_FCAT type GTT_FCAT
      !IT_KEY_MAP type GTT_KEY_MAP optional
      !IV_PARENT_ALV_KEY type CHAR10 optional
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_DELE_CLICK
    importing
      !IV_ALV_KEY type CHAR10
      !IV_TABNM type TABNAME
      !IV_ITEM_TABNM type TABNAME optional
      !IT_KEY_MAP type GTT_KEY_MAP optional
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_DELR_CLICK
    importing
      !IV_ALV_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_DOUBLE_CLICK
    importing
      !IV_ALV_KEY type CHAR10
      !IV_ITEM_ALV_KEY type CHAR10 optional
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_END_OF_SELECTION
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_FIELD_CHANGED
    importing
      !IV_ALV_KEY type CHAR10
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_FIELD_F4
    importing
      !IV_ALV_KEY type CHAR10
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_FIELD_HOTSPOT_CLICK
    importing
      !IV_ALV_KEY type CHAR10
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_GETDATA
    importing
      !IV_ALV_KEY type CHAR10
      !IT_FCAT type GTT_FCAT
      !IV_TABNM type TABNAME
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_INITIALIZATION
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_REPORT_HEADER
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_RFSH_CLICK
    importing
      !IV_ALV_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SCR_1000
    importing
      !IV_ALV_KEY type CHAR10
      !IT_FCAT type GTT_FCAT
      !IV_TABNM type TABNAME
      !IV_ZEXCEL type FLAG optional
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_VERIFY_DATA
    importing
      !IV_ALV_KEY type CHAR10
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_CONTEXT_REQUEST
    importing
      !IV_ALV_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_CONTEXT_SELECT
    importing
      !IV_ALV_KEY type CHAR10
      !IV_NODE_ID_FIELD type FIELDNAME
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_DOUBLE_CLICK_TREE
    importing
      !IV_ALV_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_GETDATA_TREE
    importing
      !IV_ALV_KEY type CHAR10
      !IV_TABNM type TABNAME
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SET_TITLE_DOUBLE
    importing
      !IT_FCAT type ZYBRD00020
      !IT_KEY_MAP type GTT_KEY_MAP
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SET_INIT_VALUE_DOUBLE
    importing
      !IV_ALV_KEY type CHAR10
      !IT_FCAT type GTT_FCAT
      !IT_KEY_MAP type GTT_KEY_MAP
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_GLOBAL_VARIABLE
    importing
      !IV_ALV_KEY type CHAR10
      !IT_FCAT type GTT_FCAT
      !IV_ALV_CLASS type SEOCLSNAME optional
      !IV_CONTAINER type SEOCLSNAME default 'CL_GUI_CONTAINER'
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_INST_CLICK
    importing
      !IV_ALV_KEY type CHAR10
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SAVE_DATA
    importing
      !IT_ALV_TAB type GTT_ALV_TAB optional
    returning
      value(RT_CODE) type STRING_TABLE .
  methods SET_ANNOTATION
    changing
      value(CT_CODE) type STRING_TABLE .
  methods GET_NODE_EXPAND
    importing
      !IV_ALV_KEY type CHAR10
      !IV_TABNM type TABNAME
      !IV_NODE_ID_FIELD type FIELDNAME
      !IV_PNODE_ID_FIELD type FIELDNAME
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_TREE_ITAB
    importing
      !IV_ALV_KEY type CHAR10
      !IV_TABNM type TABNAME
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_LAYOUT_CODE
    importing
      !IS_LAYOUT_CBO type ZTBRD00010
      !IV_LAYOUT_NAME type STRING default 'GS_LAYOUT_CBO'
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_FCAT_CODE
    importing
      !IS_FCAT type ZTBRD00020
      !IV_FCAT_NAME type STRING default 'GT_FIELDCAT_CBO'
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_1STEP_SCREEN_VARIABLE
    importing
      !IT_FCAT type GTT_FCAT
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_GET_CURSOR
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SET_CURSOR
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_SCREEN_100_ATTR
    importing
      !IT_FCAT type GTT_FCAT
    exporting
      !ET_FIELDS type DYFATC_TAB
      !ET_CONTAINER type DYCATT_TAB .
  methods GET_WHERE_QUERY_STRING
    importing
      !IV_CNT type N
      !IV_FIELDNAME type FIELDNAME
    returning
      value(RV_STR) type STRING .
  methods DELETE_DUP_FCAT
    importing
      !IT_FCAT type GTT_FCAT
    exporting
      value(ET_FCAT) type GTT_FCAT .
  methods GET_SCREEN_FIELDS
    importing
      !IT_FCAT type GTT_FCAT
    exporting
      !ET_FIELDS type DYFATC_TAB .
  methods GET_TREE_LAYOUT_CODE
    importing
      !IS_LAYOUT_CBO type ZTBRD00011
      !IV_LAYOUT_NAME type STRING default 'GS_LAYOUT_CBO'
    returning
      value(RT_CODE) type STRING_TABLE .
  methods GET_TREE_FCAT_CODE
    importing
      !IS_FCAT type ZTBRD00021
      !IV_FCAT_NAME type STRING default 'GT_FIELDCAT_CBO'
    returning
      value(RT_CODE) type STRING_TABLE .
  PROTECTED SECTION.

    DATA mt_code TYPE string_table .
    DATA mv_code TYPE string .
    DATA ms_acg_config TYPE zsbrd00140 .

    METHODS set_define_select_screen
      IMPORTING
        !it_fcat    TYPE gtt_fcat
        !iv_tabname TYPE tabname .
private section.
ENDCLASS.



CLASS ZCL_BRD_ACG_LIBRARY IMPLEMENTATION.


  METHOD constructor.
    MOVE-CORRESPONDING is_acg_config TO ms_acg_config.

    SELECT SINGLE * INTO ms_name
    FROM ztbrd00120
    WHERE uname = sy-uname.

    IF sy-subrc NE 0.
      SELECT SINGLE * INTO ms_name
      FROM ztbrd00120
      WHERE uname = 'DEFAULT'.
    ENDIF.

  ENDMETHOD.


  METHOD delete_dup_fcat.
    et_fcat[] = it_fcat[].
    SORT et_fcat BY fieldname.
    DELETE ADJACENT DUPLICATES FROM et_fcat COMPARING fieldname.
    SORT et_fcat BY alv_key fcat_key col_pos.
  ENDMETHOD.


  METHOD get_1step_screen_variable.
    CLEAR mt_code.
    CHECK ms_acg_config-is_1step EQ abap_true.


    DATA lt_fcat TYPE gtt_fcat.

    delete_dup_fcat( EXPORTING it_fcat = it_fcat
                     IMPORTING et_fcat = lt_fcat ).

    _set1 `DATA: BEGIN OF GS_SCREEN,`.
    LOOP AT lt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE ref_table IS NOT INITIAL AND tech EQ abap_false.
      _set7 `        ` <ls_fcat>-fieldname `-DATA TYPE RANGE OF ` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `,`.
      _set7 `        ` <ls_fcat>-fieldname `-LOW  TYPE ` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `,`.
      _set7 `        ` <ls_fcat>-fieldname `-HIGH TYPE ` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `,`.
      _set3 `        ` <ls_fcat>-fieldname `      TYPE GS_SCREEN_SELECT_OPTION,`.
    ENDLOOP.
    _set1 `      END OF GS_SCREEN.`.
    _set1 `DATA : BEGIN OF GS_FILTER,`.
    LOOP AT lt_fcat ASSIGNING <ls_fcat> WHERE ref_table IS NOT INITIAL AND tech EQ abap_false.
      _set7 `        ` <ls_fcat>-fieldname ` TYPE RANGE OF ` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `,`.
    ENDLOOP.
    _set1 `       END OF GS_FILTER.`.


    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&  DEFINE`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `DEFINE _set_range_extension.`.
    _set1 `  zcl_brd_util=>set_range_extension( EXPORTING it_range       = REF #( gs_screen-&1-data[] )`.
    _set1 `                                                iv_help_field  = &2`.
    _set1 `                                                iv_ok          = gv_okcode`.
    _set1 `                                                iv_text        = &3`.
    _set1 `                                       CHANGING  cv_ex_icon     = gs_screen-&1-ex`.
    _set1 `                                                 cv_icon        = gs_screen-&1-icon`.
    _set1 `                                                 cv_low         = gs_screen-&1-low`.
    _set1 `                                                 cv_high        = gs_screen-&1-high ).`.
    _set1 `END-OF-DEFINITION.`.
    _set1 `DEFINE _set_range_with_icon.`.
    _set1 `  zcl_brd_util=>set_range_with_icon(`.
    _set1 `    EXPORTING`.
    _set1 `      iv_pbo   = abap_true`.
    _set1 `    CHANGING`.
    _set1 `      ct_range = gs_screen-&1-data[]`.
    _set1 `      cv_low   = gs_screen-&1-low`.
    _set1 `      cv_high  = gs_screen-&1-high`.
    _set1 `      cv_stat  = gs_screen-&1-state`.
    _set1 `      cv_more  = gs_screen-&1-multi ).`.
    _set1 `END-OF-DEFINITION.`.
    _set1 `DEFINE _set_filter.`.
    _set1 `  IF gs_screen-&1-data IS INITIAL.`.
    _set1 `    IF gs_screen-&1-low IS NOT INITIAL.`.
    _set1 `      APPEND VALUE #( sign = c_i`.
    _set1 `                      option = c_eq`.
    _set1 `                      low = gs_screen-&1-low ) TO gs_filter-&1.`.
    _set1 `    ENDIF.`.
    _set1 `  ELSE.`.
    _set1 `    gs_filter-&1[] = gs_screen-&1-data[].`.
    _set1 `  ENDIF.`.
    _set1 `END-OF-DEFINITION.`.




    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_addr_click.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_ADDR_CLICK.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_ADDR_CLICK.`.
    _set5 `  CLEAR : ` ms_name-g_itab `_` iv_alv_key `.`.
    _add4 `  INSERT ` ms_name-g_itab `_` iv_alv_key.
    _add5 ` INTO ` ms_name-g_itab `_` iv_alv_key ` INDEX 1.`.
    _append.
    _set5 `  ` ms_name-g_obj `_` iv_alv_key `->REFRESH( ).`.
    _set3 `ENDFORM.                    "` iv_alv_key `_ADDR_CLICK.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_canc_click.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_CANC_CLICK.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_CANC_CLICK.`.
    _set1 ``.
    _set5 `  IF ` ms_name-g_data `_ON_CHAINGING_FLAG_` iv_alv_key ` EQ ABAP_TRUE`.
    _set5 `    AND ` ms_name-g_obj `_` iv_alv_key `->CONFIRM_CANCEL( ) NE ABAP_TRUE.`.
    _set1 `    EXIT.`.
    _set1 `  ENDIF.`.
    _set1 ``.
    _set5 `  CLEAR : ` ms_name-g_itab `_` iv_alv_key `, `.
    _set4          ms_name-g_itab `_` iv_alv_key `[].`.
    _add4 `  ` ms_name-g_itab `_` iv_alv_key.
    _add5 `[] = <` ms_name-g_fieldsymbol_t `_` iv_alv_key `>[].`.
    _append.
    _set1 ``.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE`.
    _set5 `                   CHANGING CT_DATA  = ` ms_name-g_itab `_` iv_alv_key `[] ).`.
    _set5 `  CLEAR <` ms_name-g_fieldsymbol_t `_` iv_alv_key `>.`.
    _set3 `ENDFORM.                    "` iv_alv_key `_CANC_CLICK.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_chan_click.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_CHAN_CLICK.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_CHAN_CLICK.`.
    IF iv_parent_alv_key IS NOT INITIAL.
      _set5 `  IF ` ms_name-g_itab `_` iv_parent_alv_key ` IS INITIAL.`.
      _set3 `    MESSAGE I002(ZBRD001) DISPLAY LIKE ` ms_name-g_constants `_E.`.
      _set1 `    EXIT.`.
      _set1 `  ENDIF.`.
    ENDIF.
    _set5 `  IF ` ms_name-g_obj `_DATA_` iv_alv_key ` IS INITIAL.`.
    _add4 `    CREATE DATA ` ms_name-g_obj `_DATA_` iv_alv_key.
    _add5 ` LIKE STANDARD TABLE OF ` ms_name-g_itab `_` iv_alv_key `.`.
    _append.
    _add4 `    ASSIGN ` ms_name-g_obj `_DATA_` iv_alv_key.
    _add5 `->* TO <` ms_name-g_fieldsymbol_t `_` iv_alv_key `>.`.
    _append.
    _set1 `  ENDIF.`.
    _add4 `  <` ms_name-g_fieldsymbol_t `_` iv_alv_key.
    _add5 `>[] = ` ms_name-g_itab `_` iv_alv_key `[].`.
    _append.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_CHANGE_MODE`.
    _set5 `                   CHANGING CT_DATA  = ` ms_name-g_itab `_` iv_alv_key `[] ).`.
    _set3 `ENDFORM.                    "` iv_alv_key `_CHAN_CLICK.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_check_authority.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      FORM  CHECK_AUTHORITY`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `FORM CHECK_AUTHORITY .`.
    _set1 ``.
    _set1 `ENDFORM.                    " CHECK_AUTHORITY`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_check_pk.
    CLEAR mt_code.
    DATA lv_index TYPE i.
    DATA ls_fcat TYPE LINE OF gtt_fcat.
    DATA lt_fcat TYPE gtt_fcat.

    delete_dup_fcat( EXPORTING it_fcat = it_fcat
                     IMPORTING et_fcat = lt_fcat ).

    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_CHECK_PK`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_CHECK_PK .`.
    _set5 `  CLEAR : ` ms_name-g_data `_ERR, ` ms_name-g_data `_COUNT.`.
    _set1 ``.
    _set3 `  SELECT COUNT(*) INTO ` ms_name-g_data `_COUNT`.
    _set2 `    FROM ` iv_tabnm.
    _add1 `  WHERE `.
    LOOP AT lt_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'.
      ADD 1 TO lv_index.
      IF lv_index > 1.
        _add1 `    AND `.
      ENDIF.
      _add7 ls_fcat-fieldname ` = ` ms_name-g_wa `_` iv_alv_key `-` ls_fcat-fieldname.
      _append.
    ENDLOOP.
    _set1 `.`.
    _set1 ``.
    _set3 `  IF ` ms_name-g_data `_COUNT GT 0.`.
    _set5 `    ` ms_name-g_data `_ERR = ` ms_name-g_constants `_E.`.
    _set1 `  ENDIF.`.
    _set1 `ENDFORM.                    " CHECK_PK`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_context_request.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      Form  ` iv_alv_key `_CONTEXT_REQUEST`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       text`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `*  -->  p1        text`.
    _set1 `*  <--  p2        text`.
    _set1 `*----------------------------------------------------------------------*`.
    _set5 `FORM ` iv_alv_key `_CONTEXT_REQUEST USING ` ms_name-form_iv `_CONTEXT_TYPE`.
    _set3 `                                   ` ms_name-form_iv `_FIELDNAME TYPE LVC_FNAME`.
    _set3 `                                   ` ms_name-form_io `_MENU TYPE REF TO CL_CTMENU`.
    _set3 `                                   ` ms_name-form_iv `_NODE_KEY TYPE LVC_NKEY.`.
    _set3 `  DATA : ` ms_name-l_itab `_NODE  TYPE LVC_T_NKEY.`.
    _set3 `  CLEAR ` ms_name-l_itab `_NODE[].`.
    _set3 `  CASE ` ms_name-form_iv `_CONTEXT_TYPE.`.
    _set1 `    WHEN '&Header'.`.
    _set1 `    WHEN '&Node'.`.
    _set1 `    WHEN '&Item'.`.
    _set3 `      ` ms_name-form_io `_MENU->ADD_FUNCTION( EXPORTING FCODE = 'F01' TEXT  = 'Text1' ).`.
    _set5 `*      ` ms_name-g_obj `_TREE->GET_CHILDREN( EXPORTING I_NODE_KEY = ` ms_name-form_iv `_NODE_KEY`.
    _set3 `*                             IMPORTING ET_CHILDREN = ` ms_name-l_itab `_NODE ).`.
    _set3 `*      IF ` ms_name-l_itab `_NODE[] IS INITIAL.`.
    _set3 `*        ` ms_name-form_io `_MENU->ADD_FUNCTION( EXPORTING FCODE = 'F02' TEXT  = 'Text2' ).`.
    _set1 `*      ENDIF.`.
    _set1 `  ENDCASE.`.
    _set1 ``.
    _set1 `ENDFORM.`.

    rt_code = mt_code.


  ENDMETHOD.


  METHOD get_context_select.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      Form  ` iv_alv_key `_CONTEXT_SELECT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       text`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `*  -->  p1        text`.
    _set1 `*  <--  p2        text`.
    _set1 `*----------------------------------------------------------------------*`.
    _set5 `FORM ` iv_alv_key `_CONTEXT_SELECT USING ` ms_name-form_iv `_CONTEXT_TYPE`.
    _set3 `                                  ` ms_name-form_iv `_FCODE TYPE SY-UCOMM`.
    _set3 `                                  ` ms_name-form_iv `_FIELDNAME TYPE LVC_FNAME`.
    _set3 `                                  ` ms_name-form_iv `_NODE_KEY TYPE LVC_NKEY.`.
    _set3 `  DATA : ` ms_name-l_data `_NODE_TEXT   TYPE LVC_VALUE,`.
    _set3 `         ` ms_name-l_itab `_ITEM_LAYOUT TYPE LVC_T_LAYI,`.
    _set3 `         ` ms_name-l_wa `_NODE_LAYOUT TYPE LVC_S_LAYN,`.
    _set3 `         ` ms_name-l_data `_UCOMM TYPE SY-UCOMM.`.
    _add4 `  DATA ` ms_name-l_wa `_` iv_alv_key.
    _add5 ` TYPE ` ms_name-g_type `_` iv_alv_key `.`.
    _append.
    _set3 `  CLEAR ` ms_name-g_data `_OPERATING_NODE_KEY.`.
    _set5 `  ` ms_name-g_data `_OPERATING_NODE_KEY = ` ms_name-form_iv `_NODE_KEY.`.
    _set1 ``.
    _set3 `  CASE ` ms_name-form_iv `_CONTEXT_TYPE.`.
    _set1 `    WHEN '&Node' OR '&Item'.`.
    _add4 `      CLEAR : ` ms_name-l_wa `_` iv_alv_key.
    _add5 `, ` ms_name-g_wa `_` iv_alv_key `.`.
    _append.
    _set7 `      ` ms_name-g_obj `_` iv_alv_key `->GET_OUTTAB_LINE( EXPORTING I_NODE_KEY = ` ms_name-g_data `_OPERATING_NODE_KEY`.
    _set5 `                                IMPORTING E_OUTTAB_LINE = ` ms_name-l_wa `_` iv_alv_key ` ).`.
    _add4 `      READ TABLE ` ms_name-g_itab `_` iv_alv_key.
    _add4 ` INTO ` ms_name-g_wa `_` iv_alv_key .
    _append.
    _add4 `             WITH KEY ` iv_node_id_field ` = ` ms_name-l_wa.
    _add5 `_` iv_alv_key `-` iv_node_id_field `.`.
    _append.
    _set3 `      CL_GUI_CFW=>SET_NEW_OK_CODE( EXPORTING NEW_CODE = ` ms_name-form_iv `_FCODE  ).`.
    _set1 ``.
    _set1 `  ENDCASE.`.
    _set1 ``.
    _set1 `ENDFORM.`.

    rt_code = mt_code.


  ENDMETHOD.


  METHOD get_create_click.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_CREATE_CLICK`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_CREA_CLICK.`.
    IF iv_parent_alv_key IS NOT INITIAL.
      _set5 `  IF ` ms_name-g_itab `_` iv_parent_alv_key ` IS INITIAL.`.
      _set3 `    MESSAGE I002(ZBRD001) DISPLAY LIKE ` ms_name-g_constants `_E.`.
      _set1 `    EXIT.`.
      _set1 `  ENDIF.`.
    ENDIF.
    _set5 `  IF ` ms_name-g_obj `_DATA_` iv_alv_key ` IS INITIAL.`.
    _add4 `    CREATE DATA ` ms_name-g_obj `_DATA_` iv_alv_key.
    _add5 ` LIKE STANDARD TABLE OF ` ms_name-g_itab `_` iv_alv_key `.`.
    _append.
    _add4 `    ASSIGN ` ms_name-g_obj `_DATA_` iv_alv_key.
    _add5 `->* TO <` ms_name-g_fieldsymbol_t `_` iv_alv_key `>.`.
    _append.
    _set1 `  ENDIF.`.
    _add4 `  <` ms_name-g_fieldsymbol_t `_` iv_alv_key.
    _add5 `>[] = ` ms_name-g_itab `_` iv_alv_key `[].`.
    _append.
    _set5 `  _INIT : ` ms_name-g_itab `_` iv_alv_key `.`.
    _add4 `  INSERT ` ms_name-g_itab `_` iv_alv_key.
    _add5 ` INTO ` ms_name-g_itab `_` iv_alv_key ` INDEX 1.`.
    _append.
    _set1 ``.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_CREATE_MODE`.
    _set5 `                   CHANGING CT_DATA  = ` ms_name-g_itab `_` iv_alv_key `[] ).`.
    _set1 ``.
    _set3 `ENDFORM.                    "` iv_alv_key `_CREATE_CLICK`.
    _set1 ``.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_data_changed.
    DATA ls_key_map TYPE gty_key_map.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_DATA_CHANGED`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `*      -->` ms_name-form_io `_OBJECT     TEXT`.
    _set3 `*      -->` ms_name-form_iv `_ONF4  TEXT`.
    _set3 `*      -->` ms_name-form_iv `_ONF4_BEFORE  TEXT`.
    _set3 `*      -->` ms_name-form_iv `_ONF4_AFTER  TEXT`.
    _set3 `*      -->` ms_name-form_iv `_UCOMM  TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set5 `FORM ` iv_alv_key `_DATA_CHANGED USING ` ms_name-form_io `_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL`.
    _set3 `                        ` ms_name-form_iv `_ONF4`.
    _set3 `                        ` ms_name-form_iv `_ONF4_BEFORE`.
    _set3 `                        ` ms_name-form_iv `_ONF4_AFTER`.
    _set3 `                        ` ms_name-form_iv `_UCOMM.`.
    _set3 `  DATA ` ms_name-l_itab `_MOD_CELLS TYPE LVC_T_MODI WITH HEADER LINE.`.
    _set5 `  ` ms_name-l_itab `_MOD_CELLS[] = ` ms_name-form_io `_OBJECT->MT_GOOD_CELLS.`.
    _set3 `  LOOP AT ` ms_name-l_itab `_MOD_CELLS.`.
    _set1 `    AT NEW ROW_ID.`.
    _set7 `      READ TABLE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-l_itab `_MOD_CELLS-ROW_ID.`.
    _set1 `    ENDAT.`.
    _add4 `    ASSIGN COMPONENT ` ms_name-l_itab `_MOD_CELLS-FIELDNAME OF STRUCTURE ` ms_name-g_itab.
    _add5 `_` iv_alv_key ` TO <` ms_name-g_fieldsymbol_v `_FIELD>.`.
    _append.
    _set5 `    <` ms_name-g_fieldsymbol_v `_FIELD> = ` ms_name-l_itab `_MOD_CELLS-VALUE.`.
    _set1 `    AT END OF ROW_ID.`.
    _set5 `      ` ms_name-g_itab `_` iv_alv_key `-BALV_STATUS_ICON = ICON_CHANGE.`.
    _set7 `      _SET_ALV_CELL ` ms_name-l_itab `_MOD_CELLS-ROW_ID 'BALV_STATUS_ICON' ` ms_name-g_itab `_` iv_alv_key `-BALV_STATUS_ICON.`.
    _add4 `  IF ` ms_name-g_obj `_` iv_alv_key.
    _add5 `->IS_CREATE_MODE( ) = ABAP_TRUE OR ` ms_name-g_obj `_` iv_alv_key `->IS_UPLOAD_MODE( ) = ABAP_TRUE. `.
    _append.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'ERDAT'.
    IF sy-subrc EQ 0.
      _set5 `      ` ms_name-g_itab `_` iv_alv_key `-ERDAT = SY-DATUM.`.
      _set7 `      _SET_ALV_CELL ` ms_name-l_itab `_MOD_CELLS-ROW_ID 'ERDAT' ` ms_name-g_itab `_` iv_alv_key `-ERDAT.`.
    ENDIF.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'ERZET'.
    IF sy-subrc EQ 0.
      _set5 `      ` ms_name-g_itab `_` iv_alv_key `-ERZET = SY-UZEIT.`.
      _set7 `      _SET_ALV_CELL ` ms_name-l_itab `_MOD_CELLS-ROW_ID 'ERZET' ` ms_name-g_itab `_` iv_alv_key `-ERZET.`.
    ENDIF.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'ERNAM'.
    IF sy-subrc EQ 0.
      _set5 `      ` ms_name-g_itab `_` iv_alv_key `-ERNAM = SY-UNAME.`.
      _set7 `      _SET_ALV_CELL ` ms_name-l_itab `_MOD_CELLS-ROW_ID 'ERNAM' ` ms_name-g_itab `_` iv_alv_key `-ERNAM.`.
    ENDIF.
    _set1 `   ENDIF.`.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'AEDAT'.
    IF sy-subrc EQ 0.
      _set5 `      ` ms_name-g_itab `_` iv_alv_key `-AEDAT = SY-DATUM.`.
      _set7 `      _SET_ALV_CELL ` ms_name-l_itab `_MOD_CELLS-ROW_ID 'AEDAT' ` ms_name-g_itab `_` iv_alv_key `-AEDAT.`.
    ENDIF.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'AEZET'.
    IF sy-subrc EQ 0.
      _set5 `      ` ms_name-g_itab `_` iv_alv_key `-AEZET = SY-UZEIT.`.
      _set7 `      _SET_ALV_CELL ` ms_name-l_itab `_MOD_CELLS-ROW_ID 'AEZET' ` ms_name-g_itab `_` iv_alv_key `-AEZET.`.
    ENDIF.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'AENAM'.
    IF sy-subrc EQ 0.
      _set5 `      ` ms_name-g_itab `_` iv_alv_key `-AENAM = SY-UNAME.`.
      _set7 `      _SET_ALV_CELL ` ms_name-l_itab `_MOD_CELLS-ROW_ID 'AENAM' ` ms_name-g_itab `_` iv_alv_key `-AENAM.`.
    ENDIF.
    LOOP AT it_key_map INTO ls_key_map.
      _add1 : `  `, ms_name-g_itab, `_`, iv_alv_key, `-`, ls_key_map-i_field, ` = `, ms_name-g_itab, `_`, iv_parent_alv_key, `-`, ls_key_map-h_field, `.`.
      _append.
    ENDLOOP.
    _set7 `      READ TABLE ` ms_name-g_itab `_` iv_alv_key ` TRANSPORTING NO FIELDS INDEX ` ms_name-l_itab `_MOD_CELLS-ROW_ID.`.
    _set1 `      IF SY-SUBRC EQ 0.`.
    _set7 `        MODIFY ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-l_itab `_MOD_CELLS-ROW_ID.`.
    _set1 `      ELSE.`.
    _set5 `        APPEND ` ms_name-g_itab `_` iv_alv_key `.`.
    _set1 `      ENDIF.`.
    _set1 `    ENDAT.`.
    _set1 `  ENDLOOP.`.
    _set5 `  ` ms_name-g_data `_ON_CHAINGING_FLAG_` iv_alv_key ` = ABAP_TRUE.`.
    _set3 `ENDFORM.                    "` iv_alv_key `_DATA_CHANGED`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_dele_click.
    DATA lv_index TYPE i.
    DATA ls_key_map TYPE gty_key_map.
    CLEAR : mt_code, lv_index.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_DELE_CLICK.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_DELE_CLICK.`.
    _set5 `  DATA ` ms_name-l_itab `_TAB TYPE TABLE OF ` iv_tabnm ` WITH HEADER LINE.`.
    _set3 `  _INIT ` ms_name-g_itab `_ROWS.`.
    _set5 `  ` ms_name-g_obj `_` iv_alv_key `->GET_SELECTED_ROWS(`.
    _set1 `   IMPORTING`.
    _set3 `     ET_INDEX_ROWS = ` ms_name-g_itab `_ROWS`.
    _set3 `     ET_ROW_NO     = ` ms_name-g_itab `_ROW_IDS ).`.
    _set1 ``.
    _set3 `  IF ` ms_name-g_itab `_ROWS[] IS INITIAL.`.
    _set1 `    MESSAGE I002(ZBRD001).`.
    _set1 `    EXIT.`.
    _set1 `  ENDIF.`.
    _set1 ``.
    _set3 `  IF ` ms_acg_config-alv_class `=>CONFIRM_DELETE( ) NE ABAP_TRUE.`.
    _set1 `    EXIT.`.
    _set1 `  ENDIF.`.
    _set1 ``.
    _set1 `  TRY.`.
    _set5 `      IF ` ms_name-g_obj `_` iv_alv_key `->IS_DISPLAY_MODE( ) = ABAP_TRUE.`.
    _set5 `        LOOP AT ` ms_name-g_itab `_ROWS INTO ` ms_name-g_wa `_ROWS WHERE ROWTYPE EQ SPACE.`.
    _set5 `          CLEAR : ` ms_name-g_itab `_` iv_alv_key `.`.
    _set7 `          READ TABLE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-g_wa `_ROWS-INDEX.`.
    _set1 `          IF SY-SUBRC EQ 0.`.

    IF iv_item_tabnm IS NOT INITIAL.
      _set3 `            CLEAR : ` ms_name-g_data `_COUNT.`.
      _set1 ``.
      _set3 `            SELECT COUNT(*) INTO ` ms_name-g_data `_COUNT`.
      _set2 `              FROM ` iv_item_tabnm.
      _add1 `            WHERE `.
      LOOP AT it_key_map INTO ls_key_map.
        ADD 1 TO lv_index.
        IF lv_index > 1.
          _add1 `              AND `.
        ENDIF.
        _add7 ls_key_map-i_field ` = ` ms_name-g_itab `_` iv_alv_key `-` ls_key_map-h_field .
        _append.
      ENDLOOP.
      _set1  `                        .`.
      _set3 `            IF ` ms_name-g_data `_COUNT GT 0.`.
      _set3 `              _INIT ` ms_name-l_itab `_TAB.`.
      _set1 `              EXIT.`.
      _set1 `            ENDIF.`.
    ENDIF.
    _set3 `            CLEAR ` ms_name-l_itab `_TAB.`.
    _set7 `            MOVE-CORRESPONDING ` ms_name-g_itab `_` iv_alv_key ` TO ` ms_name-l_itab `_TAB.`.
    _set3 `            APPEND ` ms_name-l_itab `_TAB.`.
    _set1 `          ENDIF.`.
    _set1 `        ENDLOOP.`.
    _set3 `        IF ` ms_name-l_itab `_TAB[] IS INITIAL.`.
    IF iv_item_tabnm IS NOT INITIAL.
      _set1 `          MESSAGE I010(ZBRD001).`.
    ELSE.
      _set1 `          MESSAGE I005(ZBRD001).`.
    ENDIF.
    _set1 `          EXIT.`.
    _set1 `        ENDIF.`.
    _set5 `        DELETE ` iv_tabnm ` FROM TABLE ` ms_name-l_itab `_TAB.`.
    _set1 `        IF SY-SUBRC NE 8.`.
    _set3 `          ` ms_acg_config-alv_class `=>COMMIT_DELETE( SY-DBCNT ).`.
    _set3 `          SORT ` ms_name-g_itab `_ROWS BY INDEX DESCENDING.`.
    _set5 `          LOOP AT ` ms_name-g_itab `_ROWS INTO ` ms_name-g_wa `_ROWS WHERE ROWTYPE EQ SPACE.`.
    _set7 `            DELETE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-g_wa `_ROWS-INDEX.`.
    _set1 `          ENDLOOP.`.
    _set5 `          ` ms_name-g_obj `_` iv_alv_key `->REFRESH(  ).`.
    _set1 ``.
    _set1 `        ELSE.`.
    _set3 `          ` ms_acg_config-alv_class `=>ROLLBACK_FAIL( ).`.
    _set1 `        ENDIF.`.
    _set1 `      ENDIF.`.
    _set5 `      IF ` ms_name-g_obj `_` iv_alv_key `->IS_UPLOAD_MODE( ) = ABAP_TRUE.`.
    _set3 `        SORT ` ms_name-g_itab `_ROWS BY INDEX DESCENDING.`.
    _set5 `        LOOP AT ` ms_name-g_itab `_ROWS INTO ` ms_name-g_wa `_ROWS WHERE ROWTYPE EQ SPACE.`.
    _set7 `          DELETE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-g_wa `_ROWS-INDEX.`.
    _set1 `        ENDLOOP.`.
    _set5 `        IF ` ms_name-g_itab `_` iv_alv_key `[] IS INITIAL.`.
    _set1 `          MESSAGE I004(ZBRD001).`.
    _set1 `          LEAVE TO SCREEN 0.`.
    _set1 `        ELSE.`.
    _set5 `          ` ms_name-g_obj `_` iv_alv_key `->REFRESH( ).`.
    _set1 `        ENDIF.`.
    _set1 ``.
    _set1 `      ENDIF.`.
    _set1 ``.
    _set3 `    CATCH CX_ROOT INTO ` ms_name-g_obj `_EXCEPTION.`.
    _set5 `      ` ms_acg_config-alv_class `=>CATCH_EXCEPTION( IO_ROOT = ` ms_name-g_obj `_EXCEPTION ).`.
    _set1 `  ENDTRY.`.
    _set1 ``.
    _set3 `ENDFORM.                    "` iv_alv_key `_DELE_CLICK.`.

    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_delr_click.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_DELR_CLICK.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_DELR_CLICK.`.
    _set5 `  ` ms_name-g_obj `_` iv_alv_key `->DELETE_SELECTED_ROWS( ).`.
    _set1 `ENDFORM.                    "DELR_CLICK.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_double_click.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_DOUBLE_CLICK`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set5 `FORM ` iv_alv_key `_DOUBLE_CLICK USING ` ms_name-form_is `_ROW TYPE LVC_S_ROW`.
    _set3 `                                ` ms_name-form_is `_COLUMN TYPE LVC_S_COL`.
    _set3 `                                ` ms_name-form_is `_ROW_NO TYPE LVC_S_ROID.`.
    IF iv_item_alv_key IS NOT INITIAL.
      _set3 `  DATA ` ms_name-l_wa `_STBL TYPE LVC_S_STBL.`.
      _set5 `  CLEAR ` ms_name-g_itab `_` iv_alv_key `.`.
      _set7 `  READ TABLE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-form_is `_ROW_NO-ROW_ID.`.
      _set1 `  IF SY-SUBRC EQ 0.`.
      _set3 `    CLEAR ` ms_name-g_itab `_ROWS.`.
      _set5 `    APPEND ` ms_name-form_is `_ROW TO ` ms_name-g_itab `_ROWS.`.
      _set7 `    ` ms_name-g_obj `_` iv_alv_key `->SET_SELECTED_ROWS( EXPORTING IT_INDEX_ROWS = ` ms_name-g_itab `_ROWS ).`.
      _set3 `    PERFORM GET_` iv_item_alv_key `_DATA.`.
      _set7 `    ` ms_name-g_obj `_` iv_item_alv_key `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE`.
      _set5 `                           CHANGING CT_DATA  = ` ms_name-g_itab `_` iv_item_alv_key `[] ).`.
      _set1 `  ENDIF.`.
    ELSE.
      _set3 `  DATA ` ms_name-l_wa `_STBL TYPE LVC_S_STBL.`.
      _set5 `  CLEAR ` ms_name-g_itab `_` iv_alv_key `.`.
      _set7 `  READ TABLE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-form_is `_ROW_NO-ROW_ID.`.
      _set1 `  IF SY-SUBRC EQ 0.`.
      _set3 `    CLEAR ` ms_name-g_itab `_ROWS.`.
      _set5 `    APPEND ` ms_name-form_is `_ROW TO ` ms_name-g_itab `_ROWS.`.
      _set7 `    ` ms_name-g_obj `_` iv_alv_key `->SET_SELECTED_ROWS( EXPORTING IT_INDEX_ROWS = ` ms_name-g_itab `_ROWS ).`.
      _set1 `  ENDIF.`.
      _set1 `  MESSAGE 'DOUBLE CLICK TRIGGERED' TYPE 'I'.`.
    ENDIF.
    _set1 ``.
    _set1 `ENDFORM.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_double_click_tree.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_DOUBLE_CLICK`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set5 `FORM ` iv_alv_key `_DOUBLE_CLICK USING ` ms_name-form_iv `_FIELDNAME TYPE LVC_FNAME`.
    _set3 `                                       ` ms_name-form_iv `_NODE_KEY TYPE LVC_NKEY.`.
    _set1 `  MESSAGE 'DOUBLE CLICK TRIGGERED' TYPE 'I'.`.
    _set5 `  ` ms_name-g_data `_OPERATING_NODE_KEY = ` ms_name-form_iv `_NODE_KEY.`.
    _set3 `  CL_GUI_CFW=>SET_NEW_OK_CODE( EXPORTING NEW_CODE = ` ms_name-g_constants `_DB_CLICK  ).`.
    _set1 `ENDFORM.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_end_of_selection.
    CLEAR mt_code.
    _set1 `*---------------------------------------------------------------------*`.
    _set1 `* END-OF-SELECTION.`.
    _set1 `*---------------------------------------------------------------------*`.
    _set1 `END-OF-SELECTION.`.
    _set1 `  IF SY-BATCH IS INITIAL.`.
    _set1 `    CALL SCREEN 100.`.
    _set1 `  ENDIF.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_f01_header.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&  INCLUDE           ` ms_acg_config-progid `F01`.
    _set1 `*&---------------------------------------------------------------------*`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_fcat_code.
    CLEAR mt_code.
    _set3 `CLEAR ` ms_name-l_wa `_FCAT_CBO.`.
    _set4 ms_name-l_wa `_FCAT_CBO-PROGID = '`  is_fcat-progid `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-ALV_KEY = '`  is_fcat-alv_key `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-FCAT_KEY = '`  is_fcat-fcat_key `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-COL_POS = '`  is_fcat-col_pos `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-FIELDNAME = '`  is_fcat-fieldname `'.`.
    IF is_fcat-zkey EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-ZKEY = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-fix_column EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-FIX_COLUMN = ABAP_TRUE.`.
    ENDIF.
    _set4 ms_name-l_wa `_FCAT_CBO-REPTEXT = '`  is_fcat-reptext `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-SCRTEXT_S = '`  is_fcat-scrtext_s `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-SCRTEXT_M = '`  is_fcat-scrtext_m `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-SCRTEXT_L = '`  is_fcat-scrtext_l `'.`.
    IF is_fcat-icon EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-ICON = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-col_opt EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-COL_OPT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-outputlen IS NOT INITIAL.
      _set4 ms_name-l_wa `_FCAT_CBO-OUTPUTLEN = '`  is_fcat-outputlen `'.`.
    ENDIF.
    IF is_fcat-checkbox EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-CHECKBOX = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-no_out EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-NO_OUT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-tech EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-TECH = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-just  IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-JUST = '`  is_fcat-just `'.`.
    ENDIF.
    IF is_fcat-no_sign EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-NO_SIGN = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-no_zero EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-NO_ZERO = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-edit_mask  IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-EDIT_MASK = '`  is_fcat-edit_mask `'.`.
    ENDIF.
    IF is_fcat-emphasize  IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-EMPHASIZE = '`  is_fcat-emphasize `'.`.
    ENDIF.
    IF is_fcat-sr_spos  IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-SR_SPOS = '`  is_fcat-sr_spos `'.`.
    ENDIF.
    IF is_fcat-sr_up EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-SR_UP = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-sr_down EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-SR_DOWN = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-crea_edit EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-CREA_EDIT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-chan_edit EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-upld_edit EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-do_sum IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DO_SUM = '`  is_fcat-do_sum `'.`.
    ENDIF.
    IF is_fcat-no_sum EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-NO_SUM = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-sr_subtot EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-SR_SUBTOT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-button EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-BUTTON = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-lowercase EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-LOWERCASE = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-change_evt EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-CHANGE_EVT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-no_convext EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-NO_CONVEXT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-convexit IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-CONVEXIT = '`  is_fcat-convexit `'.`.
    ENDIF.
    IF is_fcat-hotspot EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-HOTSPOT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-f4availabl EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-F4AVAILABL = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-no_merging EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-NO_MERGING = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-drdn_hndl IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DRDN_HNDL = '`  is_fcat-drdn_hndl `'.`.
    ENDIF.
    IF is_fcat-drdn_alias EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-DRDN_ALIAS = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-drdn_field IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DRDN_FIELD = '`  is_fcat-drdn_field `'.`.
    ENDIF.
    IF is_fcat-ref_table IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-REF_TABLE = '`  is_fcat-ref_table `'.`.
    ENDIF.
    IF is_fcat-ref_field IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-REF_FIELD = '`  is_fcat-ref_field `'.`.
    ENDIF.
    IF is_fcat-checktable IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-CHECKTABLE = '`  is_fcat-checktable `'.`.
    ENDIF.
    IF is_fcat-datatype IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DATATYPE = '`  is_fcat-datatype `'.`.
    ENDIF.
    IF is_fcat-inttype IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-INTTYPE = '`  is_fcat-inttype `'.`.
    ENDIF.
    IF is_fcat-intlen IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-INTLEN = '`  is_fcat-intlen `'.`.
    ENDIF.
    IF is_fcat-currency IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-CURRENCY = '`  is_fcat-currency `'.`.
    ENDIF.
    IF is_fcat-cfieldname IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-CFIELDNAME = '`  is_fcat-cfieldname `'.`.
    ENDIF.
    IF is_fcat-quantity IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-QUANTITY = '`  is_fcat-quantity `'.`.
    ENDIF.
    IF is_fcat-qfieldname IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-QFIELDNAME = '`  is_fcat-qfieldname `'.`.
    ENDIF.
    IF is_fcat-decimals IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DECIMALS = '`  is_fcat-decimals `'.`.
    ENDIF.
    IF is_fcat-decimals_o IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DECIMALS_O = '`  is_fcat-decimals_o `'.`.
    ENDIF.
    IF is_fcat-style IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-STYLE = '`  is_fcat-style `'.`.
    ENDIF.
    IF is_fcat-rollname IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-ROLLNAME = '`  is_fcat-rollname `'.`.
    ENDIF.
    IF is_fcat-decmlfield IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DECMLFIELD = '`  is_fcat-decmlfield `'.`.
    ENDIF.
    IF is_fcat-dd_roll IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DD_ROLL = '`  is_fcat-dd_roll `'.`.
    ENDIF.
    IF is_fcat-domname IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DOMNAME = '`  is_fcat-domname `'.`.
    ENDIF.
    IF is_fcat-dd_outlen IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DD_OUTLEN = '`  is_fcat-dd_outlen `'.`.
    ENDIF.

    _set5 `APPEND ` ms_name-l_wa `_FCAT_CBO TO ` iv_fcat_name `.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_field_changed.
    DATA ls_fcat TYPE ztbrd00020.
    CLEAR mt_code.
    LOOP AT it_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'.
      _set1 `*&---------------------------------------------------------------------*`.
      _set5 `*&      FORM  ` iv_alv_key `_` ls_fcat-fieldname `_CHANGED`.
      _set1 `*&---------------------------------------------------------------------*`.
      _set1 `*       TEXT`.
      _set1 `*----------------------------------------------------------------------*`.
      _set7 `FORM ` iv_alv_key `_` ls_fcat-fieldname `_CHANGED USING ` ms_name-form_io `_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL`.
      _set3 `                                   ` ms_name-form_iv `_ROW_ID`.
      _set3 `                                   ` ms_name-form_iv `_VALUE TYPE ANY.`.
      _set3 `  DATA ` ms_name-l_wa `_FIELDCAT TYPE LVC_S_FCAT.` .
      _set5 `  CLEAR ` ms_name-g_wa `_` iv_alv_key `.`.
      _add4 `  READ TABLE ` ms_name-g_itab `_` iv_alv_key.
      _add7 ` INTO ` ms_name-g_wa `_` iv_alv_key ` INDEX ` ms_name-form_iv `_ROW_ID.`.
      _append.
      _set1 `  IF SY-SUBRC EQ 0.`.
      _add4 `    ` ms_name-g_itab `_` iv_alv_key .
      _add5 `-` ls_fcat-fieldname ` = ` ms_name-form_iv `_VALUE.`.
      _append.
      _set7 `    _SET_ALV_CELL ` ms_name-form_iv `_ROW_ID '` ls_fcat-fieldname `' ` ms_name-form_iv `_VALUE.`.
      _set3 `    PERFORM ` iv_alv_key `_CHECK_PK.`.
      _set5 `    IF ` ms_name-g_data `_ERR EQ ` ms_name-g_constants `_E.`.
      _set5 `      ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON = ICON_DEFECT.`.
      _set1 `    ELSE.`.
      _set5 `      ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON = ICON_CHANGE.`.
      _set1 `    ENDIF.`.
      _set7 `    _SET_ALV_CELL ` ms_name-form_iv `_ROW_ID 'BALV_STATUS_ICON' ` ms_name-g_itab `_` iv_alv_key `-BALV_STATUS_ICON.`.
      _add4 `    MODIFY ` ms_name-g_itab `_` iv_alv_key.
      _add7 ` FROM ` ms_name-g_wa `_` iv_alv_key ` INDEX ` ms_name-form_iv `_ROW_ID.`.
      _append.
      _set1 `  ENDIF.`.
      _set5 `ENDFORM.                    "` iv_alv_key `_` ls_fcat-fieldname `_CHANGED.   `.

    ENDLOOP.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_field_f4.
    DATA ls_fcat TYPE ztbrd00020.
    CLEAR mt_code.
    LOOP AT it_fcat INTO ls_fcat WHERE f4availabl = 'X'.
      _set1 `**&---------------------------------------------------------------------*`.
      _set5 `**&      FORM  ` iv_alv_key `_` ls_fcat-fieldname `_F4.`.
      _set1 `**&---------------------------------------------------------------------*`.
      _set1 `**       TEXT`.
      _set1 `**----------------------------------------------------------------------*`.
      _set7 `*FORM ` iv_alv_key `_` ls_fcat-fieldname `_F4 USING ` ms_name-form_iv `_fieldname   TYPE lvc_fname`.
      _set3 `*                        ` ms_name-form_iv `_fieldvalue  TYPE lvc_value`.
      _set3 `*                        ` ms_name-form_is `_row_no   TYPE lvc_s_roid`.
      _set3 `*                        ` ms_name-form_io `_event_data   TYPE REF TO cl_alv_event_data`.
      _set3 `*                        ` ms_name-form_it `_bad_cells   TYPE lvc_t_modi`.
      _set3 `*                        ` ms_name-form_iv `_display   TYPE char01`.
      _set3 `*                        ` ms_name-form_iv `_return_value.`.
      _set3 `*  DATA : BEGIN OF ` ms_name-l_itab `_SEARCH_FIELD OCCURS 0,`.
      _set1 `*         KEY LIKE DBTAB-KEY,`.
      _set1 `*         VALUE LIKE DBTAB-VALUE,`.
      _set3 `*         END OF ` ms_name-l_itab `_SEARCH_FIELD.`.
      _set3 `*  DATA ` ms_name-l_data `_VALUE TYPE SHVALUE_D.`.
      _set7 `*  READ TABLE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-form_is `_ROW_NO-ROW_ID.`.
      _set1 `*`.
      _set1 `*  SELECT DISTINCT KEY VALUE`.
      _set3 `*  INTO CORRESPONDING FIELDS OF TABLE ` ms_name-l_itab `_SEARCH_FIELD`.
      _set1 `*  FROM DBTAB`.
      _set1 `*  UP TO 200 ROWS`.
      _set1 `*  .`.
      _set5 `*  ` ms_name-g_obj `_` iv_alv_key `->GET_F4_VALUE( EXPORTING IV_FIELDNAME = 'KEY'`.
      _set3 `*                                          IT_TAB = ` ms_name-l_itab `_SEARCH_FIELD[]`.
      _set3 `*                                RECEIVING RV_VALUE = ` ms_name-l_data `_VALUE  ).`.
      _set3 `*  CHECK ` ms_name-l_data `_VALUE IS NOT INITIAL.`.
      _set7 `*  CHECK ` ms_name-g_obj `O_` iv_alv_key `->GET_ALV_MODE( ) NE ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE.`.
      _set7 `*  ` ms_name-g_itab `_` iv_alv_key `-FIELD = ` ms_name-l_data `_VALUE.`.
      _set7 `*  MODIFY ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-form_is `_ROW_NO-ROW_ID.`.
      _set5 `*  ` ms_name-form_is `_return_value = ` ms_name-l_data `_value.`.
      _set5 `*ENDFORM.                    "` iv_alv_key `-` ls_fcat-fieldname `_F4`.
    ENDLOOP.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_field_hotspot_click.
    DATA ls_fcat TYPE ztbrd00020.
    CLEAR mt_code.
    LOOP AT it_fcat INTO ls_fcat WHERE hotspot EQ 'X'.
      _set1 `*&---------------------------------------------------------------------*`.
      _set5 `*&      FORM  ` iv_alv_key `_` ls_fcat-fieldname `_HOTSPOT_CLICK`.
      _set1 `*&---------------------------------------------------------------------*`.
      _set1 `*       TEXT`.
      _set1 `*----------------------------------------------------------------------*`.
      _set7 `FORM ` iv_alv_key `_` ls_fcat-fieldname `_CLICK USING ` ms_name-form_is `_ROW_ID TYPE LVC_S_ROW`.
      _set3 `                                ` ms_name-form_is `_COLUMN_ID   TYPE LVC_S_COL`.
      _set3 `                                ` ms_name-form_is `_ROW_NO   TYPE LVC_S_ROID.`.
      _set7 `  READ TABLE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-form_is `_ROW_ID-INDEX.`.
      _set7 `  MESSAGE ` ms_name-g_itab `_` iv_alv_key `-` ls_fcat-fieldname ` TYPE 'I'.`.
      _set1 ``.
      _set5 `ENDFORM.                    "` iv_alv_key `-` ls_fcat-fieldname `_HOTSPOT_CLICK`.
    ENDLOOP.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_getdata.
    CLEAR mt_code.
    DATA : lv_index TYPE sy-tabix.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lv_str TYPE string.
    DATA lt_fcat TYPE gtt_fcat.

    delete_dup_fcat( EXPORTING it_fcat = it_fcat
                     IMPORTING et_fcat = lt_fcat ).

    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  GET_` iv_alv_key `_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM GET_` iv_alv_key `_DATA .`.
    _set5 `  _INIT : ` ms_name-g_itab `_` iv_alv_key `.`.

    IF ms_acg_config-is_1step EQ abap_true.
      _set1 `  CLEAR GS_FILTER.`.
      _set1 ``.
      _set1 `  _SET_FILTER : `.
      CLEAR lv_index.
      LOOP AT lt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE tech NE abap_true.
        ADD 1 TO lv_index.
        IF lv_index GT 1.
          _add1 `,`.
        ENDIF.
        _add2 `     ` <ls_fcat>-fieldname .
        _append.
      ENDLOOP.
      _set1 `.`.
    ENDIF.

    _set1 `  SELECT *`.
    _set4 `    INTO CORRESPONDING FIELDS OF TABLE ` ms_name-g_itab `_` iv_alv_key .
    _set2 `    FROM ` iv_tabnm.
    IF lt_fcat IS  NOT INITIAL.
      _add1 `    WHERE `.
      CLEAR lv_index.
      LOOP AT lt_fcat ASSIGNING <ls_fcat> WHERE tech NE abap_true.
        IF <ls_fcat>-zkey EQ abap_true.
          ADD 1 TO lv_cnt.
          ADD 1 TO lv_index.
          IF lv_index GT 1.
            _add1 `      AND `.
          ENDIF.
          lv_str = get_where_query_string( EXPORTING iv_cnt = lv_cnt
                                                     iv_fieldname = <ls_fcat>-fieldname ).
          _add3 <ls_fcat>-fieldname ` IN ` lv_str.
          _append.

        ELSE.
          ADD 1 TO lv_cnt.
          ADD 1 TO lv_index.
          IF lv_index GT 1.
            _add1 `*      AND `.
          ENDIF.
          lv_str = get_where_query_string( EXPORTING iv_cnt = lv_cnt
                                                     iv_fieldname = <ls_fcat>-fieldname ).
          _add3 <ls_fcat>-fieldname ` IN ` lv_str.
          _append.

        ENDIF.
      ENDLOOP.
    ENDIF.
    _set1 `.`.

    _set3 `ENDFORM.                    "GET_` iv_alv_key `_DATA`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_getdata_tree.
    CLEAR mt_code.
    DATA : lv_index TYPE sy-tabix.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lv_str TYPE string.
    DATA lt_fcat TYPE gtt_fcat.

    delete_dup_fcat( EXPORTING it_fcat = it_fcat
                     IMPORTING et_fcat = lt_fcat ).

    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  GET_` iv_alv_key `_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM GET_` iv_alv_key `_DATA .`.
    _set5 `  _INIT : ` ms_name-g_itab `_` iv_alv_key `.`.
    _add4 `  FIELD-SYMBOLS <` ms_name-l_fieldsymbol_s `_` iv_alv_key.
    _add5 `> LIKE LINE OF ` ms_name-g_itab `_` iv_alv_key `.`.
    _append.
    IF ms_acg_config-is_1step EQ abap_true.
      _set1 `  CLEAR GS_FILTER.`.
      _set1 ``.
      _set1 `  _SET_FILTER : `.
      CLEAR lv_index.
      LOOP AT lt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE tech NE abap_true.
        ADD 1 TO lv_index.
        IF lv_index GT 1.
          _add1 `,`.
        ENDIF.
        _add2 `     ` <ls_fcat>-fieldname .
        _append.
      ENDLOOP.
      _set1 `.`.
    ENDIF.
    _set3 `  MESSAGE 'Implementate GET_` iv_alv_key `_DATA to get root node data' TYPE 'I' DISPLAY LIKE 'E'.`.
    _set1 ` " Get Root node list`.
    _set1 `*  SELECT *`.
    _set4 `*    INTO CORRESPONDING FIELDS OF TABLE ` ms_name-g_itab `_` iv_alv_key .
    _set2 `*    FROM ` iv_tabnm.
    IF lt_fcat IS  NOT INITIAL.
      _add1 `*    WHERE `.
      CLEAR lv_index.
      LOOP AT lt_fcat ASSIGNING <ls_fcat> WHERE zkey EQ abap_true AND tech NE abap_true.

        ADD 1 TO lv_cnt.
        ADD 1 TO lv_index.
        IF lv_index GT 1.
          _add1 `*      AND `.
        ENDIF.
        lv_str = get_where_query_string( EXPORTING iv_cnt = lv_cnt
                                                   iv_fieldname = <ls_fcat>-fieldname ).
        _add3 <ls_fcat>-fieldname ` IN ` lv_str.
        _append.


      ENDLOOP.
    ENDIF.
    _set1 `.`.

    _add4 `  LOOP AT ` ms_name-g_itab `_` iv_alv_key.
    _add5 ` ASSIGNING <` ms_name-l_fieldsymbol_s `_` iv_alv_key `>.`.
    _append.
    _set1 `    IF SY-SUBRC EQ 0.`.
    _set5 `      <` ms_name-l_fieldsymbol_s `_` iv_alv_key `>-EXPANDER = ABAP_TRUE.`.
    _set1 `    ENDIF.      `.
    _set1 `  ENDLOOP.`.

    _set3 `ENDFORM.                    "GET_` iv_alv_key `_DATA`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_get_cursor.
    CLEAR mt_code.
    CHECK ms_acg_config-is_1step EQ abap_true.

    _set1 `*---------------------------------------------------------------------*`.
    _set1 `*      MODULE  GET_CURSOR INPUT`.
    _set1 `*---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE GET_CURSOR INPUT.`.
    _set1 `  GET CURSOR FIELD GV_CURSOR_FIELD.`.
    _set1 `ENDMODULE.                 " GET_CURSOR  INPUT`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_global_variable.
    DATA ls_fcat TYPE ztbrd00020.
    DATA lv_container	TYPE seoclsname.
    CLEAR mt_code.
    IF iv_container IS INITIAL.
      lv_container = 'CL_GUI_CONTAINER'.
    ELSE.
      lv_container = iv_container.
    ENDIF.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&  DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set5 `DATA : ` ms_name-g_data `_MODE_` iv_alv_key ` TYPE CHAR04,   "SCREEN CHANGE DISPLAY MODE`.
    _set5 `       ` ms_name-g_data `_ON_CHAINGING_FLAG_` iv_alv_key `.`.
    IF ms_acg_config-is_standalone EQ abap_true.
      _set5 `DATA : ` ms_name-g_wa `_LAYOUT_CBO TYPE ` iv_alv_class `=>TS_HEADER_CONFIG,`.
      _set5 `       ` ms_name-g_itab `_FIELDCAT_CBO TYPE ` iv_alv_class `=>TT_FCAT_CONFIG.`.
    ENDIF.
    IF iv_alv_class IS INITIAL.
      _set7 `DATA : ` ms_name-g_obj `_` iv_alv_key `   TYPE REF TO ` ms_acg_config-alv_class `,`.
    ELSE.
      _set7 `DATA : ` ms_name-g_obj `_` iv_alv_key `   TYPE REF TO ` iv_alv_class `,`.
    ENDIF.
    _set5 `       ` ms_name-g_obj `_DATA_` iv_alv_key `   TYPE REF TO DATA,`.
    _set3 `       ` ms_name-g_obj `_STRUC TYPE REF TO DATA,`.

    _set7 `       ` ms_name-g_obj `_CONTAINER_`  iv_alv_key ` TYPE REF TO ` lv_container `.`.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&  FIELD-SYMBOLS`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set5 `FIELD-SYMBOLS : <` ms_name-g_fieldsymbol_t `_` iv_alv_key `>  TYPE STANDARD TABLE,`.
    _set5 `                <` ms_name-g_fieldsymbol_s `_S` iv_alv_key `> TYPE ANY.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_initialization.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------**`.
    _set1 `* INITIALIZATION.`.
    _set1 `*&---------------------------------------------------------------------**`.
    _set1 `INITIALIZATION.`.
    IF ms_acg_config-is_standalone EQ abap_true.
      _set1 `*  PERFORM CREATE_INIT_DYN_OBJ."최초 실행시 주석을 풀고 1회 실행하여 Screen을 생성시킨다.`.
    ENDIF.
    _set1 `  PERFORM SET_INIT_VALUE.`.
    IF ms_acg_config-is_1step EQ abap_true.
      _set1 `  PERFORM CHECK_AUTHORITY.`.
    ENDIF.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_inst_click.
    CLEAR mt_code.

    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_itab.
    CLEAR mt_code.
    _set5 `DATA : BEGIN OF ` ms_name-g_wa `_` iv_alv_key `,`.
    _set1 `       BALV_STATUS_ICON TYPE ICON-ID.`.
    _set3 `      .INCLUDE TYPE ` iv_tabnm `. `.
    _set1 `DATA : CELLTAB TYPE LVC_T_STYL,`.
    _set1 `       COLTAB TYPE LVC_T_SCOL,`.
    _set1 `       RCOLOR(4), "c_alv_yellow, blue, green, red`.
    _set5 `END OF ` ms_name-g_wa `_` iv_alv_key `.`.

    _add4 `DATA ` ms_name-g_wa `_` iv_alv_key.
    _add5 ` LIKE TABLE OF ` ms_name-g_wa `_` iv_alv_key `.`.
    _append.

    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_layout_code.
    CLEAR mt_code.
    _set3 `CLEAR ` iv_layout_name `.`.
    _set5 `` iv_layout_name `-PROGID = '`  is_layout_cbo-progid `'.`.
    _set5 `` iv_layout_name `-ALV_KEY = '`  is_layout_cbo-alv_key `'.`.
    IF is_layout_cbo-zcreate EQ abap_true.
      _set3 `` iv_layout_name `-ZCREATE = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-zupdate EQ abap_true.
      _set3 `` iv_layout_name `-ZUPDATE = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-zdelete EQ abap_true.
      _set3 `` iv_layout_name `-ZDELETE = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-zexcel EQ abap_true.
      _set3 `` iv_layout_name `-ZEXCEL = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-zrefresh EQ abap_true.
      _set3 `` iv_layout_name `-ZREFRESH = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-db_click EQ abap_true.
      _set3 `` iv_layout_name `-DB_CLICK = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-change_evt EQ abap_true.
      _set3 `` iv_layout_name `-CHANGE_EVT = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-after_refresh EQ abap_true.
      _set3 `` iv_layout_name `-AFTER_REFRESH = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-zebra EQ abap_true.
      _set3 `` iv_layout_name `-ZEBRA = ABAP_TRUE.`.
    ENDIF.

    _set5 `` iv_layout_name `-SEL_MODE = '`  is_layout_cbo-sel_mode `'.`.
    IF is_layout_cbo-edit EQ abap_true.
      _set3 `` iv_layout_name `-EDIT = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-optimize_all_cols EQ abap_true.
      _set3 `` iv_layout_name `-OPTIMIZE_ALL_COLS = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-ctab_fname IS NOT INITIAL.
      _set5 `` iv_layout_name `-CTAB_FNAME = '`  is_layout_cbo-ctab_fname `'.`.
    ENDIF.
    IF is_layout_cbo-info_fname IS NOT INITIAL.
      _set5 `` iv_layout_name `-INFO_FNAME = '`  is_layout_cbo-info_fname `'.`.
    ENDIF.
    IF is_layout_cbo-stylefname IS NOT INITIAL.
      _set5 `` iv_layout_name `-STYLEFNAME = '`  is_layout_cbo-stylefname `'.`.
    ENDIF.
    IF is_layout_cbo-no_totexp EQ abap_true.
      _set3 `` iv_layout_name `-NO_TOTEXP = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-no_totline EQ abap_true.
      _set3 `` iv_layout_name `-NO_TOTLINE = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-no_rowmark EQ abap_true.
      _set3 `` iv_layout_name `-NO_ROWMARK = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-no_rowins EQ abap_true.
      _set3 `` iv_layout_name `-NO_ROWINS = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-no_merging EQ abap_true.
      _set3 `` iv_layout_name `-NO_MERGING = ABAP_TRUE.`.
    ENDIF.
    _set5 `` iv_layout_name `-GRID_TITLE = '`  is_layout_cbo-grid_title `'.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_node_expand.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_NODE_EXPAND`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set5 `FORM ` iv_alv_key `_NODE_EXPAND USING ` ms_name-form_iv `_fieldname TYPE lvc_fname`.
    _set3 `                                       ` ms_name-form_iv `_node_key TYPE lvc_nkey.`.
    _set3 `  DATA: ` ms_name-l_data `_nodeid    TYPE lvc_nkey,`.
    _add4 `        ` ms_name-l_wa `_` iv_alv_key.
    _add5 `      LIKE LINE OF ` ms_name-g_itab `_` iv_alv_key `,`.
    _append.
    _add4 `        ` ms_name-l_itab `_` iv_alv_key.
    _add5 `      LIKE TABLE OF  ` ms_name-g_wa `_` iv_alv_key `,`.
    _append.
    _set3 `        ` ms_name-l_wa `_node_layout TYPE lvc_s_layn,`.
    _set3 `        ` ms_name-l_data `_node_text TYPE lvc_value.`.
    _add4 `  FIELD-SYMBOLS <` ms_name-l_fieldsymbol_s `_` iv_alv_key.
    _add5 `> LIKE LINE OF ` ms_name-g_itab `_` iv_alv_key `.      `.
    _append.
    _set5 `  ` ms_name-g_data `_operating_node_key = ` ms_name-form_iv `_node_key.`.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->get_line( EXPORTING i_node_key = ` ms_name-form_iv `_node_key`.
    _set5 `                     CHANGING c_outtab_line = ` ms_name-l_wa `_` iv_alv_key ` ).`.
    _set3 `  MESSAGE 'Implementate ` iv_alv_key `_NODE_EXPAND to get child node data' TYPE 'I' DISPLAY LIKE 'E'.`.
    _set1 ` "Get Child Node Data by Parents Node ID`.
    _set1 `*  SELECT *`.
    _set5 `*  INTO CORRESPONDING FIELDS OF TABLE ` ms_name-l_itab `_` iv_alv_key ``.
    _set2 `*  FROM ` iv_tabnm.
    _set5 `*  WHERE FIELD = ls_` iv_alv_key `-` iv_node_id_field `.`.

    _set1 `  IF sy-subrc EQ 0.`.
    _add4 `    LOOP AT ` ms_name-l_itab `_` iv_alv_key.
    _add5 ` ASSIGNING <` ms_name-l_fieldsymbol_s `_` iv_alv_key `>.`.
    _append.
    _set7 `      ` ms_name-l_data `_node_text = <` ms_name-l_fieldsymbol_s `_` iv_alv_key `>-node_txt.`.
    _set3 `*      ` ms_name-l_wa `_node_layout-expander = abap_true.`.
    _set5 `      ` ms_name-g_obj `_` iv_alv_key `->add_node(`.
    _set1 `              EXPORTING`.
    _set3 `                i_relat_node_key = ` ms_name-form_iv `_node_key`.
    _set1 `                i_relationship   = cl_gui_column_tree=>relat_last_child`.
    _set3 `                i_node_text      = ` ms_name-l_data `_node_text`.
    _set3 `                is_node_layout  = ` ms_name-l_wa `_node_layout`.
    _set5 `                is_outtab_line   = <` ms_name-l_fieldsymbol_s `_` iv_alv_key `>`.
    _set1 `              IMPORTING`.
    _set3 `                e_new_node_key   = ` ms_name-l_data `_nodeid ).`.
    _set1 `    ENDLOOP.`.
    _set1 `  ENDIF.`.
    _set3 `ENDFORM. "` iv_alv_key `_NODE_EXPAND`.
    _set1 ``.


    rt_code = mt_code.


  ENDMETHOD.


  METHOD get_report_header.
    CLEAR mt_code.
    DATA : lv_date TYPE string.
    DATA : lv_progid(20) TYPE c.
    DATA lv_module TYPE dd07t-ddtext.
    DATA lv_smodule TYPE rstxtlg.
    lv_progid = ms_acg_config-progid.
    CONCATENATE sy-datum(4) '.' sy-datum+4(2) '.' sy-datum+6(2) INTO lv_date.
    _set1 `*************************************************************************`.
    _add1 `* MODULES / SUB MODULE : `.

    SELECT SINGLE ddtext INTO lv_module
    FROM dd07t
    WHERE domname = 'ZD_MODULE'
      AND domvalue_l = lv_progid+2(2).

    _add1  lv_module.
    _add1  ` / `.

*    SELECT SINGLE txtlg INTO lv_smodule
*    FROM ztbrdsubmodule
*    WHERE zmodule = lv_progid+2(2)
*      AND zsubmodule = lv_progid+4(1).

    _add1  lv_smodule.
    _append.
    _set1 `*&---------------------------------------------------------------------`.
    _set2 `* T_CODE             : ` ms_acg_config-progid.
    _set1 `* WRITER             : BALV` .
    _set2 `* DATE               : ` lv_date.
    _set1 `* TYPE               : REPORT`.
    _set1 `* DESCRIPTION        : ` .
    _set1 `*`.
    _set1 `*************************************************************************`.
    _set1 `*              CHANGED HISTORY`.
    _set1 `*&---------------------------------------------------------------------**`.
    _set1 `*CHANGED  CHANGED DATE   WRITER       CR No.     DESCRIPTION`.
    _set1 `*&---------------------------------------------------------------------**`.
    _set3 `*  N      ` lv_date `     BALV                    CREATE       *`.
    _set1 `*************************************************************************`.
    _set3 `REPORT ` ms_acg_config-progid ` NO STANDARD PAGE HEADING.`.
    _set1 ``.
    DATA : lt_src TYPE TABLE OF ztbrd00090,
           ls_src TYPE ztbrd00090.
    SELECT * INTO TABLE lt_src
    FROM ztbrd00090
    WHERE uname = sy-uname
    ORDER BY zsort.
    IF lt_src IS NOT INITIAL.
      LOOP AT lt_src INTO ls_src.
        _set1 ls_src-inc.
      ENDLOOP.
    ELSE.
      IF ms_acg_config-is_standalone EQ abap_true.
        _set1 `INCLUDE ZBALV_STD_INC01.`.
        _set1 `INCLUDE ZBALV_STD_INC02.`.
      ELSE.
        _set1 `INCLUDE ZNBRD00010.`.
        _set1 `INCLUDE ZNBRD00020.`.
        _set1 `*INCLUDE ZNBRD00030.`.
      ENDIF.
    ENDIF.
    _set3 `INCLUDE ` ms_acg_config-progid `TOP.`.
    _set3 `INCLUDE ` ms_acg_config-progid `F01.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_rfsh_click.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_RFSH_CLICK`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_RFSH_CLICK.`.
    _add4 `  ` ms_name-g_data `_MODE_` iv_alv_key.
    _add5 ` = ` ms_name-g_obj `_` iv_alv_key `->GET_ALV_MODE( ).`.
    _append.
    _add4 `  ` ms_name-g_obj `_` iv_alv_key.
    _add5 `->REFRESH( ` ms_name-g_data `_MODE_` iv_alv_key ` ).`.
    _append.
    _set3 `ENDFORM.                    "` iv_alv_key `_RFSH_CLICK`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_save_click.
    CLEAR mt_code.

    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_SAVE_CLICK.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_SAVE_CLICK.`.
    _set5 `  DATA ` ms_name-l_itab `_TAB TYPE TABLE OF ` iv_tabnm ` WITH HEADER LINE .`.
    _set5 `  CLEAR : ` ms_name-g_itab `_ROWS[], ` ms_name-g_wa `_ROWS.`.
    _set5 `  ` ms_name-g_obj `_` iv_alv_key `->GET_SELECTED_ROWS(`.
    _set1 `   IMPORTING`.
    _set3 `     ET_INDEX_ROWS = ` ms_name-g_itab `_ROWS`.
    _set3 `     ET_ROW_NO     = ` ms_name-g_itab `_ROW_IDS ).`.
    _set1 ``.
    _set3 `  IF ` ms_name-g_itab `_ROWS[] IS INITIAL.`.
    _set1 `    MESSAGE i002(zBRD001).`.
    _set1 `    EXIT.`.
    _set1 `  ENDIF.`.
    _set1 ``.
    _set3 `  IF ` ms_acg_config-alv_class `=>CONFIRM_SAVE( ) NE ABAP_TRUE.`.
    _set1 `    EXIT.`.
    _set1 `  ENDIF.`.

    _set5 `  LOOP AT ` ms_name-g_itab `_ROWS INTO ` ms_name-g_wa `_ROWS WHERE ROWTYPE EQ SPACE.`.
    _set5 `    CLEAR ` ms_name-g_itab `_` iv_alv_key `.`.
    _set7 `    READ TABLE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-g_wa `_ROWS-INDEX.`.
    _set1 `    IF SY-SUBRC EQ 0.`.
    _set3 `      CLEAR ` ms_name-l_itab `_TAB.`.
    _set7 `      MOVE-CORRESPONDING ` ms_name-g_itab `_` iv_alv_key ` TO ` ms_name-l_itab `_TAB.`.
    _set3 `*        _set_timestamp_change ` ms_name-l_itab `_tab.`.
    _set3 `*        _set_timestamp_create ` ms_name-l_itab `_tab.`.
    _set3 `      APPEND ` ms_name-l_itab `_TAB.`.
    _set1 ``.
    _set1 `    ENDIF.`.
    _set1 `  ENDLOOP.`.
    _set1 `  TRY.`.
    _set3 `      PERFORM ` iv_alv_key `_VERIFY_DATA .`.
    _set3 `      IF ` ms_name-g_data `_ERR EQ ABAP_TRUE.`.
    _set5 `        MESSAGE  I003(ZBRD001) WITH ` ms_name-g_data `_MSG DISPLAY LIKE ` ms_name-g_constants `_E.`.
    _set5 `        ` ms_name-g_obj `_` iv_alv_key `->REFRESH( ).`.
    _set1 `        EXIT.`.
    _set1 `      ENDIF.`.
    _set5 `      IF ` ms_name-g_obj `_` iv_alv_key `->IS_CREATE_MODE( ) EQ ABAP_TRUE.`.
    _set5 `        MODIFY ` iv_tabnm ` FROM TABLE ` ms_name-l_itab `_TAB.`.
    _set1 `      ENDIF.`.
    _set5 `      IF ` ms_name-g_obj `_` iv_alv_key `->IS_CHANGE_MODE( ) EQ ABAP_TRUE.`.
    _set5 `        MODIFY ` iv_tabnm ` FROM TABLE ` ms_name-l_itab `_TAB.`.
    _set1 `      ENDIF.`.
    _set5 `      IF ` ms_name-g_obj `_` iv_alv_key `->IS_UPLOAD_MODE( ) EQ ABAP_TRUE.`.
    _set5 `        MODIFY ` iv_tabnm ` FROM TABLE ` ms_name-l_itab `_TAB.`.
    _set1 `      ENDIF.`.
    _set1 ``.
    _set1 `      IF SY-SUBRC NE 8.`.
    _set3 `        ` ms_acg_config-alv_class `=>COMMIT_SAVE( SY-DBCNT ).`.
    _set1 ``.
    _set3 `        PERFORM GET_` iv_alv_key `_DATA.`.
    _add4 `        ` ms_name-g_obj `_` iv_alv_key.
    _add5 `->DISPLAY( CHANGING CT_DATA  = ` ms_name-g_itab `_` iv_alv_key `[] ).`.
    _append.
    _set1 `      ELSE.`.
    _set3 `        ` ms_acg_config-alv_class `=>ROLLBACK_FAIL( ).`.
    _set1 `      ENDIF.`.
    _set3 `    CATCH CX_ROOT INTO ` ms_name-g_obj `_EXCEPTION.`.
    _set5 `      ` ms_acg_config-alv_class `=>CATCH_EXCEPTION( IO_ROOT = ` ms_name-g_obj `_EXCEPTION ).`.
    _set1 `  ENDTRY.`.
    _set1 ``.
    _set5 `  CLEAR <` ms_name-g_fieldsymbol_t `_` iv_alv_key `>[].`.
    _set3 `ENDFORM.                    "` iv_alv_key `_SAVE_CLICK.`.

    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_save_data.
    CLEAR mt_code.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_screen_100.
    CLEAR mt_code.
    _set1 `PROCESS BEFORE OUTPUT.`.
    _set1 `  MODULE SET_SCREEN.`.
    _set1 `  MODULE SET_ALV.`.
    IF ms_acg_config-is_1step EQ abap_true.
      _set1 `  MODULE SET_CURSOR.`.
    ENDIF.
    _set1 ``.
    _set1 `PROCESS AFTER INPUT.`.
    _set1 `  MODULE EXIT_SCREEN AT EXIT-COMMAND.`.
    IF ms_acg_config-is_1step EQ abap_true.
      _set1 `  MODULE GET_CURSOR.`.
    ENDIF.
    _set1 `  MODULE USER_COMMAND.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_screen_100_attr.

    "Screen
    et_container = VALUE #( ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
                              length = '000' height = '000' loop_block = '000' loop_disp = '000'
                              c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' ) ).
    "OK Code
    et_fields = VALUE #( ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
                           text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
                           height = '001' input_fld = 'X' format = 'CHAR'  ) ).

    IF ms_acg_config-is_1step EQ abap_true.
      "Custom Container
      APPEND VALUE #( type = 'CUST_CTRL' name = 'CON_' && ms_acg_config-alv_key element_of = 'SCREEN' line = '008' column = '001'
                      length = '255'  height = '193' loop_block = '000' loop_disp = '000'
                      c_resize_v = 'X' c_resize_h = 'X'
                      c_line_min = '015' c_coln_min = '090' tc_fixcol = '000' ) TO et_container.
      "Search Button
      APPEND VALUE #( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'PUSH' name = 'SEARCH'
                      text = 'Search' line = '006' column = '249' length = '006' vislength = '006'
                      height = '001' push_fcode = 'EXEC' format = 'CHAR' requ_entry = 'N' ) TO et_fields.
      "Frame
      APPEND VALUE #( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'FRAME' name = ms_acg_config-alv_key && '_BOX'
                      text = 'Select Options' line = '001' column = '001' length = '255' vislength = '255'
                      height = '007' format = 'CHAR' requ_entry = 'N' )  TO et_fields.

      get_screen_fields( EXPORTING it_fcat = it_fcat
                         IMPORTING et_fields = et_fields ).


    ENDIF.
  ENDMETHOD.


  METHOD get_screen_fields.
    DATA : lv_line(3)      TYPE n VALUE 1,
           lv_vislength(3) TYPE n,
           lv_cnt          TYPE i.
    DATA lv_ref_field TYPE fieldname.

    LOOP AT it_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE zkey = abap_true AND tech NE abap_true.
      ADD 1 TO lv_line.
      ADD 1 TO lv_cnt.

      IF lv_cnt > 5.
        EXIT.
      ENDIF.

      IF <ls_fcat>-dd_outlen > 18.
        lv_vislength = 18.
      ELSE.
        lv_vislength = <ls_fcat>-dd_outlen.
      ENDIF.
      IF <ls_fcat>-ref_field IS NOT INITIAL.
        lv_ref_field = <ls_fcat>-ref_field.
      ELSE.
        lv_ref_field = <ls_fcat>-fieldname.
      ENDIF.
      "Label
      APPEND VALUE #( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = <ls_fcat>-fieldname && '%'
                      text = <ls_fcat>-reptext line = lv_line column = '002' length = '018' vislength = '018'
                      height = '001' format = 'CHAR'  requ_entry = 'N' right_just = 'X'
                      labelleft = 'X' ) TO et_fields.
      "Select option Low
      APPEND VALUE #( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEMPLATE'
                      name = 'GS_SCREEN-' && <ls_fcat>-fieldname && '-LOW'
                      text = '_' line = lv_line column = '021' length = <ls_fcat>-dd_outlen vislength = lv_vislength
                      height = '001' format = <ls_fcat>-datatype input_fld = 'X' output_fld = 'X'
                      ref_field = lv_ref_field
                      matchcode = <ls_fcat>-ref_table ) TO et_fields.
      "Between ~
      APPEND VALUE #( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = <ls_fcat>-fieldname && '~'
                      text = '~' line = lv_line column = '040' length = '005' vislength = '005'
                      height = '001' format = 'CHAR'  requ_entry = 'N'
                      labelleft = 'X' ) TO et_fields.
      "Select option High
      APPEND VALUE #( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEMPLATE'
                      name = 'GS_SCREEN-' && <ls_fcat>-fieldname && '-HIGH'
                      text = '_' line = lv_line column = '046' length = <ls_fcat>-dd_outlen vislength = lv_vislength
                      height = '001' format = <ls_fcat>-datatype  input_fld = 'X' output_fld = 'X'
                      ref_field = lv_ref_field
                      matchcode = <ls_fcat>-ref_table ) TO et_fields.
      "Select option Button
      APPEND VALUE #( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'PUSH_TMPL'
                      name = 'GS_SCREEN-' && <ls_fcat>-fieldname && '-MULTI'
                      text = '___' with_icon = 'X' line = lv_line column = '065' length = '008' vislength = '004'
                      height = '001' push_fcode = 'FC_' && <ls_fcat>-fieldname format = 'CHAR'  output_fld = 'X'
                      requ_entry = 'N' ) TO et_fields.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_scr_1000.
    CLEAR mt_code.

    CHECK ms_acg_config-is_1step EQ abap_false.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&  SELECTION SCREEN`.
    _set1 `*&---------------------------------------------------------------------*`.
    IF iv_zexcel EQ 'X'.
      _set1 `SELECTION-SCREEN BEGIN OF LINE .`.
      _set3 `PARAMETERS ` ms_name-parameters `_DISP RADIOBUTTON GROUP R1 USER-COMMAND SET  DEFAULT 'X'.`.
      _set1 `SELECTION-SCREEN COMMENT 4(20) TEXT001 FOR FIELD PA_DISP.`.
      _set3 `PARAMETERS ` ms_name-parameters `_UP RADIOBUTTON GROUP R1.`.
      _set1 `SELECTION-SCREEN COMMENT (20) TEXT002 FOR FIELD PA_UP.`.
      _set1 `SELECTION-SCREEN END OF LINE.`.
      _set1 `SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT009.`.
      _set1 ``.

      set_define_select_screen( EXPORTING it_fcat = it_fcat iv_tabname = iv_tabnm ).

      _set1 ``.
      _set1 `SELECTION-SCREEN BEGIN OF LINE.`.
      _set1 `SELECTION-SCREEN COMMENT (20) TEXT003  MODIF ID UP.`.
      _set3 `PARAMETERS : ` ms_name-parameters `_FILE LIKE RLGRAP-FILENAME VISIBLE LENGTH 35 DEFAULT 'C:\' OBLIGATORY MODIF ID UP.`.
      _set3 `PARAMETER: ` ms_name-parameters `_UCOMM LIKE SY-UCOMM DEFAULT 'SAMP' NO-DISPLAY.`.
      _set1 `SELECTION-SCREEN END OF LINE.`.
      _set1 ``.
      _set1 `SELECTION-SCREEN BEGIN OF LINE.`.
      _set1 `SELECTION-SCREEN COMMENT (20) TEXT006 MODIF ID UP.`.
      _set3 `SELECTION-SCREEN PUSHBUTTON (14) ` ms_name-parameters `_SAMP USER-COMMAND SAMP MODIF ID UP.`.
      _set1 `SELECTION-SCREEN COMMENT (20) TEXT007 MODIF ID UP.`.
      _set1 `SELECTION-SCREEN END OF LINE.`.
      _set1 `SELECTION-SCREEN END OF BLOCK B1.`.
    ELSE.
      _set1 `SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT009.`.
      set_define_select_screen( EXPORTING it_fcat = it_fcat iv_tabname = iv_tabnm ).
      _set1 `SELECTION-SCREEN END OF BLOCK B1.`.
    ENDIF.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_selection_screen.
    CLEAR mt_code.
    CHECK ms_acg_config-is_1step EQ abap_false.

    IF iv_excel_upload EQ 'X'.
      _set1 `*&---------------------------------------------------------------------**`.
      _set1 `*  AT SELECTION-SCREEN`.
      _set1 `*&---------------------------------------------------------------------**`.
      _set1 `AT SELECTION-SCREEN.`.
      _set1 `  IF SSCRFIELDS-UCOMM EQ 'SAMP'.`.
      IF ms_acg_config-is_standalone EQ abap_true.
        _set1 `    PERFORM SET_ALV_CBO_CONFIG.`.
        _set5 `        ` ms_acg_config-alv_class `=>GET_ALV_ITAB( EXPORTING IT_FCAT_CONFIG = ` ms_name-g_itab `_FIELDCAT_CBO[]`.
        _set3 `                                        IMPORTING EO_DATA = ` ms_name-g_obj `_DOWNLOAD_DATA`.
        _set3 `                                             ET_HEADER_LABEL = ` ms_name-g_itab `_EXCEL_HEADER ).`.
        _set3 `      PERFORM SMW0_FILE_DOWNLOAD USING 'SAMPLE' '` ms_acg_config-progid `_SAMPLE01' 'XLSX'.`.
      ELSE.
        IF iv_alv_key EQ 'BALV' AND iv_fcat_key EQ 'DEFAULT'.
          _set5 `        ` ms_acg_config-alv_class `=>GET_ALV_ITAB( IMPORTING EO_DATA = ` ms_name-g_obj `_DOWNLOAD_DATA`.
          _set3 `                                             ET_HEADER_LABEL = ` ms_name-g_itab `_EXCEL_HEADER ).`.
        ELSE.
          _set5 `        ` ms_acg_config-alv_class `=>GET_ALV_ITAB( EXPORTING IV_ALV_KEY = '` iv_alv_key `'`.
          _set3 `                                                  IV_FCAT_KEY = '` iv_fcat_key `'`.
          _set3 `                                        IMPORTING EO_DATA = ` ms_name-g_obj `_DOWNLOAD_DATA`.
          _set3 `                                                  ET_HEADER_LABEL = ` ms_name-g_itab `_EXCEL_HEADER ).`.
        ENDIF.

        _set5 `        ASSIGN ` ms_name-g_obj `_DOWNLOAD_DATA->* TO <` ms_name-g_fieldsymbol_t `_DOWNLOAD_TAB>.`.
        _set5 `        PERFORM ITAB_TO_EXCEL_DOWNLOAD TABLES <` ms_name-g_fieldsymbol_t `_DOWNLOAD_TAB> ` ms_name-g_itab `_EXCEL_HEADER[] USING 'SAMPLE' '' . `.
*      _set3 `      PERFORM SMW0_FILE_DOWNLOAD USING 'SAMPLE' '` MS_ACG_CONFIG-progid `_SAMPLE01' 'XLSX'.`.
      ENDIF.
      _set1 `  ENDIF.`.
      _set1 `*&---------------------------------------------------------------------**`.
      _set1 `* AT SELECTION-SCREEN ON VALUE-REQUEST                                 *`.
      _set1 `*&---------------------------------------------------------------------**`.
      _set3 `AT SELECTION-SCREEN ON VALUE-REQUEST FOR ` ms_name-parameters `_FILE.`.
      _set5 `  ` ms_acg_config-alv_class `=>ADD_EXCEL_FILE_OPEN_DIALOG( CHANGING CV_FILE = ` ms_name-parameters `_FILE ).`.
      _set1 `*----------------------------------------------------------------------*`.
      _set1 `*  AT SELECTION-SCREEN OUTPUT`.
      _set1 `*----------------------------------------------------------------------*`.
      _set1 `AT SELECTION-SCREEN OUTPUT.`.
      _set1 `  LOOP AT SCREEN .`.
      _set1 `    CASE ABAP_TRUE.`.
      _set3 `      WHEN ` ms_name-parameters `_DISP.`.
      _set1 `        IF SCREEN-GROUP1 = 'DP' .`.
      _set1 `          SCREEN-INPUT = 1 .`.
      _set1 `          SCREEN-INVISIBLE = 0 .`.
      _set1 `        ELSEIF SCREEN-GROUP1 = 'UP'.`.
      _set1 `          SCREEN-INPUT = 0 .`.
      _set1 `          SCREEN-INVISIBLE = 1.`.
      _set1 `        ENDIF .`.
      _set3 `      WHEN ` ms_name-parameters `_UP.`.
      _set1 `        IF SCREEN-GROUP1 = 'UP' .`.
      _set1 `          SCREEN-INPUT = 1 .`.
      _set1 `          SCREEN-INVISIBLE = 0 .`.
      _set1 `        ELSEIF SCREEN-GROUP1 = 'DP'.`.
      _set1 `          SCREEN-INPUT = 0 .`.
      _set1 `          SCREEN-INVISIBLE = 1.`.
      _set1 `        ENDIF .`.
      _set1 `    ENDCASE.`.
      _set1 `    MODIFY SCREEN .`.
      _set1 `  ENDLOOP.`.
    ENDIF.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_set_alv.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      MODULE  SET_ALV  OUTPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE SET_ALV OUTPUT.`.
    IF ms_acg_config-is_1step EQ abap_true.
      _set5 `  IF ` ms_name-g_obj `_CONTAINER_` iv_alv_key ` IS INITIAL.`.
      _set4 `    CREATE OBJECT ` ms_name-g_obj `_CONTAINER_` iv_alv_key .
      _set1 `      EXPORTING`.
      _set3 `        CONTAINER_NAME = 'CON_` iv_alv_key `'.`.
      _set1 `  ENDIF.`.
    ELSE.
      _set3 `  IF ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT IS INITIAL.`.
      _set3 `    CREATE OBJECT ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT`.
      _set1 `      EXPORTING`.
      _set1 `        PARENT  = CL_GUI_CONTAINER=>DEFAULT_SCREEN`.
      _set1 `        ROWS    = 2`.
      _set1 `        COLUMNS = 1 .`.
      _set5 `    ` ms_name-g_obj `_CONTAINER_TITLE = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).`.
      _set7 `    ` ms_name-g_obj `_CONTAINER_` iv_alv_key ` = ` ms_name-g_obj `_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).`.
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
    _set5 `  IF ` ms_name-g_obj `_` iv_alv_key ` IS INITIAL.`.
    _set4 `    CREATE OBJECT ` ms_name-g_obj `_` iv_alv_key.
    _set1 `      EXPORTING`.
    _set4 `        IO_PARENT = ` ms_name-g_obj `_CONTAINER_` iv_alv_key .
    IF ms_acg_config-is_standalone EQ abap_true.
      _set3 `        IS_LAYOUT_CBO = ` ms_name-g_wa `_LAYOUT_CBO`.
    ENDIF.
    IF iv_alv_key <> 'BALV'.
      _set3 `        IV_ALV_KEY = '` iv_alv_key `'`.
    ENDIF.
    IF iv_fcat_key <> 'DEFAULT'.
      _set3 `        IV_FCAT_KEY = '` iv_fcat_key `'`.
    ENDIF.
    _set1 `.`.
    _set1 ``.
    IF iv_fcat_key <> 'DEFAULT'.
      _set7 `    ` ms_name-g_obj `_` iv_alv_key `->DISPLAY( EXPORTING IV_FCAT_KEY = '` iv_fcat_key `'`.
      IF ms_acg_config-is_standalone EQ abap_true.
        _set3 `                                          IS_LAYOUT_CBO = ` ms_name-g_wa `_LAYOUT_CBO`.
      ENDIF.
      _set5 `                                CHANGING CT_DATA = ` ms_name-g_itab `_` iv_alv_key `[] ).`.
    ELSE.
      IF ms_acg_config-is_standalone EQ abap_true.
        _set7 `    ` ms_name-g_obj `_` iv_alv_key `->DISPLAY( EXPORTING IT_FIELDCAT_CBO = ` ms_name-g_itab `_FIELDCAT_CBO`.
        _set5 `                                CHANGING CT_DATA = ` ms_name-g_itab `_` iv_alv_key `[] ).`.
      ELSE.
        _add4 `    ` ms_name-g_obj `_` iv_alv_key.
        _add5 `->DISPLAY( CHANGING CT_DATA = ` ms_name-g_itab `_` iv_alv_key `[] ).`.
        _append.
      ENDIF.

    ENDIF.


    _set1 `  ELSE.`.
    _set5 `    ` ms_name-g_obj `_` iv_alv_key `->REFRESH( ).`.
    _set1 `  ENDIF.`.

    _set1 `ENDMODULE.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_set_cursor.
    CLEAR mt_code.
    CHECK ms_acg_config-is_1step EQ abap_true.

    _set1 `*---------------------------------------------------------------------*`.
    _set1 `*      MODULE  SET_CURSOR OUTPUT`.
    _set1 `*---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE SET_CURSOR OUTPUT.`.
    _set1 `  IF GV_CURSOR_FIELD IS NOT INITIAL.`.
    _set1 `    SET CURSOR FIELD GV_CURSOR_FIELD.`.
    _set1 `  ENDIF.`.
    _set1 `ENDMODULE.                 " SET_CURSOR  OUTPUT`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_set_init_value.
    DATA ls_fcat TYPE ztbrd00020.
    CLEAR mt_code.
    DATA lv_cnt(2) TYPE n VALUE 9.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      FORM  SET_INIT_VALUE`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `FORM SET_INIT_VALUE .`.
    _set5 `  _INIT : ` ms_name-g_itab `_` iv_alv_key `.`.
    IF ms_acg_config-is_1step EQ abap_false.
      IF iv_excel_upload EQ 'X'.
        _set3 `  ` ms_name-parameters `_SAMP = 'Download'.`.
        _set1 `  TEXT001 = 'Display'.`.
        _set1 `  TEXT002 = 'Upload'.`.
        _set1 `  TEXT003 = 'File Path'.`.
        _set1 `  TEXT006 = 'Sample Excel'.`.
      ENDIF.
      _set1 `  TEXT009 = 'Select Options'.`.

      LOOP AT it_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'.
        ADD 1 TO lv_cnt.
        _set5 `  TEXT0` lv_cnt ` = '` ls_fcat-reptext `'.`.
      ENDLOOP.
      LOOP AT it_fcat INTO ls_fcat WHERE zkey NE 'X' AND tech NE 'X'.
        ADD 1 TO lv_cnt.
        _set5 `*  TEXT0` lv_cnt ` = '` ls_fcat-reptext `'.`.
      ENDLOOP.
    ENDIF.
    _set1 ``.
    _set1 `ENDFORM.                    " SET_INIT_VALUE`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_set_init_value_double.
    CLEAR mt_code.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA ls_fcat TYPE ztbrd00020.
    DATA ls_key_map TYPE gty_key_map.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      FORM  SET_INIT_VALUE`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `FORM SET_INIT_VALUE .`.
    _set5 `  _INIT : ` ms_name-g_itab `_` iv_alv_key `.`.
    IF ms_acg_config-is_1step EQ abap_false.
      _set1 `  TEXT009 = 'Select Options'.`.
      LOOP AT it_key_map INTO ls_key_map.
        ADD 1 TO lv_cnt.
        READ TABLE it_fcat INTO ls_fcat WITH KEY fieldname = ls_key_map-h_field.
        IF sy-subrc EQ 0.
          _set5 `  TEXT0` lv_cnt ` = '` ls_fcat-reptext `'.`.
        ELSE.
          _set5 `  TEXT0` lv_cnt ` = '` ls_key_map-h_field `'.`.
        ENDIF.
      ENDLOOP.
    ENDIF.
    _set1 ``.
    _set1 `ENDFORM.                    " SET_INIT_VALUE`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_set_screen.
    CLEAR mt_code.
    _set1 `*---------------------------------------------------------------------*`.
    _set1 `*      MODULE  SET_ALV_SCREEN  OUTPUT`.
    _set1 `*---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE SET_SCREEN OUTPUT.`.
    _set3 `  SET PF-STATUS '0100' EXCLUDING ` ms_name-g_itab `_EXCLUDE.`.
    _set1 `  SET TITLEBAR  '0100' WITH TEXT-T00.`.
    IF ms_acg_config-is_1step EQ abap_true.
      _set1 `  PERFORM SET_SELECT_OPTION.`.
    ENDIF.
    _set1 `ENDMODULE.                 " SET_ALV_SCREEN  OUTPUT`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_set_select_option.
    CLEAR mt_code.
    CHECK ms_acg_config-is_1step EQ abap_true.
    DATA : lv_index TYPE sy-tabix.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*& Form SET_SELECT_OPTION`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*& text`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*& -->  p1        text`.
    _set1 `*& <--  p2        text`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `FORM SET_SELECT_OPTION .`.
    _set1 `  _SET_RANGE_WITH_ICON : `.
    CLEAR lv_index.
    LOOP AT it_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE tech NE abap_true.
      ADD 1 TO lv_index.
      IF lv_index GT 1.
        _add1 `,`.
      ENDIF.
      _add2 `     ` <ls_fcat>-fieldname .
      _append.
    ENDLOOP.
    _set1 `.`.
    _set1 `ENDFORM.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_set_title.
    CLEAR mt_code.

    CHECK ms_acg_config-is_1step EQ abap_false.

    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lt_name TYPE TABLE OF char05.
    DATA lv_str TYPE string.
    DATA ls_fcat TYPE LINE OF gtt_fcat.
    DATA lt_fcat TYPE gtt_fcat.

    delete_dup_fcat( EXPORTING it_fcat = it_fcat
                     IMPORTING et_fcat = lt_fcat ).

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      FORM  SET_TITLE`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `FORM SET_TITLE .`.
    _set3 `  DATA : ` ms_name-l_obj `_TAB  TYPE REF TO CL_DD_TABLE_ELEMENT,`.
    _set3 `         ` ms_name-l_obj `_COL1 TYPE REF TO CL_DD_AREA,`.
    _set3 `         ` ms_name-l_obj `_COL2 TYPE REF TO CL_DD_AREA,`.
    _set3 `         ` ms_name-l_data `_TEXT TYPE SDYDO_TEXT_ELEMENT.`.
    _set1 ``.
    _set3 `  ` ms_name-l_data `_TEXT = TEXT009.`.
    _set5 `  ` ms_name-g_obj `_DOCUMENT->ADD_TEXT( EXPORTING TEXT = ` ms_name-l_data `_TEXT`.
    _set1 `                                   SAP_EMPHASIS = CL_DD_AREA=>STRONG`.
    _set1 `                                   SAP_FONTSIZE = CL_DD_AREA=>LARGE ).`.
    _set3 `  ` ms_name-g_obj `_DOCUMENT->NEW_LINE( ).`.
    _set3 `  ` ms_name-g_obj `_DOCUMENT->NEW_LINE( ).`.
    _set1 ``.
    _set3 `  ` ms_name-g_obj `_DOCUMENT->ADD_TABLE( EXPORTING NO_OF_COLUMNS = 2`.
    _set1 `                                    BORDER        = '0'`.
    _set1 `                                    WIDTH = '100%'`.
    _set3 `                          IMPORTING TABLE         = ` ms_name-l_obj `_TAB ).`.
    _set1 ``.
    _set3 `  ` ms_name-l_obj `_TAB->ADD_COLUMN( EXPORTING WIDTH  = '10%'`.
    _set3 `                      IMPORTING COLUMN = ` ms_name-l_obj `_COL1 ).`.
    _set3 `  ` ms_name-l_obj `_TAB->ADD_COLUMN( EXPORTING WIDTH  = '90%'`.
    _set3 `                      IMPORTING COLUMN = ` ms_name-l_obj `_COL2 ).`.

    LOOP AT lt_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'..
      ADD 1 TO lv_cnt.
      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_fcat-fieldname(5).
      IF sy-subrc EQ 0.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(3) lv_cnt '-LOW' INTO lv_str.
      ELSE.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(5) '-LOW' INTO lv_str.
        APPEND ls_fcat-fieldname(5) TO lt_name.
      ENDIF.
      _set3 `  IF ` lv_str ` IS NOT INITIAL.`.
      _set5 `    ` ms_name-l_data `_TEXT = TEXT0` lv_cnt `.`.
      _set5 `    ` ms_name-l_obj `_COL1->ADD_TEXT( EXPORTING TEXT         = ` ms_name-l_data `_TEXT`.
      _set1 `                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT`.
      _set1 `                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).`.
      _set5 `    ` ms_name-l_data `_TEXT = ` lv_str `.`.
      _set5 `    ` ms_name-l_obj `_COL2->ADD_TEXT( EXPORTING TEXT         = ` ms_name-l_data `_TEXT ).`.
      _set3 `    ` ms_name-l_obj `_TAB->NEW_ROW( ).`.
      _set1 `  ENDIF.`.
    ENDLOOP.

    LOOP AT lt_fcat INTO ls_fcat WHERE zkey NE 'X' AND tech NE 'X'..
      ADD 1 TO lv_cnt.
      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_fcat-fieldname(5).
      IF sy-subrc EQ 0.
        CONCATENATE '*' ms_name-selectoption '_' ls_fcat-fieldname(3) lv_cnt '-LOW' INTO lv_str.
      ELSE.
        CONCATENATE '*' ms_name-selectoption '_' ls_fcat-fieldname(5) '-LOW' INTO lv_str.
        APPEND ls_fcat-fieldname(5) TO lt_name.
      ENDIF.
      _set3 `*  IF ` lv_str ` IS NOT INITIAL.`.
      _set5 `*    ` ms_name-l_data `_TEXT = TEXT0` lv_cnt `.`.
      _set5 `*    ` ms_name-l_obj `_COL1->ADD_TEXT( EXPORTING TEXT         = ` ms_name-l_data `_TEXT`.
      _set1 `*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT`.
      _set1 `*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).`.
      _set5 `*    ` ms_name-l_data `_TEXT = ` lv_str `.`.
      _set5 `*    ` ms_name-l_obj `_COL2->ADD_TEXT( EXPORTING TEXT         = ` ms_name-l_data `_TEXT ).`.
      _set3 `*    ` ms_name-l_obj `_TAB->NEW_ROW( ).`.
      _set1 `*  ENDIF.`.
    ENDLOOP.
    _set1 ``.
    _set3 `  ` ms_name-g_obj `_DOCUMENT->MERGE_DOCUMENT( ).`.
    _set1 `ENDFORM.                    " SET_TITLE`.

    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_set_title_double.
    CHECK ms_acg_config-is_1step EQ abap_false.
    CLEAR mt_code.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lt_name TYPE TABLE OF char05.
    DATA lv_str TYPE string.
    DATA ls_fcat TYPE ztbrd00020.
    DATA ls_key_map TYPE gty_key_map.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      FORM  SET_TITLE`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `FORM SET_TITLE .`.
    _set3 `  DATA : ` ms_name-l_obj `_TAB  TYPE REF TO CL_DD_TABLE_ELEMENT,`.
    _set3 `         ` ms_name-l_obj `_COL1 TYPE REF TO CL_DD_AREA,`.
    _set3 `         ` ms_name-l_obj `_COL2 TYPE REF TO CL_DD_AREA,`.
    _set3 `         ` ms_name-l_data `_TEXT TYPE SDYDO_TEXT_ELEMENT.`.
    _set1 ``.
    _set3 `  ` ms_name-l_data `_TEXT = TEXT009.`.
    _set5 `  ` ms_name-g_obj `_DOCUMENT->ADD_TEXT( EXPORTING TEXT = ` ms_name-l_data `_TEXT`.
    _set1 `                                   SAP_EMPHASIS = CL_DD_AREA=>STRONG`.
    _set1 `                                   SAP_FONTSIZE = CL_DD_AREA=>LARGE ).`.
    _set3 `  ` ms_name-g_obj `_DOCUMENT->NEW_LINE( ).`.
    _set3 `  ` ms_name-g_obj `_DOCUMENT->NEW_LINE( ).`.
    _set1 ``.
    _set3 `  ` ms_name-g_obj `_DOCUMENT->ADD_TABLE( EXPORTING NO_OF_COLUMNS = 2`.
    _set1 `                                    BORDER        = '0'`.
    _set1 `                                    WIDTH = '100%'`.
    _set3 `                          IMPORTING TABLE         = ` ms_name-l_obj `_TAB ).`.
    _set1 ``.
    _set3 `  ` ms_name-l_obj `_TAB->ADD_COLUMN( EXPORTING WIDTH  = '10%'`.
    _set3 `                      IMPORTING COLUMN = ` ms_name-l_obj `_COL1 ).`.
    _set3 `  ` ms_name-l_obj `_TAB->ADD_COLUMN( EXPORTING WIDTH  = '90%'`.
    _set3 `                      IMPORTING COLUMN = ` ms_name-l_obj `_COL2 ).`.

    LOOP AT it_key_map INTO ls_key_map.
      ADD 1 TO lv_cnt.
      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_key_map-h_field(5).
      IF sy-subrc EQ 0.
        CONCATENATE ms_name-selectoption '_' ls_key_map-h_field(3) lv_cnt '-LOW' INTO lv_str.
      ELSE.
        CONCATENATE ms_name-selectoption '_' ls_key_map-h_field(5) '-LOW' INTO lv_str.
        APPEND ls_key_map-h_field(5) TO lt_name.
      ENDIF.
      _set3 `  IF ` lv_str ` IS NOT INITIAL.`.
      READ TABLE it_fcat INTO ls_fcat WITH KEY fieldname = ls_key_map-h_field.
      IF sy-subrc EQ 0.
        _set5 `*    ` ms_name-l_data `_TEXT = '` ls_fcat-reptext `'.`.
        _set5 `    ` ms_name-l_data `_TEXT = TEXT0` lv_cnt `.`.
      ELSE.
        _set5 `    ` ms_name-l_data `_TEXT = '` ls_key_map-h_field `'.`.
      ENDIF.
      _set5 `    ` ms_name-l_obj `_COL1->ADD_TEXT( EXPORTING TEXT         = ` ms_name-l_data `_TEXT`.
      _set1 `                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT`.
      _set1 `                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).`.
      _set5 `    ` ms_name-l_data `_TEXT = ` lv_str `.`.
      _set5 `    ` ms_name-l_obj `_COL2->ADD_TEXT( EXPORTING TEXT         = ` ms_name-l_data `_TEXT ).`.
      _set3 `    ` ms_name-l_obj `_TAB->NEW_ROW( ).`.
      _set1 `  ENDIF.`.
    ENDLOOP.
    _set1 ``.
    _set3 `  ` ms_name-g_obj `_DOCUMENT->MERGE_DOCUMENT( ).`.
    _set1 `ENDFORM.                    " SET_TITLE`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_set_toolbar.
    CLEAR mt_code.
    _set1 `**&---------------------------------------------------------------------*`.
    _set3 `**&      FORM  ` iv_alv_key `_SET_TOOLBAR`.
    _set1 `**&---------------------------------------------------------------------*`.
    _set1 `**       TEXT`.
    _set1 `**----------------------------------------------------------------------*`.
    _set3 `**      -->` ms_name-form_iv `_INTERACTIVE     TEXT`.
    _set3 `**      -->` ms_name-form_io `_OBJECT  TEXT`.
    _set1 `**----------------------------------------------------------------------*`.
    _set5 `*FORM ` iv_alv_key `_SET_TOOLBAR USING ` ms_name-form_iv `_INTERACTIVE`.
    _set3 `*                       ` ms_name-form_io `_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET.`.
    _set7 `*  ` ms_name-g_data `_FLAG = ` ms_name-g_obj `_` iv_alv_key `->IS_DISPLAY_MODE( ). `.
    _set3 `*  IF ` ms_name-g_data `_FLAG NE ABAP_TRUE .`.
    _set5 `*    ` ms_name-g_obj `_` iv_alv_key `->APPEND_TOOLBAR_BUTTON( EXPORTING`.
    _set1 `*                                   IV_FUNCTION = 'F01'`.
    _set1 `*                                   IV_ICON = '' "ICON-ID`.
    _set1 `*                                   IV_QUICKINFO = '' `.
    _set1 `*                                   IV_TEXT = 'MY TOOLBAR'`.
    _set1 `*                                   ).`.
    _set1 `*  ENDIF.`.
    _set3 `*ENDFORM.                    "` iv_alv_key `_SET_TOOLBAR`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_start_of_selection.
    CLEAR mt_code.

    CHECK ms_acg_config-is_1step EQ abap_false.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*& START-OF-SELECTION.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `START-OF-SELECTION.`.
    IF iv_excel_upload EQ 'X'.
      _set1 `  PERFORM CHECK_AUTHORITY.`.
      _set3 `  CASE ` ms_name-g_constants `_X.`.
      _set3 `    WHEN ` ms_name-parameters `_DISP.`.
      _set7 `      ` ms_name-g_data `_MODE_` iv_alv_key ` = ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE.`.
      _set3 `      PERFORM GET_` iv_alv_key `_DATA.`.
      _set3 `    WHEN ` ms_name-parameters `_UP.`.
      _set7 `      ` ms_name-parameters `_MODE_` iv_alv_key ` = ` ms_acg_config-alv_class `=>MC_UPLOAD_MODE.`.
      _set5 `      PERFORM UPLOAD_` iv_alv_key `_DATA USING ABAP_FALSE ` ms_name-parameters `_FILE.`.
      _set3 `      IF ` ms_name-g_data `_ERR = ABAP_TRUE.`.
      _set1 `        EXIT.`.
      _set1 `      ENDIF.`.
      _set1 `  ENDCASE.`.
    ELSE.
      _set1 `  PERFORM CHECK_AUTHORITY.`.
      _set7 `  ` ms_name-g_data `_MODE_` iv_alv_key ` = ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE.`.
      _set3 `  PERFORM GET_` iv_alv_key `_DATA.`.
    ENDIF.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_struct_line.
    DATA lv_len TYPE string.
    DATA lv_dec TYPE string.
    DATA lv_intlen TYPE intlen.
    DATA ls_fcat TYPE ztbrd00020.
    CLEAR mt_code.


    LOOP AT it_fcat INTO ls_fcat.
      CHECK ls_fcat-fieldname <> 'BALV_STATUS_ICON'.
      IF ls_fcat-ref_table IS INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = ls_fcat-intlen
          IMPORTING
            output = lv_intlen.
        lv_len = lv_intlen .
        lv_dec = ls_fcat-decimals.
        CASE ls_fcat-datatype.
          WHEN 'DEC'.       _set7 `       ` ls_fcat-fieldname ` TYPE P LENGTH ` lv_len ` DECIMALS ` lv_dec `,`.
          WHEN 'INT1'.      _set5 `       ` ls_fcat-fieldname ` TYPE ` ls_fcat-datatype `,`.
          WHEN 'INT2'.      _set5 `       ` ls_fcat-fieldname ` TYPE ` ls_fcat-datatype `,`.
          WHEN 'INT4'.      _set5 `       ` ls_fcat-fieldname ` TYPE ` ls_fcat-datatype `,`.
          WHEN 'CURR'.      _set7 `       ` ls_fcat-fieldname ` TYPE P LENGTH ` lv_len ` DECIMALS ` lv_dec `,`.
          WHEN 'CUKY'.      _set5 `       ` ls_fcat-fieldname ` TYPE C LENGTH ` lv_len `,`.
          WHEN 'QUAN'.      _set7 `       ` ls_fcat-fieldname ` TYPE P LENGTH ` lv_len ` DECIMALS ` lv_dec `,`.
          WHEN 'UNIT'.      _set5 `       ` ls_fcat-fieldname ` TYPE C LENGTH ` lv_len `,`.
          WHEN 'FLTP'.      _set3 `       ` ls_fcat-fieldname ` TYPE F,`.
          WHEN 'NUMC'.      _set5 `       ` ls_fcat-fieldname ` TYPE N LENGTH ` lv_len `,`.
          WHEN 'CHAR'.      _set5 `       ` ls_fcat-fieldname ` TYPE C LENGTH ` lv_len `,`.
          WHEN 'LCHR'.      _set5 `       ` ls_fcat-fieldname ` TYPE C LENGTH ` lv_len `,`.
          WHEN 'STRING'.    _set3 `       ` ls_fcat-fieldname ` TYPE STRING,`.
          WHEN 'RAWSTRING'. _set3 `       ` ls_fcat-fieldname ` TYPE STRING,`.
          WHEN 'DATS'.      _set3 `       ` ls_fcat-fieldname ` TYPE SY-DATUM,`.
          WHEN 'ACCP'.      _set5 `       ` ls_fcat-fieldname ` TYPE C LENGTH ` lv_len `,`.
          WHEN 'TIMS'.      _set5 `       ` ls_fcat-fieldname ` TYPE C LENGTH ` lv_len `,`.
          WHEN 'RAW'.       _set3 `       ` ls_fcat-fieldname ` TYPE STRING,`.
          WHEN 'LRAW'.      _set3 `       ` ls_fcat-fieldname ` TYPE STRING,`.
          WHEN 'CLNT'.      _set3 `       ` ls_fcat-fieldname ` TYPE SY-MANDT,`.
          WHEN 'LANG'.      _set3 `       ` ls_fcat-fieldname ` TYPE SY-LANGU,`.
        ENDCASE.
      ELSE.
        IF ls_fcat-ref_field IS INITIAL.
          _set7 `       ` ls_fcat-fieldname ` TYPE ` ls_fcat-ref_table `-` ls_fcat-fieldname `,`.
        ELSE.
          _set7 `       ` ls_fcat-fieldname ` TYPE ` ls_fcat-ref_table `-` ls_fcat-ref_field `,`.
        ENDIF.
      ENDIF.
    ENDLOOP.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_tree_fcat_code.
    CLEAR mt_code.
    _set3 `CLEAR ` ms_name-l_wa `_FCAT_CBO.`.
    _set4 ms_name-l_wa `_FCAT_CBO-PROGID = '`  is_fcat-progid `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-ALV_KEY = '`  is_fcat-alv_key `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-FCAT_KEY = '`  is_fcat-fcat_key `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-COL_POS = '`  is_fcat-col_pos `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-FIELDNAME = '`  is_fcat-fieldname `'.`.

    IF is_fcat-node EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-NODE = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-parents_node EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-PARENTS_NODE = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-sortidx EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-SORTIDX = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-node_txt EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-NODE_TXT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-zkey EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-ZKEY = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-fix_column EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-FIX_COLUMN = ABAP_TRUE.`.
    ENDIF.
    _set4 ms_name-l_wa `_FCAT_CBO-REPTEXT = '`  is_fcat-reptext `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-SCRTEXT_S = '`  is_fcat-scrtext_s `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-SCRTEXT_M = '`  is_fcat-scrtext_m `'.`.
    _set4 ms_name-l_wa `_FCAT_CBO-SCRTEXT_L = '`  is_fcat-scrtext_l `'.`.
    IF is_fcat-icon EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-ICON = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-col_opt EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-COL_OPT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-outputlen IS NOT INITIAL.
      _set4 ms_name-l_wa `_FCAT_CBO-OUTPUTLEN = '`  is_fcat-outputlen `'.`.
    ENDIF.
    IF is_fcat-checkbox EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-CHECKBOX = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-no_out EQ abap_true.
      _set2 ms_name-l_wa `_FCAT_CBO-NO_OUT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-tech EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-TECH = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-just  IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-JUST = '`  is_fcat-just `'.`.
    ENDIF.
    IF is_fcat-no_sign EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-NO_SIGN = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-no_zero EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-NO_ZERO = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-edit_mask  IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-EDIT_MASK = '`  is_fcat-edit_mask `'.`.
    ENDIF.
    IF is_fcat-emphasize  IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-EMPHASIZE = '`  is_fcat-emphasize `'.`.
    ENDIF.
    IF is_fcat-do_sum IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DO_SUM = '`  is_fcat-do_sum `'.`.
    ENDIF.
    IF is_fcat-no_sum EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-NO_SUM = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-lowercase EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-LOWERCASE = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-no_convext EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-NO_CONVEXT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-convexit IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-CONVEXIT = '`  is_fcat-convexit `'.`.
    ENDIF.
    IF is_fcat-hotspot EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-HOTSPOT = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-f4availabl EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-F4AVAILABL = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-no_merging EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-NO_MERGING = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-drdn_hndl IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DRDN_HNDL = '`  is_fcat-drdn_hndl `'.`.
    ENDIF.
    IF is_fcat-drdn_alias EQ abap_true.
      _set2 ms_name-l_wa  `_FCAT_CBO-DRDN_ALIAS = ABAP_TRUE.`.
    ENDIF.
    IF is_fcat-drdn_field IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DRDN_FIELD = '`  is_fcat-drdn_field `'.`.
    ENDIF.
    IF is_fcat-ref_table IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-REF_TABLE = '`  is_fcat-ref_table `'.`.
    ENDIF.
    IF is_fcat-ref_field IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-REF_FIELD = '`  is_fcat-ref_field `'.`.
    ENDIF.
    IF is_fcat-checktable IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-CHECKTABLE = '`  is_fcat-checktable `'.`.
    ENDIF.
    IF is_fcat-datatype IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DATATYPE = '`  is_fcat-datatype `'.`.
    ENDIF.
    IF is_fcat-inttype IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-INTTYPE = '`  is_fcat-inttype `'.`.
    ENDIF.
    IF is_fcat-intlen IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-INTLEN = '`  is_fcat-intlen `'.`.
    ENDIF.
    IF is_fcat-currency IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-CURRENCY = '`  is_fcat-currency `'.`.
    ENDIF.
    IF is_fcat-cfieldname IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-CFIELDNAME = '`  is_fcat-cfieldname `'.`.
    ENDIF.
    IF is_fcat-quantity IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-QUANTITY = '`  is_fcat-quantity `'.`.
    ENDIF.
    IF is_fcat-qfieldname IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-QFIELDNAME = '`  is_fcat-qfieldname `'.`.
    ENDIF.
    IF is_fcat-decimals IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DECIMALS = '`  is_fcat-decimals `'.`.
    ENDIF.
    IF is_fcat-decimals_o IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DECIMALS_O = '`  is_fcat-decimals_o `'.`.
    ENDIF.
    IF is_fcat-style IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-STYLE = '`  is_fcat-style `'.`.
    ENDIF.
    IF is_fcat-rollname IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-ROLLNAME = '`  is_fcat-rollname `'.`.
    ENDIF.
    IF is_fcat-decmlfield IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DECMLFIELD = '`  is_fcat-decmlfield `'.`.
    ENDIF.
    IF is_fcat-dd_roll IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DD_ROLL = '`  is_fcat-dd_roll `'.`.
    ENDIF.
    IF is_fcat-domname IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DOMNAME = '`  is_fcat-domname `'.`.
    ENDIF.
    IF is_fcat-dd_outlen IS NOT INITIAL.
      _set4 ms_name-l_wa  `_FCAT_CBO-DD_OUTLEN = '`  is_fcat-dd_outlen `'.`.
    ENDIF.

    _set5 `APPEND ` ms_name-l_wa `_FCAT_CBO TO ` iv_fcat_name `.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_tree_itab.
    CLEAR mt_code.

    _set5 `DATA : BEGIN OF ` ms_name-g_wa `_` iv_alv_key `.`.
    _set3 `      .INCLUDE TYPE ` iv_tabnm `. `.
    _set1 `      .INCLUDE TYPE LVC_S_LAYN.`.
    _set5 `DATA : END OF ` ms_name-g_wa `_` iv_alv_key `.`.
    _add4 `DATA ` ms_name-g_itab `_` iv_alv_key.
    _add5 ` LIKE TABLE OF ` ms_name-g_wa `_` iv_alv_key `.`.
    _append.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_tree_layout_code.
    CLEAR mt_code.
    _set3 `CLEAR ` iv_layout_name `.`.
    _set5 `` iv_layout_name `-PROGID = '`  is_layout_cbo-progid `'.`.
    _set5 `` iv_layout_name `-ALV_KEY = '`  is_layout_cbo-alv_key `'.`.
    IF is_layout_cbo-db_click EQ abap_true.
      _set3 `` iv_layout_name `-DB_CLICK = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-context_menu EQ abap_true.
      _set3 `` iv_layout_name `-CONTEXT_MENU = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-check_box_change EQ abap_true.
      _set3 `` iv_layout_name `-CHECK_BOX_CHANGE = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-key_press EQ abap_true.
      _set3 `` iv_layout_name `-KEY_PRESS = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-link_click EQ abap_true.
      _set3 `` iv_layout_name `-LINK_CLICK = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-optimize_all_cols EQ abap_true.
      _set3 `` iv_layout_name `-OPTIMIZE_ALL_COLS = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-t_image is not INITIAL.
      _set5 `` iv_layout_name `-T_IMAGE = '`  is_layout_cbo-t_image `'.`.
    ENDIF.
    IF is_layout_cbo-heading is not INITIAL.
      _set5 `` iv_layout_name `-HEADING = '`  is_layout_cbo-heading `'.`.
    ENDIF.
    IF is_layout_cbo-tooltip is not INITIAL.
      _set5 `` iv_layout_name `-TOOLTIP = '`  is_layout_cbo-tooltip `'.`.
    ENDIF.
    IF is_layout_cbo-width > 0.
      _set5 `` iv_layout_name `-WIDTH = `  is_layout_cbo-width `.`.
    ENDIF.
    IF is_layout_cbo-width_pix EQ abap_true.
      _set3 `` iv_layout_name `-WIDTH_PIX = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-node_selection_mode > 0.
      _set5 `` iv_layout_name `-NODE_SELECTION_MODE = `  is_layout_cbo-node_selection_mode `.`.
    ENDIF.
    IF is_layout_cbo-item_selection EQ abap_true.
      _set3 `` iv_layout_name `-ITEM_SELECTION = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-no_html_header EQ abap_true.
      _set3 `` iv_layout_name `-NO_HTML_HEADER = ABAP_TRUE.`.
    ENDIF.
    IF is_layout_cbo-no_toolbar EQ abap_true.
      _set3 `` iv_layout_name `-NO_TOOLBAR = ABAP_TRUE.`.
    ENDIF.


    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_upload_click_form.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_UPLD_CLICK`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_UPLD_CLICK.`.
    _set5 `  IF ` ms_name-g_obj `_DATA_` iv_alv_key ` IS INITIAL.`.
    _add4 `    CREATE DATA ` ms_name-g_obj `_DATA_` iv_alv_key.
    _add5 ` LIKE STANDARD TABLE OF ` ms_name-g_itab `_` iv_alv_key `.`.
    _append.
    _add4 `    ASSIGN ` ms_name-g_obj `_DATA_` iv_alv_key.
    _add5  `->* TO <` ms_name-g_fieldsymbol_t `_` iv_alv_key `>.`.
    _append.
    _set1 `  ENDIF.`.
    _set5 `  CLEAR <` ms_name-g_fieldsymbol_t `_` iv_alv_key `>[].`.
    _add4 `  <` ms_name-g_fieldsymbol_t `_` iv_alv_key.
    _add5 `>[] = ` ms_name-g_itab `_` iv_alv_key `[].`.
    _append.
    _set5 `  CLEAR ` ms_name-g_itab `_` iv_alv_key `[].`.
    _set3 `  PERFORM UPLOAD_` iv_alv_key `_DATA USING ABAP_TRUE ''.`.
    _set3 `  IF ` ms_name-g_data `_ERR = ABAP_TRUE.`.
    _set1 `    EXIT.`.
    _set1 `  ENDIF.`.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_UPLOAD_MODE`.
    _set5 `                   CHANGING CT_DATA  = ` ms_name-g_itab `_` iv_alv_key `[] ).`.
    _set1 ``.
    _set1 `ENDFORM.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_upload_data_form.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  UPLOAD_` iv_alv_key `_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set7 `FORM UPLOAD_` iv_alv_key `_DATA USING ` ms_name-form_iv `_FILE_DIALOG ` ms_name-form_iv `_FILE_NAME.`.
    _set7 `  DATA ` ms_name-l_itab `_TAB TYPE TABLE OF ` ms_name-g_type `_` iv_alv_key `.`.
    _set7 `  DATA ` ms_name-l_wa `_TAB TYPE ` ms_name-g_type `_` iv_alv_key `.`.
    _set3 `  CLEAR ` ms_name-g_data `_ERR.`.
    _set3 `  CALL METHOD ` ms_acg_config-alv_class `=>EXCEL_UPLOAD`.
    _set1 `    EXPORTING`.
    _set3 `      IV_FILE_DIALOG = ` ms_name-form_iv `_FILE_DIALOG`.
    _set3 `      IV_FILE_NAME   = ` ms_name-form_iv `_FILE_NAME`.
    _set1 `    CHANGING`.
    _set3 `      CT_DATA        = ` ms_name-l_itab `_TAB[] `.
    _set1 `    RECEIVING`.
    _set3 `      EV_SUBRC       = ` ms_name-g_data `_SUBRC.`.
    _set3 `  IF ` ms_name-g_data `_SUBRC EQ 0.`.
    _set5 `    LOOP AT ` ms_name-l_itab `_TAB INTO ` ms_name-l_wa `_TAB.`.
    _set7 `      MOVE-CORRESPONDING ` ms_name-l_wa `_TAB TO ` ms_name-g_itab `_` iv_alv_key `.`.
    _set5 `      APPEND ` ms_name-g_itab `_` iv_alv_key `.`.
    _set7 `      CLEAR : ` ms_name-l_wa `_TAB, ` ms_name-g_itab `_` iv_alv_key `.`.
    _set1 `    ENDLOOP.`.
    _set1 `  ELSE.`.
    _set3 `    MESSAGE S004(ZBRD001) DISPLAY LIKE ` ms_name-g_constants `_E.`.
    _set3 `    ` ms_name-g_data `_ERR = ABAP_TRUE.`.
    _set1 `  ENDIF.`.
    _set1 ``.
    _set1 `ENDFORM.                    " UPLOAD_DATA`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_user_command.
    CLEAR mt_code.

    DATA lv_cnt(2) TYPE n VALUE 9.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      Module  USER_COMMAND  INPUT`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       text`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `MODULE USER_COMMAND INPUT.`.
    _set3 `  CASE ` ms_name-g_data `_OKCODE.`.
    IF ms_acg_config-is_1step EQ abap_true.
      _set1 `    WHEN C_UCOMM-ENTER. "Forced PBO Excute`.
      _set1 `    WHEN C_UCOMM-EXCUTE.`.
      _set3 `      PERFORM GET_` is_alv_config-alv_key `_DATA.`.
      LOOP AT it_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE zkey EQ abap_true AND tech EQ abap_false.

        ADD 1 TO  lv_cnt.
        _set3 `    WHEN 'FC_` <ls_fcat>-fieldname `'.`.
        _add2 `      _SET_RANGE_EXTENSION ` <ls_fcat>-fieldname.
        _add7  ` '` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `' TEXT-T` lv_cnt `.`.
        _append.
      ENDLOOP.
      LOOP AT it_fcat ASSIGNING <ls_fcat> WHERE zkey EQ abap_false AND tech EQ abap_false.
        ADD 1 TO  lv_cnt.
        _set3 `*    WHEN 'FC_` <ls_fcat>-fieldname `'.`.
        _add2 `*      _SET_RANGE_EXTENSION ` <ls_fcat>-fieldname.
        _add7  ` '` <ls_fcat>-ref_table `-` <ls_fcat>-fieldname `' TEXT-T` lv_cnt `.`.
        _append.
      ENDLOOP.
    ENDIF.
    IF is_alv_config-zcreate EQ abap_true
       OR is_alv_config-zupdate EQ abap_true
       OR is_alv_config-zdelete EQ abap_true.
      _set3 `    WHEN ` ms_name-g_constants `_UCOMM-SAVE.`.
      _set1 `      PERFORM SAVE_DATA.`.
    ELSE.
      _set3 `*    WHEN ` ms_name-g_constants `_UCOMM-SAVE.`.
      _set1 `*      PERFORM SAVE_DATA.`.
    ENDIF.
    _set1 `  ENDCASE.`.
    _set1 `  CLEAR GV_OKCODE.`.
    _set1 `ENDMODULE.`.

    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_verify_data.
    DATA ls_fcat TYPE ztbrd00020.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_VERIFY_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_VERIFY_DATA.`.
    _set3 `  DEFINE ` ms_name-l_define `SET_ERR.`.
    _set3 `    ` ms_name-g_data `_ERR = C_X.`.
    _set3 `    ` ms_name-g_data `_MSG = &1.`.
    _set5 `    ` ms_name-g_itab `_` iv_alv_key `-BALV_STATUS_ICON = ICON_DEFECT.`.
    _set5 `    MODIFY ` ms_name-g_itab `_` iv_alv_key ` TRANSPORTING BALV_STATUS_ICON.`.
    _set1 `    CONTINUE.`.
    _set1 `  END-OF-DEFINITION.`.
    _set5 `  CLEAR : ` ms_name-g_data `_MSG, ` ms_name-g_data `_ERR.`.
    _set5 `  LOOP AT ` ms_name-g_itab `_` iv_alv_key `.`.
*    _set3 `    CHECK GT_` IV_ALV_KEY `-BALV_STATUS_ICON EQ ICON_CHANGE.`.
    LOOP AT it_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'..
      _set7 `    IF ` ms_name-g_itab `_` iv_alv_key `-` ls_fcat-fieldname ` IS INITIAL.`.
      _set3 `      _SET_ERR '` ls_fcat-reptext `'.`.
      _set1 `    ENDIF.`.
    ENDLOOP.
    _set1 ``.
    _set1 `  ENDLOOP.`.
    _set3 `ENDFORM.                    " ` iv_alv_key `_VERIFY_DATA`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_where_query_string.
    DATA lt_name TYPE TABLE OF char05.

    IF ms_acg_config-is_1step EQ abap_true.
      rv_str = 'GS_FILTER-' && iv_fieldname.
    ELSE.
      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = iv_fieldname(5).
      IF sy-subrc EQ 0.
        CONCATENATE ms_name-selectoption '_' iv_fieldname(3) iv_cnt INTO rv_str.
      ELSE.
        CONCATENATE ms_name-selectoption'_' iv_fieldname(5) INTO rv_str.
        APPEND iv_fieldname(5) TO lt_name.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD set_annotation.
    FIELD-SYMBOLS <ls_code> TYPE string.
    LOOP AT ct_code ASSIGNING <ls_code>.
      <ls_code> = `*` && <ls_code>.
    ENDLOOP.
  ENDMETHOD.


  METHOD set_define_select_screen.
    DATA lv_cnt(2) TYPE n VALUE 9.
    DATA lt_name TYPE TABLE OF char05.
    DATA lv_str TYPE string.
    DATA ls_fcat TYPE ztbrd00020.
    DATA lt_fcat TYPE gtt_fcat.

    delete_dup_fcat( EXPORTING it_fcat = it_fcat
                     IMPORTING et_fcat = lt_fcat ).

    LOOP AT lt_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'.

      ADD 1 TO lv_cnt.
      _set1 `SELECTION-SCREEN BEGIN OF LINE.`.
      _set3 `SELECTION-SCREEN COMMENT (20) TEXT0` lv_cnt ` MODIF ID DP.`.
      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_fcat-fieldname(5).
      IF sy-subrc EQ 0.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(3) lv_cnt INTO lv_str.
      ELSE.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(5) INTO lv_str.
        APPEND ls_fcat-fieldname(5) TO lt_name.
      ENDIF.
      _set7 `SELECT-OPTIONS ` lv_str ` FOR ` iv_tabname `-` ls_fcat-fieldname ` MODIF ID DP.`.
      _set1 `SELECTION-SCREEN END OF LINE.`.
    ENDLOOP.

    LOOP AT lt_fcat INTO ls_fcat WHERE zkey NE 'X' AND tech NE 'X'.

      ADD 1 TO lv_cnt.
      _set1 `*SELECTION-SCREEN BEGIN OF LINE.`.
      _set3 `*SELECTION-SCREEN COMMENT (20) TEXT0` lv_cnt ` MODIF ID DP.`.
      READ TABLE lt_name TRANSPORTING NO FIELDS WITH KEY table_line = ls_fcat-fieldname(5).
      IF sy-subrc EQ 0.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(3) lv_cnt INTO lv_str.
      ELSE.
        CONCATENATE ms_name-selectoption '_' ls_fcat-fieldname(5) INTO lv_str.
        APPEND ls_fcat-fieldname(5) TO lt_name.
      ENDIF.
      _set7 `*SELECT-OPTIONS ` lv_str ` FOR ` iv_tabname `-` ls_fcat-fieldname ` MODIF ID DP.`.
      _set1 `*SELECTION-SCREEN END OF LINE.`.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
