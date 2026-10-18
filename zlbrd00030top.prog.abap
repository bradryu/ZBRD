*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD00090TOP
*&---------------------------------------------------------------------*

TABLES : ztbrd00090.

*&---------------------------------------------------------------------*
*&  CONSTANTS
*&---------------------------------------------------------------------*
CONSTANTS: BEGIN OF c_field_balv,
             uname TYPE fieldname VALUE 'UNAME',
             zsort TYPE fieldname VALUE 'ZSORT',
             inc   TYPE fieldname VALUE 'INC',
             ernam TYPE fieldname VALUE 'ERNAM',
             erdat TYPE fieldname VALUE 'ERDAT',
             erzet TYPE fieldname VALUE 'ERZET',
             aenam TYPE fieldname VALUE 'AENAM',
             aedat TYPE fieldname VALUE 'AEDAT',
             aezet TYPE fieldname VALUE 'AEZET',
             mandt TYPE fieldname VALUE 'MANDT',
             zdel  TYPE fieldname VALUE 'ZDEL',
           END OF c_field_balv.
*&---------------------------------------------------------------------*
*&  DATA
*&---------------------------------------------------------------------*
DATA : go_balv           TYPE REF TO zcl_brd_alv_n,
       go_container_balv TYPE REF TO cl_gui_container.
TYPES : BEGIN OF gty_balv,
          balv_status_icon TYPE icon-id,
          uname            TYPE ztbrd00090-uname,
          zsort            TYPE ztbrd00090-zsort,
          inc              TYPE ztbrd00090-inc,
          ernam            TYPE ztbrd00090-ernam,
          erdat            TYPE ztbrd00090-erdat,
          erzet            TYPE ztbrd00090-erzet,
          aenam            TYPE ztbrd00090-aenam,
          aedat            TYPE ztbrd00090-aedat,
          aezet            TYPE ztbrd00090-aezet,
          mandt            TYPE ztbrd00090-mandt,
          zdel             TYPE ztbrd00090-zdel,
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
*&---------------------------------------------------------------------*
*&  SELECTION SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 010 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text009.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (20) text010 MODIF ID dp.
SELECT-OPTIONS so_uname FOR ztbrd00090-uname MODIF ID dp.
SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (20) TEXT011 MODIF ID DP.
*SELECT-OPTIONS SO_ZSORT FOR ZTBRD00090-ZSORT MODIF ID DP.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (20) TEXT012 MODIF ID DP.
*SELECT-OPTIONS SO_INC FOR ZTBRD00090-INC MODIF ID DP.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (20) TEXT013 MODIF ID DP.
*SELECT-OPTIONS SO_ERNAM FOR ZTBRD00090-ERNAM MODIF ID DP.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (20) TEXT014 MODIF ID DP.
*SELECT-OPTIONS SO_ERDAT FOR ZTBRD00090-ERDAT MODIF ID DP.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (20) TEXT015 MODIF ID DP.
*SELECT-OPTIONS SO_ERZET FOR ZTBRD00090-ERZET MODIF ID DP.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (20) TEXT016 MODIF ID DP.
*SELECT-OPTIONS SO_AENAM FOR ZTBRD00090-AENAM MODIF ID DP.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (20) TEXT017 MODIF ID DP.
*SELECT-OPTIONS SO_AEDAT FOR ZTBRD00090-AEDAT MODIF ID DP.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (20) TEXT018 MODIF ID DP.
*SELECT-OPTIONS SO_AEZET FOR ZTBRD00090-AEZET MODIF ID DP.
*SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN END OF SCREEN 010.

SELECTION-SCREEN BEGIN OF SCREEN 020 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (20) text003  MODIF ID up.
PARAMETERS : pa_file LIKE rlgrap-filename VISIBLE LENGTH 35 DEFAULT 'C:\' OBLIGATORY MODIF ID up.
PARAMETER: pa_ucomm LIKE sy-ucomm DEFAULT 'SAMP' NO-DISPLAY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (20) text006 MODIF ID up.
SELECTION-SCREEN PUSHBUTTON (14) pa_samp USER-COMMAND samp MODIF ID up.
SELECTION-SCREEN COMMENT (20) text007 MODIF ID up.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF SCREEN 020.

SELECTION-SCREEN: BEGIN OF TABBED BLOCK go_tab FOR 10 LINES,
                  TAB (20) text001 USER-COMMAND disp,
                  TAB (20) text002 USER-COMMAND upld,
                  END OF BLOCK go_tab.
