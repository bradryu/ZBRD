*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD00120F01
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*      MODULE  SET_ALV_SCREEN  OUTPUT
*---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE set_screen OUTPUT.
  SET PF-STATUS '0100' EXCLUDING gt_exclude.
  SET TITLEBAR  '0100' WITH TEXT-t00.
ENDMODULE.                 " SET_ALV_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*&      MODULE  SET_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE set_alv OUTPUT.
  IF go_splitter_container_out IS INITIAL.
    CREATE OBJECT go_splitter_container_out
      EXPORTING
        parent  = cl_gui_container=>default_screen
        rows    = 2
        columns = 1.
    go_container_title = go_splitter_container_out->get_container( row = 1 column = 1 ).
    go_container_balv = go_splitter_container_out->get_container( row = 2 column = 1 ).
    go_splitter_container_out->set_row_height( id = 1 height = 20 ).
    CREATE OBJECT go_document.

    PERFORM set_title.

    go_document->display_document( parent = go_container_title ).
  ENDIF.

  IF go_balv IS INITIAL.
    CREATE OBJECT go_balv
      EXPORTING
        io_parent = go_container_balv.

    go_balv->display( CHANGING ct_data = gt_balv[] ).
  ELSE.
    go_balv->refresh( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      MODULE  EXIT_SCREEN  INPUT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
MODULE exit_screen INPUT.
  CASE gv_okcode.
    WHEN c_canc OR c_back.
      CASE go_balv->get_alv_mode( ).
        WHEN zcl_brd_alv_n=>mc_display_mode.
          LEAVE TO SCREEN 0.
*        WHEN ZCL_BRD_ALV_N=>MC_UPLOAD_MODE.
*          LEAVE TO SCREEN 0.
        WHEN zcl_brd_alv_n=>mc_create_mode.
          PERFORM balv_canc_click.
        WHEN zcl_brd_alv_n=>mc_change_mode.
          PERFORM balv_canc_click.
      ENDCASE.
    WHEN c_exit.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR gv_okcode.
ENDMODULE.                 " EXIT_SCREEN  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command INPUT.
  CASE gv_okcode.
    WHEN c_ucomm-save.
      PERFORM save_data.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      FORM  SET_INIT_VALUE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM set_init_value .
  _init : gt_balv.
  text009 = TEXT-t09. "'Select Options'.
  text010 = 'User Name'."text-t10
*  TEXT011 = 'Define(Global)'."text-t11
*  TEXT012 = 'Define(Local)'."text-t12
*  TEXT013 = 'Type(Global)'."text-t13
*  TEXT014 = 'Type(Local)'."text-t14
*  TEXT015 = 'Table Type(Global)'."text-t15
*  TEXT016 = 'Table Type(Local)'."text-t16
*  TEXT017 = 'Constants(Global)'."text-t17
*  TEXT018 = 'Constants(Local)'."text-t18
*  TEXT019 = 'FieldSymbol(Global)'."text-t19
*  TEXT020 = 'FieldSymbol(Local)'."text-t20
*  TEXT021 = 'FieldSymbol Value(Global)'."text-t21
*  TEXT022 = 'FieldSymbol Value(Local)'."text-t22
*  TEXT023 = 'FieldSymbol Wa(Global)'."text-t23
*  TEXT024 = 'FieldSymbol Wa(Local)'."text-t24
*  TEXT025 = 'FieldSymbol Table(Global)'."text-t25
*  TEXT026 = 'FieldSymbol Table(Local)'."text-t26
*  TEXT027 = 'FieldSymbol Object(Global)'."text-t27
*  TEXT028 = 'FieldSymbol Object(Local)'."text-t28
*  TEXT029 = 'Screen Parameter'."text-t29
*  TEXT030 = 'Screen Select-Options'."text-t30
*  TEXT031 = 'Data(Global)'."text-t31
*  TEXT032 = 'Data(Local)'."text-t32
*  TEXT033 = 'Internal Table(Global)'."text-t33
*  TEXT034 = 'Internal Table(Local)'."text-t34
*  TEXT035 = 'Object(Global)'."text-t35
*  TEXT036 = 'Object(Local)'."text-t36
*  TEXT037 = 'Work Area(Global)'."text-t37
*  TEXT038 = 'Work Area(Local)'."text-t38
*  TEXT039 = 'Form Import Value'."text-t39
*  TEXT040 = 'Form Import Structure'."text-t40
*  TEXT041 = 'Form Import Table'."text-t41
*  TEXT042 = 'Form Change Value'."text-t42
*  TEXT043 = 'Form Change Structure'."text-t43
*  TEXT044 = 'Form Change Table'."text-t44
*  TEXT045 = 'Form Table Parameter'."text-t45
*  TEXT046 = 'Create User'."text-t46
*  TEXT047 = 'Create Date'."text-t47
*  TEXT048 = 'Create Time'."text-t48
*  TEXT049 = 'Change User'."text-t49
*  TEXT050 = 'Change Date'."text-t50
*  TEXT051 = 'Change Time'."text-t51

ENDFORM.                    " SET_INIT_VALUE
*&---------------------------------------------------------------------*
*&      FORM  CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM check_authority .

ENDFORM.                    " CHECK_AUTHORITY
*&---------------------------------------------------------------------*
*&      FORM  GET_BALV_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM get_balv_data .
  _init : gt_balv.
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE gt_balv
    FROM ztbrd00120
    WHERE uname IN so_uname
*      AND G_DEFINE IN SO_G_DEF
*      AND L_DEFINE IN SO_L_DEF
*      AND G_TYPE IN SO_G_TYP
*      AND L_TYPE IN SO_L_TYP
*      AND G_T_TYPE IN SO_G_T_T
*      AND L_T_TYPE IN SO_L_T_T
*      AND G_CONSTANTS IN SO_G_CON
*      AND L_CONSTANTS IN SO_L_CON
*      AND G_FIELDSYMBOL IN SO_G_FIL
*      AND L_FIELDSYMBOL IN SO_L_FIL
*      AND G_FIELDSYMBOL_V IN SO_G_F21
*      AND L_FIELDSYMBOL_V IN SO_L_F22
*      AND G_FIELDSYMBOL_S IN SO_G_F23
*      AND L_FIELDSYMBOL_S IN SO_L_F24
*      AND G_FIELDSYMBOL_T IN SO_G_F25
*      AND L_FIELDSYMBOL_T IN SO_L_F26
*      AND G_FIELDSYMBOL_O IN SO_G_F27
*      AND L_FIELDSYMBOL_O IN SO_L_F28
*      AND PARAMETERS IN SO_PARAM
*      AND SELECTOPTION IN SO_SELEC
*      AND G_DATA IN SO_G_DAT
*      AND L_DATA IN SO_L_DAT
*      AND G_ITAB IN SO_G_ITA
*      AND L_ITAB IN SO_L_ITA
*      AND G_OBJ IN SO_G_OBJ
*      AND L_OBJ IN SO_L_OBJ
*      AND G_WA IN SO_G_WA
*      AND L_WA IN SO_L_WA
*      AND FORM_IV IN SO_FORM_
*      AND FORM_IS IN SO_FOR40
*      AND FORM_IT IN SO_FOR41
*      AND FORM_CV IN SO_FOR42
*      AND FORM_CS IN SO_FOR43
*      AND FORM_CT IN SO_FOR44
*      AND FORM_TT IN SO_FOR45
*      AND ERNAM IN SO_ERNAM
*      AND ERDAT IN SO_ERDAT
*      AND ERZET IN SO_ERZET
*      AND AENAM IN SO_AENAM
*      AND AEDAT IN SO_AEDAT
*      AND AEZET IN SO_AEZET
.
ENDFORM.                    "GET_BALV_DATA
**&---------------------------------------------------------------------*
**&      FORM  UPLOAD_BALV_DATA
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM UPLOAD_BALV_DATA USING PV_FILE_DIALOG PV_FILE_NAME.
*  DATA LT_TAB TYPE TABLE OF GTY_BALV.
*  DATA LS_TAB TYPE GTY_BALV.
*  CLEAR GV_ERR.
*  CALL METHOD ZCL_BRD_ALV_N=>EXCEL_UPLOAD
*    EXPORTING
*      IV_FILE_DIALOG = PV_FILE_DIALOG
*      IV_FILE_NAME   = PV_FILE_NAME
*    CHANGING
*      CT_DATA        = LT_TAB[]
*    RECEIVING
*      EV_SUBRC       = GV_SUBRC.
*  IF GV_SUBRC EQ 0.
*    LOOP AT LT_TAB INTO LS_TAB.
*      MOVE-CORRESPONDING LS_TAB TO GT_BALV.
*      APPEND GT_BALV.
*      CLEAR : LS_TAB, GT_BALV.
*    ENDLOOP.
*    GO_BALV->SET_CHANGING_FLAG( ABAP_TRUE ).
*  ELSE.
*    MESSAGE S004(ZBRD001) DISPLAY LIKE C_E.
*    GV_ERR = ABAP_TRUE.
*  ENDIF.
*
*ENDFORM.                    " UPLOAD_DATA
*&---------------------------------------------------------------------*
*&      FORM  SET_TITLE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM set_title .
  DATA : lo_tab  TYPE REF TO cl_dd_table_element,
         lo_col1 TYPE REF TO cl_dd_area,
         lo_col2 TYPE REF TO cl_dd_area,
         lv_text TYPE sdydo_text_element.

  lv_text = text009.
  go_document->add_text( EXPORTING text = lv_text
                                   sap_emphasis = cl_dd_area=>strong
                                   sap_fontsize = cl_dd_area=>large ).
  go_document->new_line( ).
  go_document->new_line( ).

  go_document->add_table( EXPORTING no_of_columns = 2
                                    border        = '0'
                                    width = '100%'
                          IMPORTING table         = lo_tab ).

  lo_tab->add_column( EXPORTING width  = '10%'
                      IMPORTING column = lo_col1 ).
  lo_tab->add_column( EXPORTING width  = '90%'
                      IMPORTING column = lo_col2 ).
  IF so_uname-low IS NOT INITIAL.
    lv_text = text010.
    lo_col1->add_text( EXPORTING text         = lv_text
                                 sap_color    = cl_dd_area=>list_background_int
                                 sap_emphasis = cl_dd_area=>strong ).
    lv_text = so_uname-low.
    lo_col2->add_text( EXPORTING text         = lv_text ).
    lo_tab->new_row( ).
  ENDIF.
*  IF *SO_G_DEF-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT011.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_DEF-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_DEF-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT012.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_DEF-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_TYP-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT013.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_TYP-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_TYP-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT014.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_TYP-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_T_T-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT015.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_T_T-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_T_T-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT016.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_T_T-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_CON-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT017.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_CON-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_CON-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT018.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_CON-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_FIL-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT019.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_FIL-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_FIL-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT020.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_FIL-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_F21-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT021.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_F21-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_F22-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT022.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_F22-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_F23-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT023.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_F23-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_F24-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT024.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_F24-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_F25-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT025.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_F25-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_F26-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT026.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_F26-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_F27-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT027.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_F27-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_F28-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT028.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_F28-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_PARAM-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT029.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_PARAM-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_SELEC-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT030.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_SELEC-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_DAT-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT031.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_DAT-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_DAT-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT032.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_DAT-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_ITA-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT033.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_ITA-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_ITA-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT034.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_ITA-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_OBJ-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT035.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_OBJ-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_OBJ-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT036.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_OBJ-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_G_WA-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT037.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_G_WA-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_L_WA-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT038.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_L_WA-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_FORM_-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT039.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_FORM_-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_FOR40-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT040.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_FOR40-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_FOR41-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT041.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_FOR41-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_FOR42-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT042.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_FOR42-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_FOR43-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT043.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_FOR43-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_FOR44-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT044.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_FOR44-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_FOR45-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT045.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_FOR45-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_ERNAM-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT046.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_ERNAM-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_ERDAT-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT047.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_ERDAT-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_ERZET-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT048.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_ERZET-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_AENAM-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT049.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_AENAM-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_AEDAT-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT050.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_AEDAT-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.
*  IF *SO_AEZET-LOW IS NOT INITIAL.
*    LV_TEXT = TEXT051.
*    LO_COL1->ADD_TEXT( EXPORTING TEXT         = LV_TEXT
*                                 SAP_COLOR    = CL_DD_AREA=>LIST_BACKGROUND_INT
*                                 SAP_EMPHASIS = CL_DD_AREA=>STRONG ).
*    LV_TEXT = *SO_AEZET-LOW.
*    LO_COL2->ADD_TEXT( EXPORTING TEXT         = LV_TEXT ).
*    LO_TAB->NEW_ROW( ).
*  ENDIF.

  go_document->merge_document( ).
ENDFORM.                    " SET_TITLE
*&---------------------------------------------------------------------*
*&      FORM  BALV_CREATE_CLICK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_crea_click.
  CLEAR gs_balv.
  gs_balv-balv_status_icon = icon_create.
  go_balv->set_celltab_style( EXPORTING iv_mode = zcl_brd_alv_n=>mc_create_mode
                              CHANGING ct_celltab = gs_balv-celltab ).
  _set_timestamp_create gs_balv.
  APPEND gs_balv TO gt_balv.
  go_balv->set_changing_flag( abap_true ).
  go_balv->refresh( ).
ENDFORM.                    "BALV_CREATE_CLICK

*&---------------------------------------------------------------------*
*&      FORM  BALV_CHAN_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_chan_click.
  gt_balv_buff[] = gt_balv[].
  go_balv->set_celltab_style( EXPORTING iv_mode = zcl_brd_alv_n=>mc_change_mode
                            CHANGING ct_celltab = gt_celltab ).
  LOOP AT gt_balv ASSIGNING FIELD-SYMBOL(<ls_balv>).
    <ls_balv>-celltab = gt_celltab.
  ENDLOOP.

  go_balv->display( EXPORTING iv_mode = zcl_brd_alv_n=>mc_change_mode
                    CHANGING ct_data  = gt_balv[] ).
ENDFORM.                    "BALV_CHAN_CLICK.
*&---------------------------------------------------------------------*
*&      FORM  BALV_CANC_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_canc_click.

  IF go_balv->is_changing( ) EQ abap_true
    AND go_balv->confirm_cancel( ) NE abap_true.
    EXIT.
  ENDIF.

  CLEAR : gt_balv, gt_balv[].
  gt_balv[] = gt_balv_buff[].
  CLEAR gt_balv_buff[].
  go_balv->set_changing_flag( abap_false ).

  go_balv->display( EXPORTING iv_mode = zcl_brd_alv_n=>mc_display_mode
                   CHANGING ct_data  = gt_balv[] ).
ENDFORM.                    "BALV_CANC_CLICK.
**&---------------------------------------------------------------------*
**&      FORM  BALV_RFSH_CLICK
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_RFSH_CLICK.
*ENDFORM.                    "RFSH_CLICK
*&---------------------------------------------------------------------*
*&      FORM  BALV_INST_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_inst_click.
  CLEAR : gt_rows, gt_row_ids.
  go_balv->get_selected_rows( IMPORTING et_index_rows = gt_rows
                                        et_row_no = gt_row_ids ).
  IF lines( gt_rows ) > 0.
    SORT gt_rows BY index.
    gv_index = gt_rows[ 1 ]-index.
    SORT gt_rows BY index DESCENDING.
    CLEAR gt_celltab.
    go_balv->set_celltab_style( EXPORTING iv_mode = zcl_brd_alv_n=>mc_create_mode
                                CHANGING ct_celltab = gt_celltab ).
    LOOP AT gt_rows INTO gs_rows.
      CLEAR gs_balv.
      gs_balv-balv_status_icon = icon_create.
      gs_balv-celltab = gt_celltab.
      _set_timestamp_create gs_balv.
      INSERT gs_balv INTO gt_balv INDEX gv_index.
    ENDLOOP.
    go_balv->set_changing_flag( abap_true ).
    go_balv->refresh( ).
  ELSE.
    zcl_brd_alv_n=>message_strip( EXPORTING iv_code = zcl_brd_alv_n=>mc_msg-no_row_select ).
  ENDIF.

ENDFORM.                    "BALV_INST_CLICK.
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
*  GO_BALV->DISPLAY( EXPORTING IV_MODE = ZCL_BRD_ALV_N=>MC_UPLOAD_MODE
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
*&---------------------------------------------------------------------*
*&      FORM  BALV_VERIFY_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_verify_data USING pv_tabix TYPE sy-tabix
                                      ps_data LIKE gs_balv.
  IF gs_balv-uname IS INITIAL
.
    APPEND VALUE #( icon = icon_defect
                    row_no = pv_tabix
                    msg = go_balv->message( EXPORTING iv_code = zcl_brd_alv_n=>mc_msg-input_mandatory ) ) TO gt_log.
  ENDIF.
ENDFORM.                    " BALV_VERIFY_DATA
*&---------------------------------------------------------------------*
*&      FORM  BALV_DELE_CLICK.
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_dele_click.
  DATA lt_tab TYPE TABLE OF ztbrd00120 WITH HEADER LINE.
  _init gt_rows.
  go_balv->get_selected_rows(
   IMPORTING
     et_index_rows = gt_rows
     et_row_no     = gt_row_ids ).

  IF lines( gt_rows ) > 0.
    SORT gt_rows BY index DESCENDING.
    LOOP AT gt_rows INTO gs_rows.
      IF gt_balv[ gs_rows-index ]-balv_status_icon = icon_create.
        DELETE gt_balv INDEX gs_rows-index.
      ELSE.
        gt_balv[ gs_rows-index ]-balv_status_icon = icon_delete.
      ENDIF.
    ENDLOOP.
    go_balv->set_changing_flag( abap_true ).
    go_balv->refresh( ).
  ELSE.
    zcl_brd_alv_n=>message_strip( EXPORTING iv_code = zcl_brd_alv_n=>mc_msg-no_row_select ).
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
FORM balv_data_changed USING po_object TYPE REF TO cl_alv_changed_data_protocol
                        pv_onf4
                        pv_onf4_before
                        pv_onf4_after
                        pv_ucomm.
  DATA lt_mod_cells TYPE lvc_t_modi WITH HEADER LINE.
  lt_mod_cells[] = po_object->mt_good_cells.
  LOOP AT lt_mod_cells ASSIGNING FIELD-SYMBOL(<ls_mod_cells>).
    AT NEW row_id.
      READ TABLE gt_balv INDEX <ls_mod_cells>-row_id.
    ENDAT.
    ASSIGN COMPONENT <ls_mod_cells>-fieldname OF STRUCTURE gt_balv TO <gv_field>.
    <gv_field> = lt_mod_cells-value.
    AT END OF row_id.
      READ TABLE gt_balv ASSIGNING FIELD-SYMBOL(<ls_balv>) INDEX <ls_mod_cells>-row_id.
      IF sy-subrc EQ 0." modify
        IF <ls_balv>-balv_status_icon NE icon_create.
          <ls_balv>-balv_status_icon = icon_change.
        ENDIF.
        _set_alv_cell <ls_mod_cells>-row_id c_field-balv_status_icon <ls_balv>-balv_status_icon.
*      GT_BALV-AEDAT = SY-DATUM.
*      _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-AEDAT GT_BALV-AEDAT.
*      GT_BALV-AEZET = SY-UZEIT.
*      _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-AEZET GT_BALV-AEZET.
*      GT_BALV-AENAM = SY-UNAME.
*      _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-AENAM GT_BALV-AENAM.
      ELSE."auto added new row
        _set_alv_cell <ls_mod_cells>-row_id c_field-balv_status_icon icon_create.
        CLEAR gs_balv-celltab.
        go_balv->set_celltab_style( EXPORTING iv_mode = zcl_brd_alv_n=>mc_create_mode
                                    CHANGING ct_celltab = gs_balv-celltab ).
        LOOP AT gs_balv-celltab ASSIGNING FIELD-SYMBOL(<ls_celltab>).
          po_object->modify_style( EXPORTING i_row_id    = <ls_mod_cells>-row_id
                                             i_fieldname = <ls_celltab>-fieldname
                                             i_style     = <ls_celltab>-style ).
        ENDLOOP.
*      GT_BALV-ERDAT = SY-DATUM.
*      _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-ERDAT GT_BALV-ERDAT.
*      GT_BALV-ERZET = SY-UZEIT.
*      _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-ERZET GT_BALV-ERZET.
*      GT_BALV-ERNAM = SY-UNAME.
*      _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-ERNAM GT_BALV-ERNAM.
*      GT_BALV-AEDAT = SY-DATUM.
*      _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-AEDAT GT_BALV-AEDAT.
*      GT_BALV-AEZET = SY-UZEIT.
*      _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-AEZET GT_BALV-AEZET.
*      GT_BALV-AENAM = SY-UNAME.
*      _SET_ALV_CELL <LS_MOD_CELLS>-ROW_ID C_FIELD-AENAM GT_BALV-AENAM.
        APPEND gs_balv TO gt_balv.
      ENDIF.
      READ TABLE gt_balv TRANSPORTING NO FIELDS INDEX <ls_mod_cells>-row_id.
      IF sy-subrc EQ 0.
        MODIFY gt_balv INDEX <ls_mod_cells>-row_id.
      ELSE.
        APPEND gt_balv.
      ENDIF.
    ENDAT.
  ENDLOOP.
  go_balv->set_changing_flag( abap_true ).
ENDFORM.                    "BALV_DATA_CHANGED
*&---------------------------------------------------------------------*
*&      FORM  BALV_UNAME_CHANGED
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_uname_changed USING po_object TYPE REF TO cl_alv_changed_data_protocol
                                   pv_row_id
                                   pv_value TYPE any.
  DATA ls_fieldcat TYPE lvc_s_fcat.
  CLEAR gt_balv.
  READ TABLE gt_balv INDEX pv_row_id.
  IF sy-subrc EQ 0.
    gt_balv-uname = pv_value.
    _set_alv_cell pv_row_id c_field_balv-uname pv_value.
    PERFORM balv_check_pk.
    IF gv_err EQ c_e.
      gt_balv-balv_status_icon = icon_defect.
    ELSE.
      gt_balv-balv_status_icon = icon_change.
    ENDIF.
    _set_alv_cell pv_row_id c_field-balv_status_icon gt_balv-balv_status_icon.
    MODIFY gt_balv INDEX pv_row_id.
  ENDIF.
ENDFORM.                    "BALV_UNAME_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_DEFINE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_DEFINE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_DEFINE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_DEFINE PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_DEFINE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_DEFINE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_DEFINE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_DEFINE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_DEFINE PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_DEFINE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_TYPE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_TYPE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_TYPE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_TYPE PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_TYPE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_TYPE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_TYPE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_TYPE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_TYPE PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_TYPE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_T_TYPE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_T_TYPE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_T_TYPE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_T_TYPE PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_T_TYPE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_T_TYPE_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_T_TYPE_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_T_TYPE = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_T_TYPE PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_T_TYPE_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_CONSTANTS_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_CONSTANTS_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_CONSTANTS = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_CONSTANTS PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_CONSTANTS_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_CONSTANTS_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_CONSTANTS_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_CONSTANTS = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_CONSTANTS PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_CONSTANTS_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_FIELDSYMBOL_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_FIELDSYMBOL_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_FIELDSYMBOL = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_FIELDSYMBOL PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_FIELDSYMBOL_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_FIELDSYMBOL_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_FIELDSYMBOL_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_FIELDSYMBOL = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_FIELDSYMBOL PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_FIELDSYMBOL_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_FIELDSYMBOL_V_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_FIELDSYMBOL_V_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_FIELDSYMBOL_V = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_FIELDSYMBOL_V PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_FIELDSYMBOL_V_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_FIELDSYMBOL_V_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_FIELDSYMBOL_V_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_FIELDSYMBOL_V = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_FIELDSYMBOL_V PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_FIELDSYMBOL_V_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_FIELDSYMBOL_S_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_FIELDSYMBOL_S_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_FIELDSYMBOL_S = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_FIELDSYMBOL_S PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_FIELDSYMBOL_S_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_FIELDSYMBOL_S_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_FIELDSYMBOL_S_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_FIELDSYMBOL_S = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_FIELDSYMBOL_S PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_FIELDSYMBOL_S_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_FIELDSYMBOL_T_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_FIELDSYMBOL_T_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_FIELDSYMBOL_T = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_FIELDSYMBOL_T PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_FIELDSYMBOL_T_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_FIELDSYMBOL_T_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_FIELDSYMBOL_T_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_FIELDSYMBOL_T = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_FIELDSYMBOL_T PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_FIELDSYMBOL_T_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_FIELDSYMBOL_O_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_FIELDSYMBOL_O_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_FIELDSYMBOL_O = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_FIELDSYMBOL_O PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_FIELDSYMBOL_O_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_FIELDSYMBOL_O_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_FIELDSYMBOL_O_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_FIELDSYMBOL_O = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_FIELDSYMBOL_O PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_FIELDSYMBOL_O_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_PARAMETERS_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_PARAMETERS_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-PARAMETERS = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-PARAMETERS PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_PARAMETERS_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_SELECTOPTION_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_SELECTOPTION_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-SELECTOPTION = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-SELECTOPTION PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_SELECTOPTION_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_DATA_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_DATA_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_DATA = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_DATA PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_DATA_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_DATA_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_DATA_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_DATA = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_DATA PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_DATA_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_ITAB_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_ITAB_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_ITAB = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_ITAB PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_ITAB_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_ITAB_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_ITAB_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_ITAB = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_ITAB PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_ITAB_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_OBJ_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_OBJ_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_OBJ = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_OBJ PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_OBJ_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_OBJ_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_OBJ_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_OBJ = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_OBJ PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_OBJ_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_G_WA_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_G_WA_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-G_WA = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-G_WA PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_G_WA_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_L_WA_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_L_WA_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-L_WA = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-L_WA PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_L_WA_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_FORM_IV_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_FORM_IV_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-FORM_IV = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-FORM_IV PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_FORM_IV_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_FORM_IS_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_FORM_IS_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-FORM_IS = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-FORM_IS PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_FORM_IS_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_FORM_IT_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_FORM_IT_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-FORM_IT = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-FORM_IT PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_FORM_IT_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_FORM_CV_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_FORM_CV_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-FORM_CV = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-FORM_CV PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_FORM_CV_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_FORM_CS_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_FORM_CS_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-FORM_CS = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-FORM_CS PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_FORM_CS_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_FORM_CT_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_FORM_CT_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-FORM_CT = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-FORM_CT PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_FORM_CT_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_FORM_TT_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_FORM_TT_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-FORM_TT = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-FORM_TT PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_FORM_TT_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_ERNAM_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_ERNAM_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-ERNAM = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-ERNAM PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_ERNAM_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_ERDAT_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_ERDAT_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-ERDAT = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-ERDAT PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_ERDAT_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_ERZET_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_ERZET_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-ERZET = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-ERZET PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_ERZET_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_AENAM_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_AENAM_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-AENAM = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-AENAM PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_AENAM_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_AEDAT_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_AEDAT_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-AEDAT = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-AEDAT PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_AEDAT_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_AEZET_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_AEZET_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-AEZET = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-AEZET PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_AEZET_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_MANDT_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_MANDT_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-MANDT = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-MANDT PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_MANDT_CHANGED.
**&---------------------------------------------------------------------*
**&      FORM  BALV_ZDEL_CHANGED
**&---------------------------------------------------------------------*
**       TEXT
**----------------------------------------------------------------------*
*FORM BALV_ZDEL_CHANGED USING PO_OBJECT TYPE REF TO CL_ALV_CHANGED_DATA_PROTOCOL
*                                   PV_ROW_ID
*                                   PV_VALUE TYPE ANY.
*  DATA LS_FIELDCAT TYPE LVC_S_FCAT.
*  CLEAR GT_BALV.
*  READ TABLE GT_BALV INDEX PV_ROW_ID.
*  IF SY-SUBRC EQ 0.
*    GT_BALV-ZDEL = PV_VALUE.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD_BALV-ZDEL PV_VALUE.
*    PERFORM BALV_CHECK_PK.
*    IF GV_ERR EQ C_E.
*      GT_BALV-BALV_STATUS_ICON = ICON_DEFECT.
*    ELSE.
*      GT_BALV-BALV_STATUS_ICON = ICON_CHANGE.
*    ENDIF.
*    _SET_ALV_CELL PV_ROW_ID C_FIELD-BALV_STATUS_ICON GT_BALV-BALV_STATUS_ICON.
*    MODIFY GT_BALV INDEX PV_ROW_ID.
*  ENDIF.
*ENDFORM.                    "BALV_ZDEL_CHANGED.
*&---------------------------------------------------------------------*
*&      FORM  BALV_CHECK_PK
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
FORM balv_check_pk .
  CLEAR : gv_err, gv_count.

  SELECT COUNT(*) INTO gv_count
    FROM ztbrd00120
  WHERE uname = gt_balv-uname
.

  IF gv_count GT 0.
    gv_err = c_e.
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
*  IF go_BALV->get_alv_mode( ) NE ZCL_BRD_ALV_N=>mc_display_mode .
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
FORM save_data.
  DATA:
    ls_balv        TYPE ztbrd00120,
    lt_create_balv TYPE TABLE OF ztbrd00120,
    lt_update_balv TYPE TABLE OF ztbrd00120,
    lt_delete_balv TYPE TABLE OF ztbrd00120.
  DATA:
    lv_create_cnt TYPE sy-dbcnt,
    lv_update_cnt TYPE sy-dbcnt,
    lv_delete_cnt TYPE sy-dbcnt.

  CLEAR gt_log[].
  CLEAR gs_balv.
  LOOP AT gt_balv INTO gs_balv.
    CLEAR ls_balv.
    IF gs_balv-balv_status_icon IS NOT INITIAL.
      PERFORM balv_verify_data USING sy-tabix gs_balv.
      MOVE-CORRESPONDING gs_balv TO ls_balv.
    ENDIF.
    CASE gs_balv-balv_status_icon.
      WHEN icon_create.
        _set_timestamp_create ls_balv.
        APPEND ls_balv TO lt_create_balv.
      WHEN icon_change.
        _set_timestamp_change ls_balv.
        APPEND ls_balv TO lt_update_balv.
      WHEN icon_delete.
        APPEND ls_balv TO lt_delete_balv.
    ENDCASE.
    CLEAR gs_balv.
  ENDLOOP.


  IF gt_log[] IS NOT INITIAL.
    zcl_brd_alv_n=>message_popup( CHANGING ct_msg = gt_log[] ).
    EXIT.
  ENDIF.

  IF zcl_brd_alv_n=>confirm_save( ) NE abap_true.
    EXIT.
  ENDIF.

  TRY.
      IF lt_create_balv IS NOT INITIAL.
        INSERT ztbrd00120 FROM TABLE lt_create_balv.
        lv_create_cnt = lv_create_cnt + lines( lt_create_balv ).
      ENDIF.
      IF lt_update_balv IS NOT INITIAL.
        MODIFY ztbrd00120 FROM TABLE lt_update_balv.
        lv_update_cnt = lv_update_cnt + lines( lt_update_balv ).
      ENDIF.
      IF lt_delete_balv IS NOT INITIAL.
        DELETE ztbrd00120 FROM TABLE lt_delete_balv.
        lv_delete_cnt = lv_delete_cnt + lines( lt_delete_balv ).
      ENDIF.
    CATCH cx_root INTO go_exception.
      zcl_brd_alv_n=>catch_exception( io_root = go_exception ).
  ENDTRY.
  zcl_brd_alv_n=>message_strip( EXPORTING iv_code = zcl_brd_alv_n=>mc_msg-save_success
                                    iv_param1 = |{ lv_create_cnt }|
                                    iv_param2 = |{ lv_update_cnt }|
                                    iv_param3 = |{ lv_delete_cnt }| ).

  CLEAR gt_balv_buff[].
  go_balv->set_changing_flag( abap_false ).
  DELETE gt_balv WHERE balv_status_icon = icon_delete.
  LOOP AT gt_balv ASSIGNING <gs_balv>.
    IF <gs_balv>-balv_status_icon IS NOT INITIAL.
      CLEAR <gs_balv>-balv_status_icon.
    ENDIF.
  ENDLOOP.
  go_balv->display( EXPORTING iv_mode = zcl_brd_alv_n=>mc_display_mode
                    CHANGING ct_data  = gt_balv[] ).
ENDFORM.                    "SAVE_DATA
