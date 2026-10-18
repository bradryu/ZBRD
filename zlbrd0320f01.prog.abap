*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD0320F01
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*      MODULE  SET_ALV_SCREEN  OUTPUT
*---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE SET_SCREEN OUTPUT.
  SET PF-STATUS '0100' EXCLUDING GT_EXCLUDE.
  SET TITLEBAR  '0100' WITH TEXT-T00.
ENDMODULE.                 " SET_ALV_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*&      MODULE  SET_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE SET_ALV OUTPUT.
  IF GO_SPLITTER_CONTAINER_OUT IS INITIAL.
    CREATE OBJECT GO_SPLITTER_CONTAINER_OUT
      EXPORTING
        PARENT  = CL_GUI_CONTAINER=>DEFAULT_SCREEN
        ROWS    = 2
        COLUMNS = 1 .
    GO_CONTAINER_TITLE = GO_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
    GO_CONTAINER_BALV = GO_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).
    GO_SPLITTER_CONTAINER_OUT->SET_ROW_HEIGHT( ID = 1 HEIGHT = 20 ).
    CREATE OBJECT GO_DOCUMENT.

    PERFORM SET_TITLE.

    GO_DOCUMENT->DISPLAY_DOCUMENT( PARENT = GO_CONTAINER_TITLE ).
  ENDIF.

  PERFORM SET_ALV_CBO_CONFIG.
  IF GO_BALV IS INITIAL.
    CREATE OBJECT GO_BALV
      EXPORTING
        IO_PARENT = GO_CONTAINER_BALV
        IS_LAYOUT_CBO = GS_LAYOUT_CBO
.

    GO_BALV->DISPLAY( EXPORTING IT_FIELDCAT_CBO = GT_FIELDCAT_CBO
                                CHANGING CT_DATA = GT_BALV[] ).
  ELSE.
    GO_BALV->REFRESH( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      MODULE  EXIT_SCREEN  INPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE EXIT_SCREEN INPUT.
  CASE GV_OKCODE.
    WHEN C_CANC OR C_BACK.
      CASE GO_BALV->GET_ALV_MODE( ).
        WHEN ZCL_BRD_ALV_STD=>MC_DISPLAY_MODE.
          LEAVE TO SCREEN 0.
        WHEN ZCL_BRD_ALV_STD=>MC_UPLOAD_MODE.
          LEAVE TO SCREEN 0.
        WHEN ZCL_BRD_ALV_STD=>MC_CREATE_MODE.
          PERFORM BALV_CANC_CLICK.
        WHEN ZCL_BRD_ALV_STD=>MC_CHANGE_MODE.
          PERFORM BALV_CANC_CLICK.
      ENDCASE.
    WHEN C_EXIT.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR GV_OKCODE.
ENDMODULE.                 " EXIT_SCREEN  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND INPUT.
  CASE GV_OKCODE.
    WHEN C_UCOMM-SAVE.
      PERFORM SAVE_DATA.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      FORM  SET_INIT_VALUE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM SET_INIT_VALUE .
  _INIT : GT_BALV.
  PA_SAMP = text-b01. "'Download'.
  TEXT001 = text-t01. "'Display'.
  TEXT002 = text-t02. "'Upload'.
  TEXT003 = text-t03. "'File Path'.
  TEXT006 = text-t04. "'Sample Excel'.
  TEXT009 = text-t09. "'Select Options'.
  TEXT010 = ''."text-t10
  TEXT011 = ''."text-t11
  TEXT012 = ''."text-t12
*  TEXT013 = ''."text-t13
*  TEXT014 = ''."text-t14
*  TEXT015 = ''."text-t15
*  TEXT016 = ''."text-t16
*  TEXT017 = ''."text-t17
*  TEXT018 = ''."text-t18
*  TEXT019 = ''."text-t19
*  TEXT020 = ''."text-t20
*  TEXT021 = ''."text-t21
*  TEXT022 = ''."text-t22
  GO_TAB-PROG = SY-REPID.
  GO_TAB-DYNNR = 010.
  GO_TAB-ACTIVETAB = C_UCOMM-DISPLAY.

ENDFORM.                    " SET_INIT_VALUE
*&---------------------------------------------------------------------*
*&      FORM  CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM CHECK_AUTHORITY .

ENDFORM.                    " CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*&      FORM  GET_BALV_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM GET_BALV_DATA .
  _INIT : GT_BALV.
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_BALV
    FROM SFLIGHT
    WHERE CARRID IN SO_CARRI
      AND CONNID IN SO_CONNI
      AND FLDATE IN SO_FLDAT
*      AND PRICE IN SO_PRICE
*      AND CURRENCY IN SO_CURRE
*      AND PLANETYPE IN SO_PLANE
*      AND SEATSMAX IN SO_SEATS
*      AND SEATSOCC IN SO_SEA17
*      AND PAYMENTSUM IN SO_PAYME
*      AND SEATSMAX_B IN SO_SEA19
*      AND SEATSOCC_B IN SO_SEA20
*      AND SEATSMAX_F IN SO_SEA21
*      AND SEATSOCC_F IN SO_SEA22
.
ENDFORM.                    "GET_BALV_DATA
*&---------------------------------------------------------------------*
*&      FORM  UPLOAD_BALV_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM UPLOAD_BALV_DATA USING PV_FILE_DIALOG PV_FILE_NAME.
  DATA LT_TAB TYPE TABLE OF GTY_BALV.
  DATA LS_TAB TYPE GTY_BALV.
  CLEAR GV_ERR.
  CALL METHOD ZCL_BRD_ALV_STD=>EXCEL_UPLOAD
    EXPORTING
      IV_FILE_DIALOG = PV_FILE_DIALOG
      IV_FILE_NAME   = PV_FILE_NAME
    CHANGING
      CT_DATA        = LT_TAB[]
    RECEIVING
      EV_SUBRC       = GV_SUBRC.
  IF GV_SUBRC EQ 0.
    LOOP AT LT_TAB INTO LS_TAB.
      MOVE-CORRESPONDING LS_TAB TO GT_BALV.
      APPEND GT_BALV.
      CLEAR : LS_TAB, GT_BALV.
    ENDLOOP.
    GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
  ELSE.
    MESSAGE 'No File Selected' TYPE 'S' DISPLAY LIKE C_E.
    GV_ERR = ABAP_TRUE.
  ENDIF.

ENDFORM.                    " UPLOAD_DATA
*&---------------------------------------------------------------------*
*&      FORM  SET_TITLE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM SET_TITLE .
  DATA : LO_TAB  TYPE REF TO CL_DD_TABLE_ELEMENT,
         LO_COL1 TYPE REF TO CL_DD_AREA,
         LO_COL2 TYPE REF TO CL_DD_AREA,
         LV_TEXT TYPE SDYDO_TEXT_ELEMENT.

  LV_TEXT = TEXT009.
  GO_DOCUMENT->ADD_TEXT( EXPORTING TEXT = LV_TEXT
                                   SAP_EMPHASIS = CL_DD_AREA=>STRONG
                                   SAP_FONTSIZE = CL_DD_AREA=>LARGE ).
  GO_DOCUMENT->NEW_LINE( ).
  GO_DOCUMENT->NEW_LINE( ).

  GO_DOCUMENT->ADD_TABLE( EXPORTING NO_OF_COLUMNS = 2
                                    BORDER        = '0'
                                    WIDTH = '100%'
                          IMPORTING TABLE         = LO_TAB ).

  LO_TAB->ADD_COLUMN( EXPORTING WIDTH  = '10%'
                      IMPORTING COLUMN = LO_COL1 ).
  LO_TAB->ADD_COLUMN( EXPORTING WIDTH  = '90%'
                      IMPORTING COLUMN = LO_COL2 ).
  IF SO_CARRI-LOW IS NOT INITIAL.
    LV_TEXT = TEXT010.
    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
    LV_TEXT = SO_CARRI-LOW.
    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
    LO_TAB->NEW_ROW( ).
  ENDIF.
  IF SO_CONNI-LOW IS NOT INITIAL.
    LV_TEXT = TEXT011.
    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
    LV_TEXT = SO_CONNI-LOW.
    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
    LO_TAB->NEW_ROW( ).
  ENDIF.
  IF SO_FLDAT-LOW IS NOT INITIAL.
    LV_TEXT = TEXT012.
    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
    LV_TEXT = SO_FLDAT-LOW.
    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
    LO_TAB->NEW_ROW( ).
  ENDIF.
*  IF *SO_PRICE-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT013.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_PRICE-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_CURRE-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT014.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_CURRE-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_PLANE-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT015.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_PLANE-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_SEATS-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT016.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_SEATS-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_SEA17-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT017.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_SEA17-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_PAYME-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT018.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_PAYME-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_SEA19-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT019.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_SEA19-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_SEA20-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT020.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_SEA20-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_SEA21-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT021.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_SEA21-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_SEA22-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT022.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_SEA22-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.

  GO_DOCUMENT->MERGE_DOCUMENT( ).
ENDFORM.                    " SET_TITLE
*&---------------------------------------------------------------------*
*&      FORM  BALV_CREATE_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_CREA_CLICK.
  CLEAR GS_BALV.
  GS_BALV-BALV_STATUS_ICON = ICON_CREATE.
  GO_BALV->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_CREATE_MODE
                              CHANGING CT_CELLTAB = GS_BALV-CELLTAB ).
  _set_timestamp_create GS_BALV.
  APPEND GS_BALV TO GT_BALV.
  GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
  GO_BALV->REFRESH( ).
ENDFORM.                    "BALV_CREATE_CLICK

*&---------------------------------------------------------------------*
*&      FORM  BALV_CHAN_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_CHAN_CLICK.
  GT_BALV_BUFF[] = GT_BALV[].
  GO_BALV->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_CHANGE_MODE
                            CHANGING CT_CELLTAB = GT_CELLTAB ).
  LOOP AT GT_BALV ASSIGNING FIELD-SYMBOL(<LS_BALV>).
    <LS_BALV>-CELLTAB = GT_CELLTAB.
  ENDLOOP.

  GO_BALV->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_CHANGE_MODE
                    CHANGING CT_DATA  = GT_BALV[] ).
ENDFORM.                    "BALV_CHAN_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  BALV_CANC_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_CANC_CLICK.

  IF GO_BALV->IS_CHANGING( ) EQ ABAP_TRUE
    AND GO_BALV->CONFIRM_CANCEL( ) NE ABAP_TRUE.
    EXIT.
  ENDIF.

  CLEAR : GT_BALV, GT_BALV[].
  GT_BALV[] = GT_BALV_BUFF[].
  CLEAR GT_BALV_BUFF[].
  GO_BALV->SET_CHANGING_FLAG( ABAP_FALSE ).

  GO_BALV->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_DISPLAY_MODE
                   CHANGING CT_DATA  = GT_BALV[] ).
ENDFORM.                    "BALV_CANC_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  BALV_RFSH_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_RFSH_CLICK.
ENDFORM.                    "RFSH_CLICK
*&---------------------------------------------------------------------*
*&      FORM  BALV_INST_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_INST_CLICK.
  CLEAR : GT_ROWS, GT_ROW_IDS.
  GO_BALV->GET_SELECTED_ROWS( IMPORTING ET_INDEX_ROWS = GT_ROWS
                                        ET_ROW_NO = GT_ROW_IDS ).
  IF LINES( GT_ROWS ) > 0.
    SORT GT_ROWS BY INDEX.
    GV_INDEX = GT_ROWS[ 1 ]-INDEX.
    SORT GT_ROWS BY INDEX DESCENDING.
    CLEAR GT_CELLTAB.
    GO_BALV->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_CREATE_MODE
                                CHANGING CT_CELLTAB = GT_CELLTAB ).
    LOOP AT GT_ROWS INTO GS_ROWS.
      CLEAR GS_BALV.
      GS_BALV-BALV_STATUS_ICON = ICON_CREATE.
      GS_BALV-CELLTAB = GT_CELLTAB.
      _set_timestamp_create GS_BALV.
      INSERT GS_BALV INTO GT_BALV INDEX GV_INDEX.
    ENDLOOP.
    GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
    GO_BALV->REFRESH( ).
  ELSE.
    ZCL_BRD_ALV_STD=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_STD=>MC_MSG-NO_ROW_SELECT ).
  ENDIF.

ENDFORM.                    "BALV_INST_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  BALV_UPLD_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_UPLD_CLICK.
  GT_BALV_BUFF[] = GT_BALV[].
  _INIT GT_BALV.
  PERFORM UPLOAD_BALV_DATA USING ABAP_TRUE ''.
  IF GV_ERR = ABAP_TRUE.
    EXIT.
  ENDIF.
  GO_BALV->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_UPLOAD_MODE
                     CHANGING CT_DATA  = GT_BALV[] ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  BALV_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_DOUBLE_CLICK USING PS_ROW TYPE LVC_S_ROW
                                PS_COLUMN TYPE LVC_S_COL
                                PS_ROW_NO TYPE LVC_S_ROID.
  CLEAR GT_BALV.
  READ TABLE GT_BALV INDEX PS_ROW_NO-ROW_ID.
  IF SY-SUBRC EQ 0.
    CLEAR GT_ROWS.
    APPEND PS_ROW TO GT_ROWS.
    GO_BALV->SET_SELECTED_ROWS( EXPORTING IT_INDEX_ROWS = GT_ROWS ).
  ENDIF.
  MESSAGE 'DOUBLE CLICK TRIGGERED' TYPE 'I'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  BALV_VERIFY_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_VERIFY_DATA USING PV_TABIX TYPE SY-TABIX
                                      PS_DATA LIKE GS_BALV.
    IF GS_BALV-CARRID IS INITIAL
       OR GS_BALV-CONNID IS INITIAL
       OR GS_BALV-FLDATE IS INITIAL
.
      APPEND VALUE #( ICON = ICON_DEFECT
                      ROW_NO = PV_TABIX
                      MSG = GO_BALV->MESSAGE( EXPORTING IV_CODE = ZCL_BRD_ALV_STD=>MC_MSG-INPUT_MANDATORY ) ) TO GT_LOG.
    ENDIF.
ENDFORM.                    " BALV_VERIFY_DATA
*&---------------------------------------------------------------------*
*&      FORM  BALV_DELE_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_DELE_CLICK.
  DATA LT_TAB TYPE TABLE OF SFLIGHT WITH HEADER LINE.
  _INIT GT_ROWS.
  GO_BALV->GET_SELECTED_ROWS(
   IMPORTING
     ET_INDEX_ROWS = GT_ROWS
     ET_ROW_NO     = GT_ROW_IDS ).

  IF LINES( GT_ROWS ) > 0.
    SORT GT_ROWS BY INDEX DESCENDING.
    LOOP AT GT_ROWS INTO GS_ROWS.
      IF GT_BALV[ GS_ROWS-INDEX ]-BALV_STATUS_ICON = ICON_CREATE.
        DELETE GT_BALV INDEX GS_ROWS-INDEX.
      ELSE.
        GT_BALV[ GS_ROWS-INDEX ]-BALV_STATUS_ICON = ICON_DELETE.
      ENDIF.
    ENDLOOP.
    GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
    GO_BALV->REFRESH( ).
  ELSE.
    ZCL_BRD_ALV_STD=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_STD=>MC_MSG-NO_ROW_SELECT ).
  ENDIF.

ENDFORM.                    "BALV_DELE_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  BALV_DATA_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->PO_OBJECT     TEXT
*      -->PV_ONF4  TEXT
*      -->PV_ONF4_BEFORE  TEXT
*      -->PV_ONF4_AFTER  TEXT
*      -->PV_UCOMM  TEXT
*----------------------------------------------------------------------*
FORM BALV_DATA_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                        PV_ONF4
                        PV_ONF4_BEFORE
                        PV_ONF4_AFTER
                        PV_UCOMM.
  DATA LT_MOD_CELLS TYPE LVC_T_MODI WITH HEADER LINE.
  LT_MOD_CELLS[] = PO_OBJECT->MT_GOOD_CELLS.
  LOOP AT LT_MOD_CELLS ASSIGNING FIELD-SYMBOL(<LS_MOD_CELLS>).
    AT NEW ROW_ID.
      READ TABLE GT_BALV INDEX <LS_MOD_CELLS>-ROW_ID.
    ENDAT.
    ASSIGN COMPONENT <LS_MOD_CELLS>-FIELDNAME OF STRUCTURE GT_BALV TO <GV_FIELD>.
    <GV_FIELD> = LT_MOD_CELLS-VALUE.
    AT END OF ROW_ID.
      READ TABLE GT_BALV ASSIGNING FIELD-SYMBOL(<LS_BALV>) INDEX <LS_MOD_CELLS>-ROW_ID.
      IF SY-SUBRC EQ 0." modify
        IF <LS_BALV>-BALV_STATUS_ICON NE ICON_CREATE.
          <LS_BALV>-BALV_STATUS_ICON = ICON_CHANGE.
        ENDIF.
        _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-BALV_STATUS_ICON <LS_BALV>-BALV_STATUS_ICON.
      ELSE."auto added new row
        _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-BALV_STATUS_ICON ICON_CREATE.
        CLEAR GS_BALV-CELLTAB.
        GO_BALV->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_CREATE_MODE
                                    CHANGING CT_CELLTAB = GS_BALV-CELLTAB ).
        LOOP AT GS_BALV-CELLTAB ASSIGNING FIELD-SYMBOL(<LS_CELLTAB>).
          PO_OBJECT->MODIFY_STYLE( EXPORTING I_ROW_ID    = <LS_MOD_CELLS>-ROW_ID
                                             I_FIELDNAME = <LS_CELLTAB>-FIELDNAME
                                             I_STYLE     = <LS_CELLTAB>-STYLE ).
        ENDLOOP.
        APPEND GS_BALV TO GT_BALV.
      ENDIF.
      READ TABLE GT_BALV TRANSPORTING NO FIELDS INDEX <LS_MOD_CELLS>-ROW_ID.
      IF SY-SUBRC EQ 0.
        MODIFY GT_BALV INDEX <LS_MOD_CELLS>-ROW_ID.
      ELSE.
        APPEND GT_BALV.
      ENDIF.
    ENDAT.
  ENDLOOP.
  GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
ENDFORM.                    "BALV_DATA_CHANGED
*&---------------------------------------------------------------------*
*&      FORM  BALV_CARRID_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_CARRID_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                   PV_ROW_ID
                                   PV_VALUE TYPE ANY.
  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
  CLEAR GT_BALV.
  READ TABLE GT_BALV INDEX PV_ROW_ID.
  IF SY-SUBRC EQ 0.
    GT_BALV-CARRID = PV_VALUE.
    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-CARRID PV_VALUE.
    PERFORM BALV_CHECK_PK.
    IF GV_ERR EQ C_E.
      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
    ELSE.
      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
    ENDIF.
    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
    MODIFY GT_BALV INDEX PV_ROW_ID.
  ENDIF.
ENDFORM.                    "BALV_CARRID_CHANGED.
*&---------------------------------------------------------------------*
*&      FORM  BALV_CONNID_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_CONNID_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                   PV_ROW_ID
                                   PV_VALUE TYPE ANY.
  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
  CLEAR GT_BALV.
  READ TABLE GT_BALV INDEX PV_ROW_ID.
  IF SY-SUBRC EQ 0.
    GT_BALV-CONNID = PV_VALUE.
    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-CONNID PV_VALUE.
    PERFORM BALV_CHECK_PK.
    IF GV_ERR EQ C_E.
      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
    ELSE.
      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
    ENDIF.
    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
    MODIFY GT_BALV INDEX PV_ROW_ID.
  ENDIF.
ENDFORM.                    "BALV_CONNID_CHANGED.
*&---------------------------------------------------------------------*
*&      FORM  BALV_FLDATE_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_FLDATE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                   PV_ROW_ID
                                   PV_VALUE TYPE ANY.
  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
  CLEAR GT_BALV.
  READ TABLE GT_BALV INDEX PV_ROW_ID.
  IF SY-SUBRC EQ 0.
    GT_BALV-FLDATE = PV_VALUE.
    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-FLDATE PV_VALUE.
    PERFORM BALV_CHECK_PK.
    IF GV_ERR EQ C_E.
      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
    ELSE.
      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
    ENDIF.
    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
    MODIFY GT_BALV INDEX PV_ROW_ID.
  ENDIF.
ENDFORM.                    "BALV_FLDATE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_PRICE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_PRICE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-PRICE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-PRICE PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_PRICE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_CURRENCY_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_CURRENCY_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-CURRENCY = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-CURRENCY PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_CURRENCY_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_PLANETYPE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_PLANETYPE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-PLANETYPE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-PLANETYPE PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_PLANETYPE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_SEATSMAX_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_SEATSMAX_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-SEATSMAX = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSMAX PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_SEATSMAX_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_SEATSOCC_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_SEATSOCC_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-SEATSOCC = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSOCC PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_SEATSOCC_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_PAYMENTSUM_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_PAYMENTSUM_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-PAYMENTSUM = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-PAYMENTSUM PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_PAYMENTSUM_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_SEATSMAX_B_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_SEATSMAX_B_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-SEATSMAX_B = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSMAX_B PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_SEATSMAX_B_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_SEATSOCC_B_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_SEATSOCC_B_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-SEATSOCC_B = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSOCC_B PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_SEATSOCC_B_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_SEATSMAX_F_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_SEATSMAX_F_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-SEATSMAX_F = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSMAX_F PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_SEATSMAX_F_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_SEATSOCC_F_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_SEATSOCC_F_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-SEATSOCC_F = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSOCC_F PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_SEATSOCC_F_CHANGED.
*&---------------------------------------------------------------------*
*&      FORM  BALV_CHECK_PK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM BALV_CHECK_PK .
  CLEAR : GV_ERR, GV_COUNT.

  SELECT COUNT(*) INTO GV_COUNT
    FROM SFLIGHT
  WHERE CARRID = GT_BALV-CARRID
    AND CONNID = GT_BALV-CONNID
    AND FLDATE = GT_BALV-FLDATE
.

  IF GV_COUNT GT 0.
    GV_ERR = C_E.
  ENDIF.
ENDFORM.                    " CHECK_PK
**&---------------------------------------------------------------------*
**&      FORM  BALV_SET_TOOLBAR
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
**      -->PV_INTERACTIVE     TEXT
**      -->PO_OBJECT  TEXT
**----------------------------------------------------------------------*
*FORM BALV_SET_TOOLBAR USING PV_INTERACTIVE
*                       PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET.
*  IF go_BALV->get_alv_mode( ) NE ZCL_BRD_ALV_STD=>mc_display_mode .
*    GO_BALV->APPEND_TOOLBAR_BUTTON( EXPORTING
*                                   IV_FUNCTION = 'F01'
*                                   IV_ICON = '' "ICON-ID
*                                   IV_QUICKINFO = ''
*                                   IV_TEXT = 'MY TOOLBAR'
*                                   ).
*  ENDIF.
*ENDFORM.                    "BALV_SET_TOOLBAR
*&---------------------------------------------------------------------*
*&      FORM  SAVE_DATA.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM SAVE_DATA.
  DATA:
        LS_BALV        TYPE SFLIGHT,
        LT_CREATE_BALV TYPE TABLE OF SFLIGHT,
        LT_UPDATE_BALV TYPE TABLE OF SFLIGHT,
        LT_DELETE_BALV TYPE TABLE OF SFLIGHT.
  DATA:
        LV_CREATE_CNT  TYPE SY-DBCNT,
        LV_UPDATE_CNT  TYPE SY-DBCNT,
        LV_DELETE_CNT  TYPE SY-DBCNT.

  CLEAR GT_LOG[].
  CLEAR GS_BALV.
  LOOP AT GT_BALV INTO GS_BALV.
    CLEAR LS_BALV.
    IF GS_BALV-BALV_STATUS_ICON IS NOT INITIAL.
      PERFORM BALV_VERIFY_DATA USING SY-TABIX GS_BALV.
      MOVE-CORRESPONDING GS_BALV TO LS_BALV.
    ENDIF.
    CASE GS_BALV-BALV_STATUS_ICON.
      WHEN ICON_CREATE.
        _set_timestamp_create ls_BALV.
        APPEND LS_BALV TO LT_CREATE_BALV.
      WHEN ICON_CHANGE.
        _set_timestamp_change ls_BALV.
        APPEND LS_BALV TO LT_UPDATE_BALV.
      WHEN ICON_DELETE.
        APPEND LS_BALV TO LT_DELETE_BALV.
    ENDCASE.
    CLEAR GS_BALV.
  ENDLOOP.


  IF GT_LOG[] IS NOT INITIAL.
     ZCL_BRD_ALV_STD=>MESSAGE_POPUP( CHANGING CT_MSG = GT_LOG[] ).
    EXIT.
  ENDIF.

  IF ZCL_BRD_ALV_STD=>CONFIRM_SAVE( ) NE ABAP_TRUE.
    EXIT.
  ENDIF.

  TRY.
      IF LT_CREATE_BALV IS NOT INITIAL.
        INSERT SFLIGHT FROM TABLE LT_CREATE_BALV.
        LV_CREATE_CNT = LV_CREATE_CNT + LINES( LT_CREATE_BALV ).
      ENDIF.
      IF LT_UPDATE_BALV IS NOT INITIAL.
        MODIFY SFLIGHT FROM TABLE LT_UPDATE_BALV.
        LV_UPDATE_CNT = LV_UPDATE_CNT + LINES( LT_UPDATE_BALV ).
      ENDIF.
      IF LT_DELETE_BALV IS NOT INITIAL.
        DELETE SFLIGHT FROM TABLE LT_DELETE_BALV.
        LV_DELETE_CNT = LV_DELETE_CNT + LINES( LT_DELETE_BALV ).
      ENDIF.
    CATCH CX_ROOT INTO GO_EXCEPTION.
      ZCL_BRD_ALV_STD=>CATCH_EXCEPTION( IO_ROOT = GO_EXCEPTION ).
  ENDTRY.
  ZCL_BRD_ALV_STD=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_STD=>MC_MSG-SAVE_SUCCESS
                                    IV_PARAM1 = |{ LV_CREATE_CNT }|
                                    IV_PARAM2 = |{ LV_UPDATE_CNT }|
                                    IV_PARAM3 = |{ LV_DELETE_CNT }| ).

  CLEAR GT_BALV_BUFF[].
  GO_BALV->SET_CHANGING_FLAG( ABAP_FALSE ).
  DELETE GT_BALV WHERE BALV_STATUS_ICON = ICON_DELETE.
  LOOP AT GT_BALV ASSIGNING <GS_BALV>.
    IF <GS_BALV>-BALV_STATUS_ICON IS NOT INITIAL.
      CLEAR <GS_BALV>-BALV_STATUS_ICON.
    ENDIF.
  ENDLOOP.
  GO_BALV->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_DISPLAY_MODE
                    CHANGING CT_DATA  = GT_BALV[] ).
ENDFORM.                    "SAVE_DATA
*&---------------------------------------------------------------------*
*& Form SET_ALV_CBO_CONFIG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_CBO_CONFIG .
  DATA LS_FCAT_CBO TYPE ZCL_BRD_ALV_STD=>TS_FCAT_CONFIG.
  CLEAR GT_FIELDCAT_CBO[].

CLEAR GS_LAYOUT_CBO.
GS_LAYOUT_CBO-PROGID = 'ZLBRD0320'.
GS_LAYOUT_CBO-ALV_KEY = 'BALV'.
GS_LAYOUT_CBO-ZCREATE = 'X'.
GS_LAYOUT_CBO-ZUPDATE = 'X'.
GS_LAYOUT_CBO-ZDELETE = 'X'.
GS_LAYOUT_CBO-ZEXCEL = 'X'.
GS_LAYOUT_CBO-ZREFRESH = 'X'.
GS_LAYOUT_CBO-DB_CLICK = 'X'.
GS_LAYOUT_CBO-CHANGE_EVT = 'X'.
GS_LAYOUT_CBO-ZEBRA = 'X'.
GS_LAYOUT_CBO-SEL_MODE = 'D'.
GS_LAYOUT_CBO-CTAB_FNAME = 'COLTAB'.
GS_LAYOUT_CBO-INFO_FNAME = 'RCOLOR'.
GS_LAYOUT_CBO-STYLEFNAME = 'CELLTAB'.
GS_LAYOUT_CBO-GRID_TITLE = ''.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '3'.
LS_FCAT_CBO-FIELDNAME = 'BALV_STATUS_ICON'.
LS_FCAT_CBO-ZKEY = 'X'.
LS_FCAT_CBO-ICON = 'X'.
LS_FCAT_CBO-OUTPUTLEN = '000004'.
LS_FCAT_CBO-JUST = 'C'.
LS_FCAT_CBO-EMPHASIZE = 'K41'.
LS_FCAT_CBO-DATATYPE = 'CHAR'.
LS_FCAT_CBO-INTTYPE = 'C'.
LS_FCAT_CBO-INTLEN = '000004'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '3'.
LS_FCAT_CBO-FIELDNAME = 'CARRID'.
LS_FCAT_CBO-ZKEY = 'X'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'C'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'CARRID'.
LS_FCAT_CBO-DATATYPE = 'CHAR'.
LS_FCAT_CBO-INTTYPE = 'C'.
LS_FCAT_CBO-INTLEN = '000003'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '4'.
LS_FCAT_CBO-FIELDNAME = 'CONNID'.
LS_FCAT_CBO-ZKEY = 'X'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'CONNID'.
LS_FCAT_CBO-DATATYPE = 'NUMC'.
LS_FCAT_CBO-INTTYPE = 'N'.
LS_FCAT_CBO-INTLEN = '000004'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '5'.
LS_FCAT_CBO-FIELDNAME = 'FLDATE'.
LS_FCAT_CBO-ZKEY = 'X'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'C'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'FLDATE'.
LS_FCAT_CBO-DATATYPE = 'DATS'.
LS_FCAT_CBO-INTTYPE = 'D'.
LS_FCAT_CBO-INTLEN = '000008'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '6'.
LS_FCAT_CBO-FIELDNAME = 'PRICE'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-CHAN_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'PRICE'.
LS_FCAT_CBO-DATATYPE = 'CURR'.
LS_FCAT_CBO-INTTYPE = 'P'.
LS_FCAT_CBO-INTLEN = '000015'.
LS_FCAT_CBO-CFIELDNAME = 'CURRENCY'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '7'.
LS_FCAT_CBO-FIELDNAME = 'CURRENCY'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'C'.
LS_FCAT_CBO-EMPHASIZE = '$'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-CHAN_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'CURRENCY'.
LS_FCAT_CBO-DATATYPE = 'CUKY'.
LS_FCAT_CBO-INTTYPE = 'C'.
LS_FCAT_CBO-INTLEN = '000005'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '8'.
LS_FCAT_CBO-FIELDNAME = 'PLANETYPE'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'C'.
LS_FCAT_CBO-EMPHASIZE = '$'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-CHAN_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'PLANETYPE'.
LS_FCAT_CBO-DATATYPE = 'CHAR'.
LS_FCAT_CBO-INTTYPE = 'C'.
LS_FCAT_CBO-INTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '9'.
LS_FCAT_CBO-FIELDNAME = 'SEATSMAX'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-CHAN_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'SEATSMAX'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '10'.
LS_FCAT_CBO-FIELDNAME = 'SEATSOCC'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-CHAN_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'SEATSOCC'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '11'.
LS_FCAT_CBO-FIELDNAME = 'PAYMENTSUM'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-CHAN_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'PAYMENTSUM'.
LS_FCAT_CBO-DATATYPE = 'CURR'.
LS_FCAT_CBO-INTTYPE = 'P'.
LS_FCAT_CBO-INTLEN = '000017'.
LS_FCAT_CBO-CFIELDNAME = 'CURRENCY'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '12'.
LS_FCAT_CBO-FIELDNAME = 'SEATSMAX_B'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-CHAN_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'SEATSMAX_B'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '13'.
LS_FCAT_CBO-FIELDNAME = 'SEATSOCC_B'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-CHAN_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'SEATSOCC_B'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '14'.
LS_FCAT_CBO-FIELDNAME = 'SEATSMAX_F'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-CHAN_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'SEATSMAX_F'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD0320'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '15'.
LS_FCAT_CBO-FIELDNAME = 'SEATSOCC_F'.
LS_FCAT_CBO-REPTEXT = ''.
LS_FCAT_CBO-SCRTEXT_S = ''.
LS_FCAT_CBO-SCRTEXT_M = ''.
LS_FCAT_CBO-SCRTEXT_L = ''.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = 'X'.
LS_FCAT_CBO-CHAN_EDIT = 'X'.
LS_FCAT_CBO-UPLD_EDIT = 'X'.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-REF_FIELD = 'SEATSOCC_F'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
ENDFORM.
