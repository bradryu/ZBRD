*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD03010F01
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
  CHECK go_custom_container IS INITIAL.

  CREATE OBJECT go_custom_container
    EXPORTING
      container_name = 'CON1'.

  CREATE OBJECT go_item
    EXPORTING
      io_parent  = go_custom_container
      iv_alv_key = 'ITEM'.

  go_item->set_celltab_style( EXPORTING iv_mode = zcl_brd_alv_n=>mc_change_mode
                            CHANGING ct_celltab = gt_celltab ).
  LOOP AT gt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat2>).
    <ls_fcat2>-celltab = gt_celltab.
  ENDLOOP.

  go_item->display( EXPORTING iv_mode = zcl_brd_alv_n=>mc_change_mode
                    CHANGING ct_data  = gt_fcat[] ).

ENDMODULE.
*---------------------------------------------------------------------*
*      MODULE  SET_ALV_SCREEN  OUTPUT
*---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE set_screen_110 OUTPUT.
  SET PF-STATUS '0110' EXCLUDING gt_exclude.
  SET TITLEBAR  '0100' WITH TEXT-t00.
ENDMODULE.                 " SET_ALV_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*&      MODULE  SET_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE set_alv_110 OUTPUT.

  IF go_textedit_json IS INITIAL.

    CREATE OBJECT go_container_editor
      EXPORTING
        container_name = 'CON1'.
    CREATE OBJECT go_textedit_json
      EXPORTING
        wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
        wordwrap_to_linebreak_mode = cl_gui_textedit=>false
        wordwrap_position          = 2000
        parent                     = go_container_editor.
    go_textedit_json->set_text_as_stream( text = gt_editor_text ).
  ENDIF.
ENDMODULE.
*---------------------------------------------------------------------*
*      MODULE  SET_ALV_SCREEN  OUTPUT
*---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE set_screen_200 OUTPUT.
  SET PF-STATUS '0200' EXCLUDING gt_exclude.
  SET TITLEBAR  '0100' WITH TEXT-t00.
ENDMODULE.                 " SET_ALV_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*&      MODULE  SET_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE set_alv_200 OUTPUT.

  IF go_splitter_container IS INITIAL.
    CREATE OBJECT go_splitter_container
      EXPORTING
        parent  = cl_gui_container=>default_screen
        rows    = 1
        columns = 3.

    go_container_main = go_splitter_container->get_container( row = 1 column = 1 ).
    go_container_top = go_splitter_container->get_container( row = 1 column = 2 ).
    go_container_f01 = go_splitter_container->get_container( row = 1 column = 3 ).

    CREATE OBJECT go_textedit_top
      EXPORTING
        parent = go_container_top.
    CREATE OBJECT go_textedit_main
      EXPORTING
        parent = go_container_main.
    CREATE OBJECT go_textedit_f01
      EXPORTING
        parent = go_container_f01.
  ENDIF.

  CLEAR gs_alv_config.
  gs_alv_config-progid = gs_head-repid.
  gs_alv_config-alv_key = 'BALV'.
  gs_alv_config-zcreate = 'X'.
  gs_alv_config-zupdate = 'X'.
  gs_alv_config-zdelete = 'X'.
  gs_alv_config-zexcel = gs_head-excel.
  gs_alv_config-zrefresh = 'X'.
  gs_alv_config-db_click = 'X'.
  gs_alv_config-change_evt = 'X'.
  gs_alv_config-after_refresh = ''.
  gs_alv_config-zebra = 'X'.
  gs_alv_config-sel_mode = 'D'.
  gs_alv_config-ctab_fname = 'COLTAB'.
  gs_alv_config-info_fname = 'RCOLOR'.
  gs_alv_config-stylefname = 'CELLTAB'.


  LOOP AT gt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>).
    CHECK <ls_fcat>-fieldname NE 'MANDT'.
    CLEAR gs_alv_fcat.
    MOVE-CORRESPONDING <ls_fcat> TO gs_alv_fcat.
    gs_alv_fcat-progid = gs_alv_config-progid.
    gs_alv_fcat-alv_key = gs_alv_config-alv_key.
    gs_alv_fcat-fcat_key = 'DEFAULT'.
    gs_alv_fcat-col_pos = <ls_fcat>-col_pos + 1.


    IF <ls_fcat>-zkey EQ abap_true.
      gs_alv_fcat-crea_edit = abap_true.
      gs_alv_fcat-chan_edit = abap_false.
      gs_alv_fcat-upld_edit = abap_true.
    ELSE.
      CASE <ls_fcat>-fieldname.
        WHEN 'ERNAM' OR 'ERDAT' OR 'ERZET'.
          gs_alv_fcat-crea_edit = abap_false.
          gs_alv_fcat-chan_edit = abap_false.
          gs_alv_fcat-upld_edit = abap_false.
        WHEN 'AENAM' OR 'AEDAT' OR 'AEZET'.
          gs_alv_fcat-crea_edit = abap_false.
          gs_alv_fcat-chan_edit = abap_false.
          gs_alv_fcat-upld_edit = abap_false.
        WHEN OTHERS.
          gs_alv_fcat-crea_edit = abap_true.
          gs_alv_fcat-chan_edit = abap_true.
          gs_alv_fcat-upld_edit = abap_true.
      ENDCASE.
    ENDIF.

    APPEND gs_alv_fcat TO gt_alv_fcat.
  ENDLOOP.
  DATA : lt_top  TYPE zybrd00100,
         lt_main TYPE zybrd00100,
         lt_f01  TYPE zybrd00100,
         lt_100  TYPE zybrd00100.
  DATA : ls_acg_config TYPE zsbrd00140,
         ls_alv_config TYPE   ztbrd00010.
  ls_acg_config-progid = gs_head-repid.
  ls_acg_config-alv_key = 'BALV'.
  ls_acg_config-fcat_key = 'DEFAULT'.
  ls_acg_config-is_new = abap_true.
  ls_acg_config-alv_class = 'ZCL_BRD_ALV_STD'.
  ls_acg_config-is_1step = abap_false.
  ls_acg_config-is_standalone = abap_true.
  ls_acg_config-tabname = gs_head-tabnm.

  CALL FUNCTION 'ZBRD_GET_SRC_SINGLE'
    EXPORTING
      is_acg_config         = ls_acg_config
      is_alv_config         = gs_alv_config
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

  MOVE lt_top[] TO gt_top[].
  MOVE lt_main[] TO gt_main[].
  MOVE lt_f01[] TO gt_f01[].



  go_textedit_top->set_text_as_r3table( table = gt_top ).
  go_textedit_main->set_text_as_r3table( table = gt_main ).
  go_textedit_f01->set_text_as_r3table( table = gt_f01 ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      MODULE  EXIT_SCREEN  INPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE exit_screen INPUT.

  LEAVE TO SCREEN 0.
  CLEAR gv_okcode.
ENDMODULE.                 " EXIT_SCREEN  INPUT
*&---------------------------------------------------------------------*
*&      MODULE  EXIT_SCREEN  INPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE exit_screen_popup INPUT.
  CASE gv_okcode.
    WHEN c_canc OR c_back OR c_exit.
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
    WHEN 'DOWN'.
      PERFORM pre_install_down_click.
    WHEN 'GEN_INFO'.
      PERFORM add_gen_info.

    WHEN 'GEN_CODE'.
      CLEAR : gt_rows, gt_row_ids.
      CALL SCREEN 200.
  ENDCASE.
  CLEAR gv_okcode.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      FORM  SET_INIT_VALUE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM set_init_value .


ENDFORM.                    " SET_INIT_VALUE
*&---------------------------------------------------------------------*
*&      FORM  CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM check_authority .

ENDFORM.                    " CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*&      FORM  ITEM_DATA_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->PO_OBJECT     TEXT
*      -->PV_ONF4  TEXT
*      -->PV_ONF4_BEFORE  TEXT
*      -->PV_ONF4_AFTER  TEXT
*      -->PV_UCOMM  TEXT
*----------------------------------------------------------------------*
FORM item_data_changed USING po_object TYPE REF TO cl_alv_changed_data_protocol
                        pv_onf4
                        pv_onf4_before
                        pv_onf4_after
                        pv_ucomm.
  DATA lt_mod_cells TYPE lvc_t_modi WITH HEADER LINE.
  lt_mod_cells[] = po_object->mt_good_cells.
  LOOP AT lt_mod_cells ASSIGNING FIELD-SYMBOL(<ls_mod_cells>).
    AT NEW row_id.
      CLEAR gs_fcat.
      READ TABLE gt_fcat INTO gs_fcat INDEX <ls_mod_cells>-row_id.
    ENDAT.
    ASSIGN COMPONENT <ls_mod_cells>-fieldname OF STRUCTURE gs_fcat TO <gv_field>.
    <gv_field> = lt_mod_cells-value.
    AT END OF row_id.
      READ TABLE gt_fcat ASSIGNING FIELD-SYMBOL(<ls_item>) INDEX <ls_mod_cells>-row_id.
      IF sy-subrc EQ 0." modify
        IF <ls_item>-balv_status_icon NE icon_create.
          <ls_item>-balv_status_icon = icon_change.
        ENDIF.
        _set_alv_cell <ls_mod_cells>-row_id c_field-balv_status_icon <ls_item>-balv_status_icon.

      ELSE."auto added new row
        _set_alv_cell <ls_mod_cells>-row_id c_field-balv_status_icon icon_create.
        CLEAR gs_fcat-celltab.
        go_item->set_celltab_style( EXPORTING iv_mode = zcl_brd_alv_n=>mc_create_mode
                                    CHANGING ct_celltab = gs_fcat-celltab ).
        LOOP AT gs_fcat-celltab ASSIGNING FIELD-SYMBOL(<ls_celltab>).
          po_object->modify_style( EXPORTING i_row_id    = <ls_mod_cells>-row_id
                                             i_fieldname = <ls_celltab>-fieldname
                                             i_style     = <ls_celltab>-style ).
        ENDLOOP.

        APPEND gs_fcat TO gt_fcat.
      ENDIF.
      READ TABLE gt_fcat TRANSPORTING NO FIELDS INDEX <ls_mod_cells>-row_id.
      IF sy-subrc EQ 0.
        MODIFY gt_fcat FROM gs_fcat INDEX <ls_mod_cells>-row_id.
      ELSE.
        APPEND gs_fcat TO gt_fcat.
      ENDIF.
    ENDAT.
  ENDLOOP.
  go_item->set_changing_flag( abap_true ).
ENDFORM.                    "ITEM_DATA_CHANGED
*&---------------------------------------------------------------------*
*&      FORM  ITEM_SET_TOOLBAR
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->PV_INTERACTIVE     TEXT
*      -->PO_OBJECT  TEXT
*----------------------------------------------------------------------*
FORM item_set_toolbar USING pv_interactive
                       po_object TYPE REF TO cl_alv_event_toolbar_set.

  IF go_item->get_alv_mode( ) NE zcl_brd_alv_n=>mc_display_mode .
    go_item->append_toolbar_button( EXPORTING
                                   iv_function = 'ADD'
                                   iv_icon = icon_view_create "ICON-ID
                                   iv_quickinfo = ''
                                   iv_text = 'ADD BALV INFO By Json'
                                   ).
  ENDIF.
ENDFORM.                    "ITEM_SET_TOOLBAR
*&---------------------------------------------------------------------*
*&      FORM  ITEM_ADD_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->PV_INTERACTIVE     TEXT
*      -->PO_OBJECT  TEXT
*----------------------------------------------------------------------*
FORM item_add_click.
  CALL SCREEN 110 STARTING AT 10 5 ENDING AT 130  25.
ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  ITEM_ADD_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->PV_INTERACTIVE     TEXT
*      -->PO_OBJECT  TEXT
*----------------------------------------------------------------------*
FORM pre_install_down_click.
  DATA : lo_zip      TYPE REF TO cl_abap_zip,
         lv_xstring  TYPE xstring,
         lv_len      TYPE i,
         lv_src      TYPE string,
         lt_contents TYPE TABLE OF x.

  DEFINE _add_file_to_zip.
    CLEAR : lv_xstring.

    PERFORM get_src USING &1 &2 lv_src.

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = lv_src
*     MIMETYPE       = ' '
*     ENCODING       =
      IMPORTING
        buffer = lv_xstring
*   EXCEPTIONS
*     FAILED = 1
*     OTHERS = 2
      .

    "add 1st file to zip
    CALL METHOD lo_zip->add
      EXPORTING
        name    = &3
        content = lv_xstring.
  END-OF-DEFINITION.

  CREATE OBJECT lo_zip.
  _add_file_to_zip 'REP': 'ZBALV_STD_GEN_INFO' 'ZBALV_STD_GEN_INFO.txt',
                          'ZBALV_STD_INC01' 'ZBALV_STD_INC01.txt',
                           'ZBALV_STD_INC02' 'ZBALV_STD_INC02.txt'.
  _add_file_to_zip 'CLS': 'ZCL_BRD_ALV_STD' 'ZCL_BRD_ALV_STD.txt'.

  "save zip
  CLEAR lv_xstring.
  CALL METHOD lo_zip->save
    RECEIVING
      zip = lv_xstring.

  lv_len = lv_len * 2.

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer        = lv_xstring
    IMPORTING
      output_length = lv_len
    TABLES
      binary_tab    = lt_contents[].

  DATA lv_filename TYPE string.
  lv_filename = 'BALV_STD_INSTALL.zip'.
  IF cl_gui_control=>www_active EQ abap_false.
    lv_filename = 'C:\tmp\' && lv_filename.
  ENDIF.

  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      bin_filesize = lv_len
      filename     = lv_filename
      filetype     = 'BIN'
*     codepage     = '8500'
    CHANGING
      data_tab     = lt_contents[]
    EXCEPTIONS
      OTHERS       = 1.
  IF sy-subrc EQ 0.
    MESSAGE 'Successful download to C:\tmp\BALV_STD_INSTALL.zip' TYPE 'I' DISPLAY LIKE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_gen_info .
  DATA : lv_result TYPE i,
         lv_str    TYPE string.
  TYPES: BEGIN OF ts_json_input,
           progname     TYPE sy-repid,
           tabname      TYPE tabname,
           excel        TYPE flag,
           fieldcatalog LIKE gt_fcat,
         END OF ts_json_input.
  DATA : ls_json TYPE ts_json_input.

  CLEAR : gt_editor_text, gt_fcat[].
  go_textedit_json->get_text_as_stream( IMPORTING text = gt_editor_text
                                                  is_modified = lv_result ).

  LOOP AT gt_editor_text ASSIGNING FIELD-SYMBOL(<lv_txt>).
    lv_str = lv_str && <lv_txt>.
  ENDLOOP.

  /ui2/cl_json=>deserialize( EXPORTING json = lv_str
                             CHANGING data = ls_json ).
  gs_head-repid = ls_json-progname.
  gs_head-tabnm = ls_json-tabname.
  gs_head-excel = ls_json-excel.
  gt_fcat[] = ls_json-fieldcatalog[].

  LOOP AT gt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>).
    CASE <ls_fcat>-datatype.
      WHEN 'CHAR'.
        IF <ls_fcat>-dd_outlen > 20.
          <ls_fcat>-outputlen = 20.
        ELSEIF <ls_fcat>-dd_outlen < 8.
          <ls_fcat>-outputlen = 8.
        ELSE.
          <ls_fcat>-outputlen = <ls_fcat>-dd_outlen.
        ENDIF.
        IF <ls_fcat>-intlen = 1.
          IF <ls_fcat>-fieldname CP '*FLAG*' OR <ls_fcat>-fieldname EQ 'ZDEL'.
            <ls_fcat>-checkbox = abap_true.
          ENDIF.
        ENDIF.
      WHEN 'DATS'..
        <ls_fcat>-outputlen = 10.
      WHEN 'TIMS'.
        <ls_fcat>-outputlen = 8.
    ENDCASE.
    CASE <ls_fcat>-domname.
      WHEN 'FLAG' OR 'BOOLE' OR 'XFELD' OR 'XFLAG'
        OR 'FLAG'  OR 'X' OR 'DDFLAG' OR 'CHAR1_X'.
        <ls_fcat>-checkbox = abap_true.
    ENDCASE.
    IF <ls_fcat>-inttype = 'C' AND <ls_fcat>-intlen <= 10.
      <ls_fcat>-just = 'C'.
    ELSEIF <ls_fcat>-inttype = 'I'.
      <ls_fcat>-just = 'R'.
    ELSEIF <ls_fcat>-inttype = 'N'.
      <ls_fcat>-just = 'R'.
    ELSEIF <ls_fcat>-inttype = 'P'.
      <ls_fcat>-just = 'R'.
    ELSEIF <ls_fcat>-inttype = 'X'.
      <ls_fcat>-just = 'R'.
    ELSEIF <ls_fcat>-inttype = 'D'.
      <ls_fcat>-just = 'C'.
    ELSEIF <ls_fcat>-inttype = 'T'.
      <ls_fcat>-just = 'C'.
    ELSE.
      gs_alv_fcat-just = 'L'.
    ENDIF.
  ENDLOOP.



  go_textedit_json->delete_text( ).

  go_item->refresh( ).

  LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_SRC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_SRC
*&      --> P_
*&      --> CLEAR
*&      --> LV_XSTRING
*&---------------------------------------------------------------------*
FORM get_src USING  VALUE(pv_type)
                    VALUE(pv_objnm)
                    pv_src TYPE string.

  DATA : lt_src     TYPE TABLE OF string,
         lv_src     TYPE string,
         lv_src_tmp TYPE string,
         lv_cls     TYPE seoclskey.

  CASE pv_type.
    WHEN 'REP'.
      READ REPORT pv_objnm INTO lt_src.
    WHEN 'CLS'.
      lv_cls = pv_objnm.
      CLASS cl_oo_include_naming DEFINITION LOAD.

      DATA:
        clstype     TYPE seoclstype,
        source      TYPE seop_source_string,
        pool_source TYPE seop_source_string,
        source_line TYPE LINE OF seop_source_string,
        tabix       TYPE sytabix,
        includes    TYPE seop_methods_w_include,
        include     TYPE seop_method_w_include,
        cifref      TYPE REF TO if_oo_clif_incl_naming,
        clsref      TYPE REF TO if_oo_class_incl_naming,
        intref      TYPE REF TO if_oo_interface_incl_naming.
      DATA: l_string TYPE string.

      CALL METHOD cl_oo_include_naming=>get_instance_by_cifkey
        EXPORTING
          cifkey = lv_cls
        RECEIVING
          cifref = cifref
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.


      clsref ?= cifref.
      READ REPORT clsref->class_pool
        INTO pool_source.
      LOOP AT pool_source INTO source_line.
        IF source_line CS 'CLASS-POOL'
          OR source_line CS 'class-pool'.
*          APPEND source_line TO lt_src.
          tabix = sy-tabix.
          EXIT.
        ENDIF.
      ENDLOOP.
      SKIP.
      READ REPORT clsref->locals_old
        INTO source.
      LOOP AT source
        INTO source_line.
        IF source_line NS '*"*'.
          APPEND source_line TO lt_src.
        ENDIF.
      ENDLOOP.
      IF sy-subrc = 0.
        SKIP.
      ENDIF.
      READ REPORT clsref->locals_def
        INTO source.
      LOOP AT source
        INTO source_line.
        IF source_line NS '*"*'.
          APPEND source_line TO lt_src.
        ENDIF.
      ENDLOOP.
      IF sy-subrc = 0.
        SKIP.
      ENDIF.
      READ REPORT clsref->locals_imp
        INTO source.
      LOOP AT source
        INTO source_line.
        IF source_line NS '*"*'.
          APPEND source_line TO lt_src.
        ENDIF.
      ENDLOOP.
      IF sy-subrc = 0.
        SKIP.
      ENDIF.
      READ REPORT clsref->macros
        INTO source.
      LOOP AT source
        INTO source_line.
        IF source_line NS '*"*'.
          APPEND source_line TO lt_src.
        ENDIF.
      ENDLOOP.
      IF sy-subrc = 0.
        SKIP.
      ENDIF.
      READ REPORT clsref->public_section
        INTO source.
      LOOP AT source
        INTO source_line.
        IF source_line NS '*"*'.
          APPEND source_line TO lt_src.
        ENDIF.
      ENDLOOP.
      SKIP.
      READ REPORT clsref->protected_section
        INTO source.
      LOOP AT source
        INTO source_line.
        IF source_line NS '*"*'.
          APPEND source_line TO lt_src.
        ENDIF.
      ENDLOOP.
      SKIP.
      READ REPORT clsref->private_section
        INTO source.
      LOOP AT source
        INTO source_line.
        IF source_line NS '*"*'.
          APPEND source_line TO lt_src.
        ENDIF.
      ENDLOOP.
      CONCATENATE 'CLASS' lv_cls 'IMPLEMENTATION' INTO l_string SEPARATED BY space.
      LOOP AT pool_source
        FROM tabix
        INTO source_line.
        IF source_line CS 'ENDCLASS'.
          APPEND source_line TO lt_src.
        ENDIF.
        IF source_line CS l_string.
          SKIP.
          tabix = sy-tabix.
          APPEND source_line TO lt_src.

          EXIT.
        ENDIF.
      ENDLOOP.
* method implementation
      includes = clsref->get_all_method_includes( ).
      LOOP AT includes
        INTO include.
        READ REPORT include-incname
          INTO source.
        SKIP.
        LOOP AT source
          INTO source_line.
          APPEND source_line TO lt_src.
        ENDLOOP.
      ENDLOOP.
      LOOP AT pool_source
        FROM tabix
        INTO source_line.
        IF source_line CS 'ENDCLASS'.
          APPEND source_line TO lt_src.
        ENDIF.
      ENDLOOP.
  ENDCASE.

  LOOP AT lt_src INTO lv_src_tmp.
    CONCATENATE lv_src lv_src_tmp INTO lv_src SEPARATED BY cl_abap_char_utilities=>newline.
    CLEAR lv_src_tmp.
  ENDLOOP.
  pv_src = lv_src.
ENDFORM.
