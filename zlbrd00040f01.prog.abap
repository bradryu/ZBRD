*&---------------------------------------------------------------------*
*& Include          ZLBRD00040F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_CONFIG_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_config_data .

  gs_header-progid = pa_prog.
  gs_header-alv_key = pa_alv.
  gs_header-zcreate = abap_true.
  gs_header-zupdate = abap_true.
  gs_header-zdelete = abap_true.
  gs_header-zrefresh = abap_true.
  gs_header-zexcel = abap_true.
  gs_header-use_flag = abap_false.
  gs_header-zebra = abap_true.
  gs_header-stylefname = 'CELLTAB'.
  gs_header-sel_mode = 'D'.
  gs_header-info_fname = 'RCOLOR'.
  gs_header-ctab_fname = 'COLTAB'.
  gs_header-change_evt = abap_true.
  gs_header-ernam = sy-uname.
  gs_header-erdat = sy-datum.
  gs_header-erzet = sy-uzeit.
  gs_header-aenam = sy-uname.
  gs_header-aedat = sy-datum.
  gs_header-aezet = sy-uzeit.

  DATA : lt_field TYPE lvc_t_fcat,
         ls_field TYPE lvc_s_fcat.

  CLEAR lt_field.
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = pa_tabnm
      "i_buffer_active        = abap_true      " Put this as X
      i_client_never_display = abap_true
      i_bypassing_buffer     = abap_true      " Put this as X
    CHANGING
      ct_fieldcat            = lt_field
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  CLEAR gs_item.
  gs_item-progid = pa_prog.
  gs_item-alv_key = pa_alv.
  gs_item-fcat_key = 'DEFAULT'.
  gs_item-fieldname = 'BALV_STATUS_ICON'.
  gs_item-icon = abap_true.
  gs_item-datatype = 'CHAR'.
  gs_item-intlen = 4.
  gs_item-col_pos = 1.
  gs_item-zkey = abap_true.
  gs_item-inttype = 'C'.
  gs_item-emphasize = 'K41'.
  gs_item-just = 'C'.
  APPEND gs_item TO gt_item.

  DEFINE _set_value.
    gs_item-&1 = &2.
  END-OF-DEFINITION.
  LOOP AT lt_field INTO ls_field.
    CLEAR gs_item.
    MOVE-CORRESPONDING ls_field TO gs_item.
    gs_item-progid = pa_prog.
    gs_item-alv_key = pa_alv.
    gs_item-fcat_key = 'DEFAULT'.
    gs_item-zkey = ls_field-key.
    gs_item-decimals_o = gs_item-decimals.
    IF gs_item-tabname EQ '1'.
      CLEAR gs_item-tabname.
    ENDIF.
    IF gs_item-ref_table EQ 'ICON'.
      CLEAR gs_item-ref_table.
    ENDIF.
    IF gs_item-fieldname EQ 'MANDT'.
      gs_item-col_pos = 999.
    ENDIF.

    CASE gs_item-fieldname.
      WHEN 'ERDAT'.
        _set_value : scrtext_s 'Create Date',
                     scrtext_m 'Create Date',
                     scrtext_l 'Create Date',
                     reptext 'Create Date',
                     just 'C',
                     crea_edit '',
                     chan_edit '',
                     upld_edit ''.
      WHEN 'ERZET'.
        _set_value : scrtext_s 'Create Time',
                     scrtext_m 'Create Time',
                     scrtext_l 'Create Time',
                     reptext 'Create Time',
                     just 'C',
                     crea_edit '',
                     chan_edit '',
                     upld_edit ''.
      WHEN 'ERNAM'.
        _set_value : scrtext_s 'Create User',
                     scrtext_m 'Create User',
                     scrtext_l 'Create User',
                     reptext 'Create User',
                     just 'C',
                     crea_edit '',
                     chan_edit '',
                     upld_edit ''.
      WHEN 'AEDAT'.
        _set_value : scrtext_s 'Change Date',
                     scrtext_m 'Change Date',
                     scrtext_l 'Change Date',
                     reptext 'Change Date',
                     just 'C',
                     crea_edit '',
                     chan_edit '',
                     upld_edit ''.
      WHEN 'AEZET'.
        _set_value : scrtext_s 'Change Time',
                     scrtext_m 'Change Time',
                     scrtext_l 'Change Time',
                     reptext 'Change Time',
                     just 'C',
                     crea_edit '',
                     chan_edit '',
                     upld_edit ''.
      WHEN 'AENAM'.
        _set_value : scrtext_s 'Change User',
                     scrtext_m 'Change User',
                     scrtext_l 'Change User',
                     reptext 'Change User',
                     just 'C',
                     crea_edit '',
                     chan_edit '',
                     upld_edit ''.
      WHEN 'ZDEL'.
        _set_value : tech 'X'.
      WHEN OTHERS.
        IF gs_item-datatype EQ 'CHAR' AND gs_item-inttype EQ 'C' AND gs_item-intlen <= 20.
          _set_value : just 'C'.
        ENDIF.
        IF gs_item-fieldname CP '*FLAG*'.
          _set_value : just 'C',
                 outputlen 10,
                 checkbox abap_true.
        ENDIF.
    ENDCASE.
    APPEND gs_item TO gt_item.
    CLEAR ls_field.
  ENDLOOP.

  LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<ls_item>).
    IF <ls_item>-zkey EQ abap_true.
      IF <ls_item>-fieldname NE 'BALV_STATUS_ICON'.
        <ls_item>-crea_edit = abap_true.
        <ls_item>-chan_edit = abap_false.
        <ls_item>-upld_edit = abap_true.
      ENDIF.
    ELSE.
      <ls_item>-crea_edit = abap_true.
      <ls_item>-chan_edit = abap_true.
      <ls_item>-upld_edit = abap_true.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GEN_SOURCE_CODE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM gen_source_code .
  DATA : lt_top  TYPE zybrd00100,
         lt_main TYPE zybrd00100,
         lt_f01  TYPE zybrd00100,
         lt_100  TYPE zybrd00100.

  gs_acg_config-progid = pa_prog.
  gs_acg_config-alv_key = pa_alv.
  gs_acg_config-fcat_key = 'DEFAULT'.
  gs_acg_config-is_new = abap_true.
  gs_acg_config-alv_class = gv_alv_class.
  gs_acg_config-tabname = pa_tabnm.

  CALL FUNCTION 'ZBRD_GET_SRC_SINGLE'
    DESTINATION gc_acg_rfc_desc
    EXPORTING
      is_acg_config         = gs_acg_config
      is_alv_config         = gs_header
    IMPORTING
      et_fields             = gs_dynpro-fields
      et_container          = gs_dynpro-containers
    TABLES
      t_top                 = lt_top
      t_main                = lt_main
      t_f01                 = lt_f01
      t_100                 = lt_100
      t_alv_fcat            = gt_item
    EXCEPTIONS
      system_failure        = 1
      communication_failure = 2
      resource_failure      = 3
      license_expired       = 4.

  MOVE lt_top[] TO gt_top[].
  MOVE lt_main[] TO gt_main[].
  MOVE lt_f01[] TO gt_f01[].
  MOVE lt_100[] TO gt_100[].
ENDFORM.

**&---------------------------------------------------------------------*
**& Form GENERATE_PROGRAM
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**& -->  p1        text
**& <--  p2        text
**&---------------------------------------------------------------------*
*FORM generate_program .
*  DATA : ls_ko200            LIKE  ko200,
*         ls_tadir            TYPE tadir,
*         lv_program_name     LIKE  trdir-name,
*         lv_mainprogram_name LIKE  trdir-name,
*         lv_program_ordernum LIKE  e070-trkorr,
*         lv_program_devclass LIKE  tdevc-devclass,
*         ls_program_progdir  LIKE  progdir,
*         ls_program_trdir    LIKE  trdir.
*
*
*  gv_repti = pa_repti.
*
*
*  lv_program_name = pa_prog.
*
*  "1. get CTS No, Package ID
*  PERFORM get_cts USING lv_program_name lv_program_devclass lv_program_ordernum.
*
*  "2. Empty Main Report Create
*  PERFORM create_empty_program USING lv_program_name
*                                     lv_program_devclass
*                                     gv_err.
*  IF gv_err = abap_true.
*    EXIT.
*  ENDIF.
*
*  "3. Screen Create
*  PERFORM create_screen USING lv_program_name lv_program_ordernum.
*
*  "4. Titlebar, Satus bar create
*  PERFORM create_screen_bar USING lv_program_name  .
*
*  "5. Object List Rebuild
*  PERFORM rebuild_program USING lv_program_name lv_program_devclass lv_program_ordernum.
*
*  MESSAGE 'Program Generated!' TYPE 'I' DISPLAY LIKE 'S'.
*ENDFORM.
**&---------------------------------------------------------------------*
**& Form GET_CTS
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**&      --> LV_PROGRAM_NAME
**&---------------------------------------------------------------------*
*FORM get_cts  USING    pv_program_name pv_program_devclass pv_program_ordernum.
*  DATA : ls_ko200            LIKE  ko200,
*         ls_tadir            TYPE tadir,
*         lv_program_name     LIKE  trdir-name,
*         lv_program_corrnum  LIKE  e070-trkorr,
*         lv_program_ordernum LIKE  e070-trkorr,
*         lv_program_devclass LIKE  tdevc-devclass.
*
*  lv_program_name = pv_program_name.
*
*  ls_ko200-pgmid = 'R3TR'.
*  ls_ko200-object = 'PROG'.
*  ls_ko200-obj_name = lv_program_name.
*  ls_ko200-masterlang = sy-langu.
*  CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
*    EXPORTING
*      input  = sy-langu
*    IMPORTING
*      output = ls_ko200-masterlang.
*  ls_ko200-operation = '1'.
*
*  CALL FUNCTION 'TRINT_CORR_INSERT'
*    EXPORTING
*      is_ko200 = ls_ko200
*    IMPORTING
*      we_order = lv_program_ordernum "request
*      we_task  = lv_program_corrnum "task
*      es_tadir = ls_tadir.
*
*  pv_program_ordernum = lv_program_ordernum.
*  pv_program_devclass = ls_tadir-devclass. "package name
*ENDFORM.
**&---------------------------------------------------------------------*
**& Form CREATE_EMPTY_PROGRAM
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**&      --> LV_PROGRAM_NAME
**&---------------------------------------------------------------------*
*FORM create_empty_program  USING    pv_program_name pv_program_devclass pv_exit.
*
*  DATA : ls_ko200            LIKE  ko200,
*         ls_tadir            TYPE tadir,
*         lv_program_name     LIKE  trdir-name,
*         lv_mainprogram_name LIKE  trdir-name,
*         lv_program_corrnum  LIKE  e070-trkorr,
*         lv_program_ordernum LIKE  e070-trkorr,
*         lv_program_devclass LIKE  tdevc-devclass,
*         ls_program_progdir  LIKE  progdir,
*         ls_program_trdir    LIKE  trdir.
*
*
*  lv_program_name = pv_program_name.
*
*  CLEAR pv_exit.
*  "1. Empty  Report Create
*  ls_program_trdir-name = lv_program_name.
*  ls_program_trdir-varcl = 'X'.
*  ls_program_trdir-subc = '1'. "Excutable
*  ls_program_trdir-cnam = sy-uname.
*  ls_program_trdir-cdat = sy-datum.
*  ls_program_trdir-unam = sy-uname.
*  ls_program_trdir-udat = sy-datum.
*  ls_program_trdir-vern = '1'.
*  ls_program_trdir-levl = sy-saprl.
*  ls_program_trdir-rmand = sy-mandt.
*  ls_program_trdir-rload = 'E'.
*  ls_program_trdir-uccheck = 'X'.
*
*  MOVE-CORRESPONDING ls_program_trdir TO ls_program_progdir.
*
*  CALL FUNCTION 'RS_EDTR_ATTR_ADD'
*    EXPORTING
*      program_name       = lv_program_name
**     activate_immediately = ' '
*      with_trdir_entry   = 'X'
*      with_progdir_entry = 'X'
*      suppress_dialog    = 'X'
*      mainprogram_name   = lv_mainprogram_name
*    CHANGING
*      program_progdir    = ls_program_progdir
*      program_trdir      = ls_program_trdir
*      program_ordernum   = lv_program_ordernum
*      program_corrnum    = lv_program_corrnum
*      program_devclass   = lv_program_devclass
*    EXCEPTIONS
*      program_exists     = 1
*      OTHERS             = 2.
*
*  CASE sy-subrc.
*    WHEN 0.
*      "title
*      DATA ls_trdirti TYPE trdirti.
*      ls_trdirti-name = lv_program_name.
*      ls_trdirti-sprsl = sy-langu.
*      ls_trdirti-text  = gv_repti.
*      MODIFY trdirti FROM ls_trdirti.
*    WHEN 1."already exits program
*      "Ask Overwrite?
*      IF zcl_brd_alv=>confirm_msg( EXPORTING iv_title = 'Confirm'
*                                          iv_question = 'Program Already Exists.. Overwrite??' ) EQ abap_true.
*      ELSE.
*        MESSAGE 'Operation Canceled' TYPE 'I'.
*        pv_exit = abap_true.
*        EXIT.
*      ENDIF.
*    WHEN OTHERS.
*      MESSAGE 'Generation Error' TYPE 'I' DISPLAY LIKE 'E'.
*      pv_exit = abap_true.
*      EXIT.
*  ENDCASE.
*
*  INSERT REPORT lv_program_name FROM gt_main.
*  COMMIT WORK.
*
*
*  "2. Empty TOP Include Report Create
*  lv_mainprogram_name = lv_program_name.
*  lv_program_name = lv_mainprogram_name && 'TOP'.
*  ls_program_trdir-name = lv_program_name.
*  ls_program_trdir-subc = 'I'. "Include
*  MOVE-CORRESPONDING ls_program_trdir TO ls_program_progdir.
*
*  CALL FUNCTION 'RS_EDTR_ATTR_ADD'
*    EXPORTING
*      program_name       = lv_program_name
**     activate_immediately = ' '
*      with_trdir_entry   = 'X'
*      with_progdir_entry = 'X'
*      suppress_dialog    = 'X'
*      mainprogram_name   = lv_mainprogram_name
*    CHANGING
*      program_progdir    = ls_program_progdir
*      program_trdir      = ls_program_trdir
*      program_ordernum   = lv_program_ordernum
*      program_corrnum    = lv_program_corrnum
*      program_devclass   = lv_program_devclass
*    EXCEPTIONS
*      program_exists     = 1
*      OTHERS             = 2.
*
*
*  INSERT REPORT lv_program_name FROM gt_top.
*  COMMIT WORK.
*
*  "3. Empty F01 Include Report Create
*  lv_program_name = lv_mainprogram_name && 'F01'.
*  ls_program_trdir-name = lv_program_name.
*  ls_program_trdir-subc = 'I'. "Include
*  MOVE-CORRESPONDING ls_program_trdir TO ls_program_progdir.
*
*  CALL FUNCTION 'RS_EDTR_ATTR_ADD'
*    EXPORTING
*      program_name       = lv_program_name
**     activate_immediately = ' '
*      with_trdir_entry   = 'X'
*      with_progdir_entry = 'X'
*      suppress_dialog    = 'X'
*      mainprogram_name   = lv_mainprogram_name
*    CHANGING
*      program_progdir    = ls_program_progdir
*      program_trdir      = ls_program_trdir
*      program_ordernum   = lv_program_ordernum
*      program_corrnum    = lv_program_corrnum
*      program_devclass   = lv_program_devclass
*    EXCEPTIONS
*      program_exists     = 1
*      OTHERS             = 2.
*
*  INSERT REPORT lv_program_name FROM gt_f01.
*  COMMIT WORK.
*ENDFORM.
**&---------------------------------------------------------------------*
**& Form CREATE_SCREEN
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**&      --> LV_PROGRAM_NAME
**&---------------------------------------------------------------------*
*FORM create_screen  USING    pv_program_name pv_program_corrnum.
*  DATA : lv_mainprogram_name LIKE  trdir-name,
*         lv_from_dynnr       TYPE dynname,
*         lv_to_dynnr         TYPE dynname,
*         lv_numc             TYPE n LENGTH 2.
*
*  lv_mainprogram_name = pv_program_name.
*
*  "Screen Header
*  gs_dynpro-header-program     = lv_mainprogram_name.
*  gs_dynpro-header-screen      = '0100'.
*  gs_dynpro-header-language    = 'EN'.
*  gs_dynpro-header-descript    = 'List'.
*  gs_dynpro-header-type        = 'N'.
*  gs_dynpro-header-nextscreen  = '0100'.
*  gs_dynpro-header-lines       = 200.
*  gs_dynpro-header-columns     = 255.
*
*
*  LOOP AT gt_100 ASSIGNING FIELD-SYMBOL(<ls_100>).
*    APPEND VALUE #( line = <ls_100> ) TO gs_dynpro-flow_logic.
*  ENDLOOP.
*
*  CALL FUNCTION 'RPY_DYNPRO_INSERT'
*    EXPORTING
*      header                 = gs_dynpro-header
*      suppress_exist_checks  = abap_true
*      corrnum                = pv_program_corrnum
*    TABLES
*      containers             = gs_dynpro-containers
*      fields_to_containers   = gs_dynpro-fields
*      flow_logic             = gs_dynpro-flow_logic
*    EXCEPTIONS
*      cancelled              = 1
*      already_exists         = 2
*      program_not_exists     = 3
*      not_executed           = 4
*      missing_required_field = 5
*      illegal_field_value    = 6
*      field_not_allowed      = 7
*      not_generated          = 8
*      illegal_field_position = 9
*      OTHERS                 = 10.
*
*
*ENDFORM.
**&---------------------------------------------------------------------*
**& Form CREATE_SCREEN_BAR
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**& -->  p1        text
**& <--  p2        text
**&---------------------------------------------------------------------*
*FORM create_screen_bar  USING    pv_program_name .
*  DATA : lv_mainprogram_name LIKE  trdir-name,
*         _program            TYPE  trdir-name.
*
*  lv_mainprogram_name = pv_program_name.
*
*
*
*  DATA: ista TYPE TABLE OF rsmpe_stat,
*        ifun TYPE TABLE OF rsmpe_funt,
*        imen TYPE TABLE OF rsmpe_men,
*        imtx TYPE TABLE OF rsmpe_mnlt,
*        iact TYPE TABLE OF rsmpe_act,
*        ibut TYPE TABLE OF rsmpe_but,
*        ipfk TYPE TABLE OF rsmpe_pfk,
*        iset TYPE TABLE OF rsmpe_staf,
*        idoc TYPE TABLE OF rsmpe_atrt,
*        itit TYPE TABLE OF rsmpe_titt,
*        ibiv TYPE TABLE OF rsmpe_buts.
*  DATA xadm   TYPE rsmpe_adm.
*  DATA xtrkey TYPE trkey.
*  _program = lv_mainprogram_name.
*
*  xtrkey-obj_type = 'PROG'.
*  xtrkey-obj_name = _program.
*  xtrkey-sub_type = 'CUAD'.
*  xtrkey-sub_name = _program.
*
**
*  xadm-actcode = '000001'.
*  xadm-pfkcode = '000001'.
*
*  ista = VALUE #( ( code = '0100' modal = 'D' actcode = '000001'
*                    pfkcode = '000001' butcode = '0000' int_note = 'Status' ) ).
*
*  ifun = VALUE #(
*  ( code = 'BACK' textno = '001' type = 'E' text_type = 'S' text_name = 'ICON_SYSTEM_BACK' icon_id = '@2M@' fun_text = 'Back' )
*  ( code = 'CANC' textno = '001' type = 'E' text_type = 'S' text_name = 'ICON_SYSTEM_CANCEL' icon_id = '@2O@' fun_text = 'Cancel' )
*  ( code = 'EXIT' textno = '001' type = 'E' text_type = 'S' text_name = 'ICON_SYSTEM_END' icon_id = '@2N@' fun_text = 'Exit' )
*  ( code = 'SAVE' textno = '001' type = ' ' text_type = 'S' text_name = 'ICON_SYSTEM_SAVE' icon_id = '@2L@' fun_text = 'Save' )
*  ).
*
*
*  ipfk = VALUE #( ( code = '000001' pfno = '03' funcode = 'BACK' funno = '001' )
*  ( code = '000001' pfno = '11' funcode = 'SAVE' funno = '001' )
*  ( code = '000001' pfno = '12' funcode = 'CANC' funno = '001' )
*  ( code = '000001' pfno = '15' funcode = 'EXIT' funno = '001' ) ).
*
*  iset = VALUE #( ( status = '0100' function = 'BACK' )
*  ( status = '0100' function = 'CANC' )
*  ( status = '0100' function = 'EXIT' )
*  ( status = '0100' function = 'SAVE' ) ).
*
*  idoc = VALUE #( ( obj_type = 'A' obj_code = '000001' sub_code = '' modal = 'D' int_note = 'Status' )
*  ( obj_type = 'P' obj_code = '000001' sub_code = '' modal = 'D' int_note = 'Status' )
*  ( obj_type = 'B' obj_code = '000001' sub_code = '0001' modal = 'D' int_note = 'Status' ) ).
*
*  itit = VALUE #( ( code = '0100' text = '&' ) ).
*
*  CALL FUNCTION 'RS_CUA_INTERNAL_WRITE'
*    EXPORTING
*      program   = _program
*      language  = sy-langu
*      tr_key    = xtrkey
*      adm       = xadm
*      state     = 'A'
*    TABLES
*      sta       = ista
*      fun       = ifun
*      men       = imen
*      mtx       = imtx
*      act       = iact
*      but       = ibut
*      pfk       = ipfk
*      set       = iset
*      doc       = idoc
*      tit       = itit
*      biv       = ibiv
*    EXCEPTIONS
*      not_found = 1
*      OTHERS    = 2.
*ENDFORM.
**&---------------------------------------------------------------------*
**& Form REBUILD_PROGRAM
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**&      --> LV_PROGRAM_NAME
**&---------------------------------------------------------------------*
*FORM rebuild_program  USING    pv_program_name
*                               pv_program_devclass
*                               pv_program_ordernum.
*
*  DATA : lv_mainprogram_name LIKE  trdir-name,
*         lv_tname            TYPE dirtree-tname.
*
*  lv_mainprogram_name = pv_program_name.
*
*  lv_tname = 'PG_' && lv_mainprogram_name.
*  CALL FUNCTION 'WB_TREE_ACTUALIZE'
*    EXPORTING
*      tree_name              = lv_tname
*      without_crossreference = abap_true
*      with_tcode_index       = abap_true.
*
*  " Text Pool
*  DATA  BEGIN OF hirst2 OCCURS 200.
*  INCLUDE STRUCTURE textpool.
*  DATA  END OF hirst2.
*
*  CLEAR hirst2.
*  hirst2-id = 'R'.
*  hirst2-key = ''.
*  hirst2-entry = gv_repti.
*  hirst2-length = '26'.
*  APPEND hirst2.
*
*  CLEAR hirst2.
*  hirst2-id = 'I'.
*  hirst2-key = 'T00'.
*  hirst2-entry = gv_repti.
*  hirst2-length = '26'.
*  APPEND hirst2.
*
*  CLEAR hirst2.
*  hirst2-id = 'I'.
*  hirst2-key = 'B01'.
*  hirst2-entry = 'Download'.
*  hirst2-length = '20'.
*  APPEND hirst2.
*
*  CLEAR hirst2.
*  hirst2-id = 'I'.
*  hirst2-key = 'T01'.
*  hirst2-entry = 'Display'.
*  hirst2-length = '20'.
*  APPEND hirst2.
*
*  CLEAR hirst2.
*  hirst2-id = 'I'.
*  hirst2-key = 'T02'.
*  hirst2-entry = 'Upload'.
*  hirst2-length = '20'.
*  APPEND hirst2.
*
*  CLEAR hirst2.
*  hirst2-id = 'I'.
*  hirst2-key = 'T03'.
*  hirst2-entry = 'File Path'.
*  hirst2-length = '20'.
*  APPEND hirst2.
*
*  CLEAR hirst2.
*  hirst2-id = 'I'.
*  hirst2-key = 'T04'.
*  hirst2-entry = 'Sample Excel'.
*  hirst2-length = '20'.
*  APPEND hirst2.
*
*  CLEAR hirst2.
*  hirst2-id = 'I'.
*  hirst2-key = 'T09'.
*  hirst2-entry = 'Select Options'.
*  hirst2-length = '20'.
*  APPEND hirst2.
*
*  DATA lv_cnt(2) TYPE n VALUE 9.
*  LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE zkey = abap_true AND tech NE abap_true.
*    ADD 1 TO lv_cnt.
*    CLEAR hirst2.
*    hirst2-id = 'I'.
*    hirst2-key = 'T' && lv_cnt.
*    hirst2-entry = <ls_fcat>-reptext(18).
*    hirst2-length = '18'.
*    APPEND hirst2.
*  ENDLOOP.
*
*  LOOP AT gt_item ASSIGNING <ls_fcat> WHERE zkey = abap_false AND tech NE abap_true.
*    ADD 1 TO lv_cnt.
*    CLEAR hirst2.
*    hirst2-id = 'I'.
*    hirst2-key = 'T' && lv_cnt.
*    hirst2-entry = <ls_fcat>-reptext(18).
*    hirst2-length = '18'.
*    APPEND hirst2.
*  ENDLOOP.
*
*  INSERT TEXTPOOL lv_mainprogram_name FROM hirst2 LANGUAGE sy-langu.
*
*  " Tcode create
*  IF gv_tcode_gen EQ abap_true.
*    DATA : ls_tstc   TYPE tstc,
*           ls_tstct  TYPE tstct,
*           lv_dynpro TYPE d020s-dnum.
*    ls_tstc-tcode = lv_mainprogram_name.
*    ls_tstc-pgmna = lv_mainprogram_name.
*    ls_tstct-ttext = gv_repti.
*    ls_tstct-tcode = lv_mainprogram_name.
*    lv_dynpro = '1000'.
*    CALL FUNCTION 'RPY_TRANSACTION_INSERT'
*      EXPORTING
*        transaction             = ls_tstc-tcode
*        program                 = ls_tstc-pgmna
*        dynpro                  = lv_dynpro
*        language                = sy-langu
*        development_class       = pv_program_devclass
*        transport_number        = pv_program_ordernum
*        transaction_type        = 'R' "report
*        shorttext               = ls_tstct-ttext
*        called_transaction      = ls_tstc-tcode
*        called_transaction_skip = abap_true
**       variant                 = ls_rsstcd-variant
**       cl_independend          = ls_rsstcd-s_ind_vari
*        html_enabled            = abap_true
*        java_enabled            = abap_true
*        wingui_enabled          = abap_true
*        suppress_corr_insert    = abap_true
**  TABLES
**       param_values            = lt_param_values
*      EXCEPTIONS
*        cancelled               = 1
*        already_exist           = 2
*        permission_error        = 3
*        name_not_allowed        = 4
*        name_conflict           = 5
*        illegal_type            = 6
*        object_inconsistent     = 7
*        db_access_error         = 8
*        OTHERS                  = 9.
*  ENDIF.
*ENDFORM.
