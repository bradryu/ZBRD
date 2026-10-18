*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD03020F01
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
*        WHEN ZCL_BRD_ALV_STD=>MC_UPLOAD_MODE.
*          LEAVE TO SCREEN 0.
*        WHEN ZCL_BRD_ALV_STD=>MC_CREATE_MODE.
*          PERFORM BALV_CANC_CLICK.
*        WHEN ZCL_BRD_ALV_STD=>MC_CHANGE_MODE.
*          PERFORM BALV_CANC_CLICK.
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
*    WHEN C_UCOMM-SAVE.
*      PERFORM SAVE_DATA.
  ENDCASE.
  CLEAR GV_OKCODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      FORM  SET_INIT_VALUE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM SET_INIT_VALUE .
  _INIT : GT_BALV.
  TEXT009 = text-t09. "'Select Options'.
  TEXT010 = 'ID'."text-t10
  TEXT011 = 'No.'."text-t11
  TEXT012 = 'Date'."text-t12
*  TEXT013 = 'Airfare'."text-t13
*  TEXT014 = 'Curr.'."text-t14
*  TEXT015 = 'Plane'."text-t15
*  TEXT016 = 'Capacity in economy class'."text-t16
*  TEXT017 = 'Occupied economy class'."text-t17
*  TEXT018 = 'Booking total'."text-t18
*  TEXT019 = 'Capacity business class'."text-t19
*  TEXT020 = 'Occupied business class'."text-t20
*  TEXT021 = 'Capacity in first class'."text-t21
*  TEXT022 = 'Occupied in first class'."text-t22

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
    WHERE CARRID IN S_CARRI
      AND CONNID IN S_CONNI
      AND FLDATE IN S_FLDAT
*      AND PRICE IN S_PRICE
*      AND CURRENCY IN S_CURRE
*      AND PLANETYPE IN S_PLANE
*      AND SEATSMAX IN S_SEATS
*      AND SEATSOCC IN S_SEATS
*      AND PAYMENTSUM IN S_PAYME
*      AND SEATSMAX_B IN S_SEATS
*      AND SEATSOCC_B IN S_SEATS
*      AND SEATSMAX_F IN S_SEATS
*      AND SEATSOCC_F IN S_SEATS
.
ENDFORM.                    "GET_BALV_DATA
**&---------------------------------------------------------------------*
**&      FORM  UPLOAD_BALV_DATA
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM UPLOAD_BALV_DATA USING PV_FILE_DIALOG PV_FILE_NAME.
*  DATA LT_TAB TYPE TABLE OF TS_BALV.
*  DATA LS_TAB TYPE TS_BALV.
*  CLEAR GV_ERR.
*  CALL METHOD ZCL_BRD_ALV_STD=>EXCEL_UPLOAD
*    EXPORTING
*      IV_FILE_DIALOG = PV_FILE_DIALOG
*      IV_FILE_NAME   = PV_FILE_NAME
*    CHANGING
*      CT_DATA        = LT_TAB[]
*    RECEIVING
*      EV_SUBRC       = GV_SUBRC.
*  IF  GV_SUBRC EQ 0.
*    LOOP AT LT_TAB INTO LS_TAB.
*      MOVE-CORRESPONDING LS_TAB TO GT_BALV.
*      APPEND GT_BALV.
*      CLEAR : LS_TAB, GT_BALV.
*    ENDLOOP.
*    GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
*  ELSE.
*    MESSAGE 'No File Selected' TYPE 'S' DISPLAY LIKE C_E.
*     GV_ERR = ABAP_TRUE.
*  ENDIF.
*
*ENDFORM.                    " UPLOAD_DATA
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
  IF S_CARRI-LOW IS NOT INITIAL.
    LV_TEXT = TEXT010.
    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
    LV_TEXT = S_CARRI-LOW.
    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
    LO_TAB->NEW_ROW( ).
  ENDIF.
  IF S_CONNI-LOW IS NOT INITIAL.
    LV_TEXT = TEXT011.
    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
    LV_TEXT = S_CONNI-LOW.
    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
    LO_TAB->NEW_ROW( ).
  ENDIF.
  IF S_FLDAT-LOW IS NOT INITIAL.
    LV_TEXT = TEXT012.
    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
    LV_TEXT = S_FLDAT-LOW.
    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
    LO_TAB->NEW_ROW( ).
  ENDIF.
*  IF *S_PRICE-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT013.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *S_PRICE-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *S_CURRE-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT014.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *S_CURRE-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *S_PLANE-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT015.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *S_PLANE-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *S_SEATS-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT016.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *S_SEATS-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *S_SEA17-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT017.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *S_SEA17-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *S_PAYME-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT018.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *S_PAYME-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *S_SEA19-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT019.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *S_SEA19-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *S_SEA20-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT020.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *S_SEA20-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *S_SEA21-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT021.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *S_SEA21-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *S_SEA22-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT022.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *S_SEA22-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.

  GO_DOCUMENT->MERGE_DOCUMENT( ).
ENDFORM.                    " SET_TITLE
**&---------------------------------------------------------------------*
**&      FORM  BALV_CREA_CLICK
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_CREA_CLICK.
*  CLEAR GS_BALV.
*  GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CREATE.
*  GO_BALV->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_CREATE_MODE
*                              CHANGING CT_CELLTAB = GS_BALV-CELLTAB ).
*  _set_timestamp_create GS_BALV.
*  APPEND GS_BALV TO GT_BALV.
*  GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
*  GO_BALV->REFRESH( ).
*  GO_BALV->GOTO_ROW_FOCUS( LINES( GT_BALV ) ).
*ENDFORM.                    "BALV_CREA_CLICK
*
**&---------------------------------------------------------------------*
**&      FORM  BALV_CHAN_CLICK.
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_CHAN_CLICK.
*  GT_BALV_BUFF[] = GT_BALV[].
*  CLEAR : GT_rows, GT_row_ids.
*  GO_BALV->GET_SELECTED_ROWS( IMPORTING et_index_rows = GT_rows
*                                      et_row_no = GT_row_ids ).
* GO_BALV->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_CHANGE_MODE
*                            CHANGING CT_CELLTAB = GT_CELLTAB ).
*  LOOP AT GT_BALV ASSIGNING FIELD-SYMBOL(<LS_BALV>).
*    <LS_BALV>-CELLTAB = GT_CELLTAB.
*  ENDLOOP.
*
*  GO_BALV->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_CHANGE_MODE
*                    CHANGING CT_DATA  = GT_BALV[] ).
*  GO_BALV->SET_SELECTED_ROWS( EXPORTING it_index_rows = GT_rows ).
*ENDFORM.                    "BALV_CHAN_CLICK.
**&---------------------------------------------------------------------*
**&      FORM  BALV_CANC_CLICK.
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_CANC_CLICK.
*
*  IF GO_BALV->IS_CHANGING( ) EQ ABAP_TRUE
*    AND GO_BALV->CONFIRM_CANCEL( ) NE ABAP_TRUE.
*    EXIT.
*  ENDIF.
*
*  CLEAR : GT_BALV, GT_BALV[].
*  GT_BALV[] = GT_BALV_BUFF[].
*  CLEAR GT_BALV_BUFF[].
*  GO_BALV->SET_CHANGING_FLAG( ABAP_FALSE ).
*
*  GO_BALV->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_DISPLAY_MODE
*                   CHANGING CT_DATA  = GT_BALV[] ).
*ENDFORM.                    "BALV_CANC_CLICK.
**&---------------------------------------------------------------------*
**&      FORM  BALV_RFSH_CLICK
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_RFSH_CLICK.
*ENDFORM.                    "RFSH_CLICK
**&---------------------------------------------------------------------*
**&      FORM  BALV_INST_CLICK.
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_INST_CLICK.
*  DATA LV_INSERT_FLAG TYPE FLAG.
*  CLEAR : GT_ROWS, GT_ROW_IDS, LV_INSERT_FLAG.
*  GO_BALV->GET_SELECTED_ROWS( IMPORTING ET_INDEX_ROWS = GT_ROWS
*                                        ET_ROW_NO = GT_ROW_IDS ).
*  IF LINES( GT_ROWS ) > 0.
*    LV_INSERT_FLAG = ABAP_TRUE.
*  ELSEIF LINES( GT_BALV ) EQ 0.
*    LV_INSERT_FLAG = ABAP_TRUE.
*  ENDIF.
*  IF LV_INSERT_FLAG EQ ABAP_TRUE.
*    CLEAR GT_CELLTAB.
*    GO_BALV->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_CREATE_MODE
*                                CHANGING CT_CELLTAB = GT_CELLTAB ).
*    IF LINES( GT_ROWS ) > 0.
*      SORT GT_ROWS BY INDEX.
*      GV_INDEX = GT_ROWS[ 1 ]-INDEX.
*      SORT GT_ROWS BY INDEX DESCENDING.
*      LOOP AT GT_ROWS INTO GS_ROWS.
*        CLEAR GS_BALV.
*      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CREATE.
*      GS_BALV-CELLTAB = GT_CELLTAB.
*        _SET_TIMESTAMP_CREATE GS_BALV.
*        INSERT GS_BALV INTO GT_BALV INDEX GV_INDEX.
*      ENDLOOP.
*    ELSEIF LINES( GT_BALV ) EQ 0.
*        CLEAR GS_BALV.
*      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CREATE.
*      GS_BALV-CELLTAB = GT_CELLTAB.
*        _SET_TIMESTAMP_CREATE GS_BALV.
*        APPEND GS_BALV TO GT_BALV.
*    ENDIF.
*    GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
*    GO_BALV->REFRESH( ).
*  ELSE.
*    ZCL_BRD_ALV_STD=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_STD=>MC_MSG-NO_ROW_SELECT ).
*  ENDIF.
*ENDFORM.                    "BALV_INST_CLICK.
**&---------------------------------------------------------------------*
**&      FORM  BALV_UPLD_CLICK
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_UPLD_CLICK.
*  GT_BALV_BUFF[] = GT_BALV[].
*  _INIT GT_BALV.
*  PERFORM UPLOAD_BALV_DATA USING ABAP_TRUE ''.
*  IF GV_ERR = ABAP_TRUE.
*    EXIT.
*  ENDIF.
*  GO_BALV->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_UPLOAD_MODE
*                     CHANGING CT_DATA  = GT_BALV[] ).
*ENDFORM.
**&---------------------------------------------------------------------*
**&      FORM  BALV_DOUBLE_CLICK
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_DOUBLE_CLICK USING PS_ROW TYPE LVC_S_ROW
*                                PS_COLUMN TYPE LVC_S_COL
*                                PS_ROW_NO TYPE LVC_S_ROID.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PS_ROW_NO-ROW_ID.
*  IF SY-SUBRC EQ 0.
*    CLEAR GT_ROWS.
*    APPEND PS_ROW TO GT_ROWS.
*    GO_BALV->SET_SELECTED_ROWS( EXPORTING IT_INDEX_ROWS = GT_ROWS ).
*  ENDIF.
*  MESSAGE 'DOUBLE CLICK TRIGGERED' TYPE 'I'.
*
*ENDFORM.
**&---------------------------------------------------------------------*
**&      FORM  BALV_VERIFY_DATA
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_VERIFY_DATA USING PV_TABIX TYPE SY-TABIX
*                                      PS_DATA LIKE GS_BALV.
*    IF GS_BALV-CARRID IS INITIAL
*       OR GS_BALV-CONNID IS INITIAL
*       OR GS_BALV-FLDATE IS INITIAL
*.
*      APPEND VALUE #( ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT
*                      ROW_NO = PV_TABIX
*                      MSG = GO_BALV->MESSAGE( EXPORTING IV_CODE = ZCL_BRD_ALV_STD=>MC_MSG-INPUT_MANDATORY ) ) TO GT_LOG.
*    ENDIF.
*ENDFORM.                    " BALV_VERIFY_DATA
**&---------------------------------------------------------------------*
**&      FORM  BALV_DELE_CLICK.
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_DELE_CLICK.
*  DATA LT_TAB TYPE TABLE OF SFLIGHT WITH HEADER LINE.
*  _INIT GT_ROWS.
*  GO_BALV->GET_SELECTED_ROWS(
*   IMPORTING
*     ET_INDEX_ROWS = GT_ROWS
*     ET_ROW_NO     = GT_ROW_IDS ).
*
*  IF LINES( GT_ROWS ) > 0.
*    SORT GT_ROWS BY INDEX DESCENDING.
*    LOOP AT GT_ROWS INTO GS_ROWS.
*      IF GT_BALV[ GS_ROWS-INDEX ]-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CREATE.
*        DELETE GT_BALV INDEX GS_ROWS-INDEX.
*      ELSE.
*        GT_BALV[ GS_ROWS-INDEX ]-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DELETE.
*      ENDIF.
*    ENDLOOP.
*    GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
*    GO_BALV->REFRESH( ).
*  ELSE.
*    ZCL_BRD_ALV_STD=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_STD=>MC_MSG-NO_ROW_SELECT ).
*  ENDIF.
*
*ENDFORM.                    "BALV_DELE_CLICK.
**&---------------------------------------------------------------------*
**&      FORM  BALV_DATA_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
**      -->PO_OBJECT     TEXT
**      -->PV_ONF4  TEXT
**      -->PV_ONF4_BEFORE  TEXT
**      -->PV_ONF4_AFTER  TEXT
**      -->PV_UCOMM  TEXT
**----------------------------------------------------------------------*
*FORM BALV_DATA_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                        PV_ONF4
*                        PV_ONF4_BEFORE
*                        PV_ONF4_AFTER
*                        PV_UCOMM.
*  DATA LT_MOD_CELLS TYPE LVC_T_MODI WITH HEADER LINE.
*  LT_MOD_CELLS[] = PO_OBJECT->MT_GOOD_CELLS.
*  LOOP AT LT_MOD_CELLS ASSIGNING FIELD-SYMBOL(<LS_MOD_CELLS>).
*    AT NEW ROW_ID.
*      CLEAR GS_BALV.
*      READ TABLE GT_BALV INTO GS_BALV INDEX <LS_MOD_CELLS>-ROW_ID.
*    ENDAT.
*    ASSIGN COMPONENT <LS_MOD_CELLS>-FIELDNAME OF STRUCTURE GS_BALV TO <GV_FIELD>.
*    <GV_FIELD> = <LS_MOD_CELLS>-VALUE.
*    _set_alv_cell <LS_MOD_CELLS>-row_id <LS_MOD_CELLS>-fieldname <gv_field>.
*    AT END OF ROW_ID.
*      READ TABLE GT_BALV TRANSPORTING NO FIELDS INDEX <LS_MOD_CELLS>-ROW_ID.
*      IF SY-SUBRC EQ 0." modify
*        IF GS_BALV-BALV_STATUS_ICON NE ZCL_BRD_ALV_STD=>MC_ICON-CREATE.
*          GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
*        ENDIF.
*        _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-BALV_STATUS_ICON GS_BALV-BALV_STATUS_ICON.
*      ELSE."auto added new row
*        _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-BALV_STATUS_ICON ZCL_BRD_ALV_STD=>MC_ICON-CREATE.
*        GO_BALV->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_CREATE_MODE
*                                    CHANGING CT_CELLTAB = GS_BALV-CELLTAB ).
*        LOOP AT GS_BALV-CELLTAB ASSIGNING FIELD-SYMBOL(<LS_CELLTAB>).
*          PO_OBJECT->MODIFY_STYLE( EXPORTING I_ROW_ID    = <LS_MOD_CELLS>-ROW_ID
*                                             I_FIELDNAME = <LS_CELLTAB>-FIELDNAME
*                                             I_STYLE     = <LS_CELLTAB>-STYLE ).
*        ENDLOOP.
*        GS_BALV-balv_status_icon = ZCL_BRD_ALV_STD=>mc_icon-create.
*        APPEND GS_BALV TO GT_BALV.
*      ENDIF.
*    ENDAT.
*  ENDLOOP.
*  GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
*ENDFORM.                    "BALV_DATA_CHANGED
**&---------------------------------------------------------------------*
**&      FORM  BALV_CARRID_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_CARRID_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  CLEAR GS_BALV.
*  READ TABLE GT_BALV
* INTO GS_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_BALV-CARRID = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-CARRID PV_VALUE.
*    CLEAR GV_ERR.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
*    ELSE.
*      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_CARRID_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_CONNID_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_CONNID_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  CLEAR GS_BALV.
*  READ TABLE GT_BALV
* INTO GS_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_BALV-CONNID = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-CONNID PV_VALUE.
*    CLEAR GV_ERR.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
*    ELSE.
*      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_CONNID_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_FLDATE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_FLDATE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  CLEAR GS_BALV.
*  READ TABLE GT_BALV
* INTO GS_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_BALV-FLDATE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-FLDATE PV_VALUE.
*    CLEAR GV_ERR.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
*    ELSE.
*      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_FLDATE_CHANGED.
***&---------------------------------------------------------------------*
***&      FORM  BALV_PRICE_CHANGED
***&---------------------------------------------------------------------*
***       TEXT
***----------------------------------------------------------------------*
**FORM BALV_PRICE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
**                                   PV_ROW_ID
**                                   PV_VALUE TYPE ANY.
**  CLEAR GS_BALV.
**  READ TABLE GT_BALV
** INTO GS_BALV INDEX PV_ROW_ID.
**  IF SY-SUBRC EQ 0.
**    GS_BALV-PRICE = PV_VALUE.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-PRICE PV_VALUE.
**    CLEAR GV_ERR.
***    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
**    IF GV_ERR EQ C_E.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
**    ELSE.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
**    ENDIF.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
**    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
**  ENDIF.
**ENDFORM.                    "BALV_PRICE_CHANGED.
***&---------------------------------------------------------------------*
***&      FORM  BALV_CURRENCY_CHANGED
***&---------------------------------------------------------------------*
***       TEXT
***----------------------------------------------------------------------*
**FORM BALV_CURRENCY_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
**                                   PV_ROW_ID
**                                   PV_VALUE TYPE ANY.
**  CLEAR GS_BALV.
**  READ TABLE GT_BALV
** INTO GS_BALV INDEX PV_ROW_ID.
**  IF SY-SUBRC EQ 0.
**    GS_BALV-CURRENCY = PV_VALUE.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-CURRENCY PV_VALUE.
**    CLEAR GV_ERR.
***    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
**    IF GV_ERR EQ C_E.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
**    ELSE.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
**    ENDIF.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
**    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
**  ENDIF.
**ENDFORM.                    "BALV_CURRENCY_CHANGED.
***&---------------------------------------------------------------------*
***&      FORM  BALV_PLANETYPE_CHANGED
***&---------------------------------------------------------------------*
***       TEXT
***----------------------------------------------------------------------*
**FORM BALV_PLANETYPE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
**                                   PV_ROW_ID
**                                   PV_VALUE TYPE ANY.
**  CLEAR GS_BALV.
**  READ TABLE GT_BALV
** INTO GS_BALV INDEX PV_ROW_ID.
**  IF SY-SUBRC EQ 0.
**    GS_BALV-PLANETYPE = PV_VALUE.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-PLANETYPE PV_VALUE.
**    CLEAR GV_ERR.
***    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
**    IF GV_ERR EQ C_E.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
**    ELSE.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
**    ENDIF.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
**    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
**  ENDIF.
**ENDFORM.                    "BALV_PLANETYPE_CHANGED.
***&---------------------------------------------------------------------*
***&      FORM  BALV_SEATSMAX_CHANGED
***&---------------------------------------------------------------------*
***       TEXT
***----------------------------------------------------------------------*
**FORM BALV_SEATSMAX_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
**                                   PV_ROW_ID
**                                   PV_VALUE TYPE ANY.
**  CLEAR GS_BALV.
**  READ TABLE GT_BALV
** INTO GS_BALV INDEX PV_ROW_ID.
**  IF SY-SUBRC EQ 0.
**    GS_BALV-SEATSMAX = PV_VALUE.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSMAX PV_VALUE.
**    CLEAR GV_ERR.
***    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
**    IF GV_ERR EQ C_E.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
**    ELSE.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
**    ENDIF.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
**    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
**  ENDIF.
**ENDFORM.                    "BALV_SEATSMAX_CHANGED.
***&---------------------------------------------------------------------*
***&      FORM  BALV_SEATSOCC_CHANGED
***&---------------------------------------------------------------------*
***       TEXT
***----------------------------------------------------------------------*
**FORM BALV_SEATSOCC_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
**                                   PV_ROW_ID
**                                   PV_VALUE TYPE ANY.
**  CLEAR GS_BALV.
**  READ TABLE GT_BALV
** INTO GS_BALV INDEX PV_ROW_ID.
**  IF SY-SUBRC EQ 0.
**    GS_BALV-SEATSOCC = PV_VALUE.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSOCC PV_VALUE.
**    CLEAR GV_ERR.
***    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
**    IF GV_ERR EQ C_E.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
**    ELSE.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
**    ENDIF.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
**    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
**  ENDIF.
**ENDFORM.                    "BALV_SEATSOCC_CHANGED.
***&---------------------------------------------------------------------*
***&      FORM  BALV_PAYMENTSUM_CHANGED
***&---------------------------------------------------------------------*
***       TEXT
***----------------------------------------------------------------------*
**FORM BALV_PAYMENTSUM_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
**                                   PV_ROW_ID
**                                   PV_VALUE TYPE ANY.
**  CLEAR GS_BALV.
**  READ TABLE GT_BALV
** INTO GS_BALV INDEX PV_ROW_ID.
**  IF SY-SUBRC EQ 0.
**    GS_BALV-PAYMENTSUM = PV_VALUE.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-PAYMENTSUM PV_VALUE.
**    CLEAR GV_ERR.
***    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
**    IF GV_ERR EQ C_E.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
**    ELSE.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
**    ENDIF.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
**    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
**  ENDIF.
**ENDFORM.                    "BALV_PAYMENTSUM_CHANGED.
***&---------------------------------------------------------------------*
***&      FORM  BALV_SEATSMAX_B_CHANGED
***&---------------------------------------------------------------------*
***       TEXT
***----------------------------------------------------------------------*
**FORM BALV_SEATSMAX_B_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
**                                   PV_ROW_ID
**                                   PV_VALUE TYPE ANY.
**  CLEAR GS_BALV.
**  READ TABLE GT_BALV
** INTO GS_BALV INDEX PV_ROW_ID.
**  IF SY-SUBRC EQ 0.
**    GS_BALV-SEATSMAX_B = PV_VALUE.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSMAX_B PV_VALUE.
**    CLEAR GV_ERR.
***    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
**    IF GV_ERR EQ C_E.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
**    ELSE.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
**    ENDIF.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
**    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
**  ENDIF.
**ENDFORM.                    "BALV_SEATSMAX_B_CHANGED.
***&---------------------------------------------------------------------*
***&      FORM  BALV_SEATSOCC_B_CHANGED
***&---------------------------------------------------------------------*
***       TEXT
***----------------------------------------------------------------------*
**FORM BALV_SEATSOCC_B_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
**                                   PV_ROW_ID
**                                   PV_VALUE TYPE ANY.
**  CLEAR GS_BALV.
**  READ TABLE GT_BALV
** INTO GS_BALV INDEX PV_ROW_ID.
**  IF SY-SUBRC EQ 0.
**    GS_BALV-SEATSOCC_B = PV_VALUE.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSOCC_B PV_VALUE.
**    CLEAR GV_ERR.
***    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
**    IF GV_ERR EQ C_E.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
**    ELSE.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
**    ENDIF.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
**    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
**  ENDIF.
**ENDFORM.                    "BALV_SEATSOCC_B_CHANGED.
***&---------------------------------------------------------------------*
***&      FORM  BALV_SEATSMAX_F_CHANGED
***&---------------------------------------------------------------------*
***       TEXT
***----------------------------------------------------------------------*
**FORM BALV_SEATSMAX_F_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
**                                   PV_ROW_ID
**                                   PV_VALUE TYPE ANY.
**  CLEAR GS_BALV.
**  READ TABLE GT_BALV
** INTO GS_BALV INDEX PV_ROW_ID.
**  IF SY-SUBRC EQ 0.
**    GS_BALV-SEATSMAX_F = PV_VALUE.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSMAX_F PV_VALUE.
**    CLEAR GV_ERR.
***    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
**    IF GV_ERR EQ C_E.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
**    ELSE.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
**    ENDIF.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
**    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
**  ENDIF.
**ENDFORM.                    "BALV_SEATSMAX_F_CHANGED.
***&---------------------------------------------------------------------*
***&      FORM  BALV_SEATSOCC_F_CHANGED
***&---------------------------------------------------------------------*
***       TEXT
***----------------------------------------------------------------------*
**FORM BALV_SEATSOCC_F_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
**                                   PV_ROW_ID
**                                   PV_VALUE TYPE ANY.
**  CLEAR GS_BALV.
**  READ TABLE GT_BALV
** INTO GS_BALV INDEX PV_ROW_ID.
**  IF SY-SUBRC EQ 0.
**    GS_BALV-SEATSOCC_F = PV_VALUE.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SEATSOCC_F PV_VALUE.
**    CLEAR GV_ERR.
***    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
**    IF GV_ERR EQ C_E.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DEFECT.
**    ELSE.
**      GS_BALV-BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
**    ENDIF.
**    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
**    MODIFY GT_BALV FROM GS_BALV INDEX PV_ROW_ID.
**  ENDIF.
**ENDFORM.                    "BALV_SEATSOCC_F_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_CHECK_PK
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_CHECK_PK .
*  CLEAR : GV_ERR, GV_COUNT.
*
*  SELECT COUNT(*) INTO GV_COUNT
*    FROM SFLIGHT
*  WHERE CARRID = GS_BALV-CARRID
*    AND CONNID = GS_BALV-CONNID
*    AND FLDATE = GS_BALV-FLDATE
*.
*
*  IF GV_COUNT GT 0.
*    GV_ERR = C_E.
*  ENDIF.
*ENDFORM.                    " CHECK_PK
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
*  IF GO_BALV->GET_ALV_MODE( ) NE ZCL_BRD_ALV_STD=>MC_DISPLAY_MODE.
*    GO_BALV->APPEND_TOOLBAR_BUTTON( EXPORTING
*                                   IV_FUNCTION = 'F01'
*                                   IV_ICON = '' "ICON-ID
*                                   IV_QUICKINFO = ''
*                                   IV_TEXT = 'MY TOOLBAR'
*                                   ).
*  ENDIF.
*ENDFORM.                    "BALV_SET_TOOLBAR
**&---------------------------------------------------------------------*
**&      FORM  SAVE_DATA.
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM SAVE_DATA.
*  DATA:
*        LS_BALV        TYPE SFLIGHT,
*        LT_CREATE_BALV TYPE TABLE OF SFLIGHT,
*        LT_UPDATE_BALV TYPE TABLE OF SFLIGHT,
*        LT_DELETE_BALV TYPE TABLE OF SFLIGHT.
*  DATA:
*        LV_CREATE_CNT  TYPE SY-DBCNT,
*        LV_UPDATE_CNT  TYPE SY-DBCNT,
*        LV_DELETE_CNT  TYPE SY-DBCNT.
*
*  CLEAR GT_LOG[].
*  CLEAR GS_BALV.
*  LOOP AT GT_BALV INTO GS_BALV.
*    CLEAR LS_BALV.
*    IF GS_BALV-BALV_STATUS_ICON IS NOT INITIAL.
*      PERFORM BALV_VERIFY_DATA USING SY-TABIX GS_BALV.
*      MOVE-CORRESPONDING GS_BALV TO LS_BALV.
*    ENDIF.
*    CASE GS_BALV-BALV_STATUS_ICON.
*      WHEN ZCL_BRD_ALV_STD=>MC_ICON-CREATE.
*        _set_timestamp_create LS_BALV.
*        APPEND LS_BALV TO LT_CREATE_BALV.
*      WHEN ZCL_BRD_ALV_STD=>MC_ICON-CHANGE.
*        _set_timestamp_change LS_BALV.
*        APPEND LS_BALV TO LT_UPDATE_BALV.
*      WHEN ZCL_BRD_ALV_STD=>MC_ICON-DELETE.
*        APPEND LS_BALV TO LT_DELETE_BALV.
*    ENDCASE.
*    CLEAR GS_BALV.
*  ENDLOOP.
*
*
*  IF GT_LOG[] IS NOT INITIAL.
*     ZCL_BRD_ALV_STD=>MESSAGE_POPUP( CHANGING CT_MSG = GT_LOG[] ).
*    EXIT.
*  ENDIF.
*
*  IF ZCL_BRD_ALV_STD=>CONFIRM_SAVE( ) NE ABAP_TRUE.
*    EXIT.
*  ENDIF.
*
*  TRY.
*      IF LT_CREATE_BALV IS NOT INITIAL.
*        INSERT SFLIGHT FROM TABLE LT_CREATE_BALV.
*        LV_CREATE_CNT = LV_CREATE_CNT + LINES( LT_CREATE_BALV ).
*      ENDIF.
*      IF LT_UPDATE_BALV IS NOT INITIAL.
*        MODIFY SFLIGHT FROM TABLE LT_UPDATE_BALV.
*        LV_UPDATE_CNT = LV_UPDATE_CNT + LINES( LT_UPDATE_BALV ).
*      ENDIF.
*      IF LT_DELETE_BALV IS NOT INITIAL.
*        DELETE SFLIGHT FROM TABLE LT_DELETE_BALV.
*        LV_DELETE_CNT = LV_DELETE_CNT + LINES( LT_DELETE_BALV ).
*      ENDIF.
*    CATCH CX_ROOT INTO GO_EXCEPTION.
*      ZCL_BRD_ALV_STD=>CATCH_EXCEPTION( IO_ROOT = GO_EXCEPTION ).
*  ENDTRY.
*  ZCL_BRD_ALV_STD=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_STD=>MC_MSG-SAVE_SUCCESS
*                                    IV_PARAM1 = |{ LV_CREATE_CNT }|
*                                    IV_PARAM2 = |{ LV_UPDATE_CNT }|
*                                    IV_PARAM3 = |{ LV_DELETE_CNT }| ).
*
*  CLEAR GT_BALV_BUFF[].
*  GO_BALV->SET_CHANGING_FLAG( ABAP_FALSE ).
*  DELETE GT_BALV WHERE BALV_STATUS_ICON = ZCL_BRD_ALV_STD=>MC_ICON-DELETE.
*  LOOP AT GT_BALV ASSIGNING <GS_BALV>.
*    IF <GS_BALV>-BALV_STATUS_ICON IS NOT INITIAL.
*      CLEAR <GS_BALV>-BALV_STATUS_ICON.
*    ENDIF.
*  ENDLOOP.
*  GO_BALV->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_STD=>MC_DISPLAY_MODE
*                    CHANGING CT_DATA  = GT_BALV[] ).
*ENDFORM.                    "SAVE_DATA
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

* ALV Layout
CLEAR GS_LAYOUT_CBO.
GS_LAYOUT_CBO-PROGID = ''.
GS_LAYOUT_CBO-ALV_KEY = ''.
GS_LAYOUT_CBO-SEL_MODE = ''.
GS_LAYOUT_CBO-GRID_TITLE = ''.

* ALV Fieldcatalog
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = ''.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '1'.
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
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '3'.
LS_FCAT_CBO-FIELDNAME = 'CARRID'.
LS_FCAT_CBO-ZKEY = ABAP_TRUE.
LS_FCAT_CBO-REPTEXT = 'ID'.
LS_FCAT_CBO-SCRTEXT_S = 'Carrier'.
LS_FCAT_CBO-SCRTEXT_M = 'Airline'.
LS_FCAT_CBO-SCRTEXT_L = 'Airline'.
LS_FCAT_CBO-JUST = 'C'.
LS_FCAT_CBO-EMPHASIZE = 'K41'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'CHAR'.
LS_FCAT_CBO-INTTYPE = 'C'.
LS_FCAT_CBO-INTLEN = '000003'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_CARR_ID'.
LS_FCAT_CBO-DD_OUTLEN = '000003'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '4'.
LS_FCAT_CBO-FIELDNAME = 'CONNID'.
LS_FCAT_CBO-ZKEY = ABAP_TRUE.
LS_FCAT_CBO-REPTEXT = 'No.'.
LS_FCAT_CBO-SCRTEXT_S = 'Flight No.'.
LS_FCAT_CBO-SCRTEXT_M = 'Flight Number'.
LS_FCAT_CBO-SCRTEXT_L = 'Connection Number'.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-EMPHASIZE = 'K41'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'NUMC'.
LS_FCAT_CBO-INTTYPE = 'N'.
LS_FCAT_CBO-INTLEN = '000004'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_CONN_ID'.
LS_FCAT_CBO-DD_OUTLEN = '000004'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '5'.
LS_FCAT_CBO-FIELDNAME = 'FLDATE'.
LS_FCAT_CBO-ZKEY = ABAP_TRUE.
LS_FCAT_CBO-REPTEXT = 'Date'.
LS_FCAT_CBO-SCRTEXT_S = 'Date'.
LS_FCAT_CBO-SCRTEXT_M = 'Date'.
LS_FCAT_CBO-SCRTEXT_L = 'Flight Date'.
LS_FCAT_CBO-JUST = 'C'.
LS_FCAT_CBO-EMPHASIZE = 'K41'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'DATS'.
LS_FCAT_CBO-INTTYPE = 'D'.
LS_FCAT_CBO-INTLEN = '000008'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_DATE'.
LS_FCAT_CBO-DD_OUTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '6'.
LS_FCAT_CBO-FIELDNAME = 'PRICE'.
LS_FCAT_CBO-REPTEXT = 'Airfare'.
LS_FCAT_CBO-SCRTEXT_S = 'Price'.
LS_FCAT_CBO-SCRTEXT_M = 'Airfare'.
LS_FCAT_CBO-SCRTEXT_L = 'Airfare'.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'CURR'.
LS_FCAT_CBO-INTTYPE = 'P'.
LS_FCAT_CBO-INTLEN = '000015'.
LS_FCAT_CBO-CFIELDNAME = 'CURRENCY'.
LS_FCAT_CBO-DECIMALS = '000002'.
LS_FCAT_CBO-DECIMALS_O = '000002'.
LS_FCAT_CBO-DOMNAME = 'S_PRICE'.
LS_FCAT_CBO-DD_OUTLEN = '000020'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '7'.
LS_FCAT_CBO-FIELDNAME = 'CURRENCY'.
LS_FCAT_CBO-REPTEXT = 'Curr.'.
LS_FCAT_CBO-SCRTEXT_S = 'Currency'.
LS_FCAT_CBO-SCRTEXT_M = 'Airline Currency'.
LS_FCAT_CBO-SCRTEXT_L = 'Airline local currency'.
LS_FCAT_CBO-JUST = 'C'.
LS_FCAT_CBO-EMPHASIZE = '$'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'CUKY'.
LS_FCAT_CBO-INTTYPE = 'C'.
LS_FCAT_CBO-INTLEN = '000005'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_CURR'.
LS_FCAT_CBO-DD_OUTLEN = '000005'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '8'.
LS_FCAT_CBO-FIELDNAME = 'PLANETYPE'.
LS_FCAT_CBO-REPTEXT = 'Plane'.
LS_FCAT_CBO-SCRTEXT_S = 'Pl.type'.
LS_FCAT_CBO-SCRTEXT_M = 'Plane Type'.
LS_FCAT_CBO-SCRTEXT_L = 'Plane Type'.
LS_FCAT_CBO-JUST = 'C'.
LS_FCAT_CBO-EMPHASIZE = '$'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'CHAR'.
LS_FCAT_CBO-INTTYPE = 'C'.
LS_FCAT_CBO-INTLEN = '000010'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_PLANE'.
LS_FCAT_CBO-DD_OUTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '9'.
LS_FCAT_CBO-FIELDNAME = 'SEATSMAX'.
LS_FCAT_CBO-REPTEXT = 'Capacity in economy class'.
LS_FCAT_CBO-SCRTEXT_S = 'Capacity'.
LS_FCAT_CBO-SCRTEXT_M = 'Max. capacity econ.'.
LS_FCAT_CBO-SCRTEXT_L = 'Maximum capacity economy class'.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_SEATS'.
LS_FCAT_CBO-DD_OUTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '10'.
LS_FCAT_CBO-FIELDNAME = 'SEATSOCC'.
LS_FCAT_CBO-REPTEXT = 'Occupied economy class'.
LS_FCAT_CBO-SCRTEXT_S = 'Occupied'.
LS_FCAT_CBO-SCRTEXT_M = 'Occupied econ.'.
LS_FCAT_CBO-SCRTEXT_L = 'Occupied seats economy class'.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_SEATS'.
LS_FCAT_CBO-DD_OUTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '11'.
LS_FCAT_CBO-FIELDNAME = 'PAYMENTSUM'.
LS_FCAT_CBO-REPTEXT = 'Booking total'.
LS_FCAT_CBO-SCRTEXT_S = 'Total'.
LS_FCAT_CBO-SCRTEXT_M = 'Total'.
LS_FCAT_CBO-SCRTEXT_L = 'Booking total'.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'CURR'.
LS_FCAT_CBO-INTTYPE = 'P'.
LS_FCAT_CBO-INTLEN = '000017'.
LS_FCAT_CBO-CFIELDNAME = 'CURRENCY'.
LS_FCAT_CBO-DECIMALS = '000002'.
LS_FCAT_CBO-DECIMALS_O = '000002'.
LS_FCAT_CBO-DOMNAME = 'S_SUM'.
LS_FCAT_CBO-DD_OUTLEN = '000022'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '12'.
LS_FCAT_CBO-FIELDNAME = 'SEATSMAX_B'.
LS_FCAT_CBO-REPTEXT = 'Capacity business class'.
LS_FCAT_CBO-SCRTEXT_S = 'Capacity'.
LS_FCAT_CBO-SCRTEXT_M = 'Max. capacity bus.'.
LS_FCAT_CBO-SCRTEXT_L = 'Maximum capacity business class'.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_SEATS'.
LS_FCAT_CBO-DD_OUTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '13'.
LS_FCAT_CBO-FIELDNAME = 'SEATSOCC_B'.
LS_FCAT_CBO-REPTEXT = 'Occupied business class'.
LS_FCAT_CBO-SCRTEXT_S = 'Occupied'.
LS_FCAT_CBO-SCRTEXT_M = 'Occupied bus.'.
LS_FCAT_CBO-SCRTEXT_L = 'Occupied seats business class'.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_SEATS'.
LS_FCAT_CBO-DD_OUTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '14'.
LS_FCAT_CBO-FIELDNAME = 'SEATSMAX_F'.
LS_FCAT_CBO-REPTEXT = 'Capacity in first class'.
LS_FCAT_CBO-SCRTEXT_S = 'Capacity'.
LS_FCAT_CBO-SCRTEXT_M = 'Max. capacity 1st'.
LS_FCAT_CBO-SCRTEXT_L = 'Maximum capacity in first class'.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_SEATS'.
LS_FCAT_CBO-DD_OUTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
CLEAR LS_FCAT_CBO.
LS_FCAT_CBO-PROGID = 'ZLBRD03020'.
LS_FCAT_CBO-ALV_KEY = 'BALV'.
LS_FCAT_CBO-FCAT_KEY = 'DEFAULT'.
LS_FCAT_CBO-COL_POS = '15'.
LS_FCAT_CBO-FIELDNAME = 'SEATSOCC_F'.
LS_FCAT_CBO-REPTEXT = 'Occupied in first class'.
LS_FCAT_CBO-SCRTEXT_S = 'Occupied'.
LS_FCAT_CBO-SCRTEXT_M = 'Occupied 1st'.
LS_FCAT_CBO-SCRTEXT_L = 'Occupied seats in first class'.
LS_FCAT_CBO-JUST = 'R'.
LS_FCAT_CBO-CREA_EDIT = ABAP_TRUE.
LS_FCAT_CBO-CHAN_EDIT = ABAP_TRUE.
LS_FCAT_CBO-UPLD_EDIT = ABAP_TRUE.
LS_FCAT_CBO-REF_TABLE = 'SFLIGHT'.
LS_FCAT_CBO-DATATYPE = 'INT4'.
LS_FCAT_CBO-INTTYPE = 'I'.
LS_FCAT_CBO-INTLEN = '000010'.
LS_FCAT_CBO-DECIMALS_O = '000000'.
LS_FCAT_CBO-DOMNAME = 'S_SEATS'.
LS_FCAT_CBO-DD_OUTLEN = '000010'.
APPEND LS_FCAT_CBO TO GT_FIELDCAT_CBO.
ENDFORM.
