*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
CLASS zcl_brd_acg_library_n DEFINITION
  PUBLIC
  INHERITING FROM zcl_brd_acg_library
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_addr_click
        REDEFINITION .
    METHODS get_canc_click
        REDEFINITION .
    METHODS get_chan_click
        REDEFINITION .
    METHODS get_create_click
        REDEFINITION .
    METHODS get_data_changed
        REDEFINITION .
    METHODS get_dele_click
        REDEFINITION .
    METHODS get_delr_click
        REDEFINITION .
    METHODS get_double_click
        REDEFINITION .
    METHODS get_field_changed
        REDEFINITION .
    METHODS get_global_variable
        REDEFINITION .
    METHODS get_inst_click
        REDEFINITION .
    METHODS get_itab
        REDEFINITION .
    METHODS get_rfsh_click
        REDEFINITION .
    METHODS get_save_click
        REDEFINITION .
    METHODS get_save_data
        REDEFINITION .
    METHODS get_scr_1000
        REDEFINITION .
    METHODS get_selection_screen
        REDEFINITION .
    METHODS get_set_init_value
        REDEFINITION .
    METHODS get_start_of_selection
        REDEFINITION .
    METHODS get_struct_line
        REDEFINITION .
    METHODS get_upload_click_form
        REDEFINITION .
    METHODS get_upload_data_form
        REDEFINITION .
    METHODS get_verify_data
        REDEFINITION .
    METHODS get_set_toolbar
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BRD_ACG_LIBRARY_N IMPLEMENTATION.


  METHOD get_addr_click.
*CALL METHOD SUPER->GET_ADDR_CLICK
*  EXPORTING
*    IV_ALV_KEY =
*  RECEIVING
*    RT_CODE    =
*    .
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
    _set5 `  IF ` ms_name-g_obj `_` iv_alv_key `->IS_CHANGING( ) EQ ABAP_TRUE`.
    _set5 `    AND ` ms_name-g_obj `_` iv_alv_key `->CONFIRM_CANCEL( ) NE ABAP_TRUE.`.
    _set1 `    EXIT.`.
    _set1 `  ENDIF.`.
    _set1 ``.
    _add4 `  CLEAR : ` ms_name-g_itab `_` iv_alv_key.
    _add5 `, ` ms_name-g_itab `_` iv_alv_key `[].`.
    _append.
    _add4 `  ` ms_name-g_itab `_` iv_alv_key.
    _add5 `[] = ` ms_name-g_itab `_` iv_alv_key `_BUFF[].`.
    _append.
    _set5 `  CLEAR ` ms_name-g_itab `_` iv_alv_key `_BUFF[].`.
    _set5 `  ` ms_name-g_obj `_` iv_alv_key `->SET_CHANGING_FLAG( ABAP_FALSE ).    `.
    _set1 ``.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE`.
    _set5 `                   CHANGING CT_DATA  = ` ms_name-g_itab `_` iv_alv_key `[] ).`.
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
    _add4 `  ` ms_name-g_itab `_` iv_alv_key.
    _add5 `_BUFF[] = ` ms_name-g_itab `_` iv_alv_key `[].`.
    _append.


    _set5 `  CLEAR : ` ms_name-g_itab `_rows, ` ms_name-g_itab `_row_ids.`.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->GET_SELECTED_ROWS( IMPORTING et_index_rows = ` ms_name-g_itab `_rows`.
    _set3 `                                      et_row_no = ` ms_name-g_itab `_row_ids ).`.



    _set7 ` ` ms_name-g_obj `_` iv_alv_key `->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_CHANGE_MODE`.
    _set3 `                            CHANGING CT_CELLTAB = ` ms_name-g_itab `_CELLTAB ).`.
    _add4 `  LOOP AT ` ms_name-g_itab `_` iv_alv_key.
    _add5 ` ASSIGNING FIELD-SYMBOL(<` ms_name-l_fieldsymbol_s `_` iv_alv_key `>).`.
    _append.
    _set7 `    <` ms_name-l_fieldsymbol_s `_` iv_alv_key `>-CELLTAB = ` ms_name-g_itab `_CELLTAB.`.
    _set1 `  ENDLOOP.`.
    _set1 ``.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_CHANGE_MODE`.
    _set5 `                    CHANGING CT_DATA  = ` ms_name-g_itab `_` iv_alv_key `[] ).`.

    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->SET_SELECTED_ROWS( EXPORTING it_index_rows = ` ms_name-g_itab `_rows ).`.

    _set3 `ENDFORM.                    "` iv_alv_key `_CHAN_CLICK.`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_create_click.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_CREA_CLICK`.
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
    _set5 `  CLEAR ` ms_name-g_wa `_` iv_alv_key `.`.
    _set7 `  ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON = ` ms_acg_config-alv_class `=>MC_ICON-CREATE.`.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_CREATE_MODE`.
    _set5 `                              CHANGING CT_CELLTAB = ` ms_name-g_wa `_` iv_alv_key `-CELLTAB ).`.
    _set5 `  _set_timestamp_create ` ms_name-g_wa `_` iv_alv_key `.`.
    _add4 `  APPEND ` ms_name-g_wa `_` iv_alv_key.
    _add5 ` TO ` ms_name-g_itab `_` iv_alv_key `.`.
    _append.
    _set5 `  ` ms_name-g_obj `_` iv_alv_key `->SET_CHANGING_FLAG( ABAP_TRUE ).`.
    _set5 `  ` ms_name-g_obj `_` iv_alv_key `->REFRESH( ).`.
    _add4 `  ` ms_name-g_obj `_` iv_alv_key .
    _add5 `->GOTO_ROW_FOCUS( LINES( ` ms_name-g_itab `_` iv_alv_key ` ) ).`.
    _append.
    _set3 `ENDFORM.                    "` iv_alv_key `_CREA_CLICK`.
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
    _set5 `  LOOP AT ` ms_name-l_itab `_MOD_CELLS ASSIGNING FIELD-SYMBOL(<` ms_name-l_fieldsymbol_s `_MOD_CELLS>).`.
    _set1 `    AT NEW ROW_ID.`.
    _set5 `      CLEAR ` ms_name-g_wa `_` iv_alv_key `.`.
    _add5 `      READ TABLE ` ms_name-g_itab `_` iv_alv_key ` INTO ` .
    _add6 ms_name-g_wa `_` iv_alv_key ` INDEX <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID.`.
    _append.
    _set1 `    ENDAT.`.
    _add4 `    ASSIGN COMPONENT <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-FIELDNAME OF STRUCTURE ` ms_name-g_wa.
    _add5 `_` iv_alv_key ` TO <` ms_name-g_fieldsymbol_v `_FIELD>.`.
    _append.
    _set5 `    <` ms_name-g_fieldsymbol_v `_FIELD> = <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-VALUE.`.
    _set5 `    _set_alv_cell <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-row_id <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-fieldname <gv_field>.`.
    _set1 `    AT END OF ROW_ID.`.
    _set7 `      READ TABLE ` ms_name-g_itab `_` iv_alv_key ` TRANSPORTING NO FIELDS INDEX <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID.`.
    _set1 `      IF SY-SUBRC EQ 0." modify`.
    _set7 `        IF ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON NE ` ms_acg_config-alv_class `=>MC_ICON-CREATE.`.
    _set7 `          ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON = ` ms_acg_config-alv_class `=>MC_ICON-CHANGE.`.
    _set1 `        ENDIF.`.
    _add4 `        _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants.
    _add5 `_FIELD-BALV_STATUS_ICON ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON.`.
    _append.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'AEDAT'.
    IF sy-subrc EQ 0.
      _set5 `*      ` ms_name-g_wa `_` iv_alv_key `-AEDAT = SY-DATUM.`.
      _add4 `*      _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants.
      _add5 `_FIELD-AEDAT ` ms_name-g_wa `_` iv_alv_key `-AEDAT.`.
      _append.
    ENDIF.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'AEZET'.
    IF sy-subrc EQ 0.
      _set5 `*      ` ms_name-g_wa `_` iv_alv_key `-AEZET = SY-UZEIT.`.
      _add4 `*      _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants.
      _add5 `_FIELD-AEZET ` ms_name-g_wa `_` iv_alv_key `-AEZET.`.
      _append.
    ENDIF.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'AENAM'.
    IF sy-subrc EQ 0.
      _set5 `*      ` ms_name-g_wa `_` iv_alv_key `-AENAM = SY-UNAME.`.
      _add4 `*      _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants.
      _add5 `_FIELD-AENAM ` ms_name-g_wa `_` iv_alv_key `-AENAM.`.
      _append.
    ENDIF.
    _set1 `      ELSE."auto added new row`.
    _set7 `        _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants `_FIELD-BALV_STATUS_ICON ` ms_acg_config-alv_class `=>MC_ICON-CREATE.`.
    _set7 `        ` ms_name-g_obj `_` iv_alv_key `->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_CREATE_MODE`.
    _set5 `                                    CHANGING CT_CELLTAB = ` ms_name-g_wa `_` iv_alv_key `-CELLTAB ).`.
    _set7 `        LOOP AT ` ms_name-g_wa `_` iv_alv_key `-CELLTAB ASSIGNING FIELD-SYMBOL(<` ms_name-l_fieldsymbol_s `_CELLTAB>).`.
    _set5 `          ` ms_name-form_io `_OBJECT->MODIFY_STYLE( EXPORTING I_ROW_ID    = <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID`.
    _set3 `                                             I_FIELDNAME = <` ms_name-l_fieldsymbol_s `_CELLTAB>-FIELDNAME`.
    _set3 `                                             I_STYLE     = <` ms_name-l_fieldsymbol_s `_CELLTAB>-STYLE ).`.
    _set1 `        ENDLOOP.`.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'ERDAT'.
    IF sy-subrc EQ 0.
      _set5 `*      ` ms_name-g_wa `_` iv_alv_key `-ERDAT = SY-DATUM.`.
      _add4 `*      _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants.
      _add5 `_FIELD-ERDAT ` ms_name-g_wa `_` iv_alv_key `-ERDAT.`.
      _append.
    ENDIF.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'ERZET'.
    IF sy-subrc EQ 0.
      _set5 `*      ` ms_name-g_wa `_` iv_alv_key `-ERZET = SY-UZEIT.`.
      _add4 `*      _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants.
      _add5 `_FIELD-ERZET ` ms_name-g_wa `_` iv_alv_key `-ERZET.`.
      _append.
    ENDIF.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'ERNAM'.
    IF sy-subrc EQ 0.
      _set5 `*      ` ms_name-g_wa `_` iv_alv_key `-ERNAM = SY-UNAME.`.
      _add4 `*      _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants.
      _add5 `_FIELD-ERNAM ` ms_name-g_wa `_` iv_alv_key `-ERNAM.`.
      _append.
    ENDIF.

    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'AEDAT'.
    IF sy-subrc EQ 0.
      _set5 `*      ` ms_name-g_wa `_` iv_alv_key `-AEDAT = SY-DATUM.`.
      _add4 `*      _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants.
      _add5 `_FIELD-AEDAT ` ms_name-g_wa `_` iv_alv_key `-AEDAT.`.
      _append.
    ENDIF.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'AEZET'.
    IF sy-subrc EQ 0.
      _set5 `*      ` ms_name-g_wa `_` iv_alv_key `-AEZET = SY-UZEIT.`.
      _add4 `*      _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants.
      _add5 `_FIELD-AEZET ` ms_name-g_wa `_` iv_alv_key `-AEZET.`.
      _append.
    ENDIF.
    READ TABLE it_fcat TRANSPORTING NO FIELDS WITH KEY fieldname = 'AENAM'.
    IF sy-subrc EQ 0.
      _set5 `*      ` ms_name-g_wa `_` iv_alv_key `-AENAM = SY-UNAME.`.
      _add4 `*      _SET_ALV_CELL <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID ` ms_name-g_constants.
      _add5 `_FIELD-AENAM ` ms_name-g_wa `_` iv_alv_key `-AENAM.`.
      _append.
    ENDIF.
    _set7 `        ` ms_name-g_wa `_` iv_alv_key `-balv_status_icon = ` ms_acg_config-alv_class `=>mc_icon-create.`.
    _add4 `        APPEND ` ms_name-g_wa `_` iv_alv_key.
    _add5 ` TO ` ms_name-g_itab `_` iv_alv_key `.`.
    _append.
    _set1 `      ENDIF.    `.


*    LOOP AT it_key_map INTO ls_key_map.
*      _add1 : `  `, ms_name-g_itab, `_`, iv_alv_key, `-`, ls_key_map-i_field, ` = `, ms_name-g_itab, `_`, iv_parent_alv_key, `-`, ls_key_map-h_field, `.`.
*      _append.
*    ENDLOOP.
*    _set7 `      READ TABLE ` ms_name-g_itab `_` iv_alv_key ` TRANSPORTING NO FIELDS INDEX <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID.`.
*    _set1 `      IF SY-SUBRC EQ 0.`.
*    _set7 `        MODIFY ` ms_name-g_itab `_` iv_alv_key ` INDEX <` ms_name-l_fieldsymbol_s `_MOD_CELLS>-ROW_ID.`.
*    _set1 `      ELSE.`.
*    _set5 `        APPEND ` ms_name-g_itab `_` iv_alv_key `.`.
*    _set1 `      ENDIF.`.
    _set1 `    ENDAT.`.
    _set1 `  ENDLOOP.`.
    _set5 `  ` ms_name-g_obj `_` iv_alv_key `->SET_CHANGING_FLAG( ABAP_TRUE ).`.
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
    _set3 `  IF LINES( ` ms_name-g_itab `_ROWS ) > 0.`.
    _set3 `    SORT ` ms_name-g_itab `_ROWS BY INDEX DESCENDING.`.
    _set5 `    LOOP AT ` ms_name-g_itab `_ROWS INTO ` ms_name-g_wa `_ROWS.`.
    _add7 `      IF ` ms_name-g_itab `_` iv_alv_key `[ ` ms_name-g_wa `_ROWS-INDEX ]-BALV_STATUS_ICON = `.
    _add2 ms_acg_config-alv_class `=>MC_ICON-CREATE.`.
    _append.
    _set7 `        DELETE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-g_wa `_ROWS-INDEX.`.
    _set1 `      ELSE.`.
    _add7 `        ` ms_name-g_itab `_` iv_alv_key `[ ` ms_name-g_wa `_ROWS-INDEX ]-BALV_STATUS_ICON = `.
    _add2 ms_acg_config-alv_class `=>MC_ICON-DELETE.`.
    _append.
    _set1 `      ENDIF.`.
    _set1 `    ENDLOOP.`.
    _set5 `    ` ms_name-g_obj `_` iv_alv_key `->SET_CHANGING_FLAG( ABAP_TRUE ).`.
    _set5 `    ` ms_name-g_obj `_` iv_alv_key `->REFRESH( ).`.
    _set1 `  ELSE.`.
    _set5 `    ` ms_acg_config-alv_class `=>MESSAGE_STRIP( EXPORTING IV_CODE = ` ms_acg_config-alv_class `=>MC_MSG-NO_ROW_SELECT ).`.
    _set1 `  ENDIF.`.
    _set1 ``.
    _set3 `ENDFORM.                    "` iv_alv_key `_DELE_CLICK.`.

    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_delr_click.
    CLEAR mt_code.

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

      _set1 `  `.
      _set5 `  IF ` ms_name-g_obj `_` iv_item_alv_key `->IS_CHANGING( ) EQ ABAP_TRUE`.
      _set5 `    AND ` ms_name-g_obj `_` iv_item_alv_key `->CONFIRM_CANCEL( ) NE ABAP_TRUE.`.
      _set1 `    EXIT.`.
      _set1 `  ENDIF.`.
      _set1 `  `.
      _set5 `  IF ` ms_name-g_obj `_` iv_alv_key `->IS_READY_FOR_INPUT( ) EQ 1.`.
      _set1 `    EXIT.`.
      _set1 `  ENDIF.      `.
      _set1 `  `.
      _set5 `  CLEAR ` ms_name-g_itab `_` iv_alv_key `.`.
      _set7 `  READ TABLE ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-form_is `_ROW_NO-ROW_ID.`.
      _set1 `  IF SY-SUBRC EQ 0.`.
      _set3 `    CLEAR ` ms_name-g_itab `_ROWS.`.
      _set5 `    APPEND ` ms_name-form_is `_ROW TO ` ms_name-g_itab `_ROWS.`.
      _set7 `    ` ms_name-g_obj `_` iv_alv_key `->SET_SELECTED_ROWS( EXPORTING IT_INDEX_ROWS = ` ms_name-g_itab `_ROWS ).`.
      _set1 `  `.
      _set5 `    CLEAR : ` ms_name-g_itab `_` iv_item_alv_key `_BUFF[].`.
      _set5 `    ` ms_name-g_obj `_` iv_item_alv_key `->SET_CHANGING_FLAG( ABAP_FALSE ).`.
      _set1 `  `.
      _set3 `    PERFORM GET_` iv_item_alv_key `_DATA.`.
      _set7 `    ` ms_name-g_obj `_` iv_item_alv_key `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE`.
      _set5 `                      CHANGING CT_DATA  = ` ms_name-g_itab `_` iv_item_alv_key `[] ).`.
      _set1 `  ENDIF.`.

    ELSE.

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


  METHOD get_field_changed.
    DATA ls_fcat TYPE ztbrd00020.
    DATA lt_code TYPE string_table.
    LOOP AT it_fcat INTO ls_fcat .
      CLEAR mt_code.
      _set1 `*&---------------------------------------------------------------------*`.
      _set5 `*&      FORM  ` iv_alv_key `_` ls_fcat-fieldname `_CHANGED`.
      _set1 `*&---------------------------------------------------------------------*`.
      _set1 `*       TEXT`.
      _set1 `*----------------------------------------------------------------------*`.
      _set7 `FORM ` iv_alv_key `_` ls_fcat-fieldname `_CHANGED USING ` ms_name-form_io `_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL`.
      _set3 `                                   ` ms_name-form_iv `_ROW_ID`.
      _set3 `                                   ` ms_name-form_iv `_VALUE TYPE ANY.`.
*      _set3 `  DATA ` ms_name-l_wa `_FIELDCAT TYPE LVC_S_FCAT.` .
      _set5 `  CLEAR ` ms_name-g_wa `_` iv_alv_key `.`.
      _set4 `  READ TABLE ` ms_name-g_itab `_` iv_alv_key.
      _add7 ` INTO ` ms_name-g_wa `_` iv_alv_key ` INDEX ` ms_name-form_iv `_ROW_ID.`.
      _append.
      _set1 `  IF SY-SUBRC EQ 0.`.
      _add4 `    ` ms_name-g_wa `_` iv_alv_key.
      _add5 `-` ls_fcat-fieldname ` = ` ms_name-form_iv `_VALUE.`.
      _append.
      _add4 `    _SET_ALV_CELL ` ms_name-form_iv `_ROW_ID ` ms_name-g_constants.
      _add7 `_FIELD_` iv_alv_key `-` ls_fcat-fieldname ` ` ms_name-form_iv `_VALUE.`.
      _append.
      _set3 `    CLEAR ` ms_name-g_data `_ERR.`.
      IF ls_fcat-zkey EQ abap_true.
        _set3 `    PERFORM ` iv_alv_key `_CHECK_PK.`.
      ELSE.
        _set1 `*    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.`.
      ENDIF.
      _set5 `    IF ` ms_name-g_data `_ERR EQ ` ms_name-g_constants `_E.`.
      _set7 `      ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON = ` ms_acg_config-alv_class `=>MC_ICON-DEFECT.`.
      _set1 `    ELSE.`.
      _set7 `      ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON = ` ms_acg_config-alv_class `=>MC_ICON-CHANGE.`.
      _set1 `    ENDIF.`.
      _set7 `    _SET_ALV_CELL ` ms_name-form_iv `_ROW_ID C_FIELD-BALV_STATUS_ICON ` ms_name-g_itab `_` iv_alv_key `-BALV_STATUS_ICON.`.
      _add4 `    MODIFY ` ms_name-g_itab `_` iv_alv_key.
      _add7 ` FROM ` ms_name-g_wa `_` iv_alv_key ` INDEX ` ms_name-form_iv `_ROW_ID.`.
      _append.
      _set1 `  ENDIF.`.
      _set5 `ENDFORM.                    "` iv_alv_key `_` ls_fcat-fieldname `_CHANGED.   `.
      IF  ls_fcat-zkey EQ 'X' AND ls_fcat-tech NE 'X'.
      ELSE.
        set_annotation( CHANGING ct_code = mt_code ).
      ENDIF.
      APPEND LINES OF mt_code TO lt_code.
    ENDLOOP.
    rt_code = lt_code.
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
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&  CONSTANTS`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set5 `CONSTANTS: BEGIN OF ` ms_name-g_constants `_FIELD_` iv_alv_key `,`.
    LOOP AT it_fcat INTO ls_fcat.
      CHECK ls_fcat-fieldname <> 'BALV_STATUS_ICON'.
      _set5 `             ` ls_fcat-fieldname `     TYPE FIELDNAME VALUE '` ls_fcat-fieldname `',`.
    ENDLOOP.
    _set5 `           END OF ` ms_name-g_constants `_FIELD_` iv_alv_key `.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&  DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    IF ms_acg_config-is_standalone EQ abap_true.
      _set5 `DATA : ` ms_name-g_wa `_LAYOUT_CBO TYPE ` ms_acg_config-alv_class `=>TS_HEADER_CONFIG,`.
      _set5 `       ` ms_name-g_itab `_FIELDCAT_CBO TYPE ` ms_acg_config-alv_class `=>TT_FCAT_CONFIG.`.
    ENDIF.
    IF iv_alv_class IS INITIAL.
      _set7 `DATA : ` ms_name-g_obj `_` iv_alv_key `   TYPE REF TO ` ms_acg_config-alv_class `,`.
    ELSE.
      _set7 `DATA : ` ms_name-g_obj `_` iv_alv_key `   TYPE REF TO ` iv_alv_class `,`.
    ENDIF.

    _set7 `       ` ms_name-g_obj `_CONTAINER_`  iv_alv_key ` TYPE REF TO ` lv_container `.`.

    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_inst_click.
    CLEAR : mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_INST_CLICK.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_INST_CLICK.`.
    _set1 `  DATA LV_INSERT_FLAG TYPE FLAG.`.
    _set5 `  CLEAR : ` ms_name-g_itab `_ROWS, ` ms_name-g_itab `_ROW_IDS, LV_INSERT_FLAG.`.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->GET_SELECTED_ROWS( IMPORTING ET_INDEX_ROWS = ` ms_name-g_itab `_ROWS`.
    _set3 `                                        ET_ROW_NO = ` ms_name-g_itab `_ROW_IDS ).`.

    _set3 `  IF LINES( ` ms_name-g_itab `_ROWS ) > 0.`.
    _set1 `    LV_INSERT_FLAG = ABAP_TRUE.`.
    _set5 `  ELSEIF LINES( ` ms_name-g_itab `_` iv_alv_key ` ) EQ 0.`.
    _set1 `    LV_INSERT_FLAG = ABAP_TRUE.`.
    _set1 `  ENDIF.`.
    _set1 `  IF LV_INSERT_FLAG EQ ABAP_TRUE.`.
    _set3 `    CLEAR ` ms_name-g_itab `_CELLTAB.`.
    _set7 `    ` ms_name-g_obj `_` iv_alv_key `->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_CREATE_MODE`.
    _set3 `                                CHANGING CT_CELLTAB = ` ms_name-g_itab `_CELLTAB ).`.
    _set3 `    IF LINES( ` ms_name-g_itab `_ROWS ) > 0.`.
    _set3 `      SORT ` ms_name-g_itab `_ROWS BY INDEX.`.
    _set5 `      ` ms_name-g_data `_INDEX = ` ms_name-g_itab `_ROWS[ 1 ]-INDEX.`.
    _set3 `      SORT ` ms_name-g_itab `_ROWS BY INDEX DESCENDING.`.
*    _set3 `      CLEAR ` ms_name-g_itab `_CELLTAB.`.
*    _set7 `    ` ms_name-g_obj `_` iv_alv_key `->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_CREATE_MODE`.
*    _set3 `                                CHANGING CT_CELLTAB = ` ms_name-g_itab `_CELLTAB ).`.
    _set5 `      LOOP AT ` ms_name-g_itab `_ROWS INTO ` ms_name-g_wa `_ROWS.`.
    _set5 `        CLEAR ` ms_name-g_wa `_` iv_alv_key `.`.
    _set7 `      ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON = ` ms_acg_config-alv_class `=>MC_ICON-CREATE.`.
    _set7 `      ` ms_name-g_wa `_` iv_alv_key `-CELLTAB = ` ms_name-g_itab `_CELLTAB.`.
    _set5 `        _SET_TIMESTAMP_CREATE ` ms_name-g_wa `_` iv_alv_key `.`.
    _add4 `        INSERT ` ms_name-g_wa `_` iv_alv_key.
    _add7 ` INTO ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-g_data `_INDEX.`.
    _append.
    _set1 `      ENDLOOP.`.
    _set5 `    ELSEIF LINES( ` ms_name-g_itab `_` iv_alv_key ` ) EQ 0.`.
    _set5 `        CLEAR ` ms_name-g_wa `_` iv_alv_key `.`.
    _set7 `      ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON = ` ms_acg_config-alv_class `=>MC_ICON-CREATE.`.
    _set7 `      ` ms_name-g_wa `_` iv_alv_key `-CELLTAB = ` ms_name-g_itab `_CELLTAB.`.
    _set5 `        _SET_TIMESTAMP_CREATE ` ms_name-g_wa `_` iv_alv_key `.`.
    _add5 `        APPEND ` ms_name-g_wa `_` iv_alv_key ` TO `.
    _add4 ms_name-g_itab `_` iv_alv_key `.`.
    _append.
    _set1 `    ENDIF.`.
    _set5 `    ` ms_name-g_obj `_` iv_alv_key `->SET_CHANGING_FLAG( ABAP_TRUE ).`.
    _set5 `    ` ms_name-g_obj `_` iv_alv_key `->REFRESH( ).`.
    _set1 `  ELSE.`.
    _set5 `    ` ms_acg_config-alv_class `=>MESSAGE_STRIP( EXPORTING IV_CODE = ` ms_acg_config-alv_class `=>MC_MSG-NO_ROW_SELECT ).`.
    _set1 `  ENDIF.`.

    "라인이 하나도 없으면 append하는 로직으로 변경을 위해 주석 처리
*    _set3 `  IF LINES( ` ms_name-g_itab `_ROWS ) > 0.`.
*    _set3 `    SORT ` ms_name-g_itab `_ROWS BY INDEX.`.
*    _set5 `    ` ms_name-g_data `_INDEX = ` ms_name-g_itab `_ROWS[ 1 ]-INDEX.`.
*    _set3 `    SORT ` ms_name-g_itab `_ROWS BY INDEX DESCENDING.`.
*    _set3 `    CLEAR ` ms_name-g_itab `_CELLTAB.`.
*    _set7 `    ` ms_name-g_obj `_` iv_alv_key `->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_CREATE_MODE`.
*    _set3 `                                CHANGING CT_CELLTAB = ` ms_name-g_itab `_CELLTAB ).`.
*    _set5 `    LOOP AT ` ms_name-g_itab `_ROWS INTO ` ms_name-g_wa `_ROWS.`.
*    _set5 `      CLEAR ` ms_name-g_wa `_` iv_alv_key `.`.
*    _set7 `      ` ms_name-g_wa `_` iv_alv_key `-BALV_STATUS_ICON = ` ms_acg_config-alv_class `=>MC_ICON-CREATE.`.
*    _set7 `      ` ms_name-g_wa `_` iv_alv_key `-CELLTAB = ` ms_name-g_itab `_CELLTAB.`.
*    _set5 `      _SET_TIMESTAMP_CREATE ` ms_name-g_wa `_` iv_alv_key `.`.
*    _add4 `      INSERT ` ms_name-g_wa `_` iv_alv_key.
*    _add7 ` INTO ` ms_name-g_itab `_` iv_alv_key ` INDEX ` ms_name-g_data `_INDEX.`.
*    _append.
*    _set1 `    ENDLOOP.`.
*    _set5 `    ` ms_name-g_obj `_` iv_alv_key `->SET_CHANGING_FLAG( ABAP_TRUE ).`.
*    _set5 `    ` ms_name-g_obj `_` iv_alv_key `->REFRESH( ).`.
*    _set1 `  ELSE.`.
*    _set5 `    ` ms_acg_config-alv_class `=>MESSAGE_STRIP( EXPORTING IV_CODE = ` ms_acg_config-alv_class `=>MC_MSG-NO_ROW_SELECT ).`.
*    _set1 `  ENDIF.`.
*    _set1 ``.
    _set3 `ENDFORM.                    "` iv_alv_key `_INST_CLICK.`.

    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_itab.
    CLEAR mt_code.
    _set5 `DATA : BEGIN OF ` ms_name-g_wa `_` iv_alv_key `.`.
    _set3 `        .INCLUDE TYPE ` iv_tabnm `. `.
    _set1 `        DATA : CELLTAB TYPE LVC_T_STYL,`.
    _set1 `        COLTAB TYPE LVC_T_SCOL,`.
    _set1 `        RCOLOR(4), "c_alv_yellow, blue, green, red`.
    _set5 `      END OF ` ms_name-g_wa `_` iv_alv_key `,`.
    _add4 `      ` ms_name-g_itab `_` iv_alv_key.
    _add5 `      LIKE TABLE OF ` ms_name-g_wa `_` iv_alv_key ` WITH HEADER LINE,`.
    _append.
    _add4 `      ` ms_name-g_itab `_` iv_alv_key.
    _add5 `_BUFF LIKE TABLE OF ` ms_name-g_wa `_` iv_alv_key `.`.
    _append.
    _add4 `FIELD-SYMBOLS <` ms_name-g_fieldsymbol_s `_` iv_alv_key.
    _add5 `> LIKE ` ms_name-g_wa `_` iv_alv_key `.`.
    _append.
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

    _set1 `ENDFORM.                    "RFSH_CLICK`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_save_click.
    CLEAR  mt_code.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_save_data.
    DATA ls_alv_tab TYPE gts_alv_tab.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&      FORM  SAVE_DATA.`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set1 `FORM SAVE_DATA.`.

    LOOP AT it_alv_tab INTO ls_alv_tab.
      _set1 `  DATA:  `.
      _set7 `        ` ms_name-l_wa `_` ls_alv_tab-alv_key `        TYPE ` ls_alv_tab-tabnm `,`.
      _set7 `        ` ms_name-l_itab `_CREATE_` ls_alv_tab-alv_key ` TYPE TABLE OF ` ls_alv_tab-tabnm `,`.
      _set7 `        ` ms_name-l_itab `_UPDATE_` ls_alv_tab-alv_key ` TYPE TABLE OF ` ls_alv_tab-tabnm `,`.
      _set7 `        ` ms_name-l_itab `_DELETE_` ls_alv_tab-alv_key ` TYPE TABLE OF ` ls_alv_tab-tabnm `.`.
      CLEAR ls_alv_tab.
    ENDLOOP.
    _set1 `  DATA:  `.
    _set3 `        ` ms_name-l_data `_CREATE_CNT  TYPE SY-DBCNT,`.
    _set3 `        ` ms_name-l_data `_UPDATE_CNT  TYPE SY-DBCNT,`.
    _set3 `        ` ms_name-l_data `_DELETE_CNT  TYPE SY-DBCNT.`.
    _set1 ``.
    _set3 `  CLEAR ` ms_name-g_itab `_LOG[].`.
    LOOP AT it_alv_tab INTO ls_alv_tab.
      _set5 `  CLEAR ` ms_name-g_wa `_` ls_alv_tab-alv_key `.`.
      _add4 `  LOOP AT ` ms_name-g_itab `_` ls_alv_tab-alv_key.
      _add5 ` INTO ` ms_name-g_wa `_` ls_alv_tab-alv_key `.`.
      _append.
      _set5 `    CLEAR ` ms_name-l_wa `_` ls_alv_tab-alv_key `.`.
      _set5 `    IF ` ms_name-g_wa `_` ls_alv_tab-alv_key `-BALV_STATUS_ICON IS NOT INITIAL.`.
      _set7 `      PERFORM ` ls_alv_tab-alv_key `_VERIFY_DATA USING SY-TABIX ` ms_name-g_wa `_` ls_alv_tab-alv_key `.`.
      _add4 `      MOVE-CORRESPONDING ` ms_name-g_wa `_` ls_alv_tab-alv_key.
      _add5 ` TO ` ms_name-l_wa `_` ls_alv_tab-alv_key `.`.
      _append.
      _set1 `    ENDIF.`.
      _set5 `    CASE ` ms_name-g_wa `_` ls_alv_tab-alv_key `-BALV_STATUS_ICON.`.
      _set3 `      WHEN ` ms_acg_config-alv_class `=>MC_ICON-CREATE.`.
      _set5 `        _set_timestamp_create ` ms_name-l_wa `_` ls_alv_tab-alv_key `.`.
      _add4 `        APPEND ` ms_name-l_wa `_` ls_alv_tab-alv_key.
      _add5 ` TO ` ms_name-l_itab `_CREATE_` ls_alv_tab-alv_key `.`.
      _append.
      _set3 `      WHEN ` ms_acg_config-alv_class `=>MC_ICON-CHANGE.`.
      _set5 `        _set_timestamp_change ` ms_name-l_wa `_` ls_alv_tab-alv_key `.`.
      _add4 `        APPEND ` ms_name-l_wa `_` ls_alv_tab-alv_key.
      _add5 ` TO ` ms_name-l_itab `_UPDATE_` ls_alv_tab-alv_key `.`.
      _append.
      _set3 `      WHEN ` ms_acg_config-alv_class `=>MC_ICON-DELETE.`.
      _add4 `        APPEND ` ms_name-l_wa `_` ls_alv_tab-alv_key.
      _add5 ` TO ` ms_name-l_itab `_DELETE_` ls_alv_tab-alv_key `.`.
      _append.
      _set1 `    ENDCASE.`.
      _set5 `    CLEAR ` ms_name-g_wa `_` ls_alv_tab-alv_key `.`.
      _set1 `  ENDLOOP.`.
      _set1 ``.
      CLEAR ls_alv_tab.
    ENDLOOP.
    _set1 ``.
    _set3 `  IF ` ms_name-g_itab `_LOG[] IS NOT INITIAL.`.
    _set5 `     ` ms_acg_config-alv_class `=>MESSAGE_POPUP( CHANGING CT_MSG = ` ms_name-g_itab `_LOG[] ).`.
    _set1 `    EXIT.`.
    _set1 `  ENDIF.`.
    _set1 ``.
    _set3 `  IF ` ms_acg_config-alv_class `=>CONFIRM_SAVE( ) NE ABAP_TRUE.`.
    _set1 `    EXIT.`.
    _set1 `  ENDIF.`.
    _set1 ``.
    _set1 `  TRY.`.
    LOOP AT it_alv_tab INTO ls_alv_tab.
      _set5 `      IF ` ms_name-l_itab `_CREATE_` ls_alv_tab-alv_key ` IS NOT INITIAL.`.
      _set7 `        INSERT ` ls_alv_tab-tabnm ` FROM TABLE ` ms_name-l_itab `_CREATE_` ls_alv_tab-alv_key `.`.
      _add4 `        ` ms_name-l_data `_CREATE_CNT = ` ms_name-l_data.
      _add5 `_CREATE_CNT + LINES( ` ms_name-l_itab `_CREATE_` ls_alv_tab-alv_key ` ).`.
      _append.
      _set1 `      ENDIF.`.
      _set5 `      IF ` ms_name-l_itab `_UPDATE_` ls_alv_tab-alv_key ` IS NOT INITIAL.`.
      _set7 `        MODIFY ` ls_alv_tab-tabnm ` FROM TABLE ` ms_name-l_itab `_UPDATE_` ls_alv_tab-alv_key `.`.
      _add4 `        ` ms_name-l_data `_UPDATE_CNT = ` ms_name-l_data.
      _add5 `_UPDATE_CNT + LINES( ` ms_name-l_itab `_UPDATE_` ls_alv_tab-alv_key ` ).`.
      _append.
      _set1 `      ENDIF.`.
      _set5 `      IF ` ms_name-l_itab `_DELETE_` ls_alv_tab-alv_key ` IS NOT INITIAL.`.
      _set7 `        DELETE ` ls_alv_tab-tabnm ` FROM TABLE ` ms_name-l_itab `_DELETE_` ls_alv_tab-alv_key `.`.
      _add4 `        ` ms_name-l_data `_DELETE_CNT = ` ms_name-l_data.
      _add5 `_DELETE_CNT + LINES( ` ms_name-l_itab `_DELETE_` ls_alv_tab-alv_key ` ).`.
      _append.
      _set1 `      ENDIF.`.
      CLEAR ls_alv_tab.
    ENDLOOP.

    _set3 `    CATCH CX_ROOT INTO ` ms_name-g_obj `_EXCEPTION.`.
    _set5 `      ` ms_acg_config-alv_class `=>CATCH_EXCEPTION( IO_ROOT = ` ms_name-g_obj `_EXCEPTION ).`.
    _set1 `  ENDTRY.`.
    _set5 `  ` ms_acg_config-alv_class `=>MESSAGE_STRIP( EXPORTING IV_CODE = ` ms_acg_config-alv_class `=>MC_MSG-SAVE_SUCCESS`.
    _set3 `                                    IV_PARAM1 = |{ ` ms_name-l_data `_CREATE_CNT }|`.
    _set3 `                                    IV_PARAM2 = |{ ` ms_name-l_data `_UPDATE_CNT }|`.
    _set3 `                                    IV_PARAM3 = |{ ` ms_name-l_data `_DELETE_CNT }| ).`.
    _set1 ``.
    LOOP AT it_alv_tab INTO ls_alv_tab.
      _set5 `  CLEAR ` ms_name-g_itab `_` ls_alv_tab-alv_key `_BUFF[].`.
      _set5 `  ` ms_name-g_obj `_` ls_alv_tab-alv_key `->SET_CHANGING_FLAG( ABAP_FALSE ).`.
      _set7 `  DELETE ` ms_name-g_itab `_` ls_alv_tab-alv_key ` WHERE BALV_STATUS_ICON = ` ms_acg_config-alv_class `=>MC_ICON-DELETE.`.
      _add4 `  LOOP AT ` ms_name-g_itab `_` ls_alv_tab-alv_key.
      _add5 ` ASSIGNING <` ms_name-g_fieldsymbol_s `_` ls_alv_tab-alv_key `>.`.
      _append.
      _set5 `    IF <` ms_name-g_fieldsymbol_s `_` ls_alv_tab-alv_key `>-BALV_STATUS_ICON IS NOT INITIAL.`.
      _set5 `      CLEAR <` ms_name-g_fieldsymbol_s `_` ls_alv_tab-alv_key `>-BALV_STATUS_ICON.`.
      _set1 `    ENDIF.`.
      _set1 `  ENDLOOP.`.
      CLEAR ls_alv_tab.
    ENDLOOP.
    LOOP AT it_alv_tab INTO ls_alv_tab.
      _set7 `  ` ms_name-g_obj `_` ls_alv_tab-alv_key `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE`.
      _set5 `                    CHANGING CT_DATA  = ` ms_name-g_itab `_` ls_alv_tab-alv_key `[] ).`.
      CLEAR ls_alv_tab.
    ENDLOOP.
    _set1 `ENDFORM.                    "SAVE_DATA`.

    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_scr_1000.
    CLEAR mt_code.
    CHECK ms_acg_config-is_1step EQ abap_false.

    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*&  SELECTION SCREEN`.
    _set1 `*&---------------------------------------------------------------------*`.
    IF iv_zexcel EQ 'X'.
      _set1 `SELECTION-SCREEN BEGIN OF SCREEN 010 AS SUBSCREEN.`.
      _set1 `SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text009.`.
      set_define_select_screen( EXPORTING it_fcat = it_fcat iv_tabname = iv_tabnm ).
      _set1 `SELECTION-SCREEN END OF BLOCK b1.`.
      _set1 `SELECTION-SCREEN END OF SCREEN 010.`.
      _set1 ``.
      _set1 `SELECTION-SCREEN BEGIN OF SCREEN 020 AS SUBSCREEN.`.
      _set1 `SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.`.
      _set1 `SELECTION-SCREEN BEGIN OF LINE.`.
      _set1 `SELECTION-SCREEN COMMENT (20) TEXT003  MODIF ID UP.`.
      _set3 `PARAMETERS : ` ms_name-parameters `_FILE LIKE RLGRAP-FILENAME VISIBLE LENGTH 35 DEFAULT 'C:\' OBLIGATORY MODIF ID UP.`.
      _set3 `PARAMETER: ` ms_name-parameters `_UCOMM LIKE SY-UCOMM DEFAULT 'SAMP' NO-DISPLAY.`.
      _set1 `SELECTION-SCREEN END OF LINE.`.
      _set1 `SELECTION-SCREEN BEGIN OF LINE.`.
      _set1 `SELECTION-SCREEN COMMENT (20) TEXT006 MODIF ID UP.`.
      _set3 `SELECTION-SCREEN PUSHBUTTON (14) ` ms_name-parameters `_SAMP USER-COMMAND SAMP MODIF ID UP.`.
      _set1 `SELECTION-SCREEN COMMENT (20) TEXT007 MODIF ID UP.`.
      _set1 `SELECTION-SCREEN END OF LINE.`.
      _set1 `SELECTION-SCREEN END OF BLOCK b2.`.
      _set1 `SELECTION-SCREEN END OF SCREEN 020.`.
      _set1 ``.
      _set3 `SELECTION-SCREEN: BEGIN OF TABBED BLOCK ` ms_name-g_obj `_TAB FOR 10 LINES,`.
      _set1 `                  TAB (20) text001 USER-COMMAND disp,`.
      _set1 `                  TAB (20) text002 USER-COMMAND upld,`.
      _set3 `                  END OF BLOCK ` ms_name-g_obj `_TAB.`.
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
      _set1 `  CASE SY-DYNNR.`.
      _set1 `    WHEN 1000.`.
      _set1 `      CASE SY-UCOMM.`.
      _set3 `        WHEN ` ms_name-g_constants `_UCOMM-DISPLAY.`.
      _set3 `          ` ms_name-g_obj `_TAB-DYNNR = 010.`.
      _set3 `          ` ms_name-g_obj `_TAB-ACTIVETAB = SY-UCOMM.`.
      _set3 `        WHEN ` ms_name-g_constants `_UCOMM-UPLOAD.`.
      _set3 `          ` ms_name-g_obj `_TAB-DYNNR = 020.`.
      _set3 `          ` ms_name-g_obj `_TAB-ACTIVETAB = SY-UCOMM.`.
      _set1 `      ENDCASE.      `.
      _set1 `      IF SSCRFIELDS-UCOMM EQ 'SAMP'.`.
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
          _set4 `        ` ms_acg_config-alv_class `=>GET_ALV_ITAB( EXPORTING IV_ALV_KEY = ` iv_alv_key.
          _set2 `                                                  IV_FCAT_KEY = ` iv_fcat_key.
          _set3 `                                        IMPORTING EO_DATA = ` ms_name-g_obj `_DOWNLOAD_DATA`.
          _set3 `                                                  ET_HEADER_LABEL = ` ms_name-g_itab `_EXCEL_HEADER ).`.
        ENDIF.

        _set5 `        ASSIGN ` ms_name-g_obj `_DOWNLOAD_DATA->* TO <` ms_name-g_fieldsymbol_t `_DOWNLOAD_TAB>.`.
        _set5 `        ` ms_acg_config-alv_class `=>ITAB_TO_EXCEL_DOWNLOAD( EXPORTING IT_HEADER = ` ms_name-g_itab `_EXCEL_HEADER`.
        _set3 `                                                         IT_TAB = <` ms_name-g_fieldsymbol_t `_DOWNLOAD_TAB>  ).`.

*      _set5 `        PERFORM ITAB_TO_EXCEL_DOWNLOAD TABLES <` ms_name-g_fieldsymbol_t `_DOWNLOAD_TAB> ` ms_name-g_itab `_EXCEL_HEADER[] USING 'SAMPLE' '' . `.
      ENDIF.
      _set1 `      ENDIF.`.

      _set1 `  ENDCASE.`.
      _set1 `*&---------------------------------------------------------------------**`.
      _set1 `* AT SELECTION-SCREEN ON VALUE-REQUEST                                 *`.
      _set1 `*&---------------------------------------------------------------------**`.
      _set3 `AT SELECTION-SCREEN ON VALUE-REQUEST FOR ` ms_name-parameters `_FILE.`.
      _set5 `  ` ms_acg_config-alv_class `=>ADD_EXCEL_FILE_OPEN_DIALOG( CHANGING CV_FILE = ` ms_name-parameters `_FILE ).`.

    ENDIF.
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
        _set3 `  ` ms_name-parameters `_SAMP = text-b01. "'Download'.`.
        _set1 `  TEXT001 = text-t01. "'Display'.`.
        _set1 `  TEXT002 = text-t02. "'Upload'.`.
        _set1 `  TEXT003 = text-t03. "'File Path'.`.
        _set1 `  TEXT006 = text-t04. "'Sample Excel'.`.
      ENDIF.
      _set1 `  TEXT009 = text-t09. "'Select Options'.`.

      LOOP AT it_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'..
        ADD 1 TO lv_cnt.
        _set7 `  TEXT0` lv_cnt ` = '` ls_fcat-reptext `'."text-t` lv_cnt ``.
      ENDLOOP.
      LOOP AT it_fcat INTO ls_fcat WHERE zkey NE 'X' AND tech NE 'X'..
        ADD 1 TO lv_cnt.
        _set7 `*  TEXT0` lv_cnt ` = '` ls_fcat-reptext `'."text-t` lv_cnt ``.
      ENDLOOP.
      IF iv_excel_upload EQ 'X'.
        _set3 `  ` ms_name-g_obj `_TAB-PROG = SY-REPID.`.
        _set3 `  ` ms_name-g_obj `_TAB-DYNNR = 010.`.
        _set3 `  ` ms_name-g_obj `_TAB-ACTIVETAB = C_UCOMM-DISPLAY.   `.
      ENDIF.
      _set1 ``.
    ENDIF.
    _set1 `ENDFORM.                    " SET_INIT_VALUE`.
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
    _set7 `*  IF ` ms_name-g_obj `_` iv_alv_key `->GET_ALV_MODE( ) NE ` ms_acg_config-alv_class `=>MC_DISPLAY_MODE.`.
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
      _set3 `  CASE ` ms_name-g_obj `_TAB-ACTIVETAB.`.
      _set3 `    WHEN ` ms_name-g_constants `_UCOMM-DISPLAY.`.
      _set3 `      PERFORM GET_` iv_alv_key `_DATA.`.
      _set3 `    WHEN ` ms_name-g_constants `_UCOMM-UPLOAD.`.
      _set5 `      PERFORM UPLOAD_` iv_alv_key `_DATA USING ABAP_FALSE ` ms_name-parameters `_FILE.`.
      _set3 `      IF ` ms_name-g_data `_ERR = ABAP_TRUE.`.
      _set1 `        EXIT.`.
      _set1 `      ENDIF.`.
      _set1 `  ENDCASE.`.
    ELSE.
      _set1 `  PERFORM CHECK_AUTHORITY.`.
      _set3 `  PERFORM GET_` iv_alv_key `_DATA.`.
    ENDIF.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_struct_line.

    CLEAR mt_code.
    CALL METHOD super->get_struct_line
      EXPORTING
        it_fcat = it_fcat
      RECEIVING
        rt_code = mt_code.

    APPEND `          BALV_STATUS_ICON TYPE ICON-ID,` TO rt_code.
    APPEND LINES OF mt_code TO rt_code.

  ENDMETHOD.


  METHOD get_upload_click_form.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_UPLD_CLICK`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set3 `FORM ` iv_alv_key `_UPLD_CLICK.`.
    _add4 `  ` ms_name-g_itab `_` iv_alv_key.
    _add5 `_BUFF[] = ` ms_name-g_itab `_` iv_alv_key `[].`.
    _append.
    _set5 `  _INIT ` ms_name-g_itab `_` iv_alv_key `.`.
    _set3 `  PERFORM UPLOAD_` iv_alv_key `_DATA USING ABAP_TRUE ''.`.
    _set3 `  IF ` ms_name-g_data `_ERR = ABAP_TRUE.`.
    _set1 `    EXIT.`.
    _set1 `  ENDIF.`.
    _set7 `  ` ms_name-g_obj `_` iv_alv_key `->DISPLAY( EXPORTING IV_MODE = ` ms_acg_config-alv_class `=>MC_UPLOAD_MODE`.
    _set5 `                     CHANGING CT_DATA  = ` ms_name-g_itab `_` iv_alv_key `[] ).    `.
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
    _set3 `  IF  ` ms_name-g_data `_SUBRC EQ 0.`.
    _set5 `    LOOP AT ` ms_name-l_itab `_TAB INTO ` ms_name-l_wa `_TAB.`.
    _set7 `      MOVE-CORRESPONDING ` ms_name-l_wa `_TAB TO ` ms_name-g_itab `_` iv_alv_key `.`.
    _set5 `      APPEND ` ms_name-g_itab `_` iv_alv_key `.`.
    _set7 `      CLEAR : ` ms_name-l_wa `_TAB, ` ms_name-g_itab `_` iv_alv_key `.`.
    _set1 `    ENDLOOP.`.
    _set5 `    ` ms_name-g_obj `_` iv_alv_key `->SET_CHANGING_FLAG( ABAP_TRUE ).    `.
    _set1 `  ELSE.`.
    IF ms_acg_config-is_standalone EQ abap_true.
      _set3 `    MESSAGE 'No File Selected' TYPE 'S' DISPLAY LIKE ` ms_name-g_constants `_E.`.
    ELSE.
      _set3 `    MESSAGE S004(ZBRD001) DISPLAY LIKE ` ms_name-g_constants `_E.`.
    ENDIF.

    _set3 `     ` ms_name-g_data `_ERR = ABAP_TRUE.`.
    _set1 `  ENDIF.`.
    _set1 ``.
    _set1 `ENDFORM.                    " UPLOAD_DATA`.
    rt_code = mt_code.
  ENDMETHOD.


  METHOD get_verify_data.
    DATA : ls_fcat  TYPE ztbrd00020,
           lv_flag  TYPE flag,
           lv_tabix TYPE sy-tabix.
    CLEAR mt_code.
    _set1 `*&---------------------------------------------------------------------*`.
    _set3 `*&      FORM  ` iv_alv_key `_VERIFY_DATA`.
    _set1 `*&---------------------------------------------------------------------*`.
    _set1 `*       TEXT`.
    _set1 `*----------------------------------------------------------------------*`.
    _set5 `FORM ` iv_alv_key `_VERIFY_DATA USING ` ms_name-form_iv `_TABIX TYPE SY-TABIX`.
    _set7 `                                      ` ms_name-form_is `_DATA LIKE ` ms_name-g_wa `_` iv_alv_key `.`.
    CLEAR lv_tabix.
    LOOP AT it_fcat INTO ls_fcat WHERE zkey EQ 'X' AND tech NE 'X'..
      IF lv_tabix EQ 0.
        _set7 `    IF ` ms_name-g_wa `_` iv_alv_key `-` ls_fcat-fieldname ` IS INITIAL`.
      ELSE.
        _set7 `       OR ` ms_name-g_wa `_` iv_alv_key `-` ls_fcat-fieldname ` IS INITIAL`.
      ENDIF.
      ADD 1 TO lv_tabix.
      lv_flag = abap_true.
    ENDLOOP.
    _set1 `.`.
    _set3 `      APPEND VALUE #( ICON = ` ms_acg_config-alv_class `=>MC_ICON-DEFECT`.
    _set3 `                      ROW_NO = ` ms_name-form_iv `_TABIX`.
    _add4 `                      MSG = ` ms_name-g_obj `_` iv_alv_key.
    _add5 `->MESSAGE( EXPORTING IV_CODE = ` ms_acg_config-alv_class `=>MC_MSG-INPUT_MANDATORY ) ) TO ` ms_name-g_itab `_LOG.`.
    _append.
    IF lv_flag = abap_true.
      _set1 `    ENDIF.`.
    ENDIF.
    _set3 `ENDFORM.                    " ` iv_alv_key `_VERIFY_DATA`.
    rt_code = mt_code.
  ENDMETHOD.
ENDCLASS.
