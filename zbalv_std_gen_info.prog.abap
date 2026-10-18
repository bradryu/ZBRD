*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
************************************************************************
* MODULES / SUB MODULE :
*&---------------------------------------------------------------------
* T_CODE             : ZBALV_STD_GEN_INFO
* WRITER             :
* DATE               :
* TYPE               :
* DESCRIPTION        :
*
************************************************************************
*              CHANGED HISTORY
*&---------------------------------------------------------------------*
*CHANGED  CHANGED DATE   WRITER       CR No.     DESCRIPTION
*&---------------------------------------------------------------------*
*  N                                             CREATE                *
************************************************************************
REPORT zbalv_std_gen_info NO STANDARD PAGE HEADING.
*&---------------------------------------------------------------------*
*& DATA
*&---------------------------------------------------------------------*
TYPES:
  BEGIN OF ts_balv_fcat,
    fieldname      TYPE lvc_fname,
    row_pos        TYPE lvc_rowpos,
    col_pos        TYPE lvc_colpos,
    tabname        TYPE lvc_tname,
    currency       TYPE lvc_curr,
    cfieldname     TYPE lvc_cfname,
    quantity       TYPE lvc_quan,
    qfieldname     TYPE lvc_qfname,
    ifieldname     TYPE lvc_fname,
    round          TYPE lvc_round,
    exponent       TYPE lvc_expont,
    zkey           TYPE lvc_key,
    key_sel        TYPE lvc_keysel,
    icon           TYPE lvc_icon,
    symbol         TYPE lvc_symbol,
    checkbox       TYPE lvc_checkb,
    just           TYPE lvc_just,
    lzero          TYPE lvc_lzero,
    no_sign        TYPE lvc_nosign,
    no_zero        TYPE lvc_nozero,
    no_convext     TYPE lvc_noconv,
    edit_mask      TYPE lvc_edtmsk,
    emphasize      TYPE lvc_emphsz,
    fix_column     TYPE lvc_fixcol,
    do_sum         TYPE lvc_dosum,
    no_sum         TYPE lvc_nosum,
    no_out         TYPE lvc_noout,
    tech           TYPE lvc_tech,
    outputlen      TYPE lvc_outlen,
    convexit       TYPE convexit,
    seltext        TYPE lvc_txt,
    tooltip        TYPE lvc_tip,
    rollname       TYPE lvc_roll,
    datatype       TYPE datatype_d,
    inttype        TYPE inttype,
    intlen         TYPE intlen,
    lowercase      TYPE lowercase,
    reptext        TYPE reptext,
    hier_level     TYPE lvc_hierl,
    reprep         TYPE lvc_crprp,
    domname        TYPE domname,
    sp_group       TYPE lvc_spgrp,
    hotspot        TYPE lvc_hotspt,
    dfieldname     TYPE lvcdbgfn,
    col_id         TYPE lvc_colid,
    f4availabl     TYPE ddf4avail,
    auto_value     TYPE lvc_auto,
    checktable     TYPE tabname,
    valexi         TYPE valexi,
    web_field      TYPE lvc_fname,
    href_hndl      TYPE int4,
    style          TYPE lvc_style,
    style2         TYPE lvc_style,
    style3         TYPE lvc_style,
    style4         TYPE lvc_style,
    drdn_hndl      TYPE int4,
    drdn_field     TYPE lvc_fname,
    no_merging     TYPE char01,
    h_ftype        TYPE lvc_ftype,
    col_opt        TYPE lvc_colopt,
    no_init_ch     TYPE char01,
    drdn_alias     TYPE char01,
    decfloat_style TYPE outputstyle,
    parameter0     TYPE char30,
    parameter1     TYPE char30,
    parameter2     TYPE char30,
    parameter3     TYPE char30,
    parameter4     TYPE char30,
    parameter5     TYPE int4,
    parameter6     TYPE int4,
    parameter7     TYPE int4,
    parameter8     TYPE int4,
    parameter9     TYPE int4,
    ref_field      TYPE lvc_rfname,
    ref_table      TYPE lvc_rtname,
    txt_field      TYPE lvc_fname,
    roundfield     TYPE lvc_rndfn,
    decimals_o     TYPE lvc_decmls,
    decmlfield     TYPE lvc_dfname,
    dd_outlen      TYPE lvc_ddlen,
    decimals       TYPE decimals,
    coltext        TYPE lvc_txtcol,
    scrtext_l      TYPE scrtext_l,
    scrtext_m      TYPE scrtext_m,
    scrtext_s      TYPE scrtext_s,
    colddictxt     TYPE lvc_ddict,
    selddictxt     TYPE lvc_ddict,
    tipddictxt     TYPE lvc_ddict,
    crea_edit      TYPE lvc_edit,
    chan_edit      TYPE lvc_edit,
    upld_edit      TYPE lvc_edit,
    tech_col       TYPE lvc_tcol,
    tech_form      TYPE lvc_tform,
    tech_comp      TYPE lvc_tcomp,
    hier_cpos      TYPE lvchcolpos,
    h_col_key      TYPE tv_itmname,
    h_select       TYPE lvc_select,
    dd_roll        TYPE rollname,
    dragdropid     TYPE lvc_ddid,
    mac            TYPE char01,
    indx_field     TYPE int4,
    indx_cfiel     TYPE int4,
    indx_qfiel     TYPE int4,
    indx_ifiel     TYPE int4,
    indx_round     TYPE int4,
    indx_decml     TYPE int4,
    get_style      TYPE char01,
    mark           TYPE char01,
    sr_spos        TYPE slis_spos,
    sr_up          TYPE char1,
    sr_down        TYPE char1,
    sr_group       TYPE slis_ctrls,
    sr_subtot      TYPE slis_dosub,
    sr_comp        TYPE char1,
    sr_expa        TYPE char1,
    sr_seltext     TYPE slis_scrit,
    sr_obligatory  TYPE char1,
    sr_level       TYPE int4,
    sr_no_out      TYPE char1,
    sr_intopt      TYPE lvciflag,
    button         TYPE char1,
    change_evt     TYPE char1,
  END OF ts_balv_fcat .

DATA : go_editor    TYPE REF TO cl_gui_textedit,
       gt_json      TYPE TABLE OF char2000,
       gt_field     TYPE lvc_t_fcat,
       gs_field     TYPE lvc_s_fcat,
       gt_balv_fcat TYPE TABLE OF ts_balv_fcat,
       gs_balv_fcat TYPE ts_balv_fcat,
       gv_json      TYPE string.
*&---------------------------------------------------------------------*
*& SELECTION SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (20) text001.
PARAMETERS : p_repid TYPE sy-repid OBLIGATORY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (20) text002.
PARAMETERS : p_tabnm TYPE dd02l-tabname OBLIGATORY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (20) text003.
PARAMETERS : p_excel TYPE flag AS CHECKBOX.
SELECTION-SCREEN END OF LINE.
*&---------------------------------------------------------------------*
*& INITIALIZATION.
*&---------------------------------------------------------------------*
INITIALIZATION.
  text001 = 'Program ID'.
  text002 = 'Table Name'.
  text003 = 'Use Excel Up/Down'.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION.
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  SELECT COUNT(*)
  FROM dd02l
  WHERE tabname = @p_tabnm.
  IF sy-dbcnt < 1.
    MESSAGE 'Invalid Table Name' TYPE 'E'.
  ENDIF.

  CLEAR: gv_json, gt_json[].
  PERFORM get_fcat_json.
  PERFORM add_prog_info.
  PERFORM json_pretty_print.
*&---------------------------------------------------------------------*
*& END-OF-SELECTION.
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  SPLIT gv_json AT cl_abap_char_utilities=>newline INTO TABLE gt_json.

  CALL FUNCTION 'TERM_CONTROL_EDIT'
    EXPORTING
      titel          = 'Json Format Fieldcatalog'
    TABLES
      textlines      = gt_json
    EXCEPTIONS
      user_cancelled = 1
      OTHERS         = 2.
*&---------------------------------------------------------------------*
*& Form GET_FCAT_JSON
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_fcat_json .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = p_tabnm
      i_client_never_display = abap_true
      i_bypassing_buffer     = abap_true
    CHANGING
      ct_fieldcat            = gt_field
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT gt_field INTO gs_field.
    CLEAR gs_balv_fcat.
    MOVE-CORRESPONDING gs_field TO gs_balv_fcat.

    gs_balv_fcat-zkey = gs_field-key.
    gs_balv_fcat-decimals_o = gs_balv_fcat-decimals.
    IF gs_balv_fcat-tabname EQ '1'.
      CLEAR gs_balv_fcat-tabname.
    ENDIF.
    IF gs_balv_fcat-ref_table EQ 'ICON'.
      CLEAR gs_balv_fcat-ref_table.
    ENDIF.
    IF gs_balv_fcat-fieldname EQ 'MANDT'.
      gs_balv_fcat-col_pos = 999.
    ENDIF.
    APPEND gs_balv_fcat TO gt_balv_fcat.
    CLEAR : gs_balv_fcat, gs_field.
  ENDLOOP.

  SORT gt_balv_fcat BY col_pos.

  gv_json = /ui2/cl_json=>serialize( EXPORTING data = gt_balv_fcat ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form JSON_PRETTY_PRINT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM json_pretty_print .

  "cloud
*  DATA(json_xstring) = cl_abap_conv_codepage=>create_out( )->convert( lv_str ).
  "on_premise
  DATA(json_xstring) = cl_abap_codepage=>convert_to( gv_json ).

  "Check and pretty print JSON

  DATA(reader) = cl_sxml_string_reader=>create( json_xstring ).
  DATA(writer) = CAST if_sxml_writer(
                        cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ) ).
  writer->set_option( option = if_sxml_writer=>co_opt_linebreaks ).
  writer->set_option( option = if_sxml_writer=>co_opt_indent ).
  reader->next_node( ).
  reader->skip_node( writer ).

  "cloud
*  DATA(json_formatted_string) = cl_abap_conv_codepage=>create_in( )->convert( CAST cl_sxml_string_writer( writer )->get_output( ) ).
  "on premise
  DATA(json_formatted_string) = cl_abap_codepage=>convert_from( CAST cl_sxml_string_writer( writer )->get_output( ) ).

  gv_json = escape( val = json_formatted_string format = cl_abap_format=>e_xml_text  ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_PROG_INFO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_prog_info .
  gv_json = `{"PROGNAME":"` && p_repid &&
  `","TABNAME":"` && p_tabnm &&
  `","EXCEL":"` && p_excel
  && `","FIELDCATALOG":` && gv_json && `}`.
ENDFORM.
