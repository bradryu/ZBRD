*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD00100F01
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*      MODULE  SET_ALV_SCREEN  OUTPUT
*---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE set_screen OUTPUT.
  SET PF-STATUS '0100' EXCLUDING gt_exclude.
  SET TITLEBAR  '0100' WITH TEXT-t00.
ENDMODULE.                 " SET_ALV_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*&      MODULE  SET_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE set_alv OUTPUT.
  IF go_splitter_container_out IS INITIAL.
    CREATE OBJECT go_splitter_container_out
      EXPORTING
        parent  = cl_gui_container=>default_screen
        rows    = 2
        columns = 1.
    go_container_title = go_splitter_container_out->get_container( row = 1 column = 1 ).
    go_container_balv = go_splitter_container_out->get_container( row = 2 column = 1 ).
    go_splitter_container_out->set_row_height( id = 1 height = 20 ).
    CREATE OBJECT go_document.

    PERFORM set_title.

    go_document->display_document( parent = go_container_title ).
  ENDIF.

  PERFORM set_alv_cbo_config.

  IF go_balv IS INITIAL.
    CREATE OBJECT go_balv
      EXPORTING
        io_parent     = go_container_balv
        is_layout_cbo = gs_layout_cbo.

    go_balv->display( EXPORTING it_fieldcat_cbo = gt_fieldcat_cbo
                      CHANGING ct_data = gt_balv[] ).
  ELSE.
    go_balv->refresh( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      MODULE  EXIT_SCREEN  INPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE exit_screen INPUT.
  CASE gv_okcode.
    WHEN c_canc OR c_back.
      CASE go_balv->get_alv_mode( ).
        WHEN zcl_brd_alv_n=>mc_display_mode.
          LEAVE TO SCREEN 0.
*        WHEN ZCL_BRD_ALV_N=>MC_UPLOAD_MODE.
*          LEAVE TO SCREEN 0.
        WHEN zcl_brd_alv_n=>mc_create_mode.
          PERFORM balv_canc_click.
        WHEN zcl_brd_alv_n=>mc_change_mode.
          PERFORM balv_canc_click.
      ENDCASE.
    WHEN c_exit.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR gv_okcode.
ENDMODULE.                 " EXIT_SCREEN  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command INPUT.
  CASE gv_okcode.
    WHEN c_ucomm-save.
      PERFORM save_data.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      FORM  SET_INIT_VALUE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM set_init_value .
  _init : gt_balv.
  text009 = TEXT-t09. "Select Options
  text010 = 'User Name'."text-t10
*  TEXT011 = 'Count'."text-t11

ENDFORM.                    " SET_INIT_VALUE
*&---------------------------------------------------------------------*
*&      FORM  CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM check_authority .

ENDFORM.                    " CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*&      FORM  GET_BALV_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM get_balv_data .
  _init : gt_balv.
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE gt_balv
    FROM ztbrd00100
    WHERE uname IN so_uname
*      AND ACG_CNT IN SO_ACG_C
.
ENDFORM.                    "GET_BALV_DATA
**&---------------------------------------------------------------------*
**&      FORM  UPLOAD_BALV_DATA
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM UPLOAD_BALV_DATA USING PV_FILE_DIALOG PV_FILE_NAME.
*  DATA LT_TAB TYPE TABLE OF GTY_BALV.
*  DATA LS_TAB TYPE GTY_BALV.
*  CLEAR GV_ERR.
*  CALL METHOD ZCL_BRD_ALV_N=>EXCEL_UPLOAD
*    EXPORTING
*      IV_FILE_DIALOG = PV_FILE_DIALOG
*      IV_FILE_NAME   = PV_FILE_NAME
*    CHANGING
*      CT_DATA        = LT_TAB[]
*    RECEIVING
*      EV_SUBRC       = GV_SUBRC.
*  IF GV_SUBRC EQ 0.
*    LOOP AT LT_TAB INTO LS_TAB.
*      MOVE-CORRESPONDING LS_TAB TO GT_BALV.
*      APPEND GT_BALV.
*      CLEAR : LS_TAB, GT_BALV.
*    ENDLOOP.
*    GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
*  ELSE.
*    MESSAGE S004(ZBRD001) DISPLAY LIKE C_E.
*    GV_ERR = ABAP_TRUE.
*  ENDIF.
*
*ENDFORM.                    " UPLOAD_DATA
*&---------------------------------------------------------------------*
*&      FORM  SET_TITLE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM set_title .
  DATA : lo_tab  TYPE REF TO cl_dd_table_element,
         lo_col1 TYPE REF TO cl_dd_area,
         lo_col2 TYPE REF TO cl_dd_area,
         lv_text TYPE sdydo_text_element.

  lv_text = text009.
  go_document->add_text( EXPORTING text = lv_text
                                   sap_emphasis = cl_dd_area=>strong
                                   sap_fontsize = cl_dd_area=>large ).
  go_document->new_line( ).
  go_document->new_line( ).

  go_document->add_table( EXPORTING no_of_columns = 2
                                    border        = '0'
                                    width = '100%'
                          IMPORTING table         = lo_tab ).

  lo_tab->add_column( EXPORTING width  = '10%'
                      IMPORTING column = lo_col1 ).
  lo_tab->add_column( EXPORTING width  = '90%'
                      IMPORTING column = lo_col2 ).
  IF so_uname-low IS NOT INITIAL.
    lv_text = text010.
    lo_col1->add_text( EXPORTING text         = lv_text
                                 sap_color    = cl_dd_area=>list_background_int
                                 sap_emphasis = cl_dd_area=>strong ).
    lv_text = so_uname-low.
    lo_col2->add_text( EXPORTING text         = lv_text ).
    lo_tab->new_row( ).
  ENDIF.
*  IF *SO_ACG_C-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT011.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_ACG_C-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.

  go_document->merge_document( ).
ENDFORM.                    " SET_TITLE
*&---------------------------------------------------------------------*
*&      FORM  BALV_CREATE_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_crea_click.
  CLEAR gs_balv.
  gs_balv-balv_status_icon = icon_create.
  go_balv->set_celltab_style( EXPORTING iv_mode = zcl_brd_alv_n=>mc_create_mode
                              CHANGING ct_celltab = gs_balv-celltab ).
  _set_timestamp_create gs_balv.
  APPEND gs_balv TO gt_balv.
  go_balv->set_changing_flag( abap_true ).
  go_balv->refresh( ).
ENDFORM.                    "BALV_CREATE_CLICK

*&---------------------------------------------------------------------*
*&      FORM  BALV_CHAN_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_chan_click.
  gt_balv_buff[] = gt_balv[].
  go_balv->set_celltab_style( EXPORTING iv_mode = zcl_brd_alv_n=>mc_change_mode
                            CHANGING ct_celltab = gt_celltab ).
  LOOP AT gt_balv ASSIGNING FIELD-SYMBOL(<ls_balv>).
    <ls_balv>-celltab = gt_celltab.
  ENDLOOP.

  go_balv->display( EXPORTING iv_mode = zcl_brd_alv_n=>mc_change_mode
                    CHANGING ct_data  = gt_balv[] ).
ENDFORM.                    "BALV_CHAN_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  BALV_CANC_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_canc_click.

  IF go_balv->is_changing( ) EQ abap_true
    AND go_balv->confirm_cancel( ) NE abap_true.
    EXIT.
  ENDIF.

  CLEAR : gt_balv, gt_balv[].
  gt_balv[] = gt_balv_buff[].
  CLEAR gt_balv_buff[].
  go_balv->set_changing_flag( abap_false ).

  go_balv->display( EXPORTING iv_mode = zcl_brd_alv_n=>mc_display_mode
                   CHANGING ct_data  = gt_balv[] ).
ENDFORM.                    "BALV_CANC_CLICK.
**&---------------------------------------------------------------------*
**&      FORM  BALV_RFSH_CLICK
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_RFSH_CLICK.
*ENDFORM.                    "RFSH_CLICK
*&---------------------------------------------------------------------*
*&      FORM  BALV_INST_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_inst_click.
  CLEAR : gt_rows, gt_row_ids.
  go_balv->get_selected_rows( IMPORTING et_index_rows = gt_rows
                                        et_row_no = gt_row_ids ).
  IF lines( gt_rows ) > 0.
    SORT gt_rows BY index.
    gv_index = gt_rows[ 1 ]-index.
    SORT gt_rows BY index DESCENDING.
    CLEAR gt_celltab.
    go_balv->set_celltab_style( EXPORTING iv_mode = zcl_brd_alv_n=>mc_create_mode
                                CHANGING ct_celltab = gt_celltab ).
    LOOP AT gt_rows INTO gs_rows.
      CLEAR gs_balv.
      gs_balv-balv_status_icon = icon_create.
      gs_balv-celltab = gt_celltab.
      _set_timestamp_create gs_balv.
      INSERT gs_balv INTO gt_balv INDEX gv_index.
    ENDLOOP.
    go_balv->set_changing_flag( abap_true ).
    go_balv->refresh( ).
  ELSE.
    zcl_brd_alv_n=>message_strip( EXPORTING iv_code = zcl_brd_alv_n=>mc_msg-no_row_select ).
  ENDIF.

ENDFORM.                    "BALV_INST_CLICK.
**&---------------------------------------------------------------------*
**&      FORM  BALV_UPLD_CLICK
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_UPLD_CLICK.
*  GT_BALV_BUFF[] = GT_BALV[].
*  _INIT GT_BALV.
*  PERFORM UPLOAD_BALV_DATA USING ABAP_TRUE ''.
*  IF GV_ERR = ABAP_TRUE.
*    EXIT.
*  ENDIF.
*  GO_BALV->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_UPLOAD_MODE
*                     CHANGING CT_DATA  = GT_BALV[] ).
*ENDFORM.
**&---------------------------------------------------------------------*
**&      FORM  BALV_DOUBLE_CLICK
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_DOUBLE_CLICK USING PS_ROW TYPE LVC_S_ROW
*                                PS_COLUMN TYPE LVC_S_COL
*                                PS_ROW_NO TYPE LVC_S_ROID.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PS_ROW_NO-ROW_ID.
*  IF SY-SUBRC EQ 0.
*    CLEAR GT_ROWS.
*    APPEND PS_ROW TO GT_ROWS.
*    GO_BALV->SET_SELECTED_ROWS( EXPORTING IT_INDEX_ROWS = GT_ROWS ).
*  ENDIF.
*  MESSAGE 'DOUBLE CLICK TRIGGERED' TYPE 'I'.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  BALV_VERIFY_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_verify_data USING pv_tabix TYPE sy-tabix
                                      ps_data LIKE gs_balv.
  IF gs_balv-uname IS INITIAL
.
    APPEND VALUE #( icon = icon_defect
                    row_no = pv_tabix
                    msg = go_balv->message( EXPORTING iv_code = zcl_brd_alv_n=>mc_msg-input_mandatory ) ) TO gt_log.
  ENDIF.
ENDFORM.                    " BALV_VERIFY_DATA
*&---------------------------------------------------------------------*
*&      FORM  BALV_DELE_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_dele_click.
  DATA lt_tab TYPE TABLE OF ztbrd00100 WITH HEADER LINE.
  _init gt_rows.
  go_balv->get_selected_rows(
   IMPORTING
     et_index_rows = gt_rows
     et_row_no     = gt_row_ids ).

  IF lines( gt_rows ) > 0.
    SORT gt_rows BY index DESCENDING.
    LOOP AT gt_rows INTO gs_rows.
      IF gt_balv[ gs_rows-index ]-balv_status_icon = icon_create.
        DELETE gt_balv INDEX gs_rows-index.
      ELSE.
        gt_balv[ gs_rows-index ]-balv_status_icon = icon_delete.
      ENDIF.
    ENDLOOP.
    go_balv->set_changing_flag( abap_true ).
    go_balv->refresh( ).
  ELSE.
    zcl_brd_alv_n=>message_strip( EXPORTING iv_code = zcl_brd_alv_n=>mc_msg-no_row_select ).
  ENDIF.

ENDFORM.                    "BALV_DELE_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  BALV_DATA_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->PO_OBJECT     TEXT
*      -->PV_ONF4  TEXT
*      -->PV_ONF4_BEFORE  TEXT
*      -->PV_ONF4_AFTER  TEXT
*      -->PV_UCOMM  TEXT
*----------------------------------------------------------------------*
FORM balv_data_changed USING po_object TYPE REF TO cl_alv_changed_data_protocol
                        pv_onf4
                        pv_onf4_before
                        pv_onf4_after
                        pv_ucomm.
  DATA lt_mod_cells TYPE lvc_t_modi WITH HEADER LINE.
  lt_mod_cells[] = po_object->mt_good_cells.
  LOOP AT lt_mod_cells ASSIGNING FIELD-SYMBOL(<ls_mod_cells>).
    AT NEW row_id.
      READ TABLE gt_balv INDEX <ls_mod_cells>-row_id.
    ENDAT.
    ASSIGN COMPONENT <ls_mod_cells>-fieldname OF STRUCTURE gt_balv TO <gv_field>.
    <gv_field> = lt_mod_cells-value.
    AT END OF row_id.
      READ TABLE gt_balv ASSIGNING FIELD-SYMBOL(<ls_balv>) INDEX <ls_mod_cells>-row_id.
      IF sy-subrc EQ 0." modify
        IF <ls_balv>-balv_status_icon NE icon_create.
          <ls_balv>-balv_status_icon = icon_change.
        ENDIF.
        _set_alv_cell <ls_mod_cells>-row_id c_field-balv_status_icon <ls_balv>-balv_status_icon.
      ELSE."auto added new row
        _set_alv_cell <ls_mod_cells>-row_id c_field-balv_status_icon icon_create.
        CLEAR gs_balv-celltab.
        go_balv->set_celltab_style( EXPORTING iv_mode = zcl_brd_alv_n=>mc_create_mode
                                    CHANGING ct_celltab = gs_balv-celltab ).
        LOOP AT gs_balv-celltab ASSIGNING FIELD-SYMBOL(<ls_celltab>).
          po_object->modify_style( EXPORTING i_row_id    = <ls_mod_cells>-row_id
                                             i_fieldname = <ls_celltab>-fieldname
                                             i_style     = <ls_celltab>-style ).
        ENDLOOP.
        APPEND gs_balv TO gt_balv.
      ENDIF.
      READ TABLE gt_balv TRANSPORTING NO FIELDS INDEX <ls_mod_cells>-row_id.
      IF sy-subrc EQ 0.
        MODIFY gt_balv INDEX <ls_mod_cells>-row_id.
      ELSE.
        APPEND gt_balv.
      ENDIF.
    ENDAT.
  ENDLOOP.
  go_balv->set_changing_flag( abap_true ).
ENDFORM.                    "BALV_DATA_CHANGED
*&---------------------------------------------------------------------*
*&      FORM  BALV_UNAME_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_uname_changed USING po_object TYPE REF TO cl_alv_changed_data_protocol
                                   pv_row_id
                                   pv_value TYPE any.
  DATA ls_fieldcat TYPE lvc_s_fcat.
  CLEAR gt_balv.
  READ TABLE gt_balv INDEX pv_row_id.
  IF sy-subrc EQ 0.
    gt_balv-uname = pv_value.
    _set_alv_cell pv_row_id c_field_balv-uname pv_value.
    PERFORM balv_check_pk.
    IF gv_err EQ c_e.
      gt_balv-balv_status_icon = icon_defect.
    ELSE.
      gt_balv-balv_status_icon = icon_change.
    ENDIF.
    _set_alv_cell pv_row_id c_field-balv_status_icon gt_balv-balv_status_icon.
    MODIFY gt_balv INDEX pv_row_id.
  ENDIF.
ENDFORM.                    "BALV_UNAME_CHANGED.
*&---------------------------------------------------------------------*
*&      FORM  BALV_CHECK_PK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_check_pk .
  CLEAR : gv_err, gv_count.

  SELECT COUNT(*) INTO gv_count
    FROM ztbrd00100
  WHERE uname = gt_balv-uname
.

  IF gv_count GT 0.
    gv_err = c_e.
  ENDIF.
ENDFORM.                    " CHECK_PK
**&---------------------------------------------------------------------*
**&      FORM  BALV_SET_TOOLBAR
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
**      -->PV_INTERACTIVE     TEXT
**      -->PO_OBJECT  TEXT
**----------------------------------------------------------------------*
*FORM BALV_SET_TOOLBAR USING PV_INTERACTIVE
*                       PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET.
*  GV_FLAG = GO_BALV->IS_DISPLAY_MODE( ).
*  IF GV_FLAG NE ABAP_TRUE .
*    GO_BALV->APPEND_TOOLBAR_BUTTON( EXPORTING
*                                   IV_FUNCTION = 'F01'
*                                   IV_ICON = '' "ICON-ID
*                                   IV_QUICKINFO = ''
*                                   IV_TEXT = 'MY TOOLBAR'
*                                   ).
*  ENDIF.
*ENDFORM.                    "BALV_SET_TOOLBAR
*&---------------------------------------------------------------------*
*&      FORM  SAVE_DATA.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM save_data.
  DATA:
    ls_balv        TYPE ztbrd00100,
    lt_create_balv TYPE TABLE OF ztbrd00100,
    lt_update_balv TYPE TABLE OF ztbrd00100,
    lt_delete_balv TYPE TABLE OF ztbrd00100.
  DATA:
    lv_create_cnt TYPE sy-dbcnt,
    lv_update_cnt TYPE sy-dbcnt,
    lv_delete_cnt TYPE sy-dbcnt.

  CLEAR gt_log[].
  CLEAR gs_balv.
  LOOP AT gt_balv INTO gs_balv.
    CLEAR ls_balv.
    IF gs_balv-balv_status_icon IS NOT INITIAL.
      PERFORM balv_verify_data USING sy-tabix gs_balv.
      MOVE-CORRESPONDING gs_balv TO ls_balv.
    ENDIF.
    CASE gs_balv-balv_status_icon.
      WHEN icon_create.
        _set_timestamp_create ls_balv.
        APPEND ls_balv TO lt_create_balv.
      WHEN icon_change.
        _set_timestamp_change ls_balv.
        APPEND ls_balv TO lt_update_balv.
      WHEN icon_delete.
        APPEND ls_balv TO lt_delete_balv.
    ENDCASE.
    CLEAR gs_balv.
  ENDLOOP.


  IF gt_log[] IS NOT INITIAL.
    zcl_brd_alv_n=>message_popup( CHANGING ct_msg = gt_log[] ).
    EXIT.
  ENDIF.

  IF zcl_brd_alv_n=>confirm_save( ) NE abap_true.
    EXIT.
  ENDIF.

  TRY.
      IF lt_create_balv IS NOT INITIAL.
        INSERT ztbrd00100 FROM TABLE lt_create_balv.
        lv_create_cnt = lv_create_cnt + lines( lt_create_balv ).
      ENDIF.
      IF lt_update_balv IS NOT INITIAL.
        MODIFY ztbrd00100 FROM TABLE lt_update_balv.
        lv_update_cnt = lv_update_cnt + lines( lt_update_balv ).
      ENDIF.
      IF lt_delete_balv IS NOT INITIAL.
        DELETE ztbrd00100 FROM TABLE lt_delete_balv.
        lv_delete_cnt = lv_delete_cnt + lines( lt_delete_balv ).
      ENDIF.
    CATCH cx_root INTO go_exception.
      zcl_brd_alv_n=>catch_exception( io_root = go_exception ).
  ENDTRY.
  zcl_brd_alv_n=>message_strip( EXPORTING iv_code = zcl_brd_alv_n=>mc_msg-save_success
                                    iv_param1 = |{ lv_create_cnt }|
                                    iv_param2 = |{ lv_update_cnt }|
                                    iv_param3 = |{ lv_delete_cnt }| ).

  CLEAR gt_balv_buff[].
  go_balv->set_changing_flag( abap_false ).
  DELETE gt_balv WHERE balv_status_icon = icon_delete.
  LOOP AT gt_balv ASSIGNING <gs_balv>.
    IF <gs_balv>-balv_status_icon IS NOT INITIAL.
      CLEAR <gs_balv>-balv_status_icon.
    ENDIF.
  ENDLOOP.
  go_balv->display( EXPORTING iv_mode = zcl_brd_alv_n=>mc_display_mode
                    CHANGING ct_data  = gt_balv[] ).
ENDFORM.                    "SAVE_DATA
*&---------------------------------------------------------------------*
*& Form SET_ALV_CBO_CONFIG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_alv_cbo_config .
  DATA ls_fcat_cbo TYPE ztbrd00020.
  CLEAR gs_layout_cbo.
  gs_layout_cbo-progid = 'ZLBRD00100'.
  gs_layout_cbo-alv_key = 'BALV'.
  gs_layout_cbo-zcreate = 'X'.
  gs_layout_cbo-zupdate = 'X'.
  gs_layout_cbo-zdelete = 'X'.
  gs_layout_cbo-change_evt = 'X'.
  gs_layout_cbo-zebra = 'X'.
  gs_layout_cbo-sel_mode = 'D'.
  gs_layout_cbo-ctab_fname = 'COLTAB'.
  gs_layout_cbo-info_fname = 'RCOLOR'.
  gs_layout_cbo-stylefname = 'CELLTAB'.
  gs_layout_cbo-grid_title = ''.
  CLEAR ls_fcat_cbo.
  ls_fcat_cbo-progid = 'ZLBRD00100'.
  ls_fcat_cbo-alv_key = 'BALV'.
  ls_fcat_cbo-fcat_key = 'DEFAULT'.
  ls_fcat_cbo-col_pos = '2'.
  ls_fcat_cbo-fieldname = 'UNAME'.
  ls_fcat_cbo-zkey = 'X'.
  ls_fcat_cbo-fix_column = ''.
  ls_fcat_cbo-reptext = 'User Name'.
  ls_fcat_cbo-scrtext_s = 'User Name'.
  ls_fcat_cbo-scrtext_m = 'User Name'.
  ls_fcat_cbo-scrtext_l = 'User Name'.
  ls_fcat_cbo-outputlen = '000000'.
  ls_fcat_cbo-just = 'C'.
  ls_fcat_cbo-emphasize = 'K41'.
  ls_fcat_cbo-crea_edit = 'X'.
  ls_fcat_cbo-upld_edit = 'X'.
  ls_fcat_cbo-ref_table = 'ZTBRD00100'.
  ls_fcat_cbo-datatype = 'CHAR'.
  ls_fcat_cbo-inttype = 'C'.
  ls_fcat_cbo-intlen = '000012'.
  ls_fcat_cbo-domname = 'UNAME'.
  ls_fcat_cbo-dd_outlen = '000012'.
  APPEND ls_fcat_cbo TO gt_fieldcat_cbo.
  CLEAR ls_fcat_cbo.
  ls_fcat_cbo-progid = 'ZLBRD00100'.
  ls_fcat_cbo-alv_key = 'BALV'.
  ls_fcat_cbo-fcat_key = 'DEFAULT'.
  ls_fcat_cbo-col_pos = '3'.
  ls_fcat_cbo-fieldname = 'ACG_CNT'.
  ls_fcat_cbo-fix_column = ''.
  ls_fcat_cbo-reptext = 'Count'.
  ls_fcat_cbo-scrtext_s = 'Count'.
  ls_fcat_cbo-scrtext_m = 'Count'.
  ls_fcat_cbo-scrtext_l = 'Count'.
  ls_fcat_cbo-outputlen = '000000'.
  ls_fcat_cbo-crea_edit = 'X'.
  ls_fcat_cbo-chan_edit = 'X'.
  ls_fcat_cbo-upld_edit = 'X'.
  ls_fcat_cbo-ref_table = 'ZTBRD00100'.
  ls_fcat_cbo-datatype = 'INT4'.
  ls_fcat_cbo-inttype = 'I'.
  ls_fcat_cbo-intlen = '000010'.
  ls_fcat_cbo-domname = 'INT4'.
  ls_fcat_cbo-dd_outlen = '000010'.
  APPEND ls_fcat_cbo TO gt_fieldcat_cbo.
  CLEAR ls_fcat_cbo.
  ls_fcat_cbo-progid = 'ZLBRD00100'.
  ls_fcat_cbo-alv_key = 'BALV'.
  ls_fcat_cbo-fcat_key = 'DEFAULT'.
  ls_fcat_cbo-col_pos = '999'.
  ls_fcat_cbo-fieldname = 'MANDT'.
  ls_fcat_cbo-zkey = 'X'.
  ls_fcat_cbo-fix_column = ''.
  ls_fcat_cbo-reptext = 'Cl.'.
  ls_fcat_cbo-scrtext_s = 'Cl.'.
  ls_fcat_cbo-scrtext_m = 'Cl.'.
  ls_fcat_cbo-scrtext_l = 'Cl.'.
  ls_fcat_cbo-outputlen = '000000'.
  ls_fcat_cbo-tech = 'X'.
  ls_fcat_cbo-emphasize = 'K41'.
  ls_fcat_cbo-crea_edit = 'X'.
  ls_fcat_cbo-upld_edit = 'X'.
  ls_fcat_cbo-ref_table = 'ZTBRD00100'.
  ls_fcat_cbo-datatype = 'CLNT'.
  ls_fcat_cbo-inttype = 'C'.
  ls_fcat_cbo-intlen = '000003'.
  ls_fcat_cbo-domname = 'MANDT'.
  ls_fcat_cbo-dd_outlen = '000003'.
  APPEND ls_fcat_cbo TO gt_fieldcat_cbo.
ENDFORM.
