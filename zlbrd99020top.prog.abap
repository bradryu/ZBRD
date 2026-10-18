*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD99020TOP
*&---------------------------------------------------------------------*

TABLES : SCARR, SFLIGHT.
*&---------------------------------------------------------------------*
*&  CONSTANTS
*&---------------------------------------------------------------------*
CONSTANTS: BEGIN OF C_FIELD_HEAD,
             CARRID     TYPE FIELDNAME VALUE 'CARRID',
             CARRNAME     TYPE FIELDNAME VALUE 'CARRNAME',
             CURRCODE     TYPE FIELDNAME VALUE 'CURRCODE',
             URL     TYPE FIELDNAME VALUE 'URL',
             MANDT     TYPE FIELDNAME VALUE 'MANDT',
           END OF C_FIELD_HEAD.
*&---------------------------------------------------------------------*
*&  DATA
*&---------------------------------------------------------------------*
DATA : GO_HEAD   TYPE REF TO ZCL_BRD_ALV_N,
       GO_CONTAINER_HEAD TYPE REF TO CL_GUI_CONTAINER.
*&---------------------------------------------------------------------*
*&  CONSTANTS
*&---------------------------------------------------------------------*
CONSTANTS: BEGIN OF C_FIELD_ITEM,
             CARRID     TYPE FIELDNAME VALUE 'CARRID',
             CONNID     TYPE FIELDNAME VALUE 'CONNID',
             FLDATE     TYPE FIELDNAME VALUE 'FLDATE',
             PRICE     TYPE FIELDNAME VALUE 'PRICE',
             CURRENCY     TYPE FIELDNAME VALUE 'CURRENCY',
             PLANETYPE     TYPE FIELDNAME VALUE 'PLANETYPE',
             SEATSMAX     TYPE FIELDNAME VALUE 'SEATSMAX',
             SEATSOCC     TYPE FIELDNAME VALUE 'SEATSOCC',
             PAYMENTSUM     TYPE FIELDNAME VALUE 'PAYMENTSUM',
             SEATSMAX_B     TYPE FIELDNAME VALUE 'SEATSMAX_B',
             SEATSOCC_B     TYPE FIELDNAME VALUE 'SEATSOCC_B',
             SEATSMAX_F     TYPE FIELDNAME VALUE 'SEATSMAX_F',
             SEATSOCC_F     TYPE FIELDNAME VALUE 'SEATSOCC_F',
             MANDT     TYPE FIELDNAME VALUE 'MANDT',
           END OF C_FIELD_ITEM.
*&---------------------------------------------------------------------*
*&  DATA
*&---------------------------------------------------------------------*
DATA : GO_ITEM   TYPE REF TO ZCL_BRD_ALV_N,
       GO_CONTAINER_ITEM TYPE REF TO CL_GUI_CONTAINER.
TYPES : BEGIN OF TS_HEAD,
          BALV_STATUS_ICON TYPE ICON-ID,
       CARRID TYPE SCARR-CARRID,
       CARRNAME TYPE SCARR-CARRNAME,
       CURRCODE TYPE SCARR-CURRCODE,
       URL TYPE SCARR-URL,
       MANDT TYPE SCARR-MANDT,
        END OF TS_HEAD.
DATA : BEGIN OF GS_HEAD.
        .INCLUDE TYPE TS_HEAD.
        DATA : CELLTAB TYPE LVC_T_STYL,
        COLTAB TYPE LVC_T_SCOL,
        RCOLOR(4), "c_alv_yellow, blue, green, red
      END OF GS_HEAD,
      GT_HEAD      LIKE TABLE OF GS_HEAD WITH HEADER LINE,
      GT_HEAD_BUFF LIKE TABLE OF GS_HEAD.
FIELD-SYMBOLS <GS_HEAD> LIKE GS_HEAD.
TYPES : BEGIN OF TS_ITEM,
          BALV_STATUS_ICON TYPE ICON-ID,
       CARRID TYPE SFLIGHT-CARRID,
       CONNID TYPE SFLIGHT-CONNID,
       FLDATE TYPE SFLIGHT-FLDATE,
       PRICE TYPE SFLIGHT-PRICE,
       CURRENCY TYPE SFLIGHT-CURRENCY,
       PLANETYPE TYPE SFLIGHT-PLANETYPE,
       SEATSMAX TYPE SFLIGHT-SEATSMAX,
       SEATSOCC TYPE SFLIGHT-SEATSOCC,
       PAYMENTSUM TYPE SFLIGHT-PAYMENTSUM,
       SEATSMAX_B TYPE SFLIGHT-SEATSMAX_B,
       SEATSOCC_B TYPE SFLIGHT-SEATSOCC_B,
       SEATSMAX_F TYPE SFLIGHT-SEATSMAX_F,
       SEATSOCC_F TYPE SFLIGHT-SEATSOCC_F,
       MANDT TYPE SFLIGHT-MANDT,
        END OF TS_ITEM.
DATA : BEGIN OF GS_ITEM.
        .INCLUDE TYPE TS_ITEM.
        DATA : CELLTAB TYPE LVC_T_STYL,
        COLTAB TYPE LVC_T_SCOL,
        RCOLOR(4), "c_alv_yellow, blue, green, red
      END OF GS_ITEM,
      GT_ITEM      LIKE TABLE OF GS_ITEM WITH HEADER LINE,
      GT_ITEM_BUFF LIKE TABLE OF GS_ITEM.
FIELD-SYMBOLS <GS_ITEM> LIKE GS_ITEM.
*&---------------------------------------------------------------------*
*&  SELECTION SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT009  .
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (20) TEXT010.
SELECT-OPTIONS S_CARRI FOR SCARR-CARRID.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B1 .
