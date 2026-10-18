*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD00100TOP
*&---------------------------------------------------------------------*

TABLES : ztbrd00100.

*&---------------------------------------------------------------------*
*&  CONSTANTS
*&---------------------------------------------------------------------*
CONSTANTS: BEGIN OF c_field_balv,
             uname   TYPE fieldname VALUE 'UNAME',
             acg_cnt TYPE fieldname VALUE 'ACG_CNT',
             mandt   TYPE fieldname VALUE 'MANDT',
           END OF c_field_balv.
*&---------------------------------------------------------------------*
*&  DATA
*&---------------------------------------------------------------------*
DATA : go_balv           TYPE REF TO zcl_brd_alv_n,
       go_container_balv TYPE REF TO cl_gui_container.
TYPES : BEGIN OF gty_balv,
          balv_status_icon TYPE icon-id,
          uname            TYPE ztbrd00100-uname,
          acg_cnt          TYPE ztbrd00100-acg_cnt,
          mandt            TYPE ztbrd00100-mandt,
        END OF gty_balv.
DATA : BEGIN OF gs_balv.
         .INCLUDE TYPE gty_balv.
         DATA : celltab   TYPE lvc_t_styl,
         coltab    TYPE lvc_t_scol,
         rcolor(4), "c_alv_yellow, blue, green, red
       END OF gs_balv,
       gt_balv      LIKE TABLE OF gs_balv WITH HEADER LINE,
       gt_balv_buff LIKE TABLE OF gs_balv.
FIELD-SYMBOLS <gs_balv> LIKE gs_balv.
DATA : gs_layout_cbo   TYPE ztbrd00010,
       gt_fieldcat_cbo TYPE TABLE OF ztbrd00020.
*&---------------------------------------------------------------------*
*&  SELECTION SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text009.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (20) text010 MODIF ID dp.
SELECT-OPTIONS so_uname FOR ztbrd00100-uname MODIF ID dp.
SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (20) TEXT011 MODIF ID DP.
*SELECT-OPTIONS SO_ACG_C FOR ZTBRD00100-ACG_CNT MODIF ID DP.
*SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b1.
