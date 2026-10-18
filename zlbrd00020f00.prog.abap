*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*&---------------------------------------------------------------------*
*&  Include           ZLBRD00020F00
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  set_screen  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_screen OUTPUT.
  SET PF-STATUS '9100'.
  SET TITLEBAR '9100' WITH TEXT-t00.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      MODULE  SET_SELECTED_TAB  OUTPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE set_selected_tab OUTPUT.
  go_tabstrip-activetab = gs_tab_list-pressed_tab.
  CASE gs_tab_list-pressed_tab.
    WHEN 'MAIN'.
      gs_tab_list-subscreen = '9102'.
    WHEN 'TOP'.
      gs_tab_list-subscreen = '9103'.
    WHEN 'F01'.
      gs_tab_list-subscreen = '9104'.
    WHEN 'S100'.
      gs_tab_list-subscreen = '9105'.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      MODULE  GET_SELECTED_TAB  INPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE get_selected_tab INPUT .
  gs_tab_list-pressed_tab = gv_okcode.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9101 OUTPUT.
  SET PF-STATUS '9101'.
  SET TITLEBAR '9101'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9210  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9210 OUTPUT.
  SET PF-STATUS '9210'.
  SET TITLEBAR '9210'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  set_alv  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_alv OUTPUT.
  CHECK go_container_top IS INITIAL.
  PERFORM get_source_code.


  CREATE OBJECT go_container_top
    EXPORTING
      container_name = 'CON_TOP'
      repid          = sy-repid
      dynnr          = sy-dynnr.
  CREATE OBJECT go_container_main
    EXPORTING
      container_name = 'CON_MAIN'
      repid          = sy-repid
      dynnr          = sy-dynnr.
  CREATE OBJECT go_container_f01
    EXPORTING
      container_name = 'CON_F01'
      repid          = sy-repid
      dynnr          = sy-dynnr.
  CREATE OBJECT go_container_100
    EXPORTING
      container_name = 'CON_100'
      repid          = sy-repid
      dynnr          = sy-dynnr.
*  CREATE OBJECT go_splitter_container
*    EXPORTING
*      parent  = cl_gui_container=>default_screen
*      rows    = 2
*      columns = 1.
*  go_container_title = go_splitter_container->get_container( row = 1 column = 1 ) .
*  go_container_body = go_splitter_container->get_container( row = 2 column = 1 ) .
*
*  go_splitter_container->set_row_height( id = 1 height = 30 ).
*  go_splitter_container->set_row_height( id = 2 height = 70 ).
*
*
*  CREATE OBJECT go_splitter_container_editor
*    EXPORTING
*      parent  = go_container_body
*      rows    = 2
*      columns = 2.
*
*  go_container_top = go_splitter_container_editor->get_container( row = 1 column = 2 ).
*  go_container_main = go_splitter_container_editor->get_container( row = 1 column = 1 ).
*  go_container_f01 = go_splitter_container_editor->get_container( row = 2 column = 1 ).
*  go_container_100 = go_splitter_container_editor->get_container( row = 2 column = 2 ).

  CREATE OBJECT go_textedit_top
    EXPORTING
      parent = go_container_top.
  CREATE OBJECT go_textedit_main
    EXPORTING
      parent = go_container_main.
  CREATE OBJECT go_textedit_f01
    EXPORTING
      parent = go_container_f01.
  CREATE OBJECT go_textedit_100
    EXPORTING
      parent = go_container_100.


  go_textedit_top->set_text( table = gt_top ).
  go_textedit_main->set_text( table = gt_main ).
  go_textedit_f01->set_text( table = gt_f01 ).
  go_textedit_100->set_text( table = gt_100 ).

  CREATE OBJECT go_document .
  PERFORM set_title.
  go_document->display_document( parent = go_container_title ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_SCREEN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_screen INPUT.
  CASE gv_okcode.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT' OR 'CANC'.
      SUBMIT (sy-cprog) VIA SELECTION-SCREEN
                        WITH pa_r1 = pa_r1
                        WITH pa_r2 = pa_r2
                        WITH pa_r3 = pa_r3
                        WITH pa_r4 = pa_r4
                        WITH pa_r5 = pa_r5
                        WITH pa_s1 = pa_s1
                        WITH pa_s2 = pa_s2
                        WITH pa_s3 = pa_s3
                        WITH pa_s4 = pa_s4
                        WITH pa_s5 = pa_s5
                        WITH pa_s6 = pa_s6
                        WITH pa_modu = pa_modu
                        WITH pa_prog = pa_prog
                        WITH pa_tabnm = pa_tabnm
                        WITH pa_alv = pa_alv
                        WITH pa_fcat = pa_fcat
                        WITH pa_prog = pa_prog
                        .
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command INPUT.
  CASE gv_okcode.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'COPY'.
      PERFORM copy_screen.
    WHEN 'GENP'.
      CLEAR : gv_repti, gv_tcode_gen.
      CALL SCREEN 9210 STARTING AT 10 5 ENDING AT 100 7.

    WHEN 'EXEC'.
      CASE abap_true.
        WHEN pa_r1.
          PERFORM check_join_input USING gv_err.
          IF gv_err EQ abap_true.
            EXIT.
          ENDIF.
          CALL SCREEN 9100.
        WHEN pa_r2.
          PERFORM check_double_input USING gv_err.
          IF gv_err EQ abap_true.
            EXIT.
          ENDIF.

          CALL SCREEN 9100.
        WHEN pa_r3.
          PERFORM check_multi_input USING gv_err.
          IF gv_err EQ abap_true.
            EXIT.
          ENDIF.
          CALL SCREEN 9100.
        WHEN pa_r5.
          IF pa_s6 EQ abap_true.
            PERFORM check_double_input USING gv_err.
            IF gv_err EQ abap_true.
              EXIT.
            ENDIF.
          ENDIF.
          CALL SCREEN 9100.
      ENDCASE.
  ENDCASE.
  CLEAR gv_okcode.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9210  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9210 INPUT.
  CASE gv_okcode.
    WHEN 'EXEC'.
      PERFORM generate_program.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  CHECK_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_input USING pv_err.
  CASE abap_true.
    WHEN pa_r1.
      CASE abap_true.
        WHEN pa_s1.
          PERFORM check_tabnm USING pa_tabnm pv_err.
          PERFORM check_alv_key USING pa_alv pv_err.
          PERFORM check_fcat_key USING pa_alv pa_fcat pv_err.
        WHEN pa_s2.
          PERFORM check_alv_key USING pa_alv pv_err.
          PERFORM check_fcat_key USING pa_alv pa_fcat pv_err.
      ENDCASE.
    WHEN pa_r4.
      PERFORM check_tabnm USING pa_tabnm pv_err.
      PERFORM check_talv_key USING pa_alv pv_err.
      PERFORM check_tfcat_key USING pa_alv pa_fcat pv_err.
    WHEN pa_r5.
      CASE abap_true.
        WHEN pa_s5.
          PERFORM check_tabnm USING pa_tabnm pv_err.
        WHEN pa_s6.

      ENDCASE.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_TABNM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_tabnm  USING pv_tabnm pv_err.
  IF pv_tabnm IS INITIAL.
    MESSAGE TEXT-m03 TYPE 'S' DISPLAY LIKE 'E'.
    pv_err = abap_true.
    EXIT.
  ENDIF.
  SELECT COUNT( * ) INTO sy-dbcnt
  FROM dd02l
  WHERE tabname = pv_tabnm
  AND as4local EQ 'A'.

  IF sy-dbcnt EQ 0.
    MESSAGE TEXT-m07 TYPE 'S' DISPLAY LIKE 'E'.
    pv_err = abap_true.
    EXIT.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_ALV_KEY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_alv_key  USING pv_alv pv_err.
  IF pv_alv IS INITIAL.
    MESSAGE TEXT-m04 TYPE 'S' DISPLAY LIKE 'E'.
    pv_err = abap_true.
    EXIT.
  ENDIF.

  SELECT COUNT( * ) INTO sy-dbcnt
   FROM ztbrd00020
   WHERE progid = pa_prog
   AND alv_key = pv_alv.

  CONCATENATE `ALV Key ` pv_alv ` is not exists in ZALV` INTO gv_msg.
  IF sy-dbcnt EQ 0.
    MESSAGE gv_msg TYPE 'I' DISPLAY LIKE 'E'.
    pv_err = abap_true.
    EXIT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_FCAT_KEY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_fcat_key  USING pv_alv pv_fcat pv_err.
  IF pv_fcat IS INITIAL.
    MESSAGE TEXT-m05 TYPE 'S' DISPLAY LIKE 'E'.
    pv_err = abap_true.
    EXIT.
  ENDIF.

  SELECT COUNT( * ) INTO sy-dbcnt
   FROM ztbrd00020
   WHERE progid = pa_prog
   AND alv_key = pv_alv
   AND fcat_key = pv_fcat.

  CONCATENATE `ALV Key ` pv_alv `, Fcat Key ` pv_fcat ` is not exists in ZALV` INTO gv_msg.
  IF sy-dbcnt EQ 0.
    MESSAGE gv_msg TYPE 'I' DISPLAY LIKE 'E'.
    pv_err = abap_true.
    EXIT.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_TALV_KEY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_talv_key  USING pv_alv pv_err.
  IF pv_alv IS INITIAL.
    MESSAGE TEXT-m04 TYPE 'S' DISPLAY LIKE 'E'.
    pv_err = abap_true.
    EXIT.
  ENDIF.

  SELECT COUNT( * ) INTO sy-dbcnt
   FROM ztbrd00021
   WHERE progid = pa_prog
   AND alv_key = pv_alv.

  IF sy-dbcnt EQ 0.
    MESSAGE TEXT-m06 TYPE 'S' DISPLAY LIKE 'E'.
    pv_err = abap_true.
    EXIT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_TFCAT_KEY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_tfcat_key  USING pv_alv pv_fcat pv_err.
  IF pv_fcat IS INITIAL.
    MESSAGE TEXT-m05 TYPE 'S' DISPLAY LIKE 'E'.
    pv_err = abap_true.
    EXIT.
  ENDIF.

  SELECT COUNT( * ) INTO sy-dbcnt
   FROM ztbrd00021
   WHERE progid = pa_prog
   AND alv_key = pv_alv
   AND fcat_key = pv_fcat.

  IF sy-dbcnt EQ 0.
    MESSAGE TEXT-m06 TYPE 'S' DISPLAY LIKE 'E'.
    pv_err = abap_true.
    EXIT.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SET_TITLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_title .
  DATA lv_str TYPE string.
  DATA lv_title_char(255).
  DEFINE _set_title.
    lv_title_char = &1.
    go_document->add_text( text = lv_title_char ).
    go_document->new_line( ).
  END-OF-DEFINITION .

  CASE abap_true.
    WHEN pa_r1.
      CASE abap_true.
        WHEN pa_s1.
          CONCATENATE text010 ` : ` pa_prog INTO lv_str.
          _set_title lv_str .
          CONCATENATE text011 ` : ` pa_tabnm INTO lv_str.
          _set_title lv_str .
          CONCATENATE text012 ` : ` pa_alv INTO lv_str.
          _set_title lv_str .
          CONCATENATE text013 ` : ` pa_fcat INTO lv_str.
          _set_title lv_str .
        WHEN pa_s2.
          CONCATENATE text010 ` : ` pa_prog INTO lv_str.
          _set_title lv_str .
          LOOP AT gt_double_alv.
            CONCATENATE gt_double_alv-type ` ` text011 ` : ` gt_double_alv-tabnm INTO lv_str.
            _set_title lv_str .
          ENDLOOP.
          CONCATENATE text012 ` : ` pa_alv INTO lv_str.
          _set_title lv_str .
          CONCATENATE text013 ` : ` pa_fcat INTO lv_str.
          _set_title lv_str .
      ENDCASE.
    WHEN pa_r2.
      CONCATENATE text010 ` : ` pa_prog INTO lv_str.
      _set_title lv_str .
      LOOP AT gt_double_alv.
        CONCATENATE gt_double_alv-type ` ` text011 ` : ` gt_double_alv-tabnm INTO lv_str.
        _set_title lv_str .
        CONCATENATE gt_double_alv-type ` ` text012 ` : ` gt_double_alv-alv_key INTO lv_str.
        _set_title lv_str .
        CONCATENATE gt_double_alv-type ` ` text013 ` : ` gt_double_alv-fcat_key INTO lv_str.
        _set_title lv_str .
      ENDLOOP.
    WHEN pa_r3.
      CONCATENATE text010 ` : ` pa_prog INTO lv_str.
      _set_title lv_str .
      LOOP AT gt_multi_alv.
        lv_str = gt_multi_alv-no.
        CONCATENATE lv_str `. ` text011 ` : ` gt_multi_alv-tabnm INTO lv_str.
        CONCATENATE lv_str `, ` text012 ` : ` gt_multi_alv-alv_key INTO lv_str.
        CONCATENATE lv_str `, ` text013 ` : ` gt_multi_alv-fcat_key INTO lv_str.
        _set_title lv_str .
      ENDLOOP.
    WHEN pa_r4.
      CONCATENATE text010 ` : ` pa_prog INTO lv_str.
      _set_title lv_str .
      CONCATENATE text011 ` : ` pa_tabnm INTO lv_str.
      _set_title lv_str .
      CONCATENATE text012 ` : ` pa_alv INTO lv_str.
      _set_title lv_str .
      CONCATENATE text013 ` : ` pa_fcat INTO lv_str.
      _set_title lv_str .
    WHEN pa_r5.
      CASE abap_true.
        WHEN pa_s5.
          CONCATENATE text010 ` : ` pa_prog INTO lv_str.
          _set_title lv_str .
          CONCATENATE text011 ` : ` pa_tabnm INTO lv_str.
          _set_title lv_str .
          CONCATENATE text012 ` : ` gs_tree_grid-g_alv_key INTO lv_str.
          _set_title lv_str .
          CONCATENATE text013 ` : ` gs_tree_grid-g_fcat_key INTO lv_str.
          _set_title lv_str .
          CONCATENATE `Tree ` text012 ` : `  gs_tree_grid-t_alv_key INTO lv_str.
          _set_title lv_str .
          CONCATENATE `Tree ` text013 ` : ` gs_tree_grid-t_fcat_key INTO lv_str.
          _set_title lv_str .
        WHEN pa_s6.
          CONCATENATE text010 ` : ` pa_prog INTO lv_str.
          _set_title lv_str .
          LOOP AT gt_double_alv.
            CONCATENATE gt_double_alv-type ` ` text011 ` : ` gt_double_alv-tabnm INTO lv_str.
            _set_title lv_str .
            CONCATENATE gt_double_alv-type ` ` text012 ` : ` gt_double_alv-alv_key INTO lv_str.
            _set_title lv_str .
            CONCATENATE gt_double_alv-type ` ` text013 ` : ` gt_double_alv-fcat_key INTO lv_str.
            _set_title lv_str .
          ENDLOOP.
      ENDCASE.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  DATA lv_tabix TYPE sy-tabix.
  CASE abap_true.
    WHEN pa_r1.
      CASE abap_true.
        WHEN pa_s1.
        WHEN pa_s2.
          CLEAR : gt_double_alv[], gt_key_map[].

          gt_double_alv-type = 'Left Table'.
          gt_double_alv-alv_key = pa_alv.
          gt_double_alv-fcat_key = pa_fcat.
          APPEND gt_double_alv.

          gt_double_alv-type = 'Right Table'.
          gt_double_alv-alv_key = pa_alv.
          gt_double_alv-fcat_key = pa_fcat.
          APPEND gt_double_alv.

          DO 10 TIMES.
            gt_key_map-icon = icon_equal.
            APPEND gt_key_map.
          ENDDO.
      ENDCASE.
    WHEN pa_r2.
      CLEAR : gt_double_alv[], gt_key_map[].
      CASE abap_true.
        WHEN pa_s3.
          gt_double_alv-type = 'Left Table'.
          gt_double_alv-alv_key = 'LEFT'.
          gt_double_alv-fcat_key = 'DEFAULT'.
          gt_double_alv-progid = pa_prog.
          APPEND gt_double_alv.

          gt_double_alv-type = 'Right Table'.
          gt_double_alv-progid = pa_prog.
          gt_double_alv-alv_key = 'RIGH'.
          gt_double_alv-fcat_key = 'DEFAULT'.
          APPEND gt_double_alv.
        WHEN pa_s4.
          gt_double_alv-type = 'Header'.
          gt_double_alv-progid = pa_prog.
          gt_double_alv-alv_key = 'HEAD'.
          gt_double_alv-fcat_key = 'DEFAULT'.
          APPEND gt_double_alv.

          gt_double_alv-type = 'Item'.
          gt_double_alv-progid = pa_prog.
          gt_double_alv-alv_key = 'ITEM'.
          gt_double_alv-fcat_key = 'DEFAULT'.
          APPEND gt_double_alv.
      ENDCASE.
      DO 10 TIMES.
        gt_key_map-icon = icon_equal.
        APPEND gt_key_map.
      ENDDO.
    WHEN pa_r3.
      DO 20 TIMES.
        ADD 1 TO lv_tabix.
        gt_multi_alv-no = lv_tabix.
        APPEND gt_multi_alv.
      ENDDO.
    WHEN pa_r5.
      CASE abap_true.
        WHEN pa_s5.
          gs_tree_grid-t_cls = gv_tree_alv_class.
          gs_tree_grid-t_alv_key = 'TALV'.
          gs_tree_grid-t_fcat_key = 'DEFAULT'.
          gs_tree_grid-g_cls = gv_alv_class.
          gs_tree_grid-g_alv_key = 'BALV'.
          gs_tree_grid-g_fcat_key = 'DEFAULT'.

        WHEN pa_s6.
          CLEAR : gt_double_alv[], gt_key_map[].
          gt_double_alv-progid = pa_prog.
          gt_double_alv-type = 'Tree Table'.
          gt_double_alv-alv_key = 'TALV'.
          gt_double_alv-clsname = gv_tree_alv_class.
          gt_double_alv-fcat_key = 'DEFAULT'.
          APPEND gt_double_alv.

          gt_double_alv-progid = pa_prog.
          gt_double_alv-type = 'List Table'.
          gt_double_alv-alv_key = 'BALV'.
          gt_double_alv-clsname = gv_alv_class.
          gt_double_alv-fcat_key = 'DEFAULT'.
          APPEND gt_double_alv.

          DO 10 TIMES.
            gt_key_map-icon = icon_equal.
            APPEND gt_key_map.
          ENDDO.
      ENDCASE.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_SOURCE_CODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_source_code .
  CASE abap_true.
    WHEN pa_r1. PERFORM get_single_src.
    WHEN pa_r2. PERFORM get_double_src.
    WHEN pa_r3. PERFORM get_multi_src.
    WHEN pa_r4. PERFORM get_tree_src.
    WHEN pa_r5. PERFORM get_tree_grid_src.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INSTALL_PROGRAM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM install_program .
  DATA : lt_header TYPE TABLE OF ztbrd00010 WITH HEADER LINE,
         lt_item   TYPE TABLE OF ztbrd00020 WITH HEADER LINE.
  DATA lv_progid TYPE sy-cprog VALUE 'ZLBRD00020'.

  PERFORM get_header_install_data TABLES lt_header.
  PERFORM get_item_install_data TABLES lt_item.

  LOOP AT lt_header.
    lt_header-progid = lv_progid.
    lt_header-erdat = sy-datum.
    lt_header-erzet = sy-uzeit.
    lt_header-ernam = sy-uname.
    lt_header-aedat = sy-datum.
    lt_header-aezet = sy-uzeit.
    lt_header-aenam = sy-uname.
    MODIFY lt_header.
  ENDLOOP.

  LOOP AT lt_item.
    lt_item-progid = lv_progid.
    lt_item-erdat = sy-datum.
    lt_item-erzet = sy-uzeit.
    lt_item-ernam = sy-uname.
    lt_item-aedat = sy-datum.
    lt_item-aezet = sy-uzeit.
    lt_item-aenam = sy-uname.
    MODIFY lt_item.
  ENDLOOP.

  MODIFY ztbrd00010 FROM TABLE lt_header.
  MODIFY ztbrd00020 FROM TABLE lt_item.

  PERFORM create_acg_screen.

  MESSAGE 'Installed!!' TYPE 'I' DISPLAY LIKE 'S'.
ENDFORM.
FORM get_header_install_data TABLES pt_header STRUCTURE ztbrd00010.

  "header
  CLEAR pt_header.
  pt_header-alv_key = 'HEADER'.
  pt_header-sel_mode = 'B'.
  APPEND pt_header.
  CLEAR pt_header.
  pt_header-alv_key = 'ITEM'.
  pt_header-sel_mode = 'B'.
  APPEND pt_header.
  CLEAR pt_header.
  pt_header-alv_key = 'MULTI'.
  pt_header-sel_mode = 'B'.
  pt_header-change_evt = 'X'.
  APPEND pt_header.
  CLEAR pt_header.
  pt_header-alv_key = 'TAB'.
  pt_header-sel_mode = 'B'.
  APPEND pt_header.
  CLEAR pt_header.
  pt_header-alv_key = 'TGHD'.
  pt_header-sel_mode = 'B'.
  APPEND pt_header.
ENDFORM.
FORM get_item_install_data TABLES pt_item STRUCTURE ztbrd00020.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'HEADER'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'ALV_KEY'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '4'.
  pt_item-emphasize = 'K41'.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-domname = 'CHAR10'.
  pt_item-f4availabl = 'X'.
  pt_item-ref_table = 'ZTBRD00020'.
  pt_item-scrtext_l = 'ALV Key'.
  pt_item-scrtext_m = 'ALV Key'.
  pt_item-scrtext_s = 'ALV Key'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'HEADER'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'CLSNAME'.
  pt_item-col_pos = '999'.
  pt_item-emphasize = 'K41'.
  pt_item-tech = 'X'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '30'.
  pt_item-reptext = 'Object Type Name'.
  pt_item-domname = 'SEOCLSNAME'.
  pt_item-ref_table = 'SEOCLASS'.
  pt_item-dd_outlen = '30'.
  pt_item-scrtext_l = 'Class/Interface'.
  pt_item-scrtext_m = 'ObjectTypeName'.
  pt_item-scrtext_s = 'ObjectType'.
  pt_item-crea_edit = 'X'.
  pt_item-upld_edit = 'X'.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'HEADER'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'FCAT_KEY'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '5'.
  pt_item-emphasize = 'K41'.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-domname = 'CHAR10'.
  pt_item-f4availabl = 'X'.
  pt_item-ref_table = 'ZTBRD00020'.
  pt_item-scrtext_l = 'Fieldcat Key'.
  pt_item-scrtext_m = 'Fieldcat Key'.
  pt_item-scrtext_s = 'Fieldcat K'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'HEADER'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'PROGID'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '2'.
  pt_item-zkey = 'X'.
  pt_item-emphasize = 'K41'.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '40'.
  pt_item-domname = 'PROGRAM_ID'.
  pt_item-col_opt = 'X'.
  pt_item-ref_table = 'ZTBRD00020'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Program ID'.
  pt_item-scrtext_m = 'Program ID'.
  pt_item-scrtext_s = 'Program ID'.
  pt_item-crea_edit = 'X'.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'HEADER'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'TABNM'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '3'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '0'.
  pt_item-ref_field = 'TABNAME'.
  pt_item-ref_table = 'DD02L'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Table ID'.
  pt_item-scrtext_m = 'Table ID'.
  pt_item-scrtext_s = 'Table ID'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = 'X'.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'HEADER'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'TYPE'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '1'.
  pt_item-zkey = 'X'.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = ''.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = ''.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Type'.
  pt_item-scrtext_m = 'Type'.
  pt_item-scrtext_s = 'Type'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = ''.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'ITEM'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'H_FIELD'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '1'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '20'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '30'.
  pt_item-reptext = 'Header Field'.
  pt_item-domname = ''.
  pt_item-f4availabl = 'X'.
  pt_item-col_opt = ''.
  pt_item-ref_field = 'FIELDNAME'.
  pt_item-ref_table = 'DD03L'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Header Field'.
  pt_item-scrtext_m = 'Header Field'.
  pt_item-scrtext_s = 'Header Fie'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'ITEM'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'ICON'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '2'.
  pt_item-zkey = ''.
  pt_item-icon = 'X'.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '4'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = ''.
  pt_item-col_opt = 'X'.
  pt_item-ref_field = ''.
  pt_item-ref_table = ''.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = ''.
  pt_item-scrtext_m = ''.
  pt_item-scrtext_s = ''.
  pt_item-crea_edit = ''.
  pt_item-chan_edit = ''.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'ITEM'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'I_FIELD'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '3'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '20'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '30'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = 'X'.
  pt_item-col_opt = ''.
  pt_item-ref_field = 'FIELDNAME'.
  pt_item-ref_table = 'DD03L'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Item Field'.
  pt_item-scrtext_m = 'Item Field'.
  pt_item-scrtext_s = 'Item Field'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'ITEM'.
  pt_item-fcat_key = 'SIMPLE'.
  pt_item-fieldname = 'H_FIELD'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '1'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '20'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '30'.
  pt_item-reptext = 'Select Field'.
  pt_item-domname = ''.
  pt_item-f4availabl = 'X'.
  pt_item-col_opt = ''.
  pt_item-ref_field = 'FIELDNAME'.
  pt_item-ref_table = 'DD03L'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Select Field'.
  pt_item-scrtext_m = 'Select Field'.
  pt_item-scrtext_s = 'Select Fie'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'ITEM'.
  pt_item-fcat_key = 'SIMPLE'.
  pt_item-fieldname = 'ICON'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '2'.
  pt_item-zkey = ''.
  pt_item-icon = 'X'.
  pt_item-emphasize = ''.
  pt_item-tech = 'X'.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '4'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = ''.
  pt_item-col_opt = 'X'.
  pt_item-ref_field = ''.
  pt_item-ref_table = ''.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = ''.
  pt_item-scrtext_m = ''.
  pt_item-scrtext_s = ''.
  pt_item-crea_edit = ''.
  pt_item-chan_edit = ''.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'ITEM'.
  pt_item-fcat_key = 'SIMPLE'.
  pt_item-fieldname = 'I_FIELD'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '3'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = 'X'.
  pt_item-outputlen = '20'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '30'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = 'X'.
  pt_item-col_opt = ''.
  pt_item-ref_field = 'FIELDNAME'.
  pt_item-ref_table = 'DD03L'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Item Field'.
  pt_item-scrtext_m = 'Item Field'.
  pt_item-scrtext_s = 'Item Field'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'MULTI'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'ALV_KEY'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '4'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = 'K41'.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-reptext = ''.
  pt_item-domname = 'CHAR10'.
  pt_item-f4availabl = 'X'.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = 'YTBRBRD00020'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'ALV Key'.
  pt_item-scrtext_m = 'ALV Key'.
  pt_item-scrtext_s = 'ALV Key'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'MULTI'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'FCAT_KEY'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '5'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = 'K41'.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-reptext = ''.
  pt_item-domname = 'CHAR10'.
  pt_item-f4availabl = 'X'.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = 'YTBRBRD00020'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Fieldcat Key'.
  pt_item-scrtext_m = 'Fieldcat Key'.
  pt_item-scrtext_s = 'Fieldcat K'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'MULTI'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'NO'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '1'.
  pt_item-zkey = 'X'.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'INT1'.
  pt_item-inttype = 'I'.
  pt_item-intlen = '4'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = ''.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = ''.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = ''.
  pt_item-scrtext_m = ''.
  pt_item-scrtext_s = ''.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = ''.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'MULTI'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'TABNM'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '3'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '0'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = ''.
  pt_item-col_opt = ''.
  pt_item-ref_field = 'TABNAME'.
  pt_item-ref_table = 'DD02L'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Table ID'.
  pt_item-scrtext_m = 'Table ID'.
  pt_item-scrtext_s = 'Table ID'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = 'X'.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TAB'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'ALV_KEY'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '4'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = 'K41'.
  pt_item-tech = 'X'.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-reptext = ''.
  pt_item-domname = 'CHAR10'.
  pt_item-f4availabl = 'X'.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = 'ZTBRD00020'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'ALV Key'.
  pt_item-scrtext_m = 'ALV Key'.
  pt_item-scrtext_s = 'ALV Key'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TAB'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'CLSNAME'.
  pt_item-row_pos = '0'.
  pt_item-col_pos = '999'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = 'K41'.
  pt_item-tech = 'X'.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '30'.
  pt_item-reptext = 'Object Type Name'.
  pt_item-domname = 'SEOCLSNAME'.
  pt_item-f4availabl = ''.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = 'SEOCLASS'.
  pt_item-dd_outlen = '30'.
  pt_item-scrtext_l = 'Class/Interface'.
  pt_item-scrtext_m = 'ObjectTypeName'.
  pt_item-scrtext_s = 'ObjectType'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = ''.
  pt_item-upld_edit = 'X'.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TAB'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'FCAT_KEY'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '5'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = 'K41'.
  pt_item-tech = 'X'.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-reptext = ''.
  pt_item-domname = 'CHAR10'.
  pt_item-f4availabl = 'X'.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = 'ZTBRD00020'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Fieldcat Key'.
  pt_item-scrtext_m = 'Fieldcat Key'.
  pt_item-scrtext_s = 'Fieldcat K'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TAB'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'PROGID'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '2'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = 'K41'.
  pt_item-tech = 'X'.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '40'.
  pt_item-reptext = ''.
  pt_item-domname = 'PROGRAM_ID'.
  pt_item-f4availabl = ''.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = 'ZTBRD00020'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Program ID'.
  pt_item-scrtext_m = 'Program ID'.
  pt_item-scrtext_s = 'Program ID'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = ''.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TAB'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'TABNM'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '3'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '0'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = ''.
  pt_item-col_opt = ''.
  pt_item-ref_field = 'TABNAME'.
  pt_item-ref_table = 'DD02L'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Table ID'.
  pt_item-scrtext_m = 'Table ID'.
  pt_item-scrtext_s = 'Table ID'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = 'X'.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TAB'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'TYPE'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '1'.
  pt_item-zkey = 'X'.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = ''.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = ''.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Type'.
  pt_item-scrtext_m = 'Type'.
  pt_item-scrtext_s = 'Type'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = ''.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TGHD'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'ALV_KEY'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '5'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = 'K41'.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-reptext = ''.
  pt_item-domname = 'CHAR10'.
  pt_item-f4availabl = 'X'.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = 'ZTBRD00020'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'ALV Key'.
  pt_item-scrtext_m = 'ALV Key'.
  pt_item-scrtext_s = 'ALV Key'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TGHD'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'CLSNAME'.
  pt_item-row_pos = '0'.
  pt_item-col_pos = '3'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = 'K41'.
  pt_item-tech = ''.
  pt_item-outputlen = '20'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '30'.
  pt_item-reptext = ''.
  pt_item-domname = 'SEOCLSNAME'.
  pt_item-f4availabl = ''.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = 'SEOCLASS'.
  pt_item-dd_outlen = '30'.
  pt_item-scrtext_l = 'Class/Interface'.
  pt_item-scrtext_m = 'ObjectTypeName'.
  pt_item-scrtext_s = 'ObjectType'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TGHD'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'FCAT_KEY'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '6'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = 'K41'.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-reptext = ''.
  pt_item-domname = 'CHAR10'.
  pt_item-f4availabl = 'X'.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = 'ZTBRD00020'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Fieldcat Key'.
  pt_item-scrtext_m = 'Fieldcat Key'.
  pt_item-scrtext_s = 'Fieldcat K'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TGHD'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'PROGID'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '999'.
  pt_item-zkey = 'X'.
  pt_item-icon = ''.
  pt_item-emphasize = 'K41'.
  pt_item-tech = 'X'.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '40'.
  pt_item-reptext = ''.
  pt_item-domname = 'PROGRAM_ID'.
  pt_item-f4availabl = ''.
  pt_item-col_opt = 'X'.
  pt_item-ref_field = ''.
  pt_item-ref_table = 'ZTBRD00020'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Program ID'.
  pt_item-scrtext_m = 'Program ID'.
  pt_item-scrtext_s = 'Program ID'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = ''.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TGHD'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'TABNM'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '4'.
  pt_item-zkey = ''.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '15'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '0'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = ''.
  pt_item-col_opt = ''.
  pt_item-ref_field = 'TABNAME'.
  pt_item-ref_table = 'DD02L'.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Table ID'.
  pt_item-scrtext_m = 'Table ID'.
  pt_item-scrtext_s = 'Table ID'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = 'X'.
  pt_item-upld_edit = ''.
  pt_item-change_evt = 'X'.
  APPEND pt_item.
  CLEAR pt_item.
  pt_item-progid = 'ZLBRD00020'.
  pt_item-alv_key = 'TGHD'.
  pt_item-fcat_key = 'DEFAULT'.
  pt_item-fieldname = 'TYPE'.
  pt_item-row_pos = '1'.
  pt_item-col_pos = '1'.
  pt_item-zkey = 'X'.
  pt_item-icon = ''.
  pt_item-emphasize = ''.
  pt_item-tech = ''.
  pt_item-outputlen = '0'.
  pt_item-datatype = 'CHAR'.
  pt_item-inttype = 'C'.
  pt_item-intlen = '10'.
  pt_item-reptext = ''.
  pt_item-domname = ''.
  pt_item-f4availabl = ''.
  pt_item-col_opt = ''.
  pt_item-ref_field = ''.
  pt_item-ref_table = ''.
  pt_item-dd_outlen = '0'.
  pt_item-scrtext_l = 'Type'.
  pt_item-scrtext_m = 'Type'.
  pt_item-scrtext_s = 'Type'.
  pt_item-crea_edit = 'X'.
  pt_item-chan_edit = ''.
  pt_item-upld_edit = ''.
  pt_item-change_evt = ''.
  APPEND pt_item.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_class
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_alv_class .

  IF pa_new EQ abap_true.
    CONCATENATE 'ZCL_' pa_modu 'Z_ALV_N' INTO gv_alv_class.
    CONCATENATE 'ZCL_' pa_modu 'Z_TREE_ALV' INTO gv_tree_alv_class.
  ELSE.
    CONCATENATE 'ZCL_' pa_modu 'Z_ALV' INTO gv_alv_class.
    CONCATENATE 'ZCL_' pa_modu 'Z_TREE_ALV' INTO gv_tree_alv_class.
  ENDIF.

  SELECT SINGLE COUNT(*) INTO sy-dbcnt
  FROM tadir
  WHERE pgmid = 'R3TR'
    AND object = 'CLAS'
    AND obj_name  = gv_alv_class.

  IF sy-dbcnt EQ 0.
    IF pa_new EQ abap_true.
      gv_alv_class = 'ZCL_BRD_ALV_N'.
      gv_tree_alv_class = 'ZCL_BRD_TREE_ALV'.
    ELSE.
      gv_alv_class = 'ZCL_BRD_ALV'.
      gv_tree_alv_class = 'ZCL_BRD_TREE_ALV'.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form GET_DYN_FLDL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> IDYN_FLDL
*&---------------------------------------------------------------------*
FORM get_dyn_fldl  CHANGING pt_idyn_fldl.
  DATA: idyn_fldl TYPE TABLE OF d021s.
  IF pa_1step EQ abap_true.
    idyn_fldl = VALUE #( ( fnam = 'GV_OKCODE' didx = '0000' flg1 = '80' flg2 = '10' flg3 = '00' fmb1 = '00'
                           fmb2 = '00' leng = '14' line = 'FF' coln = '01' ltyp = 'O' lanf = '00'
                           lblk = '00' lrep = '00' type = 'CHAR' aglt = '00' adez = '00' stxt = '____________________'
                           res1 = '                                       00' )
                          ( fnam = 'SEARCH' didx = '0000' flg1 = '00' flg2 = '00' flg3 = '00'
                            fill = 'P' fmb1 = '30'
                            fmb2 = '00' leng = '06' line = '06' coln = 'FA' ltyp = ' ' lanf = '00'
                            lblk = '00' lrep = '00' type = 'CHAR' aglt = '00' adez = '00'
                            auth = '104' stxt = 'Search'
                            res1 = ' ' )
                          ( fnam = 'CON_' && pa_alv didx = '00BF' flg1 = '00' flg2 = '00' flg3 = '00'
                            fill = 'U' fmb1 = '30'
                            fmb2 = '00' leng = 'FF' line = '08' coln = '02' ltyp = ' ' lanf = '00'
                            lblk = '00' lrep = '00' type = 'CHAR' aglt = '00' adez = '00'
                            auth = '105' stxt = ' '
                            res1 = ' ' )  ).



  ELSE.
    idyn_fldl = VALUE #( ( fnam = 'GV_OKCODE' didx = '0000' flg1 = '80' flg2 = '10' flg3 = '00' fmb1 = '00'
                           fmb2 = '00' leng = '14' line = 'FF' coln = '01' ltyp = 'O' lanf = '00'
                           lblk = '00' lrep = '00' type = 'CHAR' aglt = '00' adez = '00' stxt = '____________________'
                           res1 = '                                       00' ) ).
  ENDIF.
  pt_idyn_fldl = idyn_fldl.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_acg_screen .
  DATA : lv_program_name     LIKE  trdir-name,
         lv_program_ordernum LIKE  e070-trkorr,
         lv_program_devclass LIKE  tdevc-devclass.

  lv_program_name = sy-repid.

  PERFORM get_cts USING lv_program_name lv_program_devclass lv_program_ordernum.


  PERFORM create_acg_screen_9100 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9101 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9102 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9103 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9104 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9105 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9110 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9120 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9130 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9140 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9200 USING lv_program_name lv_program_ordernum.
  PERFORM create_acg_screen_9210 USING lv_program_name lv_program_ordernum.

  PERFORM create_acg_status_bar USING lv_program_name.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9100  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9100'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = 'List'.
  gs_dynpro-header-type        = 'N'.
  gs_dynpro-header-nextscreen  = '9100'.
  gs_dynpro-header-lines       = 31.
  gs_dynpro-header-columns     = 172.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `  MODULE set_selected_tab.` )
  ( line = `  CALL SUBSCREEN subscr_200` )
  ( line = `         INCLUDING gs_tab_list-prog gs_tab_list-subscreen.` )
  ( line = `  MODULE set_screen.` )
  ( line = `  MODULE set_alv.` )
  ( line = `` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `  CALL SUBSCREEN subscr_200.` )
  ( line = `  MODULE get_selected_tab.` )
  ( line = `  MODULE exit_screen AT EXIT-COMMAND.` )
  ( line = `  MODULE user_command.` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
  ( type = 'STRIP_CTRL' name = 'GO_TABSTRIP' element_of = 'SCREEN' line = '001' column = '001'
    length = '172' height = '031' loop_block = '000' loop_disp = '000'
    c_line_min = '031' c_coln_min = '172' tc_fixcol = '000' )
  ( type = 'SUBSCREEN' name = 'SUBSCR_200' element_of = 'GO_TABSTRIP' line = '003' column = '002'
    length = '170' height = '028' loop_block = '000' loop_disp = '000'
    c_line_min = '003' c_coln_min = '003' c_scroll_v = 'X' c_scroll_h = 'X' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR'  )
  ( cont_type = 'STRIP_CTRL' cont_name = 'GO_TABSTRIP' type = 'PUSH' name = 'MAIN'
    text = 'MAIN' line = '001' column = '001' length = '004' vislength = '004'
    height = '001' push_fcode = 'MAIN' requ_entry = 'N' format = 'CHAR' ref_field = 'SUBSCR_200' )
  ( cont_type = 'STRIP_CTRL' cont_name = 'GO_TABSTRIP' type = 'PUSH' name = 'TOP'
    text = 'TOP' line = '001' column = '0012' length = '003' vislength = '003'
    height = '001' push_fcode = 'TOP' requ_entry = 'N' format = 'CHAR' ref_field = 'SUBSCR_200' )
  ( cont_type = 'STRIP_CTRL' cont_name = 'GO_TABSTRIP' type = 'PUSH' name = 'F01'
    text = 'F01' line = '001' column = '003' length = '003' vislength = '003'
    height = '001' push_fcode = 'F01' requ_entry = 'N' format = 'CHAR' ref_field = 'SUBSCR_200' )
  ( cont_type = 'STRIP_CTRL' cont_name = 'GO_TABSTRIP' type = 'PUSH' name = 'S100'
    text = 'S100' line = '001' column = '004' length = '004' vislength = '004'
    height = '001' push_fcode = 'S100' requ_entry = 'N' format = 'CHAR' ref_field = 'SUBSCR_200' )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9101
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9101  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9101'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = 'Join Option'.
  gs_dynpro-header-type        = 'N'.
  gs_dynpro-header-nextscreen  = '9101'.
  gs_dynpro-header-lines       = 27.
  gs_dynpro-header-columns     = 120.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `  MODULE status_9101.` )
  ( line = `  MODULE set_screen_9101.` )
  ( line = `` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `  MODULE user_command.  ` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
  ( type = 'RADIOGROUP' name = '%A_GV_INNER_JOIN' element_of = 'SCREEN' line = '001' column = '001'
    length = '025' height = '001' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
  ( type = 'CUST_CTRL' name = 'CON1' element_of = 'SCREEN' line = '002' column = '001'
    length = '051' height = '019' loop_block = '000' loop_disp = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR'  )
  ( cont_type = 'RADIOGROUP' cont_name = '%A_GV_INNER_JOIN' type = 'RADIO' name = 'GV_INNER_JOIN'
    text = 'Inner_join' line = '001' column = '001' length = '012' vislength = '012'
    height = '001' format = 'CHAR' input_fld = 'X' output_fld = 'X'  )
  ( cont_type = 'RADIOGROUP' cont_name = '%A_GV_INNER_JOIN' type = 'RADIO' name = 'GV_OUTER_JOIN'
    text = 'Outer_join' line = '001' column = '014' length = '012' vislength = '012'
    height = '001' format = 'CHAR' input_fld = 'X' output_fld = 'X'  )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9102
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9102  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9102'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = 'MAIN'.
  gs_dynpro-header-type        = 'I'.
  gs_dynpro-header-nextscreen  = '9102'.
  gs_dynpro-header-lines       = 28.
  gs_dynpro-header-columns     = 166.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `* MODULE STATUS_9102.` )
  ( line = `*` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `* MODULE USER_COMMAND_9102.` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
  ( type = 'CUST_CTRL' name = 'CON_MAIN' element_of = 'SCREEN' line = '001' column = '002'
    length = '164' height = '028' loop_block = '000' c_line_min = '001' c_coln_min = '001'
    loop_disp = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR' )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9103
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9103  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9103'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = 'TOP'.
  gs_dynpro-header-type        = 'I'.
  gs_dynpro-header-nextscreen  = '9103'.
  gs_dynpro-header-lines       = 28.
  gs_dynpro-header-columns     = 165.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `* MODULE STATUS_9103.` )
  ( line = `*` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `* MODULE USER_COMMAND_9103.` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
  ( type = 'CUST_CTRL' name = 'CON_TOP' element_of = 'SCREEN' line = '001' column = '002'
    length = '164' height = '028' loop_block = '000' c_line_min = '001' c_coln_min = '001'
    loop_disp = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR' )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9104
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9104  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9104'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = 'F01'.
  gs_dynpro-header-type        = 'I'.
  gs_dynpro-header-nextscreen  = '9104'.
  gs_dynpro-header-lines       = 28.
  gs_dynpro-header-columns     = 165.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `* MODULE STATUS_9104.` )
  ( line = `*` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `* MODULE USER_COMMAND_9104.` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
  ( type = 'CUST_CTRL' name = 'CON_F01' element_of = 'SCREEN' line = '001' column = '002'
    length = '164' height = '028' loop_block = '000' c_line_min = '001' c_coln_min = '001'
    loop_disp = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR' )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9105
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9105  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9105'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = '100'.
  gs_dynpro-header-type        = 'I'.
  gs_dynpro-header-nextscreen  = '9105'.
  gs_dynpro-header-lines       = 28.
  gs_dynpro-header-columns     = 165.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `* MODULE STATUS_9105.` )
  ( line = `*` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `* MODULE USER_COMMAND_9105.` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
  ( type = 'CUST_CTRL' name = 'CON_100' element_of = 'SCREEN' line = '001' column = '002'
    length = '164' height = '028' loop_block = '000' c_line_min = '001' c_coln_min = '001'
    loop_disp = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR' )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9110
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9110  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9110'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = 'Double Grid Option'.
  gs_dynpro-header-type        = 'N'.
  gs_dynpro-header-nextscreen  = '9110'.
  gs_dynpro-header-lines       = 27.
  gs_dynpro-header-columns     = 120.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `  MODULE status_9110.` )
  ( line = `  MODULE set_screen_9110.` )
  ( line = `` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `  MODULE user_command.` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR'  )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9120  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9120'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = 'Multi Grid Option'.
  gs_dynpro-header-type        = 'N'.
  gs_dynpro-header-nextscreen  = '9120'.
  gs_dynpro-header-lines       = 27.
  gs_dynpro-header-columns     = 120.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `  MODULE status_9120.` )
  ( line = `  MODULE set_screen_9120.` )
  ( line = `` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `  MODULE user_command.` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
  ( type = 'CUST_CTRL' name = 'CON2' line = '001' column = '001' element_of = 'SCREEN'
    length = '055' height = '019' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR'  )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9130
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9130  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9130'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = 'Tree BALV'.
  gs_dynpro-header-type        = 'N'.
  gs_dynpro-header-nextscreen  = '9130'.
  gs_dynpro-header-lines       = 9.
  gs_dynpro-header-columns     = 54.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `  MODULE status_9130.` )
  ( line = `` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `  MODULE exit_screen AT EXIT-COMMAND.` )
  ( line = `  MODULE user_command.  ` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'FRAME' name = '%#AUTOTEXT008'
    text = '____________________' line = '001' column = '001' length = '052' vislength = '052'
    height = '009' requ_entry = 'N' format = 'CHAR'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = '%#AUTOTEXT001'
    text = 'Input_Option' line = '002' column = '003' length = '012' vislength = '012'
    height = '001' requ_entry = 'N' format = 'CHAR'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = '%#AUTOTEXT002'
    text = 'ALV_Class' line = '003' column = '005' length = '009' vislength = '009'
    height = '001' requ_entry = 'N' format = 'CHAR' labelleft = 'X'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEMPLATE' name = 'GS_TREE_GRID-G_CLS'
    text = '______________________' line = '003' column = '027' length = '022' vislength = '022'
    height = '001' output_fld = 'X' requ_entry = 'N' format = 'CHAR' labelleft = 'X'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = '%#AUTOTEXT003'
    text = 'ALV_Key' line = '004' column = '005' length = '007' vislength = '007'
    height = '001' requ_entry = 'N' format = 'CHAR' labelleft = 'X'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEMPLATE' name = 'GS_TREE_GRID-G_ALV_KEY'
    text = '__________' line = '004' column = '027' length = '010' vislength = '010'
    height = '001' input_fld = 'X' output_fld = 'X'  format = 'CHAR' )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = '%#AUTOTEXT004'
    text = 'Fieldcatalog_Key' line = '005' column = '005' length = '016' vislength = '016'
    height = '001' requ_entry = 'N' format = 'CHAR' labelleft = 'X'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEMPLATE' name = 'GS_TREE_GRID-G_FCAT_KEY'
    text = '__________' line = '005' column = '027' length = '010' vislength = '010'
    height = '001' input_fld = 'X' output_fld = 'X'  format = 'CHAR' )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = '%#AUTOTEXT005'
    text = 'Tree_ALV_Class' line = '006' column = '005' length = '014' vislength = '014'
    height = '001' requ_entry = 'N' format = 'CHAR' labelleft = 'X'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEMPLATE' name = 'GS_TREE_GRID-T_CLS'
    text = '_________________________' line = '006' column = '027' length = '025' vislength = '025'
    height = '001' output_fld = 'X' requ_entry = 'N' format = 'CHAR' )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = '%#AUTOTEXT006'
    text = 'Tree_ALV_Key' line = '007' column = '005' length = '012' vislength = '012'
    height = '001' requ_entry = 'N' format = 'CHAR' labelleft = 'X'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEMPLATE' name = 'GS_TREE_GRID-T_ALV_KEY'
    text = '__________' line = '007' column = '027' length = '010' vislength = '010'
    height = '001' output_fld = 'X' requ_entry = 'N' format = 'CHAR' )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = '%#AUTOTEXT007'
    text = 'Tree_Fieldcatalog_Key' line = '008' column = '005' length = '021' vislength = '021'
    height = '001' requ_entry = 'N' format = 'CHAR' labelleft = 'X'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEMPLATE' name = 'GS_TREE_GRID-T_FCAT_KEY'
    text = '__________' line = '008' column = '027' length = '010' vislength = '010'
    height = '001' output_fld = 'X' requ_entry = 'N' format = 'CHAR' )

    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9140
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9140  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9140'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = 'Tree-Grid Double'.
  gs_dynpro-header-type        = 'N'.
  gs_dynpro-header-nextscreen  = '9140'.
  gs_dynpro-header-lines       = 27.
  gs_dynpro-header-columns     = 120.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `  MODULE status_9110.` )
  ( line = `  MODULE set_screen_9140.` )
  ( line = `` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `  MODULE user_command.` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR'  )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9200  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9200'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = '9200'.
  gs_dynpro-header-type        = 'N'.
  gs_dynpro-header-nextscreen  = '9200'.
  gs_dynpro-header-lines       = 27.
  gs_dynpro-header-columns     = 120.

  gs_dynpro-flow_logic = VALUE #(
  ( line = `PROCESS BEFORE OUTPUT.` )
  ( line = `  MODULE set_screen.` )
  ( line = `  MODULE set_screen_9200.` )
  ( line = `` )
  ( line = `PROCESS AFTER INPUT.` )
  ( line = `  MODULE exit_screen AT EXIT-COMMAND.` )
  ( line = `  MODULE user_command.` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR'  )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_SCREEN_9210
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&      --> LV_PROGRAM_ORDERNUM
*&---------------------------------------------------------------------*
FORM create_acg_screen_9210  USING    pv_program_name
                                     pv_program_corrnum.
  CLEAR gs_dynpro.
  gs_dynpro-header-program     = pv_program_name.
  gs_dynpro-header-screen      = '9210'.
  gs_dynpro-header-language    = 'EN'.
  gs_dynpro-header-descript    = 'Program Info'.
  gs_dynpro-header-type        = 'M'.
  gs_dynpro-header-nextscreen  = '9210'.
  gs_dynpro-header-lines       = 27.
  gs_dynpro-header-columns     = 122.

  gs_dynpro-flow_logic = VALUE #(
    ( line = `PROCESS BEFORE OUTPUT.` )
    ( line = `  MODULE status_9210.` )
    ( line = `` )
    ( line = `PROCESS AFTER INPUT.` )
    ( line = `  MODULE exit_screen AT EXIT-COMMAND.` )
    ( line = `  MODULE user_command_9210.` )
   ).

  "Screen Control
  gs_dynpro-containers = VALUE #(
  ( type = 'SCREEN' name = 'SCREEN' line = '000' column = '000'
    length = '000' height = '000' loop_block = '000' loop_disp = '000'
    c_line_min = '000' c_coln_min = '000' tc_fixcol = '000' )
   ).
  "OK Code
  gs_dynpro-fields = VALUE #(
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'OKCODE' name = 'GV_OKCODE'
    text = '____________________' line = '000' column = '000' length = '020' vislength = '020'
    height = '001' input_fld = 'X' format = 'CHAR'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = '%#AUTOTEXT001'
    text = 'Program' line = '002' column = '002' length = '007' vislength = '007'
    height = '001' requ_entry = 'N' format = 'CHAR' labelleft = 'X'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEMPLATE' name = 'PA_PROG'
    text = '________________________________________' line = '002' column = '010' length = '040' vislength = '040'
    height = '001' output_fld = 'X' requ_entry = 'N' format = 'CHAR'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = '%#AUTOTEXT002'
    text = 'Title' line = '003' column = '002' length = '005' vislength = '005'
    height = '001' requ_entry = 'N' format = 'CHAR' labelleft = 'X'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEMPLATE' name = 'GV_REPTI'
    text = '?________________________________________' line = '003' column = '010' length = '070' vislength = '070'
    height = '001' up_lower = 'X' input_fld = 'X' output_fld = 'X' requ_entry = 'O' format = 'CHAR'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'TEXT' name = '%#AUTOTEXT003'
    text = 'Tcode_Generate' line = '004' column = '002' length = '014' vislength = '014'
    height = '001' requ_entry = 'N' format = 'CHAR' labelleft = 'X'  )
  ( cont_type = 'SCREEN' cont_name = 'SCREEN' type = 'CHECK' name = 'GV_TCODE_GEN'
    line = '004' column = '017' length = '001' vislength = '001'
    height = '001' input_fld = 'X' output_fld = 'X' format = 'CHAR'  )
    ).

  CALL FUNCTION 'RPY_DYNPRO_INSERT'
    EXPORTING
      header                 = gs_dynpro-header
      suppress_exist_checks  = abap_true
      corrnum                = pv_program_corrnum
    TABLES
      containers             = gs_dynpro-containers
      fields_to_containers   = gs_dynpro-fields
      flow_logic             = gs_dynpro-flow_logic
    EXCEPTIONS
      cancelled              = 1
      already_exists         = 2
      program_not_exists     = 3
      not_executed           = 4
      missing_required_field = 5
      illegal_field_value    = 6
      field_not_allowed      = 7
      not_generated          = 8
      illegal_field_position = 9
      OTHERS                 = 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ACG_STATUS_BAR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_PROGRAM_NAME
*&---------------------------------------------------------------------*
FORM create_acg_status_bar  USING    pv_program_name.
  DATA : lv_mainprogram_name LIKE  trdir-name,
         _program            TYPE  trdir-name.

  lv_mainprogram_name = pv_program_name.



  DATA: ista TYPE TABLE OF rsmpe_stat,
        ifun TYPE TABLE OF rsmpe_funt,
        imen TYPE TABLE OF rsmpe_men,
        imtx TYPE TABLE OF rsmpe_mnlt,
        iact TYPE TABLE OF rsmpe_act,
        ibut TYPE TABLE OF rsmpe_but,
        ipfk TYPE TABLE OF rsmpe_pfk,
        iset TYPE TABLE OF rsmpe_staf,
        idoc TYPE TABLE OF rsmpe_atrt,
        itit TYPE TABLE OF rsmpe_titt,
        ibiv TYPE TABLE OF rsmpe_buts.
  DATA xadm   TYPE rsmpe_adm.
  DATA xtrkey TYPE trkey.
  _program = lv_mainprogram_name.

  xtrkey-obj_type = 'PROG'.
  xtrkey-obj_name = _program.
  xtrkey-sub_type = 'CUAD'.
  xtrkey-sub_name = _program.

*
  xadm-actcode = '000002'.
  xadm-pfkcode = '000006'.

  ista = VALUE #(
  ( code = '0100' modal = 'D' actcode = '000002' pfkcode = '000005' butcode = '0001' int_note = 'Status' )
  ( code = '9100' modal = 'D' actcode = '000001' pfkcode = '000001' butcode = '0001' int_note = 'Status' )
  ( code = '9101' modal = 'P' actcode = '' pfkcode = '000002' butcode = '0001' int_note = 'Join Option' )
  ( code = '9110' modal = 'P' actcode = '' pfkcode = '000003' butcode = '0001' int_note = 'Header Item' )
  ( code = '9120' modal = 'P' actcode = '' pfkcode = '000004' butcode = '0001' int_note = 'Multi Grid Option' )
  ( code = '9210' modal = 'P' actcode = '' pfkcode = '000006' butcode = '0001' int_note = '9210' )
  ).

  ifun = VALUE #(
  ( code = 'BACK' textno = '001' type = 'E' text_type = 'S' text_name = 'ICON_SYSTEM_BACK' icon_id = '@2M@' fun_text = 'Back' )
  ( code = 'CANC' textno = '001' type = 'E' text_type = 'S' text_name = 'ICON_SYSTEM_CANCEL' icon_id = '@2O@' fun_text = 'Cancel' )
  ( code = 'COPY' textno = '001' type = '' text_type = 'S' text_name = 'ICON_SYSTEM_COPY' icon_id = '@2U@' fun_text = 'Screen Copy' )
  ( code = 'EXEC' textno = '001' type = '' text_type = 'S' text_name = 'CON_EXECUTE_OBJECT' icon_id = '@15@' fun_text = 'EXEC' )
  ( code = 'EXIT' textno = '001' type = 'E' text_type = 'S' text_name = 'ICON_SYSTEM_END' icon_id = '@2N@' fun_text = 'Exit' )
  ( code = 'GENP' textno = '001' type = '' text_type = 'S' text_name = 'CON_EXECUTE_OBJECT' icon_id = '@15@' fun_text = 'Program Generate' )
  ( code = 'SAVE' textno = '001' type = ' ' text_type = 'S' text_name = 'ICON_SYSTEM_SAVE' icon_id = '@2L@' fun_text = 'Save' )
  ).


  ipfk = VALUE #(
  ( code = '000001' pfno = '03' funcode = 'BACK' funno = '001' )
  ( code = '000001' pfno = '08' funcode = 'GENP' funno = '001' )
  ( code = '000001' pfno = '12' funcode = 'CANC' funno = '001' )
  ( code = '000001' pfno = '15' funcode = 'EXIT' funno = '001' )
  ( code = '000002' pfno = '08' funcode = 'EXEC' funno = '001' )
  ( code = '000002' pfno = '12' funcode = 'CANC' funno = '001' )
  ( code = '000003' pfno = '08' funcode = 'EXEC' funno = '001' )
  ( code = '000003' pfno = '12' funcode = 'CANC' funno = '001' )
  ( code = '000004' pfno = '08' funcode = 'EXEC' funno = '001' )
  ( code = '000004' pfno = '12' funcode = 'CANC' funno = '001' )
  ( code = '000005' pfno = '03' funcode = 'BACK' funno = '001' )
  ( code = '000005' pfno = '11' funcode = 'SAVE' funno = '001' )
  ( code = '000005' pfno = '12' funcode = 'CANC' funno = '001' )
  ( code = '000005' pfno = '15' funcode = 'EXIT' funno = '001' )
  ( code = '000006' pfno = '08' funcode = 'EXEC' funno = '001' )
  ( code = '000005' pfno = '12' funcode = 'BACK' funno = '001' )
   ).

  iset = VALUE #(
  ( status = '0100' function = 'BACK' )
  ( status = '0100' function = 'CANC' )
  ( status = '0100' function = 'EXIT' )
  ( status = '0100' function = 'SAVE' )
  ( status = '9100' function = 'BACK' )
  ( status = '9100' function = 'CANC' )
  ( status = '9100' function = 'EXIT' )
  ( status = '9100' function = 'GENP' )
  ( status = '9101' function = 'CANC' )
  ( status = '9101' function = 'EXEC' )
  ( status = '9110' function = 'CANC' )
  ( status = '9110' function = 'EXEC' )
  ( status = '9120' function = 'CANC' )
  ( status = '9120' function = 'EXEC' )
  ( status = '9210' function = 'BACK' )
  ( status = '9210' function = 'CANC' )
  ( status = '9210' function = 'EXEC' )
  ).

  idoc = VALUE #(
  ( obj_type = 'A' obj_code = '000001' sub_code = '' modal = 'D' int_note = 'Status' )
  ( obj_type = 'P' obj_code = '000001' sub_code = '' modal = 'D' int_note = 'Status' )
  ( obj_type = 'B' obj_code = '000001' sub_code = '0001' modal = 'D' int_note = 'Status' )
  ( obj_type = 'P' obj_code = '000002' sub_code = '' modal = 'P' int_note = 'Join Option' )
  ( obj_type = 'B' obj_code = '000002' sub_code = '0001' modal = 'P' int_note = 'Join Option' )
  ( obj_type = 'P' obj_code = '000003' sub_code = '' modal = 'P' int_note = 'Header Item' )
  ( obj_type = 'B' obj_code = '000003' sub_code = '0001' modal = 'P' int_note = 'Header Item' )
  ( obj_type = 'P' obj_code = '000004' sub_code = '' modal = 'P' int_note = 'Multi Grid Option' )
  ( obj_type = 'B' obj_code = '000004' sub_code = '0001' modal = 'P' int_note = 'Multi Grid Option' )
  ( obj_type = 'A' obj_code = '000002' sub_code = '' modal = 'D' int_note = 'Status' )
  ( obj_type = 'P' obj_code = '000005' sub_code = '' modal = 'D' int_note = 'Status' )
  ( obj_type = 'B' obj_code = '000005' sub_code = '0001' modal = 'D' int_note = 'Status' )
  ( obj_type = 'P' obj_code = '000006' sub_code = '' modal = 'P' int_note = '9210' )
  ( obj_type = 'B' obj_code = '000006' sub_code = '0001' modal = 'P' int_note = '9210' )
  ).

  itit = VALUE #(
  ( code = '0100' text = '&' )
  ( code = '9100' text = '&' )
  ( code = '9101' text = 'Join Option' )
  ( code = '9110' text = 'Double Grid Option' )
  ( code = '9120' text = 'Multi Grid Option' )
  ( code = '9130' text = 'Tree BALV' )
  ).

  CALL FUNCTION 'RS_CUA_INTERNAL_WRITE'
    EXPORTING
      program   = _program
      language  = sy-langu
      tr_key    = xtrkey
      adm       = xadm
      state     = 'A'
    TABLES
      sta       = ista
      fun       = ifun
      men       = imen
      mtx       = imtx
      act       = iact
      but       = ibut
      pfk       = ipfk
      set       = iset
      doc       = idoc
      tit       = itit
      biv       = ibiv
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
ENDFORM.
