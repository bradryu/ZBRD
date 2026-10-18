*************************************************************************
* MODULES / SUB MODULE :  /
*&---------------------------------------------------------------------
* T_CODE             : ZLBRD99010
* WRITER             : BALV
* DATE               : 2025.05.27
* TYPE               : REPORT
* DESCRIPTION        :
*
*************************************************************************
*              CHANGED HISTORY
*&---------------------------------------------------------------------**
*CHANGED  CHANGED DATE   WRITER       CR No.     DESCRIPTION
*&---------------------------------------------------------------------**
*  N      2025.05.27     BALV                    CREATE       *
*************************************************************************
REPORT ZLBRD99010 NO STANDARD PAGE HEADING.

INCLUDE ZNBRD00010.
INCLUDE ZNBRD00020.
*INCLUDE ZNBRD00030.
INCLUDE ZLBRD99010TOP.
INCLUDE ZLBRD99010F01.
*&---------------------------------------------------------------------**
* INITIALIZATION.
*&---------------------------------------------------------------------**
INITIALIZATION.
  PERFORM SET_INIT_VALUE.
*&---------------------------------------------------------------------**
*  AT SELECTION-SCREEN
*&---------------------------------------------------------------------**
AT SELECTION-SCREEN.
  CASE SY-DYNNR.
    WHEN 1000.
      CASE SY-UCOMM.
        WHEN C_UCOMM-DISPLAY.
          GO_TAB-DYNNR = 010.
          GO_TAB-ACTIVETAB = SY-UCOMM.
        WHEN C_UCOMM-UPLOAD.
          GO_TAB-DYNNR = 020.
          GO_TAB-ACTIVETAB = SY-UCOMM.
      ENDCASE.
      IF SSCRFIELDS-UCOMM EQ 'SAMP'.
        ZCL_BRD_ALV_N=>GET_ALV_ITAB( IMPORTING EO_DATA = GO_DOWNLOAD_DATA
                                             ET_HEADER_LABEL = GT_EXCEL_HEADER ).
        ASSIGN GO_DOWNLOAD_DATA->* TO <GT_DOWNLOAD_TAB>.
        ZCL_BRD_ALV_N=>ITAB_TO_EXCEL_DOWNLOAD( EXPORTING IT_HEADER = GT_EXCEL_HEADER
                                                         IT_TAB = <GT_DOWNLOAD_TAB>  ).
      ENDIF.
  ENDCASE.
*&---------------------------------------------------------------------**
* AT SELECTION-SCREEN ON VALUE-REQUEST                                 *
*&---------------------------------------------------------------------**
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  ZCL_BRD_ALV_N=>ADD_EXCEL_FILE_OPEN_DIALOG( CHANGING CV_FILE = P_FILE ).
*&---------------------------------------------------------------------*
*& START-OF-SELECTION.
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM CHECK_AUTHORITY.
  CASE GO_TAB-ACTIVETAB.
    WHEN C_UCOMM-DISPLAY.
      PERFORM GET_BALV_DATA.
    WHEN C_UCOMM-UPLOAD.
      PERFORM UPLOAD_BALV_DATA USING ABAP_FALSE P_FILE.
      IF GV_ERR = ABAP_TRUE.
        EXIT.
      ENDIF.
  ENDCASE.
*---------------------------------------------------------------------*
* END-OF-SELECTION.
*---------------------------------------------------------------------*
END-OF-SELECTION.
  IF SY-BATCH IS INITIAL.
    CALL SCREEN 100.
  ENDIF.
