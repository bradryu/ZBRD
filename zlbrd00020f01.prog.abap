*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*&---------------------------------------------------------------------*
*&  Include           ZLBRD00020F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  SET_SCREEN_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_screen_9101 OUTPUT.
  CHECK go_custom_container IS INITIAL.
  CREATE OBJECT go_custom_container
    EXPORTING
      container_name = 'CON1'.

  CREATE OBJECT go_splitter_container_db
    EXPORTING
      parent  = go_custom_container
      rows    = 2
      columns = 1.
  go_container_h = go_splitter_container_db->get_container( row = 1 column = 1 ) .
  go_container_i = go_splitter_container_db->get_container( row = 2 column = 1 ) .
  go_splitter_container_db->set_row_height( id = 1 height = 30 ).


  CREATE OBJECT go_alv_h
    EXPORTING
      io_parent   = go_container_h
      iv_progid   = sy-cprog
      iv_alv_key  = 'TAB'
      iv_fcat_key = 'DEFAULT'.
  gt_toolbar_all_excluding = go_alv_h->get_all_exclude_toolbar( ).
  go_alv_h->display( EXPORTING iv_mode = zcl_brd_alv=>mc_change_mode
                               it_toolbar_excluding = gt_toolbar_all_excluding
                      CHANGING ct_data = gt_double_alv[] ).

  CREATE OBJECT go_alv_i
    EXPORTING
      io_parent   = go_container_i
      iv_progid   = sy-cprog
      iv_alv_key  = 'ITEM'
      iv_fcat_key = 'DEFAULT'.
  go_alv_i->display( EXPORTING iv_mode = zcl_brd_alv=>mc_change_mode
                               it_toolbar_excluding = gt_toolbar_all_excluding
                     CHANGING ct_data = gt_key_map[] ).

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Form  GET_SINGLE_SRC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_single_src .

  DATA : lv_join_type,
         lv_tabname_left  TYPE tabname,
         lv_tabname_right TYPE tabname.
  DATA : lt_top  TYPE zybrd00100,
         lt_main TYPE zybrd00100,
         lt_f01  TYPE zybrd00100,
         lt_100  TYPE zybrd00100.

  CLEAR: gs_acg_config, gs_acg_config_join.


  SELECT SINGLE * INTO CORRESPONDING FIELDS OF gs_alv_config
    FROM ztbrd00010
    WHERE progid = pa_prog
      AND alv_key = pa_alv.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_alv_fcat
    FROM ztbrd00020
    WHERE progid = pa_prog
      AND alv_key = pa_alv
      AND fcat_key = pa_fcat
    AND fieldname NE 'BALV_STATUS_ICON'
*      AND fieldname NE 'MANDT'
    .

  gs_acg_config-progid = pa_prog.
  gs_acg_config-alv_key = pa_alv.
  gs_acg_config-fcat_key = pa_fcat.
  gs_acg_config-is_new = pa_new.
  gs_acg_config-alv_class = gv_alv_class.
  gs_acg_config-is_1step = pa_1step.
  gs_acg_config-is_standalone = pa_stl.
  gs_acg_config-tabname = pa_tabnm.

  CASE abap_true.
    WHEN pa_s1.
      CALL FUNCTION 'ZBRD_GET_SRC_SINGLE'
        DESTINATION gc_acg_rfc_desc
        EXPORTING
          is_acg_config         = gs_acg_config
          is_alv_config         = gs_alv_config
        IMPORTING
          et_fields             = gs_dynpro-fields
          et_container          = gs_dynpro-containers
        TABLES
          t_top                 = lt_top
          t_main                = lt_main
          t_f01                 = lt_f01
          t_100                 = lt_100
          t_alv_fcat            = gt_alv_fcat
        EXCEPTIONS
          system_failure        = 1
          communication_failure = 2
          resource_failure      = 3
          license_expired       = 4.

      CASE sy-subrc.
        WHEN 0.
        WHEN 4.
          MESSAGE 'ACG License Expired' TYPE c_i DISPLAY LIKE c_e.
        WHEN OTHERS.
          MESSAGE 'RFC Call Error' TYPE c_i DISPLAY LIKE c_e.
      ENDCASE.
    WHEN pa_s2.


      READ TABLE gt_double_alv INDEX 1.
      gs_acg_config-tabname = gt_double_alv-tabnm.


      IF gv_inner_join EQ abap_true.
        gs_acg_config-param1 = 'I'.
      ELSE.
        gs_acg_config-param1 = 'O'.
      ENDIF.

      READ TABLE gt_double_alv INDEX 2.
      gs_acg_config_join-tabname = gt_double_alv-tabnm.

      CALL FUNCTION 'ZBRD_GET_SRC_JOIN'
        DESTINATION gc_acg_rfc_desc
        EXPORTING
          is_acg_config         = gs_acg_config
          is_acg_config_join    = gs_acg_config_join
          is_alv_config         = gs_alv_config
        IMPORTING
          et_fields             = gs_dynpro-fields
          et_container          = gs_dynpro-containers
        TABLES
          t_top                 = lt_top
          t_main                = lt_main
          t_f01                 = lt_f01
          t_100                 = lt_100
          t_key_map             = gt_key_map[]
          t_alv_fcat            = gt_alv_fcat
        EXCEPTIONS
          system_failure        = 1
          communication_failure = 2
          resource_failure      = 3
          license_expired       = 4.
      CASE sy-subrc.
        WHEN 0.
        WHEN 4.
          MESSAGE 'ACG License Expired' TYPE c_i DISPLAY LIKE c_e.
        WHEN OTHERS.
          MESSAGE 'RFC Call Error' TYPE c_i DISPLAY LIKE c_e.
      ENDCASE.


  ENDCASE.
  MOVE lt_top[] TO gt_top[].
  MOVE lt_main[] TO gt_main[].
  MOVE lt_f01[] TO gt_f01[].
  MOVE lt_100[] TO gt_100[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_JOIN_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_ERR  text
*----------------------------------------------------------------------*
FORM check_join_input  USING    pv_err.
  CLEAR pv_err.
  CHECK pa_s2 EQ abap_true.

  go_alv_h->check_changed_data( ).
  go_alv_i->check_changed_data( ).

  LOOP AT gt_double_alv.
    PERFORM check_tabnm USING gt_double_alv-tabnm pv_err.
    IF pv_err EQ abap_true.
      EXIT.
    ENDIF.

    PERFORM check_alv_key USING gt_double_alv-alv_key pv_err.
    IF pv_err EQ abap_true.
      EXIT.
    ENDIF.

    PERFORM check_fcat_key USING gt_double_alv-alv_key gt_double_alv-fcat_key pv_err.
    IF pv_err EQ abap_true.
      EXIT.
    ENDIF.
  ENDLOOP.
ENDFORM.
