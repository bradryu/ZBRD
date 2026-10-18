*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
*************************************************************************
* MODULES / SUB MODULE :  / Common
*&---------------------------------------------------------------------
* T_CODE             : ZLBRD00090
* WRITER             : KYUN.RYU
* DATE               : 2023.07.11
* TYPE               : REPORT
* DESCRIPTION        :
*
*************************************************************************
*              CHANGED HISTORY
*&---------------------------------------------------------------------**
*CHANGED  CHANGED DATE   WRITER       CR No.     DESCRIPTION
*&---------------------------------------------------------------------**
*  N      2023.07.11    KYUN.RYU                  CREATE       *
*************************************************************************
REPORT zlbrd00030 NO STANDARD PAGE HEADING.

INCLUDE znbrd00010.
INCLUDE znbrd00020.
INCLUDE zlbrd00030top.
INCLUDE zlbrd00030f01.

*&---------------------------------------------------------------------**
* INITIALIZATION.
*&---------------------------------------------------------------------**
INITIALIZATION.
  PERFORM set_init_value.
*&---------------------------------------------------------------------**
*  AT SELECTION-SCREEN
*&---------------------------------------------------------------------**
AT SELECTION-SCREEN.
  CASE sy-dynnr.
    WHEN 1000.
      CASE sy-ucomm.
        WHEN c_ucomm-display.
          go_tab-dynnr = 010.
          go_tab-activetab = sy-ucomm.
        WHEN c_ucomm-upload.
          go_tab-dynnr = 020.
          go_tab-activetab = sy-ucomm.
      ENDCASE.
      IF sscrfields-ucomm EQ 'SAMP'.
        zcl_brd_alv_n=>get_alv_itab( IMPORTING eo_data = go_download_data
                                             et_header_label = gt_excel_header ).
        ASSIGN go_download_data->* TO <gt_download_tab>.
        PERFORM itab_to_excel_download TABLES <gt_download_tab> gt_excel_header[] USING 'SAMPLE' '' .
      ENDIF.
  ENDCASE.
*&---------------------------------------------------------------------**
* AT SELECTION-SCREEN ON VALUE-REQUEST                                 *
*&---------------------------------------------------------------------**
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_file.
  zcl_brd_alv_n=>add_excel_file_open_dialog( CHANGING cv_file = pa_file ).
*&---------------------------------------------------------------------*
*& START-OF-SELECTION.
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM check_authority.
  CASE go_tab-activetab.
    WHEN c_ucomm-display.
      PERFORM get_balv_data.
    WHEN c_ucomm-upload.
      PERFORM upload_balv_data USING abap_false pa_file.
      IF gv_err = abap_true.
        EXIT.
      ENDIF.
  ENDCASE.
*---------------------------------------------------------------------*
* END-OF-SELECTION.
*---------------------------------------------------------------------*
END-OF-SELECTION.
  IF sy-batch IS INITIAL.
    CALL SCREEN 100.
  ENDIF.
