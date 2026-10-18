*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
* Modules / Sub Module : CM / Z
*&---------------------------------------------------------------------
* T_CODE             : ZLBRD00010
* WRITER             : BRAD.RYU
* DATE               : 2015.12.10
* TYPE               : Online Report
* Description        : BALV Configuration Management
*
*************************************************************************
*              Changed History
*&---------------------------------------------------------------------**
*Changed Number     Changed Date   Writer    Changed      Description
*&---------------------------------------------------------------------**
*      N            2015.12.10    BRAD.RYU   CREATE       CREATE       *
*************************************************************************
REPORT zlbrd00010 NO STANDARD PAGE HEADING.
TABLES : ztbrd00010, ztbrd00020, ztbrd00011, ztbrd00021.

*INCLUDE znbrd00030. "cbo log
INCLUDE zlbrd00010top.
INCLUDE zlbrd00010f01.
INCLUDE zlbrd00010f02.
INCLUDE zlbrd00010f03."install



*&---------------------------------------------------------------------*
*& INITIALIZATION.
*&---------------------------------------------------------------------*
INITIALIZATION.
  text001 = 'ALV'.
  text002 = 'Tree ALV'.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN
*----------------------------------------------------------------------*
AT SELECTION-SCREEN .
  IF sy-ucomm = 'INSTALL'.
    PERFORM install_program.
  ENDIF.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION.
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  CASE abap_true.
    WHEN pa_alv.
      CREATE OBJECT go_alv_balv.
      go_alv_config ?= go_alv_balv.
*      go_alv_config = NEW zcl_cmz_alv_config_balv( ).
    WHEN pa_tree.
      CREATE OBJECT go_alv_balv_tree.
      go_alv_config ?= go_alv_balv_tree.
*      go_alv_config = NEW zcl_cmz_alv_config_tree( ).
  ENDCASE.
  go_alv_config->mr_prog = so_prog[].
  go_alv_config->mr_alv_key = so_alv[].
  go_alv_config->mr_fcat_key = so_fcat[].
  go_alv_config->get_header_data( ).



*&---------------------------------------------------------------------*
*& END-OF-SELECTION.
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  CALL SCREEN 100.
