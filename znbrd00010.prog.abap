*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
* Modules / Sub Module : CM /
*&---------------------------------------------------------------------
* T_CODE             : ZNBRD00010
* WRITER             : BRAD.RYU
* DATE               : 2015.12.10
* TYPE               : Include Report
* Description        : 공통 변수 include프로그램
*
*************************************************************************
*              Changed History
*&---------------------------------------------------------------------**
*Changed Number     Changed Date   Writer    Changed      Description
*&---------------------------------------------------------------------**
*      N            2015.12.10    BRAD.RYU   CREATE       CREATE       *
*************************************************************************
************************************************************************
* Types                                                                *
************************************************************************

TYPE-POOLS:SGUI, "Typen und Konstanten f#r Funktionsgruppe SGUI
           STREE,"Hierarchiebausteine
           SLIS. "Globale Typen f#r generische Listbausteine
TYPE-POOLS:SLIS.

************************************************************************
* Tables                                                               *
************************************************************************

TABLES : SSCRFIELDS.
TABLES : ICON.

************************************************************************
* Include                                                              *
************************************************************************
*OLE
INCLUDE <ICON>.
************************************************************************
* TYPES                                                              *
************************************************************************
TYPES: BEGIN OF GS_SCREEN_SELECT_OPTION,
         STATE TYPE ICONS-TEXT,
         MULTI TYPE ICONS-TEXT,
         EX    TYPE CHAR4,
         ICON  TYPE CHAR4,
       END OF GS_SCREEN_SELECT_OPTION.

************************************************************************
* DEFINITION
************************************************************************
DEFINE _REMOVE_1ST_CHR.
  IF &1 IS NOT INITIAL AND &1(1) EQ &2.
    &1 = &1+1.
  ENDIF.
END-OF-DEFINITION.
DEFINE _SET_ACTIVE_SCREEN.
  IF &1 EQ c_x AND screen-group1 EQ &2.
    screen-input = 1 .
    screen-invisible = 0 .
  ENDIF.
END-OF-DEFINITION.
DEFINE _INIT.
  CLEAR &1. REFRESH &1.
END-OF-DEFINITION.
************************************************************************
* Field Symbols
************************************************************************

FIELD-SYMBOLS:<GV_FIELD>.
FIELD-SYMBOLS:<GV_F4TAB> TYPE LVC_T_MODI.
FIELD-SYMBOLS:<GV_ROW1> TYPE LVC_S_ROID,
              <GV_ROW2> TYPE LVC_S_ROID.
FIELD-SYMBOLS <GT_DOWNLOAD_TAB> TYPE STANDARD TABLE.




************************************************************************
* Ranges                                                               *
************************************************************************

RANGES:GR_DATUM FOR SY-DATUM.


************************************************************************
* Internal Table                                                       *
************************************************************************
*BDC

DATA : GT_BDCTAB LIKE BDCDATA OCCURS 0 WITH HEADER LINE,
       GT_BDCMSG LIKE BDCMSGCOLL OCCURS 0 WITH HEADER LINE.


************************************************************************
* Global Data                                                          *
************************************************************************
DATA : GT_EXCEL TYPE SOI_GENERIC_TABLE,
       GS_EXCEL TYPE SOI_GENERIC_ITEM.

*F4
DATA : GT_DYNPREAD   LIKE DYNPREAD OCCURS 0 WITH HEADER LINE,
       GT_DDSHRETVAL LIKE DDSHRETVAL OCCURS 0 WITH HEADER LINE,
       GT_HELP_VALUE LIKE HELP_VALUE OCCURS 0 WITH HEADER LINE,
       GT_HELP_VTAB  LIKE HELP_VTAB  OCCURS 0  WITH HEADER LINE.

*Global Data
DATA : GV_COUNT        TYPE I,
       GV_FIRST        TYPE C,
       GV_FLAG         TYPE C,
       GV_ERR          TYPE C, "Error flag
       GV_SIGN         TYPE C,
       GV_EXIT         TYPE C,
       GV_BDCMODE      TYPE CTU_MODE, "BDC MODE,
       GV_VALDATE      LIKE SY-DATUM,
       GV_SDATE        LIKE SY-DATUM,               "##
       GV_EDATE        LIKE SY-DATUM,               "#####
       GV_DAY          TYPE I,                      "##
       GV_CAL_DAY      TYPE I,                      "####
       GV_MONTH        TYPE N LENGTH 2,                      "##
       GV_YEAR         TYPE N LENGTH 4,                      "##
       GV_OPT          LIKE CTU_PARAMS,
       GV_ANSWER(10)   TYPE C, "Answer
       GV_OKCODE       LIKE SY-UCOMM, "ok code
       GV_SAVE_OKCODE  LIKE SY-UCOMM,
       GV_FILENAME     TYPE RLGRAP-FILENAME,
       GV_MSGTY        LIKE SY-MSGTY,
       GV_FILENAME01   TYPE STRING,
       GV_FILETYPE(10) TYPE C,
       GV_MESSAGE(100),
       GV_FVAL(15),
       GV_SAVE,
       GV_REPID        TYPE SY-REPID,
       GV_PROGRAM_NAME LIKE SY-REPID,
       GV_INCLNAME     LIKE TRDIR-NAME,
       GV_EXTENSION    TYPE I,
       GV_CHECKFLD(10),
       GV_MARKFLD(10),
       GV_REPMODE(10),   "REPORT EXECUTE MODE(UPLOAD, DISPLAY)
       GV_STATUS,     "######(X = #### ##)
       GV_LOCK,       "Lock = 'L', Unlock = 'U', Error = 'E'.
       GV_SUBRC        LIKE SY-SUBRC,
       GV_DATUM        LIKE SY-DATUM,
       GV_SDATUM       LIKE SY-DATUM,
       GV_EDATUM       LIKE SY-DATUM,
       GV_WEEK         TYPE SCAL-WEEK,
       GV_DYNNR        LIKE SY-DYNNR,
       GV_CPROG        LIKE SY-CPROG,
       GV_FLDVALUE     LIKE HELP_INFO-FLDVALUE,
       GV_FIELDNAME    LIKE HELP_INFO-DYNPROFLD,
       GV_TABIX        LIKE SY-TABIX,
       GV_LINE         TYPE I,
       GV_WIDTH        TYPE I,
       GV_HEIGHT       TYPE I,
       GV_INDEX        TYPE LVC_INDEX,
       GV_MSG          TYPE STRING,
       GV_STR          TYPE STRING,
       GV_TMP_STR      TYPE STRING,
       GV_CURSOR_FIELD TYPE FIELDNAME.

DATA : GV_TIMESTAMP TYPE TIMESTAMP.

DATA : GS_LAYOUT      TYPE LVC_S_LAYO,
       GS_ALV_VARIANT LIKE DISVARIANT.
DATA : GS_FIELDCAT TYPE LVC_S_FCAT.

*. Function Code 관리
DATA: BEGIN OF GT_EXCLUDE OCCURS 10,
        FCODE LIKE RSMPE-FUNC,                    " (GUI CODE)
      END   OF GT_EXCLUDE.
************************************************************************
* F4 Possible Entry
************************************************************************
*Structures
DATA : GS_F4_VALUE TYPE SEAHLPRES,
       GS_F4_FIELD TYPE DFIES,
       GS_F4       TYPE DDSHRETVAL,
       GS_LVC_MODI TYPE LVC_S_MODI,
       GS_LVC_F4   TYPE LVC_S_F4,
       GS_LVC_F4_2 TYPE LVC_S_F4.


*Internal tables
DATA : GT_F4_VALUES TYPE TABLE OF SEAHLPRES,
       GT_F4_FIELDS TYPE TABLE OF DFIES,
       GT_LVC_F4    TYPE LVC_T_F4,
       GT_LVC_F4_2  TYPE LVC_T_F4.

************************************************************************
* Object
************************************************************************
DATA : GO_SPLITTER_CONTAINER_OUT TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
       GO_SPLITTER_CONTAINER_IN  TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
       GO_CONTAINER              TYPE REF TO CL_GUI_CONTAINER,
       GO_CUSTOM_CONTAINER       TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
       GO_CONTAINER_DESC         TYPE REF TO CL_GUI_CONTAINER,
       GO_CONTAINER_FOR_INNER_SP TYPE REF TO CL_GUI_CONTAINER,
       GO_CONTAINER_TITLE        TYPE REF TO CL_GUI_CONTAINER,
       GO_DOCUMENT               TYPE REF TO CL_DD_DOCUMENT,
       GO_HTML_VIEWR             TYPE REF TO CL_GUI_HTML_VIEWER,
       GO_DOCKING_CONTAINER      TYPE REF TO CL_GUI_DOCKING_CONTAINER.

DATA : GT_ROWS    TYPE LVC_T_ROW,
       GS_ROWS    TYPE LVC_S_ROW,
       GT_ROW_IDS TYPE LVC_T_ROID,
       GS_ROW_ID  TYPE LVC_S_ROID,
       GT_CELLTAB TYPE LVC_T_STYL.
DATA : GS_MOD_CELLS  TYPE LVC_S_MODI.
DATA : GO_CL_MENU_XLS TYPE REF TO CL_CTMENU,
       GS_STBL        TYPE LVC_S_STBL.
DATA : GO_EXCEPTION  TYPE REF TO CX_ROOT.
DATA : GT_EXCEL_DATA TYPE SOI_GENERIC_TABLE,
       GS_EXCEL_DATA TYPE SOI_GENERIC_ITEM.


DATA : BEGIN OF GT_LOG OCCURS 0,
         ICON   TYPE ICON-ID,
         ROW_NO TYPE SY-TABIX,
         MSG    TYPE RSTXTLG,
       END OF GT_LOG.
DATA : BEGIN OF GS_CREATE_TIMESTAMP,
         ERNAM TYPE SY-UNAME,
         ERDAT TYPE SY-DATUM,
         ERZET TYPE SY-UZEIT,
         AENAM TYPE SY-UNAME,
         AEDAT TYPE SY-DATUM,
         AEZET TYPE SY-UZEIT,
       END OF GS_CREATE_TIMESTAMP.
DATA : BEGIN OF GS_CHANGE_TIMESTAMP,
         AENAM TYPE SY-UNAME,
         AEDAT TYPE SY-DATUM,
         AEZET TYPE SY-UZEIT,
       END OF GS_CHANGE_TIMESTAMP.
DATA : GO_DOWNLOAD_DATA TYPE REF TO DATA,
       GT_EXCEL_HEADER  TYPE STRING_TABLE.
************************************************************************
* Constants                                                            *
************************************************************************

CONSTANTS:C_A(1)    TYPE C VALUE 'A',
          C_B(1)    TYPE C VALUE 'B',
          C_C(1)    TYPE C VALUE 'C',
          C_D(1)    TYPE C VALUE 'D',
          C_E(1)    TYPE C VALUE 'E',
          C_F(1)    TYPE C VALUE 'F',
          C_G(1)    TYPE C VALUE 'G',
          C_H(1)    TYPE C VALUE 'H',
          C_I(1)    TYPE C VALUE 'I',
          C_J(1)    TYPE C VALUE 'J',
          C_K(1)    TYPE C VALUE 'K',
          C_L(1)    TYPE C VALUE 'L',
          C_M(1)    TYPE C VALUE 'M',
          C_N(1)    TYPE C VALUE 'N',
          C_O(1)    TYPE C VALUE 'O',
          C_P(1)    TYPE C VALUE 'P',
          C_Q(1)    TYPE C VALUE 'Q',
          C_R(1)    TYPE C VALUE 'R',
          C_S(1)    TYPE C VALUE 'S',
          C_T(1)    TYPE C VALUE 'T',
          C_U(1)    TYPE C VALUE 'U',
          C_V(1)    TYPE C VALUE 'V',
          C_W(1)    TYPE C VALUE 'W',
          C_X(1)    TYPE C VALUE 'X',
          C_Y(1)    TYPE C VALUE 'Y',
          C_Z(1)    TYPE C VALUE 'Z',
          C_0(1)    TYPE C VALUE '0',
          C_1(1)    TYPE C VALUE '1',
          C_2(1)    TYPE C VALUE '2',
          C_3(1)    TYPE C VALUE '3',
          C_4(1)    TYPE C VALUE '4',
          C_5(1)    TYPE C VALUE '5',
          C_6(1)    TYPE C VALUE '6',
          C_7(1)    TYPE C VALUE '7',
          C_8(1)    TYPE C VALUE '8',
          C_9(1)    TYPE C VALUE '9',
          C_ZERO    TYPE C LENGTH 1 VALUE '0',
          C_ZERO2   TYPE C LENGTH 2 VALUE '00',
          C_ZERO3   TYPE C LENGTH 3 VALUE '000',
          C_ZERO4   TYPE C LENGTH 4 VALUE '0000',
          C_ZERO5   TYPE C LENGTH 5 VALUE '00000',
          C_SPACE   TYPE C LENGTH 1 VALUE ' ',
          C_PERCENT TYPE C LENGTH 1 VALUE '%',
          C_MINUS   TYPE C LENGTH 1 VALUE '-',
          C_SEPAR   TYPE C LENGTH 1 VALUE '|',
          C_AST     TYPE C LENGTH 1 VALUE '*',
          C_EQ      TYPE C LENGTH 2 VALUE 'EQ',
          C_BT      TYPE C LENGTH 2 VALUE 'BT',
          C_CP      TYPE C LENGTH 2 VALUE 'CP',
          C_IEQ     TYPE C LENGTH 3 VALUE 'IEQ',
          C_EEQ     TYPE C LENGTH 3 VALUE 'EEQ',
          C_ILE     TYPE C LENGTH 3 VALUE 'ILE',
          C_ELE     TYPE C LENGTH 3 VALUE 'ELE',
          C_IGE     TYPE C LENGTH 3 VALUE 'IGE',
          C_EGE     TYPE C LENGTH 3 VALUE 'EGE',
          C_IGT     TYPE C LENGTH 3 VALUE 'IGT',
          C_EGT     TYPE C LENGTH 3 VALUE 'EGT',
          C_ILT     TYPE C LENGTH 3 VALUE 'ILT',
          C_ELT     TYPE C LENGTH 3 VALUE 'ELT',
          C_IBT     TYPE C LENGTH 3 VALUE 'IBT',
          C_EBT     TYPE C LENGTH 3 VALUE 'EBT',
          C_ICP     TYPE C LENGTH 3 VALUE 'ICP',
          C_ECP     TYPE C LENGTH 3 VALUE 'ECP',
          C_IP0     TYPE C LENGTH 3 VALUE 'IP0', "screen group
          C_IP1     TYPE C LENGTH 3 VALUE 'IP1', "screen group
          C_KR      LIKE TFACD-IDENT VALUE 'KR', "##
          C_YES     TYPE C    VALUE '1', "yes
          C_NO      TYPE C    VALUE '2'. "no

CONSTANTS : C_LANGU_EN TYPE SY-LANGU VALUE 'E'.

*BDC Message ID
CONSTANTS:C_MSGID_F5 LIKE BDCMSGCOLL-MSGID VALUE 'F5',
          C_MSGID_06 LIKE BDCMSGCOLL-MSGID VALUE '06',
          C_MSGID_BP LIKE BDCMSGCOLL-MSGID VALUE 'BP',
          C_MSGID_FP LIKE BDCMSGCOLL-MSGID VALUE 'FP',
          C_MSGID_M1 LIKE BDCMSGCOLL-MSGID VALUE 'M1',
          C_MSGID_M7 LIKE BDCMSGCOLL-MSGID VALUE 'M7'.

CONSTANTS:C_RFSH    TYPE CHAR04 VALUE 'RFSH', "Refresh
          C_CREA    TYPE CHAR04 VALUE 'CREA', "Create
          C_CHAN    TYPE CHAR04 VALUE 'CHAN', "Change
          C_DISP    TYPE CHAR04 VALUE 'DISP', "Display
          C_DELE    TYPE CHAR04 VALUE 'DELE', "Delete
          C_UPLD    TYPE CHAR04 VALUE 'UPLD', "Upload
          C_CANC    TYPE CHAR04 VALUE 'CANC', "Cancle
          C_EXEC    TYPE CHAR04 VALUE 'EXEC', "Excute
          C_OPEN    TYPE CHAR04 VALUE 'OPEN', "Excute
          C_BACK    TYPE SY-UCOMM VALUE 'BACK', "Back
          C_EXIT    TYPE SY-UCOMM VALUE 'EXIT', "Exit
          C_SAVE    TYPE SY-UCOMM VALUE 'SAVE', "Save
          C_POST    TYPE SY-UCOMM VALUE 'POST', "Posting
          C_REVE    TYPE SY-UCOMM VALUE 'REVE', "Reversed
          C_SIMU    TYPE SY-UCOMM VALUE 'SIMU', "Simulate
          C_PRNT    TYPE SY-UCOMM VALUE 'PRNT', "Print
          C_PREV    TYPE SY-UCOMM VALUE 'PREV', "Preview
          C_PRIN    TYPE SY-UCOMM VALUE 'PRIN', "Print
          C_HIST    TYPE SY-UCOMM VALUE 'HIST', "History
          C_DBCLICK TYPE SY-UCOMM VALUE 'DBCLK',
          C_CANCEL  TYPE SY-UCOMM VALUE 'CANCEL'. "cancel
CONSTANTS : C_NEWLINE TYPE C VALUE CL_ABAP_CHAR_UTILITIES=>NEWLINE,
            C_HTAB    TYPE C VALUE CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB,
            C_VTAB    TYPE C VALUE CL_ABAP_CHAR_UTILITIES=>VERTICAL_TAB.

CONSTANTS : C_ROOT    TYPE C LENGTH 12 VALUE '000000000000',
            C_NODE_ID TYPE TV_NODEKEY VALUE '1'.
CONSTANTS : C_ALV_BLUE(4)      VALUE 'C100',
            C_ALV_GRAY(4)      VALUE 'C200',
            C_ALV_YELLOW(4)    VALUE 'C300',
            C_ALV_BLUE_GRAY(4) VALUE 'C400',
            C_ALV_GREEN(4)     VALUE 'C500',
            C_ALV_RED(4)       VALUE 'C600'.

CONSTANTS : C_HTC_COMPANY  TYPE BUKRS VALUE 'G100',
            C_DHTC_COMPANY TYPE BUKRS VALUE 'G610',
            C_SHTC_COMPANY TYPE BUKRS VALUE 'G620',
            C_KRW          TYPE WAERS VALUE 'KRW'.

CONSTANTS : C_TZ_SYSTEM TYPE TTZZ-TZONE VALUE 'UTC+9',
            C_TZ_HTC    TYPE TTZZ-TZONE VALUE 'UTC+9',
            C_TZ_DHTC   TYPE TTZZ-TZONE VALUE 'UTC+8'.


CONSTANTS : BEGIN OF C_UCOMM,
              REFRESH  TYPE UI_FUNC VALUE 'RFSH', "Refresh
              CREATE   TYPE UI_FUNC VALUE 'CREA', "Create
              INSERT   TYPE UI_FUNC VALUE 'INST', "Insert
              CHANGE   TYPE UI_FUNC VALUE 'CHAN', "Change
              DISPLAY  TYPE UI_FUNC VALUE 'DISP', "Display
              DELETE   TYPE UI_FUNC VALUE 'DELE', "Delete
              XLS      TYPE UI_FUNC VALUE '$XLS', "Excel
              UPLOAD   TYPE UI_FUNC VALUE 'UPLD', "Upload
              DOWNLOAD TYPE UI_FUNC VALUE '&XXL', "Download
              CANCEL   TYPE UI_FUNC VALUE 'CANC', "Cancle
              EXCUTE   TYPE UI_FUNC VALUE 'EXEC', "Excute
              OPEN     TYPE UI_FUNC VALUE 'OPEN', "Excute
              BACK     TYPE SY-UCOMM VALUE 'BACK', "Back
              EXIT     TYPE SY-UCOMM VALUE 'EXIT', "Exit
              SAVE     TYPE SY-UCOMM VALUE 'SAVE', "Save
              SIMULATE TYPE SY-UCOMM VALUE 'SIMU', "Simulate
              PRINT    TYPE SY-UCOMM VALUE 'PRNT', "Print
              DBCLICK  TYPE SY-UCOMM VALUE 'DBCLK',
              ENTER    TYPE SY-UCOMM VALUE 'ENTER',
            END OF C_UCOMM.
CONSTANTS : BEGIN OF C_FIELD,
              MANDT            TYPE FIELDNAME VALUE 'MANDT',
              BALV_STATUS_ICON TYPE FIELDNAME VALUE 'BALV_STATUS_ICON',
              CELLTAB          TYPE FIELDNAME VALUE 'CELLTAB',
              COLTAB           TYPE FIELDNAME VALUE 'COLTAB',
              RCOLOR           TYPE FIELDNAME VALUE 'RCOLOR',
              ERDAT            TYPE FIELDNAME VALUE 'ERDAT',
              ERZET            TYPE FIELDNAME VALUE 'ERZET',
              ERNAM            TYPE FIELDNAME VALUE 'ERNAM',
              AEDAT            TYPE FIELDNAME VALUE 'AEDAT',
              AEZET            TYPE FIELDNAME VALUE 'AEZET',
              AENAM            TYPE FIELDNAME VALUE 'AENAM',
            END OF C_FIELD.
