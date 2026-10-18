*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*----------------------------------------------------------------------*
***INCLUDE ZLBRD00020F04.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0130  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9130 OUTPUT.
  SET PF-STATUS '9110'.
  SET TITLEBAR '9130'.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  SET_SCREEN_0140  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_screen_9140 OUTPUT.
  CHECK go_splitter_container_db IS INITIAL.
  CREATE OBJECT go_splitter_container_db
    EXPORTING
      parent  = cl_gui_container=>default_screen
      rows    = 2
      columns = 1.
  go_container_h = go_splitter_container_db->get_container( row = 1 column = 1 ) .
  go_container_i = go_splitter_container_db->get_container( row = 2 column = 1 ) .
  go_splitter_container_db->set_row_height( id = 1 height = 30 ).


  CREATE OBJECT go_alv_h
    EXPORTING
      io_parent  = go_container_h
      iv_progid  = sy-cprog
      iv_alv_key = 'TGHD'.
  gt_toolbar_all_excluding = go_alv_h->get_all_exclude_toolbar( ).
  go_alv_h->display( EXPORTING iv_mode = zcl_brd_alv=>mc_change_mode
                               it_toolbar_excluding = gt_toolbar_all_excluding
                      CHANGING ct_data = gt_double_alv[] ).


  CREATE OBJECT go_alv_i
    EXPORTING
      io_parent  = go_container_i
      iv_progid  = sy-cprog
      iv_alv_key = 'ITEM'.

  go_alv_i->display( EXPORTING iv_mode = zcl_brd_alv=>mc_change_mode
                               it_toolbar_excluding = gt_toolbar_all_excluding
                     CHANGING ct_data = gt_key_map[] ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  TGTD_alv_key_f4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM tgtd_alv_key_f4 USING es_row_no TYPE lvc_s_roid  .
  DATA : BEGIN OF lt_search_field OCCURS 0,
           alv_key  LIKE ztbrd00020-alv_key,
           fcat_key LIKE ztbrd00020-fcat_key,
         END OF lt_search_field.
  DATA lv_value TYPE shvalue_d.
  READ TABLE gt_double_alv INDEX es_row_no-row_id.

  SELECT DISTINCT alv_key fcat_key
  INTO CORRESPONDING FIELDS OF TABLE lt_search_field
  FROM ztbrd00020
  WHERE progid = pa_prog.
  go_alv_h->get_f4_value( EXPORTING iv_fieldname = 'ALV_KEY'
                                    it_data = lt_search_field[]
                          RECEIVING rv_value = lv_value ).

  CHECK lv_value IS NOT INITIAL.
  gv_flag = go_alv_h->is_display_mode( ).
  IF gv_flag = abap_false.
    READ TABLE lt_search_field WITH KEY alv_key = lv_value.
    gt_double_alv-alv_key = lt_search_field-alv_key.
    gt_double_alv-fcat_key = lt_search_field-fcat_key.

    MODIFY gt_double_alv INDEX es_row_no-row_id TRANSPORTING alv_key fcat_key.
    go_alv_h->refresh( ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TGTD_fcat_key_f4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM tgtd_fcat_key_f4 USING es_row_no TYPE lvc_s_roid  .
  DATA : BEGIN OF lt_search_field OCCURS 0,
           alv_key  LIKE ztbrd00020-alv_key,
           fcat_key LIKE ztbrd00020-fcat_key,
         END OF lt_search_field.
  DATA lv_value TYPE shvalue_d.
  READ TABLE gt_double_alv INDEX es_row_no-row_id.

  SELECT DISTINCT alv_key fcat_key
  INTO CORRESPONDING FIELDS OF TABLE lt_search_field
  FROM ztbrd00020
  WHERE progid = pa_prog.

  go_alv_h->get_f4_value( EXPORTING iv_fieldname = 'FCAT_KEY'
                                    it_data = lt_search_field[]
                          RECEIVING rv_value = lv_value ).

  CHECK lv_value IS NOT INITIAL.
  gv_flag = go_alv_h->is_display_mode( ).
  IF gv_flag = abap_false.
    gt_double_alv-fcat_key = lv_value.
    MODIFY gt_double_alv INDEX es_row_no-row_id TRANSPORTING fcat_key.
    go_alv_h->refresh( ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TGTD_TABNM_CHANGED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM tgtd_tabnm_changed USING po_object TYPE REF TO cl_alv_changed_data_protocol
                                pv_row_id
                                pv_value.
  READ TABLE gt_double_alv INDEX pv_row_id.
  IF sy-subrc EQ 0.
    gt_double_alv-tabnm = pv_value.
    MODIFY gt_double_alv INDEX pv_row_id.
  ENDIF.
ENDFORM.                    "` ls_fcat-fieldname `_CHANGED.
*&---------------------------------------------------------------------*
*&      Form  GET_TREE_SRC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_tree_src .

  DATA : lt_top  TYPE zybrd00100,
         lt_main TYPE zybrd00100,
         lt_f01  TYPE zybrd00100,
         lt_100  TYPE zybrd00100.


  SELECT SINGLE * INTO gs_talv_config
    FROM ztbrd00011
    WHERE progid = pa_prog
      AND alv_key = pa_alv.

  SELECT * INTO TABLE gt_talv_fcat
    FROM ztbrd00021
    WHERE progid = pa_prog
      AND alv_key = pa_alv
      AND fcat_key = pa_fcat
*        AND fieldname NE 'MANDT'
    .
  CLEAR gs_acg_config.
  gs_acg_config-progid = pa_prog.
  gs_acg_config-is_new = pa_new.
  gs_acg_config-is_1step = pa_1step.
  gs_acg_config-alv_key = pa_alv.
  gs_acg_config-fcat_key = pa_fcat.
  gs_acg_config-tabname = pa_tabnm.
  gs_acg_config-is_standalone = pa_stl.
  gs_acg_config-alv_class = gv_tree_alv_class.

  CALL FUNCTION 'ZBRD_GET_SRC_TREE'
    DESTINATION gc_acg_rfc_desc
    EXPORTING
      is_acg_config = gs_acg_config
      is_alv_config = gs_talv_config
    IMPORTING
      et_fields     = gs_dynpro-fields
      et_container  = gs_dynpro-containers
    TABLES
      t_top         = lt_top
      t_main        = lt_main
      t_f01         = lt_f01
      t_100         = lt_100
      t_alv_fcat    = gt_talv_fcat[].

  MOVE lt_top[] TO gt_top[].
  MOVE lt_main[] TO gt_main[].
  MOVE lt_f01[] TO gt_f01[].
  MOVE lt_100[] TO gt_100[].


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TREE_GRID_SRC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_tree_grid_src .

  DATA : ls_header LIKE LINE OF gt_double_alv,
         ls_item   LIKE LINE OF gt_double_alv.

  DATA : lt_top  TYPE zybrd00100,
         lt_main TYPE zybrd00100,
         lt_f01  TYPE zybrd00100,
         lt_100  TYPE zybrd00100.




  CASE abap_true.
    WHEN pa_s5.


      SELECT SINGLE * INTO gs_alv_config
        FROM ztbrd00010
        WHERE progid = pa_prog
          AND alv_key = gs_tree_grid-g_alv_key.

      SELECT * INTO TABLE gt_alv_fcat
        FROM ztbrd00020
        WHERE progid = pa_prog
          AND alv_key = gs_tree_grid-g_alv_key
          AND fcat_key = gs_tree_grid-g_fcat_key
          AND fieldname NE 'BALV_STATUS_ICON'
*        AND fieldname NE 'MANDT'
        .

      SELECT SINGLE * INTO gs_talv_config
        FROM ztbrd00011
        WHERE progid = pa_prog
          AND alv_key = gs_tree_grid-t_alv_key.

      SELECT * INTO TABLE gt_talv_fcat
        FROM ztbrd00021
        WHERE progid = pa_prog
          AND alv_key = gs_tree_grid-t_alv_key
          AND fcat_key = gs_tree_grid-t_fcat_key
          AND fieldname NE 'BALV_STATUS_ICON'
*        AND fieldname NE 'MANDT'
        .

      CLEAR : gs_acg_config, gs_acg_config_join.

      gs_acg_config-progid = pa_prog.
      gs_acg_config-tabname = pa_tabnm.
      gs_acg_config-is_new = pa_new.
      gs_acg_config-is_1step = pa_1step.
      gs_acg_config-is_standalone = pa_stl.
      gs_acg_config-alv_key = gs_tree_grid-t_alv_key.
      gs_acg_config-fcat_key = gs_tree_grid-t_fcat_key.
      gs_acg_config-alv_class = gs_tree_grid-t_cls.

      gs_acg_config_join-alv_key = gs_tree_grid-g_alv_key.
      gs_acg_config_join-fcat_key = gs_tree_grid-g_fcat_key.
      gs_acg_config_join-alv_class = gs_tree_grid-g_cls.
      gs_acg_config_join-tabname = pa_tabnm.

      CALL FUNCTION 'ZBRD_GET_SRC_TREE_GRID'
        DESTINATION gc_acg_rfc_desc
        EXPORTING
          is_acg_config_tree    = gs_acg_config
          is_acg_config_grid    = gs_acg_config_join
          is_alv_config         = gs_alv_config
          is_talv_config        = gs_talv_config
        IMPORTING
          et_fields             = gs_dynpro-fields
          et_container          = gs_dynpro-containers
        TABLES
          t_top                 = lt_top
          t_main                = lt_main
          t_f01                 = lt_f01
          t_100                 = lt_100
          t_alv_fcat            = gt_alv_fcat[]
          t_talv_fcat           = gt_talv_fcat[]
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


      MOVE lt_top[] TO gt_top[].
      MOVE lt_main[] TO gt_main[].
      MOVE lt_f01[] TO gt_f01[].
      MOVE lt_100[] TO gt_100[].
    WHEN pa_s6.
      READ TABLE gt_double_alv INTO ls_header INDEX 1.
      READ TABLE gt_double_alv INTO ls_item INDEX 2.


      SELECT SINGLE * INTO gs_talv_config
        FROM ztbrd00011
        WHERE progid = pa_prog
          AND alv_key = ls_header-alv_key.

      SELECT SINGLE * INTO gs_alv_config
        FROM ztbrd00010
        WHERE progid = pa_prog
          AND alv_key = ls_item-alv_key.


      SELECT * INTO TABLE gt_talv_fcat
        FROM ztbrd00021
        WHERE progid = pa_prog
          AND alv_key = ls_header-alv_key
          AND fcat_key = ls_header-fcat_key
        AND fieldname NE 'BALV_STATUS_ICON'
*      AND fieldname NE 'MANDT'
        .
      SELECT * INTO TABLE gt_alv_fcat
        FROM ztbrd00020
        WHERE progid = pa_prog
          AND alv_key = ls_item-alv_key
          AND fcat_key = ls_item-fcat_key
        AND fieldname NE 'BALV_STATUS_ICON'
*      AND fieldname NE 'MANDT'
        .

      CLEAR : gs_acg_config, gs_acg_config_join.

      gs_acg_config_header-progid = pa_prog.
      gs_acg_config_header-is_new = pa_new.
      gs_acg_config_header-is_1step = pa_1step.
      gs_acg_config_header-tabname = ls_header-tabnm.
      gs_acg_config_header-alv_key = ls_header-alv_key.
      gs_acg_config_header-fcat_key = ls_header-fcat_key.
      gs_acg_config_header-alv_class = ls_header-clsname.

      gs_acg_config_item-progid = pa_prog.
      gs_acg_config_item-is_new = pa_new.
      gs_acg_config_item-is_1step = pa_1step.
      gs_acg_config_item-alv_key = ls_item-alv_key.
      gs_acg_config_item-fcat_key = ls_item-fcat_key.
      gs_acg_config_item-alv_class = ls_item-clsname.
      gs_acg_config_item-tabname = ls_item-tabnm.


      CALL FUNCTION 'ZBRD_GET_SRC_TREE_DOUBLE'
        DESTINATION gc_acg_rfc_desc
        EXPORTING
          is_acg_config_header  = gs_acg_config_header
          is_acg_config_item    = gs_acg_config_item
          is_h_config           = gs_talv_config
          is_i_config           = gs_alv_config
        IMPORTING
          et_fields             = gs_dynpro-fields
          et_container          = gs_dynpro-containers
        TABLES
          t_top                 = lt_top
          t_main                = lt_main
          t_f01                 = lt_f01
          t_100                 = lt_100
          t_key_map             = gt_key_map[]
          t_i_fcat              = gt_alv_fcat[]
          t_h_fcat              = gt_talv_fcat[]
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


      MOVE lt_top[] TO gt_top[].
      MOVE lt_main[] TO gt_main[].
      MOVE lt_f01[] TO gt_f01[].
      MOVE lt_100[] TO gt_100[].

  ENDCASE.
ENDFORM.
