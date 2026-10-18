*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD99020F01
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
       ROWS    = 3
       COLUMNS = 1 .
  GO_CONTAINER_TITLE = GO_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 1 COLUMN = 1 ).
  GO_CONTAINER_HEAD = GO_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 2 COLUMN = 1 ).
  GO_CONTAINER_ITEM = GO_SPLITTER_CONTAINER_OUT->GET_CONTAINER( ROW = 3 COLUMN = 1 ).
  GO_SPLITTER_CONTAINER_OUT->SET_ROW_HEIGHT( ID = 1 HEIGHT = 20 ).
  GO_SPLITTER_CONTAINER_OUT->SET_ROW_HEIGHT( ID = 2 HEIGHT = 40 ).
  CREATE OBJECT GO_DOCUMENT.

  PERFORM SET_TITLE.

  GO_DOCUMENT->DISPLAY_DOCUMENT( PARENT = GO_CONTAINER_TITLE ).
  CREATE OBJECT GO_ITEM
    EXPORTING
      IO_PARENT = GO_CONTAINER_ITEM
      IV_ALV_KEY = 'ITEM'
      .

  GO_ITEM->DISPLAY( CHANGING CT_DATA = GT_ITEM[] ).
  CREATE OBJECT GO_HEAD
    EXPORTING
      IO_PARENT = GO_CONTAINER_HEAD
      IV_ALV_KEY = 'HEAD'
        .

  GO_HEAD->DISPLAY( CHANGING CT_DATA = GT_HEAD[] ).
ELSE.
  GO_HEAD->REFRESH( ).
  GO_ITEM->REFRESH( ).
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
      IF GO_HEAD->GET_ALV_MODE( ) EQ ZCL_BRD_ALV_N=>MC_DISPLAY_MODE
        AND GO_ITEM->GET_ALV_MODE( ) EQ ZCL_BRD_ALV_N=>MC_DISPLAY_MODE.
        LEAVE TO SCREEN 0.
      ELSE.
        IF GO_HEAD->GET_ALV_MODE( ) NE ZCL_BRD_ALV_N=>MC_DISPLAY_MODE.
          PERFORM HEAD_CANC_CLICK.
        ENDIF.
        IF GO_ITEM->GET_ALV_MODE( ) NE ZCL_BRD_ALV_N=>MC_DISPLAY_MODE.
          PERFORM ITEM_CANC_CLICK.
        ENDIF.
      ENDIF.
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
  CLEAR GV_OKCODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      FORM  SET_INIT_VALUE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM SET_INIT_VALUE .
  _INIT : GT_HEAD.
  TEXT009 = 'Select Options'.
  TEXT010 = 'ID'.

ENDFORM.                    " SET_INIT_VALUE
*&---------------------------------------------------------------------*
*&      FORM  CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM CHECK_AUTHORITY .

ENDFORM.                    " CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*&      FORM  GET_HEAD_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM GET_HEAD_DATA .
  _INIT : GT_HEAD.
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_HEAD
    FROM SCARR
    WHERE CARRID IN S_CARRI
.
ENDFORM.                    "GET_HEAD_DATA
*&---------------------------------------------------------------------*
*&      FORM  GET_ITEM_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM GET_ITEM_DATA .
  _INIT : GT_ITEM.
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE GT_ITEM
    FROM SFLIGHT
    WHERE CARRID EQ GT_HEAD-CARRID
.
ENDFORM.                    "GET_ITEM_DATA
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
*    LV_TEXT = 'ID'.
    LV_TEXT = TEXT010.
    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
    LV_TEXT = S_CARRI-LOW.
    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
    LO_TAB->NEW_ROW( ).
  ENDIF.

  GO_DOCUMENT->MERGE_DOCUMENT( ).
ENDFORM.                    " SET_TITLE
*&---------------------------------------------------------------------*
*&      FORM  HEAD_CREA_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_CREA_CLICK.
  CLEAR GS_HEAD.
  GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CREATE.
  GO_HEAD->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CREATE_MODE
                              CHANGING CT_CELLTAB = GS_HEAD-CELLTAB ).
  _set_timestamp_create GS_HEAD.
  APPEND GS_HEAD TO GT_HEAD.
  GO_HEAD->SET_CHANGING_FLAG( ABAP_TRUE ).
  GO_HEAD->REFRESH( ).
  GO_HEAD->GOTO_ROW_FOCUS( LINES( GT_HEAD ) ).
ENDFORM.                    "HEAD_CREA_CLICK

*&---------------------------------------------------------------------*
*&      FORM  ITEM_CREA_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_CREA_CLICK.
  IF GT_HEAD IS INITIAL.
    MESSAGE I002(ZBRD001) DISPLAY LIKE C_E.
    EXIT.
  ENDIF.
  CLEAR GS_ITEM.
  GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CREATE.
  GO_ITEM->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CREATE_MODE
                              CHANGING CT_CELLTAB = GS_ITEM-CELLTAB ).
  _set_timestamp_create GS_ITEM.
  APPEND GS_ITEM TO GT_ITEM.
  GO_ITEM->SET_CHANGING_FLAG( ABAP_TRUE ).
  GO_ITEM->REFRESH( ).
  GO_ITEM->GOTO_ROW_FOCUS( LINES( GT_ITEM ) ).
ENDFORM.                    "ITEM_CREA_CLICK

*&---------------------------------------------------------------------*
*&      FORM  HEAD_CHAN_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_CHAN_CLICK.
  GT_HEAD_BUFF[] = GT_HEAD[].
 GO_HEAD->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CHANGE_MODE
                            CHANGING CT_CELLTAB = GT_CELLTAB ).
  LOOP AT GT_HEAD ASSIGNING FIELD-SYMBOL(<LS_HEAD>).
    <LS_HEAD>-CELLTAB = GT_CELLTAB.
  ENDLOOP.

  GO_HEAD->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CHANGE_MODE
                    CHANGING CT_DATA  = GT_HEAD[] ).
ENDFORM.                    "HEAD_CHAN_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  ITEM_CHAN_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_CHAN_CLICK.
  IF GT_HEAD IS INITIAL.
    MESSAGE I002(ZBRD001) DISPLAY LIKE C_E.
    EXIT.
  ENDIF.
  GT_ITEM_BUFF[] = GT_ITEM[].
 GO_ITEM->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CHANGE_MODE
                            CHANGING CT_CELLTAB = GT_CELLTAB ).
  LOOP AT GT_ITEM ASSIGNING FIELD-SYMBOL(<LS_ITEM>).
    <LS_ITEM>-CELLTAB = GT_CELLTAB.
  ENDLOOP.

  GO_ITEM->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CHANGE_MODE
                    CHANGING CT_DATA  = GT_ITEM[] ).
ENDFORM.                    "ITEM_CHAN_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  HEAD_CANC_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_CANC_CLICK.

  IF GO_HEAD->IS_CHANGING( ) EQ ABAP_TRUE
    AND GO_HEAD->CONFIRM_CANCEL( ) NE ABAP_TRUE.
    EXIT.
  ENDIF.

  CLEAR : GT_HEAD, GT_HEAD[].
  GT_HEAD[] = GT_HEAD_BUFF[].
  CLEAR GT_HEAD_BUFF[].
  GO_HEAD->SET_CHANGING_FLAG( ABAP_FALSE ).

  GO_HEAD->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_DISPLAY_MODE
                   CHANGING CT_DATA  = GT_HEAD[] ).
ENDFORM.                    "HEAD_CANC_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  ITEM_CANC_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_CANC_CLICK.

  IF GO_ITEM->IS_CHANGING( ) EQ ABAP_TRUE
    AND GO_ITEM->CONFIRM_CANCEL( ) NE ABAP_TRUE.
    EXIT.
  ENDIF.

  CLEAR : GT_ITEM, GT_ITEM[].
  GT_ITEM[] = GT_ITEM_BUFF[].
  CLEAR GT_ITEM_BUFF[].
  GO_ITEM->SET_CHANGING_FLAG( ABAP_FALSE ).

  GO_ITEM->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_DISPLAY_MODE
                   CHANGING CT_DATA  = GT_ITEM[] ).
ENDFORM.                    "ITEM_CANC_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  HEAD_RFSH_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_RFSH_CLICK.
ENDFORM.                    "RFSH_CLICK
*&---------------------------------------------------------------------*
*&      FORM  ITEM_RFSH_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_RFSH_CLICK.
ENDFORM.                    "RFSH_CLICK
*&---------------------------------------------------------------------*
*&      FORM  HEAD_INST_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_INST_CLICK.
  DATA LV_INSERT_FLAG TYPE FLAG.
  CLEAR : GT_ROWS, GT_ROW_IDS, LV_INSERT_FLAG.
  GO_HEAD->GET_SELECTED_ROWS( IMPORTING ET_INDEX_ROWS = GT_ROWS
                                        ET_ROW_NO = GT_ROW_IDS ).
  IF LINES( GT_ROWS ) > 0.
    LV_INSERT_FLAG = ABAP_TRUE.
  ELSEIF LINES( GT_HEAD ) EQ 0.
    LV_INSERT_FLAG = ABAP_TRUE.
  ENDIF.
  IF LV_INSERT_FLAG EQ ABAP_TRUE.
    CLEAR GT_CELLTAB.
    GO_HEAD->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CREATE_MODE
                                CHANGING CT_CELLTAB = GT_CELLTAB ).
    IF LINES( GT_ROWS ) > 0.
      SORT GT_ROWS BY INDEX.
      GV_INDEX = GT_ROWS[ 1 ]-INDEX.
      SORT GT_ROWS BY INDEX DESCENDING.
      CLEAR GT_CELLTAB.
    GO_HEAD->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CREATE_MODE
                                CHANGING CT_CELLTAB = GT_CELLTAB ).
      LOOP AT GT_ROWS INTO GS_ROWS.
        CLEAR GS_HEAD.
      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CREATE.
      GS_HEAD-CELLTAB = GT_CELLTAB.
        _SET_TIMESTAMP_CREATE GS_HEAD.
        INSERT GS_HEAD INTO GT_HEAD INDEX GV_INDEX.
      ENDLOOP.
    ELSEIF LINES( GT_HEAD ) EQ 0.
        CLEAR GS_HEAD.
      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CREATE.
      GS_HEAD-CELLTAB = GT_CELLTAB.
        _SET_TIMESTAMP_CREATE GS_HEAD.
        APPEND GS_HEAD TO GT_HEAD.
    ENDIF.
    GO_HEAD->SET_CHANGING_FLAG( ABAP_TRUE ).
    GO_HEAD->REFRESH( ).
  ELSE.
    ZCL_BRD_ALV_N=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_N=>MC_MSG-NO_ROW_SELECT ).
  ENDIF.
ENDFORM.                    "HEAD_INST_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  ITEM_INST_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_INST_CLICK.
  DATA LV_INSERT_FLAG TYPE FLAG.
  CLEAR : GT_ROWS, GT_ROW_IDS, LV_INSERT_FLAG.
  GO_ITEM->GET_SELECTED_ROWS( IMPORTING ET_INDEX_ROWS = GT_ROWS
                                        ET_ROW_NO = GT_ROW_IDS ).
  IF LINES( GT_ROWS ) > 0.
    LV_INSERT_FLAG = ABAP_TRUE.
  ELSEIF LINES( GT_ITEM ) EQ 0.
    LV_INSERT_FLAG = ABAP_TRUE.
  ENDIF.
  IF LV_INSERT_FLAG EQ ABAP_TRUE.
    CLEAR GT_CELLTAB.
    GO_ITEM->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CREATE_MODE
                                CHANGING CT_CELLTAB = GT_CELLTAB ).
    IF LINES( GT_ROWS ) > 0.
      SORT GT_ROWS BY INDEX.
      GV_INDEX = GT_ROWS[ 1 ]-INDEX.
      SORT GT_ROWS BY INDEX DESCENDING.
      CLEAR GT_CELLTAB.
    GO_ITEM->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CREATE_MODE
                                CHANGING CT_CELLTAB = GT_CELLTAB ).
      LOOP AT GT_ROWS INTO GS_ROWS.
        CLEAR GS_ITEM.
      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CREATE.
      GS_ITEM-CELLTAB = GT_CELLTAB.
        _SET_TIMESTAMP_CREATE GS_ITEM.
        INSERT GS_ITEM INTO GT_ITEM INDEX GV_INDEX.
      ENDLOOP.
    ELSEIF LINES( GT_ITEM ) EQ 0.
        CLEAR GS_ITEM.
      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CREATE.
      GS_ITEM-CELLTAB = GT_CELLTAB.
        _SET_TIMESTAMP_CREATE GS_ITEM.
        APPEND GS_ITEM TO GT_ITEM.
    ENDIF.
    GO_ITEM->SET_CHANGING_FLAG( ABAP_TRUE ).
    GO_ITEM->REFRESH( ).
  ELSE.
    ZCL_BRD_ALV_N=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_N=>MC_MSG-NO_ROW_SELECT ).
  ENDIF.
ENDFORM.                    "ITEM_INST_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  HEAD_UPLD_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_UPLD_CLICK.
  GT_HEAD_BUFF[] = GT_HEAD[].
  _INIT GT_HEAD.
  PERFORM UPLOAD_HEAD_DATA USING ABAP_TRUE ''.
  IF GV_ERR = ABAP_TRUE.
    EXIT.
  ENDIF.
  GO_HEAD->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_UPLOAD_MODE
                     CHANGING CT_DATA  = GT_HEAD[] ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  ITEM_UPLD_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_UPLD_CLICK.
  GT_ITEM_BUFF[] = GT_ITEM[].
  _INIT GT_ITEM.
  PERFORM UPLOAD_ITEM_DATA USING ABAP_TRUE ''.
  IF GV_ERR = ABAP_TRUE.
    EXIT.
  ENDIF.
  GO_ITEM->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_UPLOAD_MODE
                     CHANGING CT_DATA  = GT_ITEM[] ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  UPLOAD_HEAD_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM UPLOAD_HEAD_DATA USING PV_FILE_DIALOG PV_FILE_NAME.
  DATA LT_TAB TYPE TABLE OF TS_HEAD.
  DATA LS_TAB TYPE TS_HEAD.
  CLEAR GV_ERR.
  CALL METHOD ZCL_BRD_ALV_N=>EXCEL_UPLOAD
    EXPORTING
      IV_FILE_DIALOG = PV_FILE_DIALOG
      IV_FILE_NAME   = PV_FILE_NAME
    CHANGING
      CT_DATA        = LT_TAB[]
    RECEIVING
      EV_SUBRC       = GV_SUBRC.
  IF  GV_SUBRC EQ 0.
    LOOP AT LT_TAB INTO LS_TAB.
      MOVE-CORRESPONDING LS_TAB TO GT_HEAD.
      APPEND GT_HEAD.
      CLEAR : LS_TAB, GT_HEAD.
    ENDLOOP.
    GO_HEAD->SET_CHANGING_FLAG( ABAP_TRUE ).
  ELSE.
    MESSAGE S004(ZBRD001) DISPLAY LIKE C_E.
     GV_ERR = ABAP_TRUE.
  ENDIF.

ENDFORM.                    " UPLOAD_DATA
*&---------------------------------------------------------------------*
*&      FORM  UPLOAD_ITEM_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM UPLOAD_ITEM_DATA USING PV_FILE_DIALOG PV_FILE_NAME.
  DATA LT_TAB TYPE TABLE OF TS_ITEM.
  DATA LS_TAB TYPE TS_ITEM.
  CLEAR GV_ERR.
  CALL METHOD ZCL_BRD_ALV_N=>EXCEL_UPLOAD
    EXPORTING
      IV_FILE_DIALOG = PV_FILE_DIALOG
      IV_FILE_NAME   = PV_FILE_NAME
    CHANGING
      CT_DATA        = LT_TAB[]
    RECEIVING
      EV_SUBRC       = GV_SUBRC.
  IF  GV_SUBRC EQ 0.
    LOOP AT LT_TAB INTO LS_TAB.
      MOVE-CORRESPONDING LS_TAB TO GT_ITEM.
      APPEND GT_ITEM.
      CLEAR : LS_TAB, GT_ITEM.
    ENDLOOP.
    GO_ITEM->SET_CHANGING_FLAG( ABAP_TRUE ).
  ELSE.
    MESSAGE S004(ZBRD001) DISPLAY LIKE C_E.
     GV_ERR = ABAP_TRUE.
  ENDIF.

ENDFORM.                    " UPLOAD_DATA
*&---------------------------------------------------------------------*
*&      FORM  HEAD_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_DOUBLE_CLICK USING PS_ROW TYPE LVC_S_ROW
                                PS_COLUMN TYPE LVC_S_COL
                                PS_ROW_NO TYPE LVC_S_ROID.

  IF GO_ITEM->IS_CHANGING( ) EQ ABAP_TRUE
    AND GO_ITEM->CONFIRM_CANCEL( ) NE ABAP_TRUE.
    EXIT.
  ENDIF.

  IF GO_HEAD->IS_READY_FOR_INPUT( ) EQ 1.
    EXIT.
  ENDIF.

  CLEAR GT_HEAD.
  READ TABLE GT_HEAD INDEX PS_ROW_NO-ROW_ID.
  IF SY-SUBRC EQ 0.
    CLEAR GT_ROWS.
    APPEND PS_ROW TO GT_ROWS.
    GO_HEAD->SET_SELECTED_ROWS( EXPORTING IT_INDEX_ROWS = GT_ROWS ).

    CLEAR : GT_ITEM_BUFF[].
    GO_ITEM->SET_CHANGING_FLAG( ABAP_FALSE ).

    PERFORM GET_ITEM_DATA.
    GO_ITEM->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_DISPLAY_MODE
                      CHANGING CT_DATA  = GT_ITEM[] ).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  ITEM_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_DOUBLE_CLICK USING PS_ROW TYPE LVC_S_ROW
                                PS_COLUMN TYPE LVC_S_COL
                                PS_ROW_NO TYPE LVC_S_ROID.
  CLEAR GT_ITEM.
  READ TABLE GT_ITEM INDEX PS_ROW_NO-ROW_ID.
  IF SY-SUBRC EQ 0.
    CLEAR GT_ROWS.
    APPEND PS_ROW TO GT_ROWS.
    GO_ITEM->SET_SELECTED_ROWS( EXPORTING IT_INDEX_ROWS = GT_ROWS ).
  ENDIF.
  MESSAGE 'DOUBLE CLICK TRIGGERED' TYPE 'I'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      FORM  HEAD_VERIFY_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_VERIFY_DATA USING PV_TABIX TYPE SY-TABIX
                                      PS_DATA LIKE GS_HEAD.
    IF GS_HEAD-CARRID IS INITIAL
.
      APPEND VALUE #( ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT
                      ROW_NO = PV_TABIX
                      MSG = GO_HEAD->MESSAGE( EXPORTING IV_CODE = ZCL_BRD_ALV_N=>MC_MSG-INPUT_MANDATORY ) ) TO GT_LOG.
    ENDIF.
ENDFORM.                    " HEAD_VERIFY_DATA
*&---------------------------------------------------------------------*
*&      FORM  ITEM_VERIFY_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_VERIFY_DATA USING PV_TABIX TYPE SY-TABIX
                                      PS_DATA LIKE GS_ITEM.
    IF GS_ITEM-CARRID IS INITIAL
       OR GS_ITEM-CONNID IS INITIAL
       OR GS_ITEM-FLDATE IS INITIAL
.
      APPEND VALUE #( ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT
                      ROW_NO = PV_TABIX
                      MSG = GO_ITEM->MESSAGE( EXPORTING IV_CODE = ZCL_BRD_ALV_N=>MC_MSG-INPUT_MANDATORY ) ) TO GT_LOG.
    ENDIF.
ENDFORM.                    " ITEM_VERIFY_DATA
*&---------------------------------------------------------------------*
*&      FORM  HEAD_DELE_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_DELE_CLICK.
  DATA LT_TAB TYPE TABLE OF SCARR WITH HEADER LINE.
  _INIT GT_ROWS.
  GO_HEAD->GET_SELECTED_ROWS(
   IMPORTING
     ET_INDEX_ROWS = GT_ROWS
     ET_ROW_NO     = GT_ROW_IDS ).

  IF LINES( GT_ROWS ) > 0.
    SORT GT_ROWS BY INDEX DESCENDING.
    LOOP AT GT_ROWS INTO GS_ROWS.
      IF GT_HEAD[ GS_ROWS-INDEX ]-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CREATE.
        DELETE GT_HEAD INDEX GS_ROWS-INDEX.
      ELSE.
        GT_HEAD[ GS_ROWS-INDEX ]-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DELETE.
      ENDIF.
    ENDLOOP.
    GO_HEAD->SET_CHANGING_FLAG( ABAP_TRUE ).
    GO_HEAD->REFRESH( ).
  ELSE.
    ZCL_BRD_ALV_N=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_N=>MC_MSG-NO_ROW_SELECT ).
  ENDIF.

ENDFORM.                    "HEAD_DELE_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  ITEM_DELE_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_DELE_CLICK.
  DATA LT_TAB TYPE TABLE OF SFLIGHT WITH HEADER LINE.
  _INIT GT_ROWS.
  GO_ITEM->GET_SELECTED_ROWS(
   IMPORTING
     ET_INDEX_ROWS = GT_ROWS
     ET_ROW_NO     = GT_ROW_IDS ).

  IF LINES( GT_ROWS ) > 0.
    SORT GT_ROWS BY INDEX DESCENDING.
    LOOP AT GT_ROWS INTO GS_ROWS.
      IF GT_ITEM[ GS_ROWS-INDEX ]-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CREATE.
        DELETE GT_ITEM INDEX GS_ROWS-INDEX.
      ELSE.
        GT_ITEM[ GS_ROWS-INDEX ]-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DELETE.
      ENDIF.
    ENDLOOP.
    GO_ITEM->SET_CHANGING_FLAG( ABAP_TRUE ).
    GO_ITEM->REFRESH( ).
  ELSE.
    ZCL_BRD_ALV_N=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_N=>MC_MSG-NO_ROW_SELECT ).
  ENDIF.

ENDFORM.                    "ITEM_DELE_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  HEAD_DATA_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->PO_OBJECT     TEXT
*      -->PV_ONF4  TEXT
*      -->PV_ONF4_BEFORE  TEXT
*      -->PV_ONF4_AFTER  TEXT
*      -->PV_UCOMM  TEXT
*----------------------------------------------------------------------*
FORM HEAD_DATA_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                        PV_ONF4
                        PV_ONF4_BEFORE
                        PV_ONF4_AFTER
                        PV_UCOMM.
  DATA LT_MOD_CELLS TYPE LVC_T_MODI WITH HEADER LINE.
  LT_MOD_CELLS[] = PO_OBJECT->MT_GOOD_CELLS.
  LOOP AT LT_MOD_CELLS ASSIGNING FIELD-SYMBOL(<LS_MOD_CELLS>).
    AT NEW ROW_ID.
      CLEAR GS_HEAD.
      READ TABLE GT_HEAD INTO GS_HEAD INDEX <LS_MOD_CELLS>-ROW_ID.
    ENDAT.
    ASSIGN COMPONENT <LS_MOD_CELLS>-FIELDNAME OF STRUCTURE GS_HEAD TO <GV_FIELD>.
    <GV_FIELD> = <LS_MOD_CELLS>-VALUE.
    _set_alv_cell <LS_MOD_CELLS>-row_id <LS_MOD_CELLS>-fieldname <gv_field>.
    AT END OF ROW_ID.
      READ TABLE GT_HEAD TRANSPORTING NO FIELDS INDEX <LS_MOD_CELLS>-ROW_ID.
      IF SY-SUBRC EQ 0." modify
        IF GS_HEAD-BALV_STATUS_ICON NE ZCL_BRD_ALV_N=>MC_ICON-CREATE.
          GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
        ENDIF.
        _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-BALV_STATUS_ICON GS_HEAD-BALV_STATUS_ICON.
      ELSE."auto added new row
        _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-BALV_STATUS_ICON ZCL_BRD_ALV_N=>MC_ICON-CREATE.
        GO_HEAD->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CREATE_MODE
                                    CHANGING CT_CELLTAB = GS_HEAD-CELLTAB ).
        LOOP AT GS_HEAD-CELLTAB ASSIGNING FIELD-SYMBOL(<LS_CELLTAB>).
          PO_OBJECT->MODIFY_STYLE( EXPORTING I_ROW_ID    = <LS_MOD_CELLS>-ROW_ID
                                             I_FIELDNAME = <LS_CELLTAB>-FIELDNAME
                                             I_STYLE     = <LS_CELLTAB>-STYLE ).
        ENDLOOP.
        GS_HEAD-balv_status_icon = ZCL_BRD_ALV_N=>mc_icon-create.
        APPEND GS_HEAD TO GT_HEAD.
      ENDIF.
    ENDAT.
  ENDLOOP.
  GO_HEAD->SET_CHANGING_FLAG( ABAP_TRUE ).
ENDFORM.                    "HEAD_DATA_CHANGED
*&---------------------------------------------------------------------*
*&      FORM  ITEM_DATA_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->PO_OBJECT     TEXT
*      -->PV_ONF4  TEXT
*      -->PV_ONF4_BEFORE  TEXT
*      -->PV_ONF4_AFTER  TEXT
*      -->PV_UCOMM  TEXT
*----------------------------------------------------------------------*
FORM ITEM_DATA_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                        PV_ONF4
                        PV_ONF4_BEFORE
                        PV_ONF4_AFTER
                        PV_UCOMM.
  DATA LT_MOD_CELLS TYPE LVC_T_MODI WITH HEADER LINE.
  LT_MOD_CELLS[] = PO_OBJECT->MT_GOOD_CELLS.
  LOOP AT LT_MOD_CELLS ASSIGNING FIELD-SYMBOL(<LS_MOD_CELLS>).
    AT NEW ROW_ID.
      CLEAR GS_ITEM.
      READ TABLE GT_ITEM INTO GS_ITEM INDEX <LS_MOD_CELLS>-ROW_ID.
    ENDAT.
    ASSIGN COMPONENT <LS_MOD_CELLS>-FIELDNAME OF STRUCTURE GS_ITEM TO <GV_FIELD>.
    <GV_FIELD> = <LS_MOD_CELLS>-VALUE.
    _set_alv_cell <LS_MOD_CELLS>-row_id <LS_MOD_CELLS>-fieldname <gv_field>.
    AT END OF ROW_ID.
      READ TABLE GT_ITEM TRANSPORTING NO FIELDS INDEX <LS_MOD_CELLS>-ROW_ID.
      IF SY-SUBRC EQ 0." modify
        IF GS_ITEM-BALV_STATUS_ICON NE ZCL_BRD_ALV_N=>MC_ICON-CREATE.
          GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
        ENDIF.
        _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-BALV_STATUS_ICON GS_ITEM-BALV_STATUS_ICON.
      ELSE."auto added new row
        _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-BALV_STATUS_ICON ZCL_BRD_ALV_N=>MC_ICON-CREATE.
        GO_ITEM->SET_CELLTAB_STYLE( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_CREATE_MODE
                                    CHANGING CT_CELLTAB = GS_ITEM-CELLTAB ).
        LOOP AT GS_ITEM-CELLTAB ASSIGNING FIELD-SYMBOL(<LS_CELLTAB>).
          PO_OBJECT->MODIFY_STYLE( EXPORTING I_ROW_ID    = <LS_MOD_CELLS>-ROW_ID
                                             I_FIELDNAME = <LS_CELLTAB>-FIELDNAME
                                             I_STYLE     = <LS_CELLTAB>-STYLE ).
        ENDLOOP.
        GS_ITEM-balv_status_icon = ZCL_BRD_ALV_N=>mc_icon-create.
        APPEND GS_ITEM TO GT_ITEM.
      ENDIF.
    ENDAT.
  ENDLOOP.
  GO_ITEM->SET_CHANGING_FLAG( ABAP_TRUE ).
ENDFORM.                    "ITEM_DATA_CHANGED
*&---------------------------------------------------------------------*
*&      FORM  HEAD_CARRID_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_CARRID_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                   PV_ROW_ID
                                   PV_VALUE TYPE ANY.
  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
  CLEAR GS_HEAD.
  READ TABLE GT_HEAD
 INTO GS_HEAD INDEX PV_ROW_ID.
  IF SY-SUBRC EQ 0.
    GS_HEAD-CARRID = PV_VALUE.
    _SET_ALV_CELL PV_ROW_ID C_FIELD_HEAD-CARRID PV_VALUE.
    CLEAR GV_ERR.
    PERFORM HEAD_CHECK_PK.
    IF GV_ERR EQ C_E.
      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
    ELSE.
      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
    ENDIF.
    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_HEAD-BALV_STATUS_ICON.
    MODIFY GT_HEAD FROM GS_HEAD INDEX PV_ROW_ID.
  ENDIF.
ENDFORM.                    "HEAD_CARRID_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  HEAD_CARRNAME_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM HEAD_CARRNAME_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_HEAD.
*  READ TABLE GT_HEAD
* INTO GS_HEAD INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_HEAD-CARRNAME = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_HEAD-CARRNAME PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_HEAD-BALV_STATUS_ICON.
*    MODIFY GT_HEAD FROM GS_HEAD INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "HEAD_CARRNAME_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  HEAD_CURRCODE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM HEAD_CURRCODE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_HEAD.
*  READ TABLE GT_HEAD
* INTO GS_HEAD INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_HEAD-CURRCODE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_HEAD-CURRCODE PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_HEAD-BALV_STATUS_ICON.
*    MODIFY GT_HEAD FROM GS_HEAD INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "HEAD_CURRCODE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  HEAD_URL_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM HEAD_URL_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_HEAD.
*  READ TABLE GT_HEAD
* INTO GS_HEAD INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_HEAD-URL = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_HEAD-URL PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_HEAD-BALV_STATUS_ICON.
*    MODIFY GT_HEAD FROM GS_HEAD INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "HEAD_URL_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  HEAD_MANDT_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM HEAD_MANDT_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_HEAD.
*  READ TABLE GT_HEAD
* INTO GS_HEAD INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_HEAD-MANDT = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_HEAD-MANDT PV_VALUE.
*    CLEAR GV_ERR.
*    PERFORM HEAD_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_HEAD-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_HEAD-BALV_STATUS_ICON.
*    MODIFY GT_HEAD FROM GS_HEAD INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "HEAD_MANDT_CHANGED.
*&---------------------------------------------------------------------*
*&      FORM  ITEM_CARRID_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_CARRID_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                   PV_ROW_ID
                                   PV_VALUE TYPE ANY.
  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
  CLEAR GS_ITEM.
  READ TABLE GT_ITEM
 INTO GS_ITEM INDEX PV_ROW_ID.
  IF SY-SUBRC EQ 0.
    GS_ITEM-CARRID = PV_VALUE.
    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-CARRID PV_VALUE.
    CLEAR GV_ERR.
    PERFORM ITEM_CHECK_PK.
    IF GV_ERR EQ C_E.
      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
    ELSE.
      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
    ENDIF.
    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
  ENDIF.
ENDFORM.                    "ITEM_CARRID_CHANGED.
*&---------------------------------------------------------------------*
*&      FORM  ITEM_CONNID_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_CONNID_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                   PV_ROW_ID
                                   PV_VALUE TYPE ANY.
  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
  CLEAR GS_ITEM.
  READ TABLE GT_ITEM
 INTO GS_ITEM INDEX PV_ROW_ID.
  IF SY-SUBRC EQ 0.
    GS_ITEM-CONNID = PV_VALUE.
    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-CONNID PV_VALUE.
    CLEAR GV_ERR.
    PERFORM ITEM_CHECK_PK.
    IF GV_ERR EQ C_E.
      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
    ELSE.
      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
    ENDIF.
    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
  ENDIF.
ENDFORM.                    "ITEM_CONNID_CHANGED.
*&---------------------------------------------------------------------*
*&      FORM  ITEM_FLDATE_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_FLDATE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
                                   PV_ROW_ID
                                   PV_VALUE TYPE ANY.
  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
  CLEAR GS_ITEM.
  READ TABLE GT_ITEM
 INTO GS_ITEM INDEX PV_ROW_ID.
  IF SY-SUBRC EQ 0.
    GS_ITEM-FLDATE = PV_VALUE.
    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-FLDATE PV_VALUE.
    CLEAR GV_ERR.
    PERFORM ITEM_CHECK_PK.
    IF GV_ERR EQ C_E.
      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
    ELSE.
      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
    ENDIF.
    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
  ENDIF.
ENDFORM.                    "ITEM_FLDATE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_PRICE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_PRICE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-PRICE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-PRICE PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_PRICE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_CURRENCY_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_CURRENCY_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-CURRENCY = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-CURRENCY PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_CURRENCY_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_PLANETYPE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_PLANETYPE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-PLANETYPE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-PLANETYPE PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_PLANETYPE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_SEATSMAX_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_SEATSMAX_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-SEATSMAX = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-SEATSMAX PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_SEATSMAX_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_SEATSOCC_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_SEATSOCC_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-SEATSOCC = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-SEATSOCC PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_SEATSOCC_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_PAYMENTSUM_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_PAYMENTSUM_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-PAYMENTSUM = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-PAYMENTSUM PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_PAYMENTSUM_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_SEATSMAX_B_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_SEATSMAX_B_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-SEATSMAX_B = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-SEATSMAX_B PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_SEATSMAX_B_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_SEATSOCC_B_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_SEATSOCC_B_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-SEATSOCC_B = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-SEATSOCC_B PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_SEATSOCC_B_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_SEATSMAX_F_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_SEATSMAX_F_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-SEATSMAX_F = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-SEATSMAX_F PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_SEATSMAX_F_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_SEATSOCC_F_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_SEATSOCC_F_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-SEATSOCC_F = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-SEATSOCC_F PV_VALUE.
*    CLEAR GV_ERR.
**    PERFORM CALL_SUBROUTINE_TO_CHECK_FIELD_VALUE_HERE!.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_SEATSOCC_F_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  ITEM_MANDT_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM ITEM_MANDT_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GS_ITEM.
*  READ TABLE GT_ITEM
* INTO GS_ITEM INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GS_ITEM-MANDT = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_ITEM-MANDT PV_VALUE.
*    CLEAR GV_ERR.
*    PERFORM ITEM_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DEFECT.
*    ELSE.
*      GS_ITEM-BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_ITEM-BALV_STATUS_ICON.
*    MODIFY GT_ITEM FROM GS_ITEM INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "ITEM_MANDT_CHANGED.
*&---------------------------------------------------------------------*
*&      FORM  HEAD_CHECK_PK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM HEAD_CHECK_PK .
  CLEAR : GV_ERR, GV_COUNT.

  SELECT COUNT(*) INTO GV_COUNT
    FROM SCARR
  WHERE CARRID = GS_HEAD-CARRID
.

  IF GV_COUNT GT 0.
    GV_ERR = C_E.
  ENDIF.
ENDFORM.                    " CHECK_PK
*&---------------------------------------------------------------------*
*&      FORM  ITEM_CHECK_PK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM ITEM_CHECK_PK .
  CLEAR : GV_ERR, GV_COUNT.

  SELECT COUNT(*) INTO GV_COUNT
    FROM SFLIGHT
  WHERE CARRID = GS_ITEM-CARRID
    AND CONNID = GS_ITEM-CONNID
    AND FLDATE = GS_ITEM-FLDATE
.

  IF GV_COUNT GT 0.
    GV_ERR = C_E.
  ENDIF.
ENDFORM.                    " CHECK_PK
**&---------------------------------------------------------------------*
**&      FORM  HEAD_SET_TOOLBAR
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
**      -->PV_INTERACTIVE     TEXT
**      -->PO_OBJECT  TEXT
**----------------------------------------------------------------------*
*FORM HEAD_SET_TOOLBAR USING PV_INTERACTIVE
*                       PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET.
*  IF GO_HEAD->GET_ALV_MODE( ) NE ZCL_BRD_ALV_N=>MC_DISPLAY_MODE.
*    GO_HEAD->APPEND_TOOLBAR_BUTTON( EXPORTING
*                                   IV_FUNCTION = 'F01'
*                                   IV_ICON = '' "ICON-ID
*                                   IV_QUICKINFO = ''
*                                   IV_TEXT = 'MY TOOLBAR'
*                                   ).
*  ENDIF.
*ENDFORM.                    "HEAD_SET_TOOLBAR
**&---------------------------------------------------------------------*
**&      FORM  ITEM_SET_TOOLBAR
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
**      -->PV_INTERACTIVE     TEXT
**      -->PO_OBJECT  TEXT
**----------------------------------------------------------------------*
*FORM ITEM_SET_TOOLBAR USING PV_INTERACTIVE
*                       PO_OBJECT TYPE REF TO CL_ALV_EVENT_TOOLBAR_SET.
*  IF GO_ITEM->GET_ALV_MODE( ) NE ZCL_BRD_ALV_N=>MC_DISPLAY_MODE.
*    GO_ITEM->APPEND_TOOLBAR_BUTTON( EXPORTING
*                                   IV_FUNCTION = 'F01'
*                                   IV_ICON = '' "ICON-ID
*                                   IV_QUICKINFO = ''
*                                   IV_TEXT = 'MY TOOLBAR'
*                                   ).
*  ENDIF.
*ENDFORM.                    "ITEM_SET_TOOLBAR
*&---------------------------------------------------------------------*
*&      FORM  SAVE_DATA.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM SAVE_DATA.
  DATA:
        LS_HEAD        TYPE SCARR,
        LT_CREATE_HEAD TYPE TABLE OF SCARR,
        LT_UPDATE_HEAD TYPE TABLE OF SCARR,
        LT_DELETE_HEAD TYPE TABLE OF SCARR.
  DATA:
        LS_ITEM        TYPE SFLIGHT,
        LT_CREATE_ITEM TYPE TABLE OF SFLIGHT,
        LT_UPDATE_ITEM TYPE TABLE OF SFLIGHT,
        LT_DELETE_ITEM TYPE TABLE OF SFLIGHT.
  DATA:
        LV_CREATE_CNT  TYPE SY-DBCNT,
        LV_UPDATE_CNT  TYPE SY-DBCNT,
        LV_DELETE_CNT  TYPE SY-DBCNT.

  CLEAR GT_LOG[].
  CLEAR GS_HEAD.
  LOOP AT GT_HEAD INTO GS_HEAD.
    CLEAR LS_HEAD.
    IF GS_HEAD-BALV_STATUS_ICON IS NOT INITIAL.
      PERFORM HEAD_VERIFY_DATA USING SY-TABIX GS_HEAD.
      MOVE-CORRESPONDING GS_HEAD TO LS_HEAD.
    ENDIF.
    CASE GS_HEAD-BALV_STATUS_ICON.
      WHEN ZCL_BRD_ALV_N=>MC_ICON-CREATE.
        _set_timestamp_create LS_HEAD.
        APPEND LS_HEAD TO LT_CREATE_HEAD.
      WHEN ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
        _set_timestamp_change LS_HEAD.
        APPEND LS_HEAD TO LT_UPDATE_HEAD.
      WHEN ZCL_BRD_ALV_N=>MC_ICON-DELETE.
        APPEND LS_HEAD TO LT_DELETE_HEAD.
    ENDCASE.
    CLEAR GS_HEAD.
  ENDLOOP.

  CLEAR GS_ITEM.
  LOOP AT GT_ITEM INTO GS_ITEM.
    CLEAR LS_ITEM.
    IF GS_ITEM-BALV_STATUS_ICON IS NOT INITIAL.
      PERFORM ITEM_VERIFY_DATA USING SY-TABIX GS_ITEM.
      MOVE-CORRESPONDING GS_ITEM TO LS_ITEM.
    ENDIF.
    CASE GS_ITEM-BALV_STATUS_ICON.
      WHEN ZCL_BRD_ALV_N=>MC_ICON-CREATE.
        _set_timestamp_create LS_ITEM.
        APPEND LS_ITEM TO LT_CREATE_ITEM.
      WHEN ZCL_BRD_ALV_N=>MC_ICON-CHANGE.
        _set_timestamp_change LS_ITEM.
        APPEND LS_ITEM TO LT_UPDATE_ITEM.
      WHEN ZCL_BRD_ALV_N=>MC_ICON-DELETE.
        APPEND LS_ITEM TO LT_DELETE_ITEM.
    ENDCASE.
    CLEAR GS_ITEM.
  ENDLOOP.


  IF GT_LOG[] IS NOT INITIAL.
     ZCL_BRD_ALV_N=>MESSAGE_POPUP( CHANGING CT_MSG = GT_LOG[] ).
    EXIT.
  ENDIF.

  IF ZCL_BRD_ALV_N=>CONFIRM_SAVE( ) NE ABAP_TRUE.
    EXIT.
  ENDIF.

  TRY.
      IF LT_CREATE_HEAD IS NOT INITIAL.
        INSERT SCARR FROM TABLE LT_CREATE_HEAD.
        LV_CREATE_CNT = LV_CREATE_CNT + LINES( LT_CREATE_HEAD ).
      ENDIF.
      IF LT_UPDATE_HEAD IS NOT INITIAL.
        MODIFY SCARR FROM TABLE LT_UPDATE_HEAD.
        LV_UPDATE_CNT = LV_UPDATE_CNT + LINES( LT_UPDATE_HEAD ).
      ENDIF.
      IF LT_DELETE_HEAD IS NOT INITIAL.
        DELETE SCARR FROM TABLE LT_DELETE_HEAD.
        LV_DELETE_CNT = LV_DELETE_CNT + LINES( LT_DELETE_HEAD ).
      ENDIF.
      IF LT_CREATE_ITEM IS NOT INITIAL.
        INSERT SFLIGHT FROM TABLE LT_CREATE_ITEM.
        LV_CREATE_CNT = LV_CREATE_CNT + LINES( LT_CREATE_ITEM ).
      ENDIF.
      IF LT_UPDATE_ITEM IS NOT INITIAL.
        MODIFY SFLIGHT FROM TABLE LT_UPDATE_ITEM.
        LV_UPDATE_CNT = LV_UPDATE_CNT + LINES( LT_UPDATE_ITEM ).
      ENDIF.
      IF LT_DELETE_ITEM IS NOT INITIAL.
        DELETE SFLIGHT FROM TABLE LT_DELETE_ITEM.
        LV_DELETE_CNT = LV_DELETE_CNT + LINES( LT_DELETE_ITEM ).
      ENDIF.
    CATCH CX_ROOT INTO GO_EXCEPTION.
      ZCL_BRD_ALV_N=>CATCH_EXCEPTION( IO_ROOT = GO_EXCEPTION ).
  ENDTRY.
  ZCL_BRD_ALV_N=>MESSAGE_STRIP( EXPORTING IV_CODE = ZCL_BRD_ALV_N=>MC_MSG-SAVE_SUCCESS
                                    IV_PARAM1 = |{ LV_CREATE_CNT }|
                                    IV_PARAM2 = |{ LV_UPDATE_CNT }|
                                    IV_PARAM3 = |{ LV_DELETE_CNT }| ).

  CLEAR GT_HEAD_BUFF[].
  GO_HEAD->SET_CHANGING_FLAG( ABAP_FALSE ).
  DELETE GT_HEAD WHERE BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DELETE.
  LOOP AT GT_HEAD ASSIGNING <GS_HEAD>.
    IF <GS_HEAD>-BALV_STATUS_ICON IS NOT INITIAL.
      CLEAR <GS_HEAD>-BALV_STATUS_ICON.
    ENDIF.
  ENDLOOP.
  CLEAR GT_ITEM_BUFF[].
  GO_ITEM->SET_CHANGING_FLAG( ABAP_FALSE ).
  DELETE GT_ITEM WHERE BALV_STATUS_ICON = ZCL_BRD_ALV_N=>MC_ICON-DELETE.
  LOOP AT GT_ITEM ASSIGNING <GS_ITEM>.
    IF <GS_ITEM>-BALV_STATUS_ICON IS NOT INITIAL.
      CLEAR <GS_ITEM>-BALV_STATUS_ICON.
    ENDIF.
  ENDLOOP.
  GO_HEAD->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_DISPLAY_MODE
                    CHANGING CT_DATA  = GT_HEAD[] ).
  GO_ITEM->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_DISPLAY_MODE
                    CHANGING CT_DATA  = GT_ITEM[] ).
ENDFORM.                    "SAVE_DATA
