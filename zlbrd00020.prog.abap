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
* T_CODE             : ZLBRD00020
* WRITER             : BRAD.RYU
* DATE               : 2016.05.09
* TYPE               : Report
* Description        : ACG (ABAP Code Generator)
*
*************************************************************************
*              Changed History
*&---------------------------------------------------------------------**
*Changed Number     Changed Date   Writer    Changed      Description
*&---------------------------------------------------------------------**
*      N            2016.05.09    BRAD.RYU   CREATE       CREATE       *
*************************************************************************
REPORT zlbrd00020 MESSAGE-ID zbrd001.

INCLUDE znbrd00010.
INCLUDE znbrd00020.
*INCLUDE znbrd00030. "cbo log
INCLUDE zlbrd00020top.
INCLUDE zlbrd00020f00." common
INCLUDE zlbrd00020f01." singe
INCLUDE zlbrd00020f02." double
INCLUDE zlbrd00020f03." multi
INCLUDE zlbrd00020f04." Tree
INCLUDE zlbrd00020f05." Program Generate


*&---------------------------------------------------------------------*
*& INITIALIZATION.
*&---------------------------------------------------------------------*
INITIALIZATION.
  text001 = 'Select Options'.
  text002 = 'Input Options'.
  text003 = 'Mandatory Input'.
  text004 = 'New BALV'.
  text005 = 'Stand Alone'.
  text006 = '2 Step'.
  text007 = '1 Step'.
  text008 = 'Screen Layout'.

  text010 = 'Program ID'.
  text011 = 'Table ID'.
  text012 = 'ALV Key'.
  text013 = 'Fieldcat Key'.
  text014 = 'Single Grid'.
  text015 = 'Double Grid'.
  text016 = 'Multi Grid'.
  text017 = 'Module'.
  text018 = 'Single Table(CRUD)'.
  text019 = 'Join Table(Read Only)'.
  text020 = 'Simple Double'.
  text021 = 'Header-Item'.
  text022 = 'Tree ALV'.
  text023 = 'Tree - Grid Conversion'.
  text024 = 'Tree - Grid Double'.
  text025 = 'Compound'.

  gs_tab_list-prog = sy-repid.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN
*----------------------------------------------------------------------*
AT SELECTION-SCREEN .
  IF sy-ucomm = 'INSTALL'.
    PERFORM install_program.
  ENDIF.
*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN OUTPUT
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN .
    CASE abap_true.
      WHEN pa_r1.
        CASE screen-group1.
          WHEN 'SG'. _set_screen_enable .
          WHEN 'TB'. IF pa_s2 = abap_true. _set_screen_disable. ENDIF.
          WHEN 'S1'. _set_screen_enable .
          WHEN 'S2'. _set_screen_disable .
          WHEN 'S3'. _set_screen_disable .
        ENDCASE.
      WHEN pa_r2.
        CASE screen-group1.
          WHEN 'SG'. _set_screen_disable .
          WHEN 'TB'. _set_screen_disable .
          WHEN 'S1'. _set_screen_disable .
          WHEN 'S2'. _set_screen_enable.
          WHEN 'S3'. _set_screen_disable .
        ENDCASE.
      WHEN pa_r3.
        CASE screen-group1.
          WHEN 'SG'. _set_screen_disable .
          WHEN 'TB'. _set_screen_disable .
          WHEN 'S1'. _set_screen_disable .
          WHEN 'S2'. _set_screen_disable .
          WHEN 'S3'. _set_screen_disable .
        ENDCASE.
      WHEN pa_r4.
        CASE screen-group1.
          WHEN 'SG'. _set_screen_enable .
          WHEN 'TB'. _set_screen_enable .
          WHEN 'S1'. _set_screen_disable .
          WHEN 'S2'. _set_screen_disable .
          WHEN 'S3'. _set_screen_disable .
        ENDCASE.
      WHEN pa_r5.
        CASE abap_true.
          WHEN pa_s5.
            CASE screen-group1.
              WHEN 'SG'. _set_screen_disable.
              WHEN 'TB'. _set_screen_enable.
              WHEN 'S1'. _set_screen_disable.
              WHEN 'S2'. _set_screen_disable.
              WHEN 'S3'. _set_screen_enable .
            ENDCASE.
          WHEN pa_s6.
            CASE screen-group1.
              WHEN 'SG'. _set_screen_disable.
              WHEN 'TB'. _set_screen_disable.
              WHEN 'S1'. _set_screen_disable.
              WHEN 'S2'. _set_screen_disable.
              WHEN 'S3'. _set_screen_enable .
            ENDCASE.
        ENDCASE.
    ENDCASE.
    MODIFY SCREEN .
  ENDLOOP.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION.
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  CLEAR gv_err.
  PERFORM check_input USING gv_err.
  IF gv_err = abap_true.
    EXIT.
  ENDIF.
  PERFORM set_alv_class.
  PERFORM get_data.

  gv_1step = pa_1step.
  gv_multi_flag = pa_r3.

*&---------------------------------------------------------------------*
*& END-OF-SELECTION.
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  CASE abap_true.
    WHEN pa_r1.
      CASE abap_true.
        WHEN pa_s1. CALL SCREEN 9100.
        WHEN pa_s2. CALL SCREEN 9101 STARTING AT 10 5 ENDING AT 62 23.
      ENDCASE.
    WHEN pa_r2. CALL SCREEN 9110 STARTING AT 10 5 ENDING AT 80 20.
    WHEN pa_r3. CALL SCREEN 9120 STARTING AT 10 5 ENDING AT 80 20.
    WHEN pa_r4. CALL SCREEN 9100.
    WHEN pa_r5.
      CASE abap_true.
        WHEN pa_s5. CALL SCREEN 9130 STARTING AT 10 5 ENDING AT 70 15.
        WHEN pa_s6. CALL SCREEN 9140 STARTING AT 10 5 ENDING AT 80 20.
      ENDCASE.
  ENDCASE.
