*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD00030F01
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

  IF go_balv IS INITIAL.
    CREATE OBJECT go_balv
      EXPORTING
        io_parent = go_container_balv.

    go_balv->display( CHANGING ct_data = gt_balv[] ).
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
        WHEN zcl_brd_alv_n=>mc_upload_mode.
          LEAVE TO SCREEN 0.
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
  pa_samp = TEXT-b01. "Download
  text001 = TEXT-t01. "Display
  text002 = TEXT-t02. "Upload
  text003 = TEXT-t03. "File Path
  text006 = TEXT-t04. "Sample Excel
  text009 = TEXT-t09. "Select Options
  text010 = 'User Name'."text-t10
*  text011 = 'No'."text-t11
*  TEXT012 = 'Include Source'."text-t12
*  TEXT013 = 'Create User'."text-t13
*  TEXT014 = 'Create Date'."text-t14
*  TEXT015 = 'Create Time'."text-t15
*  TEXT016 = 'Change User'."text-t16
*  TEXT017 = 'Change Date'."text-t17
*  TEXT018 = 'Change Time'."text-t18
  go_tab-prog = sy-repid.
  go_tab-dynnr = 010.
  go_tab-activetab = c_ucomm-display.

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
    FROM ztbrd00090
    WHERE uname IN so_uname
*      AND ZSORT IN SO_ZSORT
*      AND INC IN SO_INC
*      AND ERNAM IN SO_ERNAM
*      AND ERDAT IN SO_ERDAT
*      AND ERZET IN SO_ERZET
*      AND AENAM IN SO_AENAM
*      AND AEDAT IN SO_AEDAT
*      AND AEZET IN SO_AEZET
.
ENDFORM.                    "GET_BALV_DATA
*&---------------------------------------------------------------------*
*&      FORM  UPLOAD_BALV_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM upload_balv_data USING pv_file_dialog pv_file_name.
  DATA lt_tab TYPE TABLE OF gty_balv.
  DATA ls_tab TYPE gty_balv.
  CLEAR gv_err.
  CALL METHOD zcl_brd_alv_n=>excel_upload
    EXPORTING
      iv_file_dialog = pv_file_dialog
      iv_file_name   = pv_file_name
    CHANGING
      ct_data        = lt_tab[]
    RECEIVING
      ev_subrc       = gv_subrc.
  IF gv_subrc EQ 0.
    LOOP AT lt_tab INTO ls_tab.
      MOVE-CORRESPONDING ls_tab TO gt_balv.
      APPEND gt_balv.
      CLEAR : ls_tab, gt_balv.
    ENDLOOP.
    go_balv->set_changing_flag( abap_true ).
  ELSE.
    MESSAGE s001(zbrd001) DISPLAY LIKE c_e.
    gv_err = abap_true.
  ENDIF.

ENDFORM.                    " UPLOAD_DATA
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
*  IF SO_ZSORT-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT011.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = SO_ZSORT-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_INC-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT012.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_INC-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_ERNAM-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT013.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_ERNAM-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_ERDAT-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT014.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_ERDAT-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_ERZET-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT015.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_ERZET-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_AENAM-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT016.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_AENAM-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_AEDAT-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT017.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_AEDAT-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_AEZET-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT018.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_AEZET-LOW.
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
*&---------------------------------------------------------------------*
*&      FORM  BALV_UPLD_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_upld_click.
  gt_balv_buff[] = gt_balv[].
  _init gt_balv.
  PERFORM upload_balv_data USING abap_true ''.
  IF gv_err = abap_true.
    EXIT.
  ENDIF.
  go_balv->display( EXPORTING iv_mode = zcl_brd_alv_n=>mc_upload_mode
                     CHANGING ct_data  = gt_balv[] ).
ENDFORM.
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
     OR gs_balv-zsort IS INITIAL
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
  DATA lt_tab TYPE TABLE OF ztbrd00090 WITH HEADER LINE.
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
        gt_balv-aedat = sy-datum.
        _set_alv_cell <ls_mod_cells>-row_id c_field-aedat gt_balv-aedat.
        gt_balv-aezet = sy-uzeit.
        _set_alv_cell <ls_mod_cells>-row_id c_field-aezet gt_balv-aezet.
        gt_balv-aenam = sy-uname.
        _set_alv_cell <ls_mod_cells>-row_id c_field-aenam gt_balv-aenam.
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
        gt_balv-erdat = sy-datum.
        _set_alv_cell <ls_mod_cells>-row_id c_field-erdat gt_balv-erdat.
        gt_balv-erzet = sy-uzeit.
        _set_alv_cell <ls_mod_cells>-row_id c_field-erzet gt_balv-erzet.
        gt_balv-ernam = sy-uname.
        _set_alv_cell <ls_mod_cells>-row_id c_field-ernam gt_balv-ernam.
        gt_balv-aedat = sy-datum.
        _set_alv_cell <ls_mod_cells>-row_id c_field-aedat gt_balv-aedat.
        gt_balv-aezet = sy-uzeit.
        _set_alv_cell <ls_mod_cells>-row_id c_field-aezet gt_balv-aezet.
        gt_balv-aenam = sy-uname.
        _set_alv_cell <ls_mod_cells>-row_id c_field-aenam gt_balv-aenam.
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
*&      FORM  BALV_ZSORT_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_zsort_changed USING po_object TYPE REF TO cl_alv_changed_data_protocol
                                   pv_row_id
                                   pv_value TYPE any.
  DATA ls_fieldcat TYPE lvc_s_fcat.
  CLEAR gt_balv.
  READ TABLE gt_balv INDEX pv_row_id.
  IF sy-subrc EQ 0.
    gt_balv-zsort = pv_value.
    _set_alv_cell pv_row_id c_field_balv-zsort pv_value.
    PERFORM balv_check_pk.
    IF gv_err EQ c_e.
      gt_balv-balv_status_icon = icon_defect.
    ELSE.
      gt_balv-balv_status_icon = icon_change.
    ENDIF.
    _set_alv_cell pv_row_id c_field-balv_status_icon gt_balv-balv_status_icon.
    MODIFY gt_balv INDEX pv_row_id.
  ENDIF.
ENDFORM.                    "BALV_ZSORT_CHANGED.
*&---------------------------------------------------------------------*
*&      FORM  BALV_CHECK_PK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_check_pk .
  CLEAR : gv_err, gv_count.

  SELECT COUNT(*) INTO gv_count
    FROM ztbrd00090
  WHERE uname = gt_balv-uname
    AND zsort = gt_balv-zsort
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
    ls_balv        TYPE ztbrd00090,
    lt_create_balv TYPE TABLE OF ztbrd00090,
    lt_update_balv TYPE TABLE OF ztbrd00090,
    lt_delete_balv TYPE TABLE OF ztbrd00090.
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
        INSERT ztbrd00090 FROM TABLE lt_create_balv.
        lv_create_cnt = lv_create_cnt + lines( lt_create_balv ).
      ENDIF.
      IF lt_update_balv IS NOT INITIAL.
        MODIFY ztbrd00090 FROM TABLE lt_update_balv.
        lv_update_cnt = lv_update_cnt + lines( lt_update_balv ).
      ENDIF.
      IF lt_delete_balv IS NOT INITIAL.
        DELETE ztbrd00090 FROM TABLE lt_delete_balv.
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
