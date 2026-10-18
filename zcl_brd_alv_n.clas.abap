*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
CLASS zcl_brd_alv_n DEFINITION
  PUBLIC
  INHERITING FROM cl_gui_alv_grid
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ts_fcat_config TYPE ztbrd00020 .
    TYPES ts_header_config TYPE ztbrd00010 .
    TYPES tt_fcat_config TYPE zybrd00020 .

    DATA mt_fieldcat TYPE lvc_t_fcat .
    CLASS-DATA mc_display_mode TYPE char04 READ-ONLY VALUE 'DISP' ##NO_TEXT.
    CLASS-DATA mc_upload_mode TYPE char04 READ-ONLY VALUE 'UPLD' ##NO_TEXT.
    CLASS-DATA mc_cancel_mode TYPE char04 READ-ONLY VALUE 'CANC' ##NO_TEXT.
    CLASS-DATA mc_create_mode TYPE char04 READ-ONLY VALUE 'CREA' ##NO_TEXT.
    CLASS-DATA mc_change_mode TYPE char04 READ-ONLY VALUE 'CHAN' ##NO_TEXT.
    CLASS-DATA:
      BEGIN OF mc_msg,
        no_row_select        TYPE char10 VALUE 'M100000001',
        no_change_data_found TYPE char10 VALUE 'M100000002',
        save_error           TYPE char10 VALUE 'M100000003',
        save_success         TYPE char10 VALUE 'M100000004',
        input_mandatory      TYPE char10 VALUE 'M100000005',
      END OF mc_msg .
    CLASS-DATA:
      BEGIN OF mc_ucomm READ-ONLY,
        refresh  TYPE ui_func  VALUE 'RFSH', "Refresh
        create   TYPE ui_func  VALUE 'CREA', "Create
        insert   TYPE ui_func  VALUE 'INST', "Insert
        change   TYPE ui_func  VALUE 'CHAN', "Change
        display  TYPE ui_func  VALUE 'DISP', "Display
        delete   TYPE ui_func  VALUE 'DELE', "Delete
        xls      TYPE ui_func  VALUE '$XLS', "Excel
        upload   TYPE ui_func  VALUE 'UPLD', "Upload
        download TYPE ui_func  VALUE '&XXL', "Download
        cancel   TYPE ui_func  VALUE 'CANC', "Cancle
        excute   TYPE ui_func  VALUE 'EXEC', "Excute
        open     TYPE ui_func  VALUE 'OPEN', "Excute
        back     TYPE sy-ucomm  VALUE 'BACK', "Back
        exit     TYPE sy-ucomm  VALUE 'EXIT', "Exit
        save     TYPE sy-ucomm  VALUE 'SAVE', "Save
        simulate TYPE sy-ucomm  VALUE 'SIMU', "Simulate
        print    TYPE sy-ucomm  VALUE 'PRNT', "Print
        dbclick  TYPE sy-ucomm  VALUE 'DBCLK', "Double Click
        help     TYPE sy-ucomm  VALUE 'BAHP', "BALV Help
      END OF mc_ucomm .
    CLASS-DATA:
      BEGIN OF mc_icon READ-ONLY,
        create     TYPE icon-id VALUE icon_create,
        insert_row TYPE icon-id VALUE icon_insert_row,
        change     TYPE icon-id VALUE icon_change,
        xls        TYPE icon-id VALUE icon_xls,
        cancel     TYPE icon-id VALUE icon_cancel,
        refresh    TYPE icon-id VALUE icon_refresh,
        delete_row TYPE icon-id VALUE icon_delete_row,
        delete     TYPE icon-id VALUE icon_delete,
        defect     TYPE  icon-id VALUE icon_defect,
      END OF mc_icon .

    CLASS-METHODS add_excel_download_sheet
      IMPORTING
        !it_data  TYPE STANDARD TABLE
      EXPORTING
        !ev_subrc TYPE i .
    CLASS-METHODS add_excel_file_open_dialog
      CHANGING
        !cv_file TYPE localfile .
    METHODS append_toolbar_button
      IMPORTING
        VALUE(iv_function)  TYPE ui_func OPTIONAL
        VALUE(iv_icon)      TYPE icon_d OPTIONAL
        VALUE(iv_quickinfo) TYPE iconquick OPTIONAL
        VALUE(iv_butn_type) TYPE tb_btype OPTIONAL
        VALUE(iv_disabled)  TYPE char1 OPTIONAL
        VALUE(iv_text)      TYPE text40 OPTIONAL
        VALUE(iv_checked)   TYPE char1 OPTIONAL .
    CLASS-METHODS catch_exception
      IMPORTING
        !io_root TYPE REF TO cx_root .
    CLASS-METHODS commit_delete
      IMPORTING
        !iv_count TYPE i OPTIONAL .
    CLASS-METHODS commit_save
      IMPORTING
        !iv_count TYPE i OPTIONAL .
    CLASS-METHODS confirm_cancel
      RETURNING
        VALUE(rv_return) TYPE char1 .
    CLASS-METHODS confirm_delete
      RETURNING
        VALUE(rv_return) TYPE char1 .
    CLASS-METHODS confirm_msg
      IMPORTING
        !iv_title        TYPE char255
        !iv_question     TYPE char255
        !iv_btn1         TYPE char10 DEFAULT 'YES'
        !iv_btn2         TYPE char10 DEFAULT 'NO'
      RETURNING
        VALUE(rv_return) TYPE char1 .
    CLASS-METHODS confirm_save
      RETURNING
        VALUE(rv_return) TYPE char1 .
    METHODS constructor
      IMPORTING
        VALUE(iv_parent)      TYPE c OPTIONAL
        VALUE(iv_progid)      TYPE sy-cprog DEFAULT sy-cprog
        VALUE(iv_alv_key)     TYPE char10 DEFAULT 'BALV'
        VALUE(iv_fcat_key)    TYPE char10 DEFAULT 'DEFAULT'
        VALUE(io_parent)      TYPE REF TO cl_gui_container OPTIONAL
        VALUE(iv_lifetime)    TYPE i OPTIONAL
        VALUE(iv_appl_events) TYPE char1 OPTIONAL
        !iv_callback_progid   TYPE sy-cprog DEFAULT sy-cprog
        !is_layout_cbo        TYPE ztbrd00010 OPTIONAL .
    METHODS display
      IMPORTING
        !it_fieldcat          TYPE lvc_t_fcat OPTIONAL
        !iv_mode              TYPE char04 DEFAULT 'DISP'
        !it_toolbar_excluding TYPE ui_functions OPTIONAL
        !iv_fcat_key          TYPE char10 OPTIONAL
        !it_sortcat           TYPE lvc_t_sort OPTIONAL
        !it_drop_down         TYPE lvc_t_dral OPTIONAL
        !iv_save              TYPE char01 DEFAULT 'A'
        !iv_default           TYPE char01 DEFAULT 'X'
        !is_variant           TYPE disvariant OPTIONAL
        !it_fieldcat_cbo      TYPE zybrd00020 OPTIONAL
      CHANGING
        !ct_data              TYPE table OPTIONAL .
    CLASS-METHODS excel_download
      IMPORTING
        !it_data      TYPE STANDARD TABLE OPTIONAL
        !iv_full_path TYPE string OPTIONAL
        !it_header    TYPE zybrd00130 OPTIONAL
      EXPORTING
        !ev_subrc     TYPE i .
    CLASS-METHODS excel_upload
      IMPORTING
        !iv_file_dialog TYPE char01 DEFAULT 'X'
        !iv_file_name   TYPE localfile OPTIONAL
        !iv_max_row_cnt TYPE i DEFAULT 100000
        !iv_sheet_no    TYPE i DEFAULT 1
      CHANGING
        !ct_data        TYPE STANDARD TABLE
      RETURNING
        VALUE(ev_subrc) TYPE sy-subrc .
    METHODS get_all_exclude_toolbar
      RETURNING
        VALUE(rt_toolbar_excluding) TYPE ui_functions .
    METHODS get_alv_mode
      RETURNING
        VALUE(rv_return) TYPE char4 .
    CLASS-METHODS get_ddl_by_domain
      IMPORTING
        !iv_domname       TYPE dd07l-domname
        !iv_text          TYPE ddrefstruc-bool DEFAULT space
        !iv_langu         TYPE dd07t-ddlanguage DEFAULT space
        !iv_bypass_buffer TYPE ddrefstruc-bool DEFAULT space
        !iv_ddl_number    TYPE int4
      RETURNING
        VALUE(rt_ddl)     TYPE lvc_t_dral .
    METHODS get_f4_value
      IMPORTING
        !iv_fieldname   TYPE lvc_fname OPTIONAL
        !it_data        TYPE table
      RETURNING
        VALUE(rv_value) TYPE shvalue_d .
    CLASS-METHODS get_fieldcat_config
      IMPORTING
        VALUE(iv_progid)   TYPE sy-cprog DEFAULT sy-cprog
        VALUE(iv_alv_key)  TYPE char10 DEFAULT 'BALV'
        VALUE(iv_fcat_key) TYPE char10 DEFAULT 'DEFAULT'
      EXPORTING
        !et_fcat           TYPE zybrd00020
      RETURNING
        VALUE(rt_fcat)     TYPE lvc_t_fcat .
    CLASS-METHODS get_slis_config
      IMPORTING
        VALUE(iv_progid)   TYPE sy-cprog DEFAULT sy-cprog
        VALUE(iv_alv_key)  TYPE char10 DEFAULT 'BALV'
        VALUE(iv_fcat_key) TYPE char10 DEFAULT 'DEFAULT'
      EXPORTING
        !et_slis_fcat      TYPE slis_t_fieldcat_alv
        !es_slis_layout    TYPE slis_layout_alv
        !et_slis_sort      TYPE slis_t_sortinfo_alv .
    METHODS get_sort_filter_toolbar
      RETURNING
        VALUE(rt_toolbar_excluding) TYPE ui_functions .
    METHODS insert_toolbar_button
      IMPORTING
        VALUE(iv_function)  TYPE ui_func OPTIONAL
        VALUE(iv_icon)      TYPE icon_d OPTIONAL
        VALUE(iv_quickinfo) TYPE iconquick OPTIONAL
        VALUE(iv_butn_type) TYPE tb_btype OPTIONAL
        VALUE(iv_disabled)  TYPE char1 OPTIONAL
        VALUE(iv_text)      TYPE text40 OPTIONAL
        VALUE(iv_checked)   TYPE char1 OPTIONAL
        !iv_index           TYPE i .
    METHODS refresh
      IMPORTING
        !iv_hard_refresh TYPE flag OPTIONAL .
    CLASS-METHODS rollback_fail .
    METHODS set_alv_mode
      IMPORTING
        VALUE(iv_mode) TYPE char04 .
    METHODS set_company_code
      IMPORTING
        !iv_bukrs TYPE bukrs .
    METHODS set_celltab_style
      IMPORTING
        !iv_mode    TYPE char04
      CHANGING
        !ct_celltab TYPE lvc_t_styl .
    CLASS-METHODS message_popup
      CHANGING
        !ct_msg TYPE table .
    CLASS-METHODS message_strip
      IMPORTING
        !iv_code    TYPE char10
        !iv_param1  TYPE char20 OPTIONAL
        !iv_param2  TYPE char20 OPTIONAL
        !iv_param3  TYPE char20 OPTIONAL
        !iv_param4  TYPE char20 OPTIONAL
        !iv_type    TYPE char1 DEFAULT 'S'
        !iv_display TYPE char1 OPTIONAL .
    CLASS-METHODS message
      IMPORTING
        !iv_code      TYPE char10
        !iv_param1    TYPE char20 OPTIONAL
        !iv_param2    TYPE char20 OPTIONAL
        !iv_param3    TYPE char20 OPTIONAL
        !iv_param4    TYPE char20 OPTIONAL
      RETURNING
        VALUE(rv_msg) TYPE string .
    METHODS is_changing
      RETURNING
        VALUE(rv_flag) TYPE flag .
    METHODS set_changing_flag
      IMPORTING
        !iv_flag TYPE flag .
    CLASS-METHODS get_alv_itab
      IMPORTING
        !iv_progid       TYPE sy-cprog DEFAULT sy-cprog
        !iv_alv_key      TYPE char10 DEFAULT 'BALV'
        !iv_fcat_key     TYPE char10 DEFAULT 'DEFAULT'
        !it_fcat_config  TYPE zybrd00020 OPTIONAL
      EXPORTING
        VALUE(eo_data)   TYPE REF TO data
        !et_header_label TYPE string_table .
    METHODS goto_row_focus
      IMPORTING
        !iv_rowno TYPE int4 OPTIONAL .
    CLASS-METHODS itab_to_excel_download
      IMPORTING
        !iv_alv_key       TYPE char10 DEFAULT 'BALV'
        !iv_fcat_key      TYPE char10 DEFAULT 'DEFAULT'
        !it_header        TYPE string_table OPTIONAL
        !iv_download_path TYPE string OPTIONAL
        !iv_filename      TYPE string OPTIONAL
        !it_tab           TYPE STANDARD TABLE .
    CLASS-METHODS add_file_save_dialog
      IMPORTING
        !iv_extension   TYPE string DEFAULT ''
        !iv_title       TYPE string DEFAULT 'File save'
        !iv_directory   TYPE string DEFAULT 'C:/'
      CHANGING
        !cv_filename    TYPE string OPTIONAL
        !cv_path        TYPE string OPTIONAL
        !cv_fullpath    TYPE string
      RETURNING
        VALUE(rv_subrc) TYPE sy-subrc .
    CLASS-METHODS excel_gui_upload
      IMPORTING
        !iv_file_dialog TYPE char01 DEFAULT 'X'
        !iv_file_name   TYPE localfile OPTIONAL
        !iv_max_row_cnt TYPE i DEFAULT 100000
        !iv_sheet_no    TYPE i DEFAULT 1
      CHANGING
        !ct_data        TYPE STANDARD TABLE
      RETURNING
        VALUE(ev_subrc) TYPE sy-subrc .
    CLASS-METHODS excel_its_upload
      IMPORTING
        !iv_file_dialog TYPE char01 DEFAULT 'X'
        !iv_file_name   TYPE localfile OPTIONAL
        !iv_max_row_cnt TYPE i DEFAULT 100000
        !iv_sheet_no    TYPE i DEFAULT 1
      CHANGING
        !ct_data        TYPE STANDARD TABLE
      RETURNING
        VALUE(ev_subrc) TYPE sy-subrc .
protected section.

  types:
    BEGIN OF lvc_s_celltab,
        rownum  TYPE sy-index,
        celltab TYPE lvc_t_styl,
      END OF lvc_s_celltab .
  types:
    BEGIN OF lvc_s_coltab,
        rownum TYPE sy-index,
        coltab TYPE lvc_t_scol,
      END OF lvc_s_coltab .
  types:
    BEGIN OF ty_txt,
        line(4096) TYPE c,
      END OF ty_txt .
  types:
    ty_t_txt TYPE TABLE OF ty_txt .

  data:
    mt_config_fieldcat TYPE TABLE OF ztbrd00020 .
  data:
    mt_config_fieldcat_text TYPE TABLE OF ztbrd00070 .
  data MV_PROGID type CPROG .
  data MV_ALV_KEY type CHAR10 value 'DEFAULT' ##NO_TEXT.
  data MV_FCAT_KEY type CHAR10 value 'DEFAULT' ##NO_TEXT.
  data MS_LAYOUT type LVC_S_LAYO .
  data MS_FIELDCAT type LVC_S_FCAT .
  data MS_HEADER_CONFIG type ZTBRD00010 .
  data MV_MODE type CHAR04 value 'DISP' ##NO_TEXT.
  data MV_IS_RELOAD type CHAR1 .
  data MT_SORTCAT type LVC_T_SORT .
  data MC_REFRESH_COMMAND type CHAR04 value 'RFSH' ##NO_TEXT.
  data MO_HTML_VIEWER type ref to CL_GUI_HTML_VIEWER .
  data MV_IS_FIELD_BUTTON_EXISTS type CHAR01 .
  data MV_IS_HOT_SPOT_EXISTS type CHAR01 .
  data MS_VARIANT type DISVARIANT .
  data MV_IS_SET_CHANGE_EVT type CHAR01 .
  data MS_CONFIG_FIELDCAT type ZTBRD00020 .
  data MV_TABIX type SY-TABIX .
  data MT_F4_FIELD type LVC_T_F4 .
  data MS_F4_FIELD type LVC_S_F4 .
  data MV_IS_F4_EXISTS type CHAR01 .
  class-data MO_EXCEL type OLE2_OBJECT .
  class-data MO_WORKBOOKS type OLE2_OBJECT .
  class-data MO_WORKBOOK type OLE2_OBJECT .
  class-data MO_SHEETS type OLE2_OBJECT .
  class-data MO_SHEET type OLE2_OBJECT .
  class-data MV_SHEET_NUM type I value 1 ##NO_TEXT.
  data MS_COL_ID type LVC_S_COL .
  data MS_ROW_ID type LVC_S_ROW .
  data MV_CALLBACK_PROGID type CPROG .
  data MV_BUKRS type BUKRS .
  data MV_BUKRS_WAERS type WAERS .
  constants MC_BUKRS_WAERS type WAERS value 'KRW' ##NO_TEXT.
  data MV_ON_CHAINGING_FLAG type FLAG .
  data MT_CREATE_CELLTAB type LVC_T_STYL .
  data MT_CHANGE_CELLTAB type LVC_T_STYL .

  methods SET_FIELDCAT_CONFIG .
  class-methods DIVIDE_LINE_TO_CELL
    importing
      !IV_TABIX type SY-TABIX
    changing
      !CS_DATA type TY_TXT
      !CT_ITAB type SOI_GENERIC_TABLE
      !CV_COL type KCD_EX_COL
      !CV_FDPOS type SY-FDPOS .
  methods GET_DROP_DOWN_CONFIG
    changing
      !CT_DROP_DOWN type LVC_T_DRAL .
  methods GET_FIELDCAT .
  methods HANDLE_AFTER_REFRESH
    for event AFTER_REFRESH of CL_GUI_ALV_GRID .
  methods HANDLE_BUTTON_CLICK
    for event BUTTON_CLICK of CL_GUI_ALV_GRID
    importing
      !ES_COL_ID
      !ES_ROW_NO .
  methods HANDLE_DATA_CHANGED
    for event DATA_CHANGED of CL_GUI_ALV_GRID
    importing
      !ER_DATA_CHANGED
      !E_ONF4
      !E_ONF4_BEFORE
      !E_ONF4_AFTER
      !E_UCOMM .
  methods HANDLE_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods HANDLE_HOTSPOT_CLICK
    for event HOTSPOT_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW_ID
      !E_COLUMN_ID
      !ES_ROW_NO .
  methods HANDLE_ONF4
    for event ONF4 of CL_GUI_ALV_GRID
    importing
      !E_FIELDNAME
      !E_FIELDVALUE
      !ES_ROW_NO
      !ER_EVENT_DATA
      !ET_BAD_CELLS
      !E_DISPLAY .
  methods HANDLE_TOOLBAR
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE .
  methods HANDLE_USER_COMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM .
  class-methods MOVE_ITAB_TO_EXCEL
    importing
      !IT_DATA type STANDARD TABLE
      !IT_HEADER type ZYBRD00130 optional .
  class-methods MOVE_TO_EXCEL_ITAB
    importing
      !IT_DATA type TY_T_TXT
    exporting
      !ET_ITAB type SOI_GENERIC_TABLE .
  methods SET_BLOCK_ALV_MSG .
  methods SET_FIELDCAT .
  methods SET_DEFAULT_EXCLUDE_TOOLBAR .
  methods SET_DEFAULT_FIELDCAT
    importing
      !IT_DATA type TABLE .
  methods SET_DEFAULT_LAYOUT .
  methods SET_DEFAULT_SORTCAT .
  methods SET_EVENTS .
  methods SET_NATIVE_FIELDCAT
    importing
      !IT_DATA type TABLE .
  PRIVATE SECTION.

    DATA mo_cl_menu_xls TYPE REF TO cl_ctmenu .
ENDCLASS.



CLASS ZCL_BRD_ALV_N IMPLEMENTATION.


  METHOD add_excel_download_sheet.

    DATA : lv_msg        TYPE string,
           lv_sheet_name TYPE string.

    lv_msg = mv_sheet_num.
    CONCATENATE `Generating ` lv_msg `th Sheet..` INTO lv_msg.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        text = lv_msg.
    lv_sheet_name = mv_sheet_num.
    CONCATENATE 'WorkSheet' lv_sheet_name INTO lv_sheet_name.

    IF mo_excel IS INITIAL.
      CREATE OBJECT mo_excel 'EXCEL.APPLICATION'.
      CALL METHOD OF mo_excel 'WORKBOOKS' = mo_workbooks.
      CALL METHOD OF mo_workbooks 'ADD' = mo_workbook.
      CALL METHOD OF mo_workbook 'Sheets' = mo_sheets.

      CALL METHOD OF mo_excel 'SHEETS' = mo_sheet
        EXPORTING
          #1       = mv_sheet_num.
      CALL METHOD OF mo_sheet 'SELECT'.

      ADD 1 TO mv_sheet_num.

    ELSE.
      CALL METHOD OF mo_sheets 'ADD' = mo_sheet.

      ADD 1 TO mv_sheet_num.

    ENDIF.

    SET PROPERTY OF mo_sheet 'Name' = lv_sheet_name.

    move_itab_to_excel( EXPORTING it_data = it_data ).

  ENDMETHOD.


  METHOD add_excel_file_open_dialog.
    DATA: lt_file TYPE filetable,
          ls_file LIKE LINE OF lt_file,
          lv_rc   TYPE i.
    CLEAR : cv_file.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title      = 'Select Excel File'
        file_filter       = 'Excel files (*.XLSX)|*.XLSX| Excel files (*.XLS)|*.XLS|'
        default_extension = 'xlsx'
      CHANGING
        file_table        = lt_file
        rc                = lv_rc.

    IF  sy-subrc EQ 0.
      READ TABLE lt_file INTO ls_file INDEX 1.
      MOVE  ls_file-filename   TO  cv_file.
    ENDIF.
  ENDMETHOD.


  METHOD add_file_save_dialog.
    DATA: lv_fullpath TYPE string,
          lv_path     TYPE string,
          lv_rc       TYPE i.


    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
        window_title      = iv_title
        default_extension = iv_extension
        default_file_name = cv_filename
        initial_directory = iv_directory
      CHANGING
        filename          = cv_filename
        path              = lv_path
        fullpath          = lv_fullpath
        user_action       = lv_rc.


    IF  sy-subrc EQ 0 AND lv_rc EQ 0 AND lv_fullpath IS NOT INITIAL.
      cv_fullpath = lv_fullpath.
      cv_path = lv_path.
      rv_subrc = 0.
    ELSE.
      rv_subrc = 8.
    ENDIF.
  ENDMETHOD.


  METHOD append_toolbar_button.
    DATA : ls_toolbar TYPE stb_button.
    CLEAR ls_toolbar.

    MOVE iv_butn_type TO ls_toolbar-butn_type.
    MOVE iv_function TO ls_toolbar-function.
    MOVE iv_icon TO ls_toolbar-icon.
    MOVE iv_quickinfo TO ls_toolbar-quickinfo.
    MOVE iv_text TO ls_toolbar-text.
    MOVE iv_disabled TO ls_toolbar-disabled.

    IF iv_butn_type EQ '3'.
      APPEND ls_toolbar TO m_cl_toolbar->mt_toolbar.
    ELSE.
      READ TABLE m_cl_toolbar->mt_toolbar TRANSPORTING NO FIELDS WITH KEY function = iv_function.
      IF sy-subrc NE 0.
        APPEND ls_toolbar TO m_cl_toolbar->mt_toolbar.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD catch_exception.
    DATA lv_text TYPE string.
    lv_text = io_root->get_text( ).
    MESSAGE lv_text TYPE 'I' DISPLAY LIKE 'E'.
  ENDMETHOD.


  METHOD commit_delete.
    DATA lv_str TYPE string .

    IF iv_count EQ 0.
      MESSAGE 'Data Deleted!!' TYPE 'S'.
    ELSE.
      lv_str = iv_count.

      CONCATENATE lv_str  `Record(s) Deleted!!`  INTO lv_str.
      MESSAGE lv_str TYPE 'S'.
    ENDIF.

    COMMIT WORK.
  ENDMETHOD.


  METHOD commit_save.
    DATA lv_str TYPE string.

    IF iv_count EQ 0.
      MESSAGE 'Data Saved!!' TYPE 'S'.
    ELSE.
      lv_str = iv_count.
      CONCATENATE lv_str ` Record(s) Saved!!` INTO lv_str.
      MESSAGE lv_str TYPE 'S'.
    ENDIF.

    COMMIT WORK.
  ENDMETHOD.


  METHOD confirm_cancel.

    confirm_msg( EXPORTING iv_title = 'Cancel Confirm'
                           iv_question = 'Are you sure to cancel without saving?'
                 RECEIVING rv_return = rv_return ).


  ENDMETHOD.


  METHOD confirm_delete.
    confirm_msg( EXPORTING iv_title = 'Delete Confirm'
                           iv_question = 'Delete Data?'
                 RECEIVING rv_return = rv_return ).

  ENDMETHOD.


  METHOD confirm_msg.
    DATA:lt_spar TYPE TABLE OF spar.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = iv_title
        diagnose_object       = space
        text_question         = iv_question
        text_button_1         = iv_btn1
        icon_button_1         = space
        text_button_2         = iv_btn2
        icon_button_2         = space
        default_button        = '1'
        display_cancel_button = 'X'
        userdefined_f1_help   = space
        start_column          = 25
        start_row             = 6
        popup_type            = space
        iv_quickinfo_button_1 = space
        iv_quickinfo_button_2 = space
      IMPORTING
        answer                = rv_return
      TABLES
        parameter             = lt_spar
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.
    CASE rv_return.
      WHEN '1'. rv_return = abap_true.
      WHEN OTHERS. rv_return = abap_false.
    ENDCASE.
  ENDMETHOD.


  METHOD confirm_save.
    confirm_msg( EXPORTING iv_title = 'Save Confirm'
                           iv_question = 'Save Data?'
                 RECEIVING rv_return = rv_return ).


  ENDMETHOD.


  METHOD constructor.
    DATA : lo_parent TYPE REF TO cl_gui_container,
           lo_custom TYPE REF TO cl_gui_custom_container.

    IF io_parent IS NOT INITIAL.
      lo_parent = io_parent.
    ELSE.
      IF iv_parent IS NOT INITIAL.
        CREATE OBJECT lo_custom
          EXPORTING
            container_name = iv_parent.
*        lo_parent ?= NEW cl_gui_custom_container( container_name = iv_parent ).
        lo_parent ?= lo_custom.
      ELSE.
        lo_parent = cl_gui_container=>default_screen.
      ENDIF.
    ENDIF.

    super->constructor( EXPORTING i_parent = lo_parent
                                  i_lifetime = iv_lifetime
                                  i_appl_events = iv_appl_events ).

    CLEAR mv_is_reload .
    mv_progid = iv_progid.
    mv_callback_progid = iv_callback_progid.

    IF iv_alv_key IS NOT INITIAL.
      mv_alv_key = iv_alv_key.
    ENDIF.
    IF iv_fcat_key IS NOT INITIAL.
      mv_fcat_key = iv_fcat_key.
    ENDIF.
    IF is_layout_cbo IS INITIAL.
      set_default_layout( ).
    ELSE.
      MOVE-CORRESPONDING is_layout_cbo TO ms_header_config.
      MOVE-CORRESPONDING is_layout_cbo TO ms_layout.
    ENDIF.
    set_fieldcat_config( ).

    mv_bukrs_waers = mc_bukrs_waers.



  ENDMETHOD.


  METHOD display.
    DATA : lt_exclude_toolbar TYPE ui_functions,
           lt_drop_down       TYPE lvc_t_dral,
           lv_save,
           lv_str             TYPE string.

    FIELD-SYMBOLS : <ls_data_line> TYPE any,
                    <lt_celltab>   TYPE lvc_t_styl,
                    <lt_coltab>    TYPE lvc_t_scol,
                    <lt_outtab>    TYPE STANDARD TABLE.
    DATA ls_layout TYPE lvc_s_layo.

    " 1. alv사용 가능 여부 확인
    IF ms_header_config-use_flag EQ abap_true.
      set_block_alv_msg( ).
      EXIT.
    ENDIF.

    " 2. 출력 데이터 존재 확인
    IF ct_data IS NOT REQUESTED.
      IF mt_outtab IS INITIAL.
        MESSAGE i005(zcmz01) DISPLAY LIKE 'E'.
      ELSE.
        ASSIGN mt_outtab->* TO <lt_outtab>.
      ENDIF.
    ELSE.
      ASSIGN ct_data TO <lt_outtab>.
    ENDIF.

    " 3. 파라미터 확인
    mv_mode = iv_mode.
    IF iv_fcat_key IS NOT INITIAL.
      mv_fcat_key = iv_fcat_key.
      set_fieldcat_config( ).
    ENDIF.


    IF it_fieldcat IS INITIAL AND it_fieldcat_cbo IS INITIAL.
      set_default_fieldcat( EXPORTING it_data = <lt_outtab> ).
    ENDIF.
    IF it_fieldcat IS NOT INITIAL.
      mt_fieldcat = it_fieldcat.
    ENDIF.
    IF it_fieldcat_cbo IS NOT INITIAL.
      mt_config_fieldcat = it_fieldcat_cbo.
      SORT mt_config_fieldcat BY fieldname.
      set_fieldcat( ).
    ENDIF.

    " 4. dropdown list 세팅
    CLEAR lt_drop_down.
    lt_drop_down = it_drop_down.
    get_drop_down_config( CHANGING ct_drop_down  = lt_drop_down ).
    IF lt_drop_down IS NOT INITIAL.
      set_drop_down_table( EXPORTING it_drop_down_alias = lt_drop_down ).
    ENDIF.

    " 5. 최초 실행시 세팅
    CLEAR : ms_variant-variant.
    IF mv_is_reload NE abap_true.

      set_events( ). " 이벤트 리스너

      IF it_toolbar_excluding IS INITIAL. " toolbar
        set_default_exclude_toolbar( ).
      ELSE.
        mt_excluding_toolbar = it_toolbar_excluding.
      ENDIF.

      IF it_sortcat IS INITIAL."sort catalog
        set_default_sortcat( ).
      ELSE.
        mt_sortcat = it_sortcat.
      ENDIF.

      " variant설정
      CLEAR : ms_variant.
      IF is_variant IS NOT INITIAL.
        ms_variant = is_variant.
      ELSE.
        ms_variant-report   = mv_progid.
        ms_variant-username = sy-uname.
        ms_variant-handle   = ms_header_config-alv_key.

        CALL FUNCTION 'LVC_VARIANT_DEFAULT_GET'
          EXPORTING
            i_save        = iv_save
          CHANGING
            cs_variant    = ms_variant
          EXCEPTIONS
            wrong_input   = 1
            not_found     = 2
            program_error = 3
            OTHERS        = 4.

        IF sy-subrc EQ 2.
          SELECT SINGLE variant
            INTO ms_variant-variant
            FROM ltdx
           WHERE relid   EQ 'LT'
             AND handle  EQ ms_header_config-alv_key
             AND report  EQ ms_header_config-progid
             AND erfname EQ sy-uname.
        ENDIF.
      ENDIF.

    ENDIF.

    MOVE-CORRESPONDING ms_layout TO ls_layout.
    IF mv_mode EQ mc_upload_mode.
      ls_layout-no_rowins = abap_true.
    ENDIF.

    " 8. alv출력
    CALL METHOD set_table_for_first_display
      EXPORTING
        is_layout            = ls_layout
        it_toolbar_excluding = me->mt_excluding_toolbar
        i_save               = iv_save
        i_default            = iv_default
        is_variant           = ms_variant
      CHANGING
        it_outtab            = <lt_outtab>
        it_sort              = mt_sortcat
        it_fieldcatalog      = mt_fieldcat.


    CASE mv_mode.
      WHEN mc_display_mode.
        CALL METHOD set_ready_for_input
          EXPORTING
            i_ready_for_input = 0.
      WHEN mc_change_mode.
        CALL METHOD set_ready_for_input
          EXPORTING
            i_ready_for_input = 1.
      WHEN mc_upload_mode.
        CALL METHOD set_ready_for_input
          EXPORTING
            i_ready_for_input = 1.
    ENDCASE.


    IF ms_header_config-optimize_all_cols EQ abap_true.
      optimize_all_cols( ).
    ENDIF.
    IF mv_is_reload NE abap_true AND ms_header_config-no_totline NE abap_true.
      mv_tabix = lines( <lt_outtab> ).
      lv_str = mv_tabix.
      CONCATENATE lv_str `Row(s) Listed` INTO lv_str.
      MESSAGE lv_str TYPE 'S'.
    ENDIF.
    mv_is_reload = abap_true.
  ENDMETHOD.


  METHOD divide_line_to_cell.
    DATA : lv_int  TYPE i.
    DATA : ls_itab TYPE soi_generic_item.
    CLEAR ls_itab.
    lv_int = cv_fdpos.
    ls_itab-row = iv_tabix.
    ls_itab-column = cv_col.

    IF lv_int > 0.
      ls_itab-value = cs_data(lv_int).
    ENDIF.

    IF lv_int > 0.
      APPEND ls_itab TO ct_itab.
    ENDIF.
    lv_int = lv_int + 1.
    cs_data = cs_data+lv_int.
  ENDMETHOD.


  METHOD excel_download.
    DATA : lv_fullpath TYPE string.
    DATA : lv_directory TYPE string.
    DATA : lv_title TYPE string.
    DATA : lv_filename TYPE string.
    DATA : lv_path    TYPE string.
    DATA : lv_result TYPE i.
    DATA lv_msg TYPE string.

    IF iv_full_path IS INITIAL.
      lv_directory = 'C:/'.
      lv_title = 'File save'.

      CALL METHOD cl_gui_frontend_services=>file_save_dialog
        EXPORTING
          window_title      = lv_title
          default_extension = 'XLSX'
          default_file_name = lv_filename
          initial_directory = lv_directory
        CHANGING
          filename          = lv_filename
          path              = lv_path
          fullpath          = lv_fullpath
          user_action       = lv_result.
      IF lv_fullpath IS INITIAL.
        ev_subrc = 1.
        EXIT.
      ENDIF.
    ELSE.
      lv_fullpath = iv_full_path.
    ENDIF.

    IF mo_excel IS INITIAL.
      CREATE OBJECT mo_excel 'EXCEL.APPLICATION'.
      CALL METHOD OF mo_excel 'WORKBOOKS' = mo_workbooks.
      CALL METHOD OF mo_workbooks 'ADD' = mo_workbook.
      CALL METHOD OF mo_workbook 'Sheets' = mo_sheets.

      CALL METHOD OF mo_excel 'SHEETS' = mo_sheet
        EXPORTING
          #1       = 1.
      CALL METHOD OF mo_sheet 'SELECT'.

      move_itab_to_excel( EXPORTING it_data = it_data
                                    it_header = it_header ).

    ENDIF.


    CALL METHOD OF
      mo_workbook
      'SAVEAS'
      EXPORTING
        #1 = lv_fullpath.

    CALL METHOD OF mo_workbook 'CLOSE'.
    CALL METHOD OF mo_workbooks 'CLOSE'.
    CALL METHOD OF mo_excel 'CLOSE'.
    CALL METHOD OF mo_excel 'QUIT'.

    mv_sheet_num = 1.

    FREE OBJECT : mo_excel, mo_workbooks, mo_workbook, mo_sheets, mo_sheet.



    MESSAGE 'File generated successfully' TYPE 'S'.

  ENDMETHOD.


  METHOD excel_gui_upload.
    DATA: lt_file     TYPE filetable,
          ls_file     LIKE LINE OF lt_file,
          lv_rc       TYPE i,
          lv_filename TYPE        localfile.
    TYPES : BEGIN OF ty_txt,
              line(4096) TYPE c,
            END OF ty_txt,
            ty_t_txt TYPE TABLE OF ty_txt.

    DATA lt_data TYPE  ty_t_txt.
    DATA : lv_start_row TYPE i,
           lv_end_row   TYPE i,
           lv_start_col TYPE i,
           lv_end_col   TYPE i,
           lv_do_count  TYPE i,
           lv_msg       TYPE string,
           lv_str       TYPE string,
           lv_cnt       TYPE i.
    DATA : lt_excel     TYPE soi_generic_table,
           lt_excel_all TYPE soi_generic_table,
           ls_excel     TYPE soi_generic_item.

    CONSTANTS : c_paket_size TYPE i VALUE 10000.

    DATA : lo_start_cell TYPE ole2_object,
           lo_end_cell   TYPE ole2_object,
           lo_range      TYPE ole2_object.
    DATA lo_struc TYPE REF TO data.
    DATA lo_excel TYPE ole2_object .
    DATA lo_workbooks TYPE ole2_object .
    DATA lo_workbook TYPE ole2_object .
    DATA lo_sheets TYPE ole2_object .
    DATA lo_sheet TYPE ole2_object .
    FIELD-SYMBOLS: <ls_stab>  TYPE any,
                   <ls_field> TYPE any.

    DEFINE _set_assign.
      CLEAR : lv_str.
      CONCATENATE '<LS_STAB>-' &1 INTO lv_str.
      ASSIGN (lv_str) TO <ls_field>.
      IF <ls_stab> IS ASSIGNED.
        CASE &3.
          WHEN 'D'.
            REPLACE ALL OCCURRENCES OF '.' IN &2 WITH ''.
            REPLACE ALL OCCURRENCES OF '-' IN &2 WITH ''.
            REPLACE ALL OCCURRENCES OF '/' IN &2 WITH ''.
          WHEN 'T'.
            REPLACE ALL OCCURRENCES OF ':' IN &2 WITH ''.
          WHEN 'I' OR 'B' OR 'S' OR 'P' OR 'F' OR 'A' OR 'E'.
            REPLACE ALL OCCURRENCES OF ',' IN &2 WITH ''.
        ENDCASE.
*CONDENSE &2 NO-GAPS.
        <ls_field> = &2.
      ENDIF.
    END-OF-DEFINITION.


    CLEAR : lv_filename.

    IF iv_file_dialog NE abap_true AND iv_file_name IS INITIAL.
      MESSAGE 'Wrong Parameters' TYPE 'I' DISPLAY LIKE 'E'.
      ev_subrc = 1.
      EXIT.
    ENDIF.

    IF iv_file_dialog EQ abap_true.
      CALL METHOD cl_gui_frontend_services=>file_open_dialog
        EXPORTING
          window_title      = 'Select file'
          file_filter       = 'Excel files (*.XLSX)|*.XLSX| Excel files (*.XLS)|*.XLS|'
          default_extension = 'XLSX'
        CHANGING
          file_table        = lt_file
          rc                = lv_rc.

      IF  sy-subrc EQ 0.
        READ TABLE lt_file INTO ls_file INDEX 1.
        MOVE  ls_file-filename   TO  lv_filename.
      ENDIF.
    ELSE.
      lv_filename = iv_file_name.
    ENDIF.
    IF lv_filename IS INITIAL.
      ev_subrc = 2.
      EXIT.
    ENDIF.
    IF strlen( lv_filename ) < 5.
      ev_subrc = 2.
      EXIT.
    ENDIF.

    DATA : lt_components TYPE abap_compdescr_tab,
           ls_component  LIKE LINE OF lt_components,
           lo_struct_des TYPE REF TO cl_abap_structdescr,
           lo_table_des  TYPE REF TO cl_abap_tabledescr.

    lo_table_des ?= cl_abap_typedescr=>describe_by_data( ct_data ).
    lo_struct_des ?= lo_table_des->get_table_line_type( ).
    lt_components[] = lo_struct_des->components[].



    CLEAR lt_excel.
    lv_start_row = 1.
    lv_start_col = 1.
    lv_end_col = lines( lt_components ).
    lv_do_count = 1.
    lv_msg = 'Opening excel file..'.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        text = lv_msg.

    CREATE OBJECT lo_excel 'EXCEL.APPLICATION'.

    CALL METHOD OF
      lo_excel
        'WORKBOOKS' = lo_workbooks.
    CALL METHOD OF
        lo_workbooks
        'Open'       = lo_workbook
      EXPORTING
        #1           = lv_filename.

    CALL METHOD OF
      lo_workbook
        'Sheets' = lo_sheets.
    CALL METHOD OF
        lo_sheets
        'item'    = lo_sheet
      EXPORTING
        #1        = iv_sheet_no. " sheet number

    IF iv_max_row_cnt > c_paket_size.
      lv_end_row = c_paket_size.
      lv_do_count = iv_max_row_cnt / c_paket_size.
      IF iv_max_row_cnt MOD c_paket_size > 0.
        ADD 1 TO lv_do_count.
      ENDIF.
    ELSE.
      lv_end_row = iv_max_row_cnt.
    ENDIF.

    ADD 1 TO lv_start_row. " cause header line
    ADD 1 TO lv_end_row. " cause header line

    DO lv_do_count TIMES.

      CLEAR : lv_str, lv_msg.
      lv_str = lv_start_row - 1.
      CONCATENATE `Processing : ` lv_str ` ~ ` INTO lv_msg.
      lv_str = lv_end_row - 1.
      CONCATENATE lv_msg lv_str `Rows` INTO lv_msg.
      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          text = lv_msg.

      CALL METHOD OF
          lo_sheet
          'Cells'  = lo_start_cell
        EXPORTING
          #1       = lv_start_row
          #2       = lv_start_col.
      CALL METHOD OF
          lo_sheet
          'Cells'  = lo_end_cell
        EXPORTING
          #1       = lv_end_row
          #2       = lv_end_col.

      CALL METHOD OF
          lo_sheet
          'RANGE'  = lo_range
        EXPORTING
          #1       = lo_start_cell
          #2       = lo_end_cell.

      CALL METHOD OF
        lo_range
        'SELECT'.


      CALL METHOD OF
        lo_range
        'COPY'.

      CALL METHOD cl_gui_frontend_services=>clipboard_import
        IMPORTING
          data                 = lt_data
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
          OTHERS               = 4.
      IF lt_data[] IS NOT INITIAL.
        CLEAR : ls_excel, lt_excel.
        move_to_excel_itab( EXPORTING it_data = lt_data
                            IMPORTING et_itab = lt_excel ).

        APPEND LINES OF lt_excel TO lt_excel_all.

        READ TABLE lt_excel_all INTO ls_excel INDEX lines( lt_excel_all ).
        IF sy-subrc EQ 0.
          IF ls_excel-row(1) EQ '*'.
            ADD c_paket_size TO lv_cnt.
          ELSE.
            ADD ls_excel-row TO lv_cnt.
          ENDIF.
        ENDIF.
      ELSE.
        EXIT.
      ENDIF.


      REFRESH lt_data.
      CALL METHOD cl_gui_frontend_services=>clipboard_export
        IMPORTING
          data                 = lt_data
        CHANGING
          rc                   = lv_rc
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
          OTHERS               = 4.


      ADD c_paket_size TO lv_start_row.
      ADD c_paket_size TO lv_end_row.
      IF lv_end_row > iv_max_row_cnt.
        lv_end_row = iv_max_row_cnt.
      ENDIF.



    ENDDO.

    FREE OBJECT lo_start_cell.
    FREE OBJECT lo_end_cell.
    FREE OBJECT lo_range.
    FREE OBJECT lo_sheet.
    FREE OBJECT lo_sheets.
    FREE OBJECT lo_workbooks.
    FREE OBJECT lo_workbook.

    CALL METHOD OF
      lo_excel
      'QUIT'.

    FREE OBJECT lo_excel.


    CREATE DATA lo_struc LIKE LINE OF ct_data.
    ASSIGN lo_struc->* TO <ls_stab>.

    CLEAR : ls_excel, <ls_stab>.
    LOOP AT lt_excel_all INTO ls_excel.
      READ TABLE lt_components INTO ls_component INDEX ls_excel-column.
      IF sy-subrc EQ 0.
        _set_assign ls_component-name ls_excel-value ls_component-type_kind.
      ENDIF.
      AT END OF row.
        CHECK <ls_stab> IS NOT INITIAL.
        APPEND <ls_stab> TO ct_data.
        CLEAR <ls_stab>.
      ENDAT.
      CLEAR : ls_excel.
    ENDLOOP.

    lv_str = lv_cnt.
    CONCATENATE `Appendding ` lv_str `rows uploaded data to itab` INTO lv_msg.
    MESSAGE lv_msg TYPE 'S'.



    ev_subrc = 0.

  ENDMETHOD.


  METHOD excel_its_upload.
    DATA: lt_file       TYPE filetable,
          ls_file       LIKE LINE OF lt_file,
          lv_rc         TYPE i,
          lv_filename   TYPE        string,
          lv_begin_col  TYPE  i VALUE 1,
          lv_begin_row  TYPE  i VALUE 2,
          lv_end_col    TYPE  i,
          lv_end_row    TYPE  i,
          lv_row        TYPE i,
          lv_col        TYPE i,
          lv_col_offset TYPE i,
          lv_msg        TYPE string,
          lv_str        TYPE string,
          lv_cnt        TYPE i.

    DATA : lt_components TYPE abap_compdescr_tab,
           ls_component  LIKE LINE OF lt_components,
           lo_struct_des TYPE REF TO cl_abap_structdescr,
           lo_table_des  TYPE REF TO cl_abap_tabledescr,
           lo_struct_ref TYPE REF TO data,
           lo_data       TYPE REF TO data.
    FIELD-SYMBOLS: <lt_data>  TYPE STANDARD TABLE,
                   <ls_data>  TYPE any,
                   <lt_excel> TYPE STANDARD TABLE.

    CLEAR : lv_filename.
    lv_end_row = iv_max_row_cnt.

    IF iv_file_dialog NE abap_true AND iv_file_name IS INITIAL.
      MESSAGE 'Wrong Parameters' TYPE 'I' DISPLAY LIKE 'E'.
      ev_subrc = 1.
      EXIT.
    ENDIF.

* 1. file open
    IF iv_file_dialog EQ abap_true.
      CALL METHOD cl_gui_frontend_services=>file_open_dialog
        EXPORTING
          window_title      = 'Select file'
          file_filter       = 'Excel files (*.XLSX)|*.XLSX| Excel files (*.XLS)|*.XLS|'
          default_extension = 'XLSX'
        CHANGING
          file_table        = lt_file
          rc                = lv_rc.

      IF  sy-subrc EQ 0.
        READ TABLE lt_file INTO ls_file INDEX 1.
        MOVE  ls_file-filename   TO  lv_filename.
      ENDIF.
    ELSE.
      lv_filename = iv_file_name.
    ENDIF.
    IF lv_filename IS INITIAL.
      ev_subrc = 2.
      EXIT.
    ENDIF.
    IF strlen( lv_filename ) < 5.
      ev_subrc = 2.
      EXIT.
    ENDIF.

* 2. get excel file data
    TRY.
        DATA(lv_file_x) = cl_openxml_helper=>load_local_file( lv_filename ).
      CATCH
       cx_openxml_not_found.
    ENDTRY.


    TRY.
        DATA(lo_excel) = NEW cl_fdt_xl_spreadsheet(
          document_name = lv_filename
          xdocument     = lv_file_x ).

        IF lo_excel IS BOUND.
          lo_excel->if_fdt_doc_spreadsheet~get_worksheet_names(
            IMPORTING
              worksheet_names = DATA(lt_worksheets) ).
        ENDIF.
      CATCH cx_root.
    ENDTRY.

    READ TABLE lt_worksheets INDEX 1 REFERENCE INTO DATA(lo_worksheets).
    IF sy-subrc <> 0.
      ev_subrc = 1.
      EXIT.
    ENDIF.

    DATA(lo_worksheet_itab) =
     lo_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( lo_worksheets->* ).

    " Fetch all records in the active worksheet
    ASSIGN lo_worksheet_itab->* TO <lt_excel>.

* 3. get itab reference
    TRY.
        lo_table_des ?= cl_abap_typedescr=>describe_by_data( ct_data ).
        lo_struct_des ?= lo_table_des->get_table_line_type( ).
        lt_components[] = lo_struct_des->components[].

* 4. move excel data to itab
        lv_end_col = lines( lt_components ).
        lv_col = lv_end_col - lv_begin_col + 1.
        LOOP AT <lt_excel> ASSIGNING FIELD-SYMBOL(<ls_excel>) FROM lv_begin_row TO lv_end_row.
          IF NOT <ls_excel> IS INITIAL.
            CREATE DATA lo_struct_ref TYPE HANDLE lo_struct_des.
            ASSIGN lo_struct_ref->* TO <ls_data>.
            lv_col_offset = lv_begin_col.
            DO lv_col TIMES.
              ASSIGN COMPONENT lv_col_offset OF STRUCTURE <ls_excel>
                                             TO FIELD-SYMBOL(<lv_from_val>).
              ASSIGN COMPONENT lv_col_offset OF STRUCTURE <ls_data>
                                             TO FIELD-SYMBOL(<lv_to_val>).
              <lv_to_val> = <lv_from_val>.

              lv_col_offset = lv_col_offset + 1.
            ENDDO.
            APPEND <ls_data> TO ct_data.
            ADD 1 TO lv_cnt.
          ENDIF.
        ENDLOOP.
      CATCH cx_root.
    ENDTRY.
    lv_str = lv_cnt.
    CONCATENATE `Appendding ` lv_str `rows uploaded data to itab` INTO lv_msg.
    MESSAGE lv_msg TYPE 'S'.

    ev_subrc = 0.

  ENDMETHOD.


  METHOD excel_upload.
    DATA lv_its TYPE flag.
    CALL FUNCTION 'GUI_IS_ITS'
      IMPORTING
        return = lv_its.

    IF lv_its EQ abap_true.
      ev_subrc = excel_its_upload( EXPORTING iv_file_dialog = iv_file_dialog
                                             iv_file_name = iv_file_name
                                             iv_max_row_cnt = iv_max_row_cnt
                                             iv_sheet_no = iv_sheet_no
                                   CHANGING ct_data = ct_data ).
    ELSE.
      ev_subrc = excel_gui_upload( EXPORTING iv_file_dialog = iv_file_dialog
                                             iv_file_name = iv_file_name
                                             iv_max_row_cnt = iv_max_row_cnt
                                             iv_sheet_no = iv_sheet_no
                                   CHANGING ct_data = ct_data ).
    ENDIF.

  ENDMETHOD.


  METHOD get_all_exclude_toolbar.
    DATA : lv_ui_func           TYPE ui_func,
           lt_toolbar_excluding TYPE ui_functions.

    DEFINE _set_toolbar_exclude.
      CLEAR : lv_ui_func.
      lv_ui_func = &1.
      APPEND lv_ui_func TO lt_toolbar_excluding.
    END-OF-DEFINITION.

    CLEAR lt_toolbar_excluding.
    _set_toolbar_exclude :
         cl_gui_alv_grid=>mc_fc_loc_undo, "
         cl_gui_alv_grid=>mc_fc_auf,      " 소계확장 &AUF
         cl_gui_alv_grid=>mc_fc_average,  " &AVERAGE
         cl_gui_alv_grid=>mc_fc_back_classic,
         cl_gui_alv_grid=>mc_fc_call_abc, " &ABC
         cl_gui_alv_grid=>mc_fc_call_chain,
         cl_gui_alv_grid=>mc_fc_call_crbatch,
         cl_gui_alv_grid=>mc_fc_call_crweb,
         cl_gui_alv_grid=>mc_fc_call_lineitems,
         cl_gui_alv_grid=>mc_fc_call_master_data,
         cl_gui_alv_grid=>mc_fc_call_more,
         cl_gui_alv_grid=>mc_fc_call_report,
         cl_gui_alv_grid=>mc_fc_call_xint,
         cl_gui_alv_grid=>mc_fc_call_xxl,
         cl_gui_alv_grid=>mc_fc_col_invisible,
         cl_gui_alv_grid=>mc_fc_col_optimize,
         cl_gui_alv_grid=>mc_fc_current_variant,
         cl_gui_alv_grid=>mc_fc_data_save,
         cl_gui_alv_grid=>mc_fc_delete_filter,
         cl_gui_alv_grid=>mc_fc_deselect_all,
         cl_gui_alv_grid=>mc_fc_detail,
         cl_gui_alv_grid=>mc_fc_expcrdata,
         cl_gui_alv_grid=>mc_fc_expcrdesig,
         cl_gui_alv_grid=>mc_fc_expcrtempl,
         cl_gui_alv_grid=>mc_fc_expmdb,
         cl_gui_alv_grid=>mc_fc_extend,
         cl_gui_alv_grid=>mc_fc_f4,
         cl_gui_alv_grid=>mc_fc_filter,
         cl_gui_alv_grid=>mc_fc_find,
         cl_gui_alv_grid=>mc_fc_fix_columns,
         cl_gui_alv_grid=>mc_fc_graph,
         cl_gui_alv_grid=>mc_fc_help,
         cl_gui_alv_grid=>mc_fc_info,
         cl_gui_alv_grid=>mc_fc_load_variant,
         cl_gui_alv_grid=>mc_fc_loc_copy,          " 행 카피
         cl_gui_alv_grid=>mc_fc_html,
         cl_gui_alv_grid=>mc_fc_loc_copy_row,      " 행 카피
         cl_gui_alv_grid=>mc_fc_loc_cut,           " 가위
         cl_gui_alv_grid=>mc_fc_loc_delete_row,    " 행삭제
         cl_gui_alv_grid=>mc_fc_loc_insert_row,    " 행삽입
         cl_gui_alv_grid=>mc_fc_loc_move_row,
         cl_gui_alv_grid=>mc_fc_loc_append_row,    " 라인생성
         cl_gui_alv_grid=>mc_fc_loc_paste,         " 겹쳐쓰기
         cl_gui_alv_grid=>mc_fc_loc_paste_new_row, " 겹쳐쓰기
         cl_gui_alv_grid=>mc_fc_maintain_variant,
         cl_gui_alv_grid=>mc_fc_maximum,
         cl_gui_alv_grid=>mc_fc_minimum,
         cl_gui_alv_grid=>mc_fc_pc_file,
         cl_gui_alv_grid=>mc_fc_print,
         cl_gui_alv_grid=>mc_fc_print_back,
         cl_gui_alv_grid=>mc_fc_print_prev,
         cl_gui_alv_grid=>mc_fc_reprep,
         cl_gui_alv_grid=>mc_fc_save_variant,
         cl_gui_alv_grid=>mc_fc_select_all,
         cl_gui_alv_grid=>mc_fc_send,
         cl_gui_alv_grid=>mc_fc_separator,
         cl_gui_alv_grid=>mc_fc_sort,
         cl_gui_alv_grid=>mc_fc_sort_asc,
         cl_gui_alv_grid=>mc_fc_sort_dsc,
         cl_gui_alv_grid=>mc_fc_subtot,
         cl_gui_alv_grid=>mc_fc_sum,
         cl_gui_alv_grid=>mc_fc_to_office,
         cl_gui_alv_grid=>mc_fc_to_rep_tree,
         cl_gui_alv_grid=>mc_fc_unfix_columns,
         cl_gui_alv_grid=>mc_fc_views,
         cl_gui_alv_grid=>mc_fc_view_crystal,
         cl_gui_alv_grid=>mc_fc_view_excel,
         cl_gui_alv_grid=>mc_fc_view_grid,
         cl_gui_alv_grid=>mc_fc_word_processor,
         cl_gui_alv_grid=>mc_fc_refresh,
         cl_gui_alv_grid=>mc_fc_check.


    rt_toolbar_excluding = lt_toolbar_excluding.

  ENDMETHOD.


  METHOD get_alv_itab.
    DATA : lt_fcat TYPE lvc_t_fcat,
           ls_fcat TYPE lvc_s_fcat.
    IF it_fcat_config IS INITIAL.
      lt_fcat = get_fieldcat_config( EXPORTING iv_progid = iv_progid
                                               iv_alv_key = iv_alv_key
                                               iv_fcat_key = iv_fcat_key ).
    ELSE.
      LOOP AT it_fcat_config ASSIGNING FIELD-SYMBOL(<ls_fcat_config>).
        CLEAR ls_fcat.
        MOVE-CORRESPONDING <ls_fcat_config> TO ls_fcat.
        APPEND ls_fcat TO lt_fcat.
      ENDLOOP.
    ENDIF.
    DELETE lt_fcat WHERE tech EQ abap_true.
    DELETE lt_fcat WHERE no_out EQ abap_true.

    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = lt_fcat
      IMPORTING
        ep_table        = eo_data.

    LOOP AT lt_fcat INTO ls_fcat.
      APPEND ls_fcat-reptext TO et_header_label.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_alv_mode.
    rv_return = mv_mode.
  ENDMETHOD.


  METHOD get_ddl_by_domain.
    DATA : lt_dom	TYPE TABLE OF	dd07v,
           ls_ddl TYPE lvc_s_dral.
    FIELD-SYMBOLS <ls_dom> TYPE dd07v.
    CLEAR : lt_dom, ls_ddl.

    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = iv_domname
        text           = iv_text
        langu          = iv_langu
        bypass_buffer  = iv_bypass_buffer
      TABLES
        dd07v_tab      = lt_dom
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2.

    LOOP AT lt_dom ASSIGNING <ls_dom>.
      CLEAR ls_ddl.
      ls_ddl-handle = iv_ddl_number.
      CONCATENATE  <ls_dom>-domvalue_l ` : ` <ls_dom>-ddtext INTO ls_ddl-value.
      ls_ddl-int_value = <ls_dom>-domvalue_l.
      APPEND ls_ddl TO rt_ddl.
    ENDLOOP.
    CLEAR lt_dom[].
  ENDMETHOD.


  METHOD get_drop_down_config.
    DATA : lt_drop_down  TYPE lvc_t_dral,
           ls_drop_down  TYPE lvc_s_dral,
           lv_max_handle TYPE i,
           lv_tabix      TYPE sy-tabix.

    IF ct_drop_down[] IS NOT INITIAL.
      lt_drop_down = ct_drop_down.
      SORT lt_drop_down BY handle DESCENDING.
      READ TABLE lt_drop_down INTO ls_drop_down INDEX 1.
      lv_max_handle = ls_drop_down-handle.
    ELSE.
      lv_max_handle = 0.
    ENDIF.

    LOOP AT mt_fieldcat INTO ms_fieldcat WHERE drdn_alias EQ abap_true
                                           AND drdn_hndl EQ 0
                                           AND drdn_field IS INITIAL
                                           AND domname IS NOT INITIAL.
      lv_tabix = sy-tabix.
      ADD 1 TO lv_max_handle.
      CLEAR lt_drop_down[].
      get_ddl_by_domain( EXPORTING iv_domname = ms_fieldcat-domname
                                   iv_text = abap_true
                                   iv_langu = sy-langu
                                   iv_bypass_buffer = abap_true
                                   iv_ddl_number = lv_max_handle
                         RECEIVING rt_ddl = lt_drop_down ).
      APPEND LINES OF lt_drop_down TO ct_drop_down.
      ms_fieldcat-drdn_hndl = lv_max_handle.
      MODIFY mt_fieldcat FROM ms_fieldcat INDEX lv_tabix.

    ENDLOOP.


  ENDMETHOD.


  METHOD get_f4_value.
    DATA : lt_return TYPE TABLE OF ddshretval.
    DATA : ls_return LIKE LINE OF lt_return.


    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = iv_fieldname
        value_org       = 'S'
      TABLES
        value_tab       = it_data
        return_tab      = lt_return
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.

    IF sy-subrc EQ 0.
      READ TABLE lt_return INTO ls_return INDEX 1.
      rv_value = ls_return-fieldval.
    ENDIF.
  ENDMETHOD.


  METHOD get_fieldcat.

    CLEAR mt_config_fieldcat.
    SELECT * INTO TABLE mt_config_fieldcat
    FROM ztbrd00020
    WHERE progid = mv_progid
      AND alv_key = mv_alv_key
      AND fcat_key = mv_fcat_key.

    IF sy-subrc NE 0.
      SELECT * INTO TABLE mt_config_fieldcat
      FROM ztbrd00020
      WHERE progid = mv_progid
        AND alv_key = mv_alv_key
        AND fcat_key = 'DEFAULT'.
    ENDIF.

    SORT mt_config_fieldcat BY fieldname.

    SELECT * INTO TABLE mt_config_fieldcat_text
    FROM ztbrd00070
    WHERE progid = mv_progid
      AND alv_key = mv_alv_key
      AND fcat_key = mv_fcat_key
      AND spras = sy-langu.

    SORT mt_config_fieldcat_text BY fieldname.

  ENDMETHOD.


  METHOD get_fieldcat_config.
    DATA : lt_config_fcat TYPE TABLE OF ztbrd00020,
           ls_fcat        TYPE lvc_s_fcat.
    FIELD-SYMBOLS <fs> TYPE ztbrd00020.
    SELECT * INTO TABLE lt_config_fcat
      FROM ztbrd00020
      WHERE progid = iv_progid
        AND alv_key = iv_alv_key
        AND fcat_key = iv_fcat_key
     ORDER BY col_pos .

    et_fcat = lt_config_fcat.

    LOOP AT lt_config_fcat ASSIGNING <fs>.
      CLEAR ls_fcat.
      MOVE-CORRESPONDING <fs> TO ls_fcat.
      ls_fcat-key = <fs>-zkey.
      APPEND ls_fcat TO rt_fcat.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_slis_config.
    DATA : lt_lvc_fcat    TYPE lvc_t_fcat,
           ls_lvc_fcat    TYPE lvc_s_fcat,
           ls_lvc_layout  TYPE lvc_s_layo,
           lt_lvc_sort    TYPE lvc_t_sort,
           ls_lvc_sort    TYPE lvc_s_sort,
           lt_slis_fcat   TYPE slis_t_fieldcat_alv,
           ls_slis_fcat   TYPE slis_fieldcat_alv,
           ls_slis_layout TYPE slis_layout_alv,
           lt_slis_sort   TYPE slis_t_sortinfo_alv,
           lt_config_fcat TYPE TABLE OF ztbrd00020,
           ls_config_fcat TYPE ztbrd00020.
    FIELD-SYMBOLS <fs> TYPE slis_fieldcat_alv.

    DATA lv_set_flag.

    DEFINE _set_sort_flag.
      IF ls_config_fcat-sr_&1 EQ abap_true.
        ls_lvc_sort-&1 = ls_config_fcat-sr_&1.
        lv_set_flag = abap_true.
      ENDIF.
    END-OF-DEFINITION.
    DEFINE _set_sort_num.
      IF ls_config_fcat-sr_&1  IS NOT INITIAL.
        ls_lvc_sort-&1 = ls_config_fcat-sr_&1.
        lv_set_flag = abap_true.
      ENDIF.
    END-OF-DEFINITION.
    SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_lvc_layout
     FROM ztbrd00010
     WHERE progid EQ iv_progid
       AND alv_key EQ iv_alv_key.

    SELECT * INTO TABLE lt_config_fcat
      FROM ztbrd00020
      WHERE progid = iv_progid
        AND alv_key = iv_alv_key
        AND fcat_key = iv_fcat_key.

    LOOP AT lt_config_fcat INTO ls_config_fcat.
      CLEAR ls_lvc_fcat.
      MOVE-CORRESPONDING ls_config_fcat TO ls_lvc_fcat.
      ls_lvc_fcat-key = ls_config_fcat-zkey.
      APPEND ls_lvc_fcat TO lt_lvc_fcat.


      CLEAR : ls_lvc_sort, lv_set_flag.
      _set_sort_flag : up, down, subtot, comp, expa, obligatory, no_out.
      _set_sort_num : group, spos, seltext, level.

      IF lv_set_flag = abap_true.
        ls_lvc_sort-fieldname = ls_config_fcat-fieldname.
        APPEND ls_lvc_sort TO lt_lvc_sort.
      ENDIF.

    ENDLOOP.

    CALL FUNCTION 'LVC_TRANSFER_TO_SLIS'
      EXPORTING
        is_layout_lvc           = ls_lvc_layout
        it_fieldcat_lvc         = lt_lvc_fcat
        it_sort_lvc             = lt_lvc_sort
      IMPORTING
        et_sort_alv             = et_slis_sort
        es_layout_alv           = es_slis_layout
        et_fieldcat_alv         = et_slis_fcat
      EXCEPTIONS
        it_data_missing         = 1
        it_fieldcat_lvc_missing = 2
        OTHERS                  = 3.

    LOOP AT lt_slis_fcat ASSIGNING <fs>.
      <fs>-tabname = iv_alv_key.
    ENDLOOP.



  ENDMETHOD.


  METHOD get_sort_filter_toolbar.
    DATA : lv_ui_func           TYPE ui_func,
           lt_toolbar_excluding TYPE ui_functions.

    DEFINE _set_toolbar_exclude.
      CLEAR : lv_ui_func.
      lv_ui_func = &1.
      APPEND lv_ui_func TO lt_toolbar_excluding.
    END-OF-DEFINITION.

    CLEAR lt_toolbar_excluding.
    _set_toolbar_exclude :
         cl_gui_alv_grid=>mc_fc_loc_undo, "
         cl_gui_alv_grid=>mc_fc_auf,      " 소계확장 &AUF
         cl_gui_alv_grid=>mc_fc_average,  " &AVERAGE
         cl_gui_alv_grid=>mc_fc_back_classic,
         cl_gui_alv_grid=>mc_fc_call_abc, " &ABC
         cl_gui_alv_grid=>mc_fc_call_chain,
         cl_gui_alv_grid=>mc_fc_call_crbatch,
         cl_gui_alv_grid=>mc_fc_call_crweb,
         cl_gui_alv_grid=>mc_fc_call_lineitems,
         cl_gui_alv_grid=>mc_fc_call_master_data,
         cl_gui_alv_grid=>mc_fc_call_more,
         cl_gui_alv_grid=>mc_fc_call_report,
         cl_gui_alv_grid=>mc_fc_call_xint,
         cl_gui_alv_grid=>mc_fc_call_xxl,
         cl_gui_alv_grid=>mc_fc_col_invisible,
         cl_gui_alv_grid=>mc_fc_col_optimize,
         cl_gui_alv_grid=>mc_fc_current_variant,
         cl_gui_alv_grid=>mc_fc_data_save,
         cl_gui_alv_grid=>mc_fc_delete_filter,
         cl_gui_alv_grid=>mc_fc_deselect_all,
         cl_gui_alv_grid=>mc_fc_detail,
         cl_gui_alv_grid=>mc_fc_expcrdata,
         cl_gui_alv_grid=>mc_fc_expcrdesig,
         cl_gui_alv_grid=>mc_fc_expcrtempl,
         cl_gui_alv_grid=>mc_fc_expmdb,
         cl_gui_alv_grid=>mc_fc_extend,
         cl_gui_alv_grid=>mc_fc_f4,
*         cl_gui_alv_grid=>mc_fc_filter,
*         cl_gui_alv_grid=>mc_fc_find,
         cl_gui_alv_grid=>mc_fc_fix_columns,
         cl_gui_alv_grid=>mc_fc_graph,
         cl_gui_alv_grid=>mc_fc_help,
         cl_gui_alv_grid=>mc_fc_info,
         cl_gui_alv_grid=>mc_fc_load_variant,
         cl_gui_alv_grid=>mc_fc_loc_copy,          " 행 카피
         cl_gui_alv_grid=>mc_fc_html,
         cl_gui_alv_grid=>mc_fc_loc_copy_row,      " 행 카피
         cl_gui_alv_grid=>mc_fc_loc_cut,           " 가위
         cl_gui_alv_grid=>mc_fc_loc_delete_row,    " 행삭제
         cl_gui_alv_grid=>mc_fc_loc_insert_row,    " 행삽입
         cl_gui_alv_grid=>mc_fc_loc_move_row,
         cl_gui_alv_grid=>mc_fc_loc_append_row,    " 라인생성
         cl_gui_alv_grid=>mc_fc_loc_paste,         " 겹쳐쓰기
         cl_gui_alv_grid=>mc_fc_loc_paste_new_row, " 겹쳐쓰기
         cl_gui_alv_grid=>mc_fc_maintain_variant,
         cl_gui_alv_grid=>mc_fc_maximum,
         cl_gui_alv_grid=>mc_fc_minimum,
         cl_gui_alv_grid=>mc_fc_pc_file,
         cl_gui_alv_grid=>mc_fc_print,
         cl_gui_alv_grid=>mc_fc_print_back,
         cl_gui_alv_grid=>mc_fc_print_prev,
         cl_gui_alv_grid=>mc_fc_reprep,
         cl_gui_alv_grid=>mc_fc_save_variant,
         cl_gui_alv_grid=>mc_fc_select_all,
         cl_gui_alv_grid=>mc_fc_send,
         cl_gui_alv_grid=>mc_fc_separator,
*         cl_gui_alv_grid=>mc_fc_sort,
*         cl_gui_alv_grid=>mc_fc_sort_asc,
*         cl_gui_alv_grid=>mc_fc_sort_dsc,
         cl_gui_alv_grid=>mc_fc_subtot,
         cl_gui_alv_grid=>mc_fc_sum,
         cl_gui_alv_grid=>mc_fc_to_office,
         cl_gui_alv_grid=>mc_fc_to_rep_tree,
         cl_gui_alv_grid=>mc_fc_unfix_columns,
         cl_gui_alv_grid=>mc_fc_views,
         cl_gui_alv_grid=>mc_fc_view_crystal,
         cl_gui_alv_grid=>mc_fc_view_excel,
         cl_gui_alv_grid=>mc_fc_view_grid,
         cl_gui_alv_grid=>mc_fc_word_processor,
         cl_gui_alv_grid=>mc_fc_refresh,
         cl_gui_alv_grid=>mc_fc_check.


    rt_toolbar_excluding = lt_toolbar_excluding.

  ENDMETHOD.


  METHOD goto_row_focus.

    IF iv_rowno > 0.
      ms_row_id-index = iv_rowno.
    ENDIF.
    set_current_cell_via_id( EXPORTING is_row_id = ms_row_id ).


  ENDMETHOD.


  METHOD handle_after_refresh.

    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.
    CONCATENATE mv_alv_key  '_'  'AFTER_REFRESH' INTO lv_form_name.


    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_callback_progid) IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found cx_sy_dyn_call_param_missing.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.

  ENDMETHOD.


  METHOD handle_button_click.
    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.
    CONCATENATE mv_alv_key '_BUTTON_CLICK' INTO lv_form_name.

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_callback_progid) USING es_col_id es_row_no IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found cx_sy_dyn_call_param_missing.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.

  ENDMETHOD.


  METHOD handle_data_changed.
    DATA : lv_form_name TYPE string,
           ls_mod_cells TYPE lvc_s_modi,
           lv_str       TYPE string.
    DATA : ls_stable      TYPE lvc_s_stbl,
           lv_subrc_main  TYPE sy-subrc VALUE 4,
           lv_subrc_field TYPE sy-subrc VALUE 4.
    DATA lt_mod_cells TYPE lvc_t_modi.

    lt_mod_cells = er_data_changed->mt_good_cells.

    IF ms_header_config-change_evt EQ abap_true.
      TRY.

          CLEAR lv_form_name.
          CONCATENATE ms_header_config-alv_key '_DATA_CHANGED'
                   INTO lv_form_name.
          PERFORM (lv_form_name) IN PROGRAM (mv_callback_progid)
          USING er_data_changed
                e_onf4
                e_onf4_before
                e_onf4_after
                e_ucomm
          IF FOUND.
          lv_subrc_main = 0.
        CATCH cx_sy_dyn_call_param_not_found.
          lv_str = 'data_changed subroutine parameters are not competable!!'.
          MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
      ENDTRY.
    ENDIF.
    CLEAR lv_str.
    TRY.
        LOOP AT lt_mod_cells INTO ls_mod_cells.
          READ TABLE mt_config_fieldcat INTO ms_config_fieldcat
               WITH KEY fieldname = ls_mod_cells-fieldname
               BINARY SEARCH.
          IF sy-subrc EQ 0 AND ms_config_fieldcat-change_evt EQ abap_true.
            lv_subrc_field = 0.
            CLEAR lv_form_name.
            CONCATENATE ms_header_config-alv_key '_' ls_mod_cells-fieldname '_CHANGED'
                     INTO lv_form_name.
            PERFORM (lv_form_name) IN PROGRAM (mv_callback_progid)
                  USING er_data_changed
                        ls_mod_cells-row_id
                        ls_mod_cells-value
                  IF FOUND.
          ENDIF.
        ENDLOOP.
      CATCH cx_sy_dyn_call_param_not_found cx_sy_dyn_call_param_missing.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.
*    IF lv_subrc_main EQ 0 OR lv_subrc_field EQ 0.
*      ls_stable-row = ls_stable-col = abap_true.
*      CALL METHOD me->refresh_table_display
*        EXPORTING
*          is_stable      = ls_stable
*          i_soft_refresh = abap_true
*        EXCEPTIONS
*          finished       = 1
*          OTHERS         = 2.
*    ENDIF.
  ENDMETHOD.


  METHOD handle_double_click.
    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.

    CONCATENATE mv_alv_key '_DOUBLE_CLICK' INTO lv_form_name.

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_callback_progid) USING e_row e_column es_row_no IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found cx_sy_dyn_call_param_missing.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.


  ENDMETHOD.


  METHOD handle_hotspot_click.
    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.
    CONCATENATE mv_alv_key '_' e_column_id-fieldname '_CLICK' INTO lv_form_name.

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_callback_progid) USING e_row_id e_column_id es_row_no IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found cx_sy_dyn_call_param_missing.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.

  ENDMETHOD.


  METHOD handle_onf4.
    DATA lv_value TYPE lvc_value.
    FIELD-SYMBOLS <lt_modi> TYPE lvc_t_modi.
    DATA : ls_modi TYPE lvc_s_modi.
    IF mt_f4_field[] IS INITIAL.
      MESSAGE 'No Fields Appended For F4' TYPE 'I' DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.


    DATA : lv_form_name TYPE string,
           lv_str       TYPE string.

    CONCATENATE ms_header_config-alv_key '_' e_fieldname '_F4' INTO lv_form_name.

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_callback_progid) USING es_row_no
                                                          IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found cx_sy_dyn_call_param_missing.
        TRY.
            PERFORM (lv_form_name) IN PROGRAM (mv_callback_progid) USING  e_fieldname
                                                                          e_fieldvalue
                                                                          es_row_no
                                                                          er_event_data
                                                                          et_bad_cells
                                                                          e_display
                                                                          lv_value
                                                                   IF FOUND.
            IF lv_value IS NOT INITIAL.
              ASSIGN er_event_data->m_data->* TO <lt_modi>.
              ls_modi-row_id   = es_row_no-row_id.
              ls_modi-fieldname = e_fieldname.
              ls_modi-value = lv_value.
              APPEND ls_modi TO <lt_modi>.
            ENDIF.

          CATCH cx_sy_dyn_call_param_not_found cx_sy_dyn_call_param_missing.
            CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
            MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
        ENDTRY.
    ENDTRY.




    er_event_data->m_event_handled = 'X'.


  ENDMETHOD.


  METHOD handle_toolbar.
    DATA : lv_form_name TYPE string,
           lv_str       TYPE string,
           ls_toolbar   TYPE stb_button,
           ls_btnmnu    TYPE stb_btnmnu.

    DEFINE _set_toolbar.
      CLEAR ls_toolbar.
      MOVE &1 TO ls_toolbar-butn_type.
      MOVE &2 TO ls_toolbar-function.
      MOVE &3 TO ls_toolbar-icon.
      MOVE &4 TO ls_toolbar-quickinfo.
      MOVE &5 TO ls_toolbar-text.
      MOVE &6 TO ls_toolbar-disabled.
      APPEND ls_toolbar TO e_object->mt_toolbar.
    END-OF-DEFINITION.

    IF ms_header_config-zhelp EQ abap_true.
      _set_toolbar ' ' mc_ucomm-help icon_system_extended_help 'Help Guide' '' ' '.
      _set_toolbar '3' '' '' '' '' ' '.
    ENDIF.
    CASE mv_mode.
      WHEN mc_display_mode.
        IF ms_header_config-zrefresh EQ abap_true.
          _set_toolbar ' ' mc_ucomm-refresh mc_icon-refresh 'Refresh' '' ' '.
        ENDIF.
        IF ms_header_config-zcreate EQ abap_true
           OR ms_header_config-zupdate EQ abap_true.
          _set_toolbar ' ' mc_ucomm-change mc_icon-change 'Change' '' ' '.
        ENDIF.
        IF ms_header_config-zcreate EQ abap_true.
          _set_toolbar ' ' mc_create_mode mc_icon-create 'Create' '' 'X'.
          _set_toolbar ' ' mc_ucomm-insert mc_icon-insert_row 'Insert' '' 'X'.
        ENDIF.
        IF ms_header_config-zdelete EQ abap_true.
          IF ms_header_config-zcreate EQ abap_true
            OR ms_header_config-zupdate EQ abap_true.
            _set_toolbar ' ' mc_ucomm-delete mc_icon-delete_row 'Delete' '' 'X'.
          ELSE.
            _set_toolbar ' ' mc_ucomm-delete mc_icon-delete_row 'Delete' '' ' '.
          ENDIF.
        ENDIF.
      WHEN mc_change_mode.
        IF ms_header_config-zrefresh EQ abap_true.
          _set_toolbar ' ' mc_ucomm-refresh mc_icon-refresh 'Refresh' '' 'X'.
        ENDIF.
        IF ms_header_config-zcreate EQ abap_true
           OR ms_header_config-zupdate EQ abap_true.
          _set_toolbar ' ' mc_ucomm-cancel mc_icon-cancel 'Cancel' '' ' '.
        ENDIF.
        IF ms_header_config-zcreate EQ abap_true.
          _set_toolbar ' ' mc_create_mode mc_icon-create 'Create' '' ' '.
          _set_toolbar ' ' mc_ucomm-insert mc_icon-insert_row 'Insert' '' ' '.
        ENDIF.
        IF ms_header_config-zdelete EQ abap_true.
          _set_toolbar ' ' mc_ucomm-delete mc_icon-delete_row 'Delete' '' ' '.
        ENDIF.
    ENDCASE.
    IF mv_mode NE mc_upload_mode.
      IF ms_header_config-zexcel EQ abap_true.
        _set_toolbar cntb_btype_dropdown mc_ucomm-xls mc_icon-xls 'Excel' '' ''.

*        IF mo_cl_menu_xls IS INITIAL.
        CREATE OBJECT mo_cl_menu_xls.
        CALL METHOD mo_cl_menu_xls->add_function
          EXPORTING
            fcode = mc_ucomm-upload
            text  = 'Upload'.
        CALL METHOD mo_cl_menu_xls->add_function
          EXPORTING
            fcode = mc_ucomm-download
            text  = 'Download'.

        CLEAR ls_btnmnu.
        ls_btnmnu-function = mc_ucomm-xls.
        ls_btnmnu-ctmenu   = mo_cl_menu_xls.
        APPEND ls_btnmnu TO e_object->mt_btnmnu.
*        ENDIF.
      ENDIF.
    ENDIF.
    CONCATENATE mv_alv_key '_SET_TOOLBAR' INTO lv_form_name.

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_callback_progid) USING e_interactive e_object IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.


  ENDMETHOD.


  METHOD handle_user_command.
    DATA : lv_form_name  TYPE string,
           lv_str        TYPE string,
           lv_help_tcode TYPE  tcode,
           lv_help_acode TYPE  char30.
    CONCATENATE mv_alv_key '_' e_ucomm '_CLICK' INTO lv_form_name.

    get_current_cell_col_id( IMPORTING col_id = ms_col_id ).
    get_current_cell_row_id( IMPORTING row_id = ms_row_id ).

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_callback_progid) IF FOUND.
        IF e_ucomm EQ mc_ucomm-help. "HELP GUIDE공통 호출

          lv_help_tcode = mv_progid.
          lv_help_acode = mv_alv_key.

          CALL FUNCTION 'ZCMA_WORK_HELP_DISPLAY'
            EXPORTING
              iv_tcode = lv_help_tcode
              iv_acode = lv_help_acode
            EXCEPTIONS
              no_data  = 1.
          IF sy-subrc NE 0.
            MESSAGE 'No Help Guide Found' TYPE 'I'.
          ENDIF.
        ENDIF.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.



*    set_current_cell_via_id( EXPORTING is_column_id = ms_col_id
*                                       is_row_id = ms_row_id ).

  ENDMETHOD.


  METHOD insert_toolbar_button.
    DATA : ls_toolbar TYPE stb_button.
    CLEAR ls_toolbar.

    MOVE iv_butn_type TO ls_toolbar-butn_type.
    MOVE iv_function TO ls_toolbar-function.
    MOVE iv_icon TO ls_toolbar-icon.
    MOVE iv_quickinfo TO ls_toolbar-quickinfo.
    MOVE iv_text TO ls_toolbar-text.
    MOVE iv_disabled TO ls_toolbar-disabled.


    READ TABLE m_cl_toolbar->mt_toolbar TRANSPORTING NO FIELDS WITH KEY  function = iv_function .
    IF sy-subrc NE 0.
      INSERT ls_toolbar INTO m_cl_toolbar->mt_toolbar INDEX iv_index.
    ENDIF.

  ENDMETHOD.


  METHOD is_changing.
    rv_flag = mv_on_chainging_flag.
  ENDMETHOD.


  METHOD itab_to_excel_download.
    TYPES : BEGIN OF lty_header,
              fieldname TYPE fieldname,
            END OF lty_header.

    DATA: lo_gui    TYPE REF TO cl_gui_frontend_services,
          lv_title  TYPE string,
          lv_folder TYPE string,
          lv_dir    TYPE string.

    DATA lo_table_descr TYPE REF TO cl_abap_tabledescr.
    DATA lo_struct_descr TYPE REF TO cl_abap_structdescr.
    DATA lt_columns TYPE abap_compdescr_tab.
    FIELD-SYMBOLS <ls_column> LIKE LINE OF lt_columns.
    DATA : lt_head TYPE TABLE OF lty_header,
           ls_head TYPE lty_header,
           lv_head TYPE string.
    DATA : lv_filename TYPE string.
**  1. FILE NAME
    IF iv_filename IS INITIAL.
      lv_filename = 'SAMPLE.XLS'.
    ELSE.
      CONCATENATE iv_filename '.XLS'  INTO lv_filename.
    ENDIF.

** 2. HEADER

    lo_table_descr ?= cl_abap_typedescr=>describe_by_data( it_tab[] ).
    lo_struct_descr ?= lo_table_descr->get_table_line_type( ).
    lt_columns = lo_struct_descr->components.

    IF it_header[] IS INITIAL.
      LOOP AT lt_columns ASSIGNING <ls_column>.
        CLEAR  ls_head.
        ls_head = <ls_column>-name.
        APPEND ls_head TO lt_head.
      ENDLOOP.
    ELSE.
      LOOP AT it_header INTO lv_head.
        APPEND lv_head TO lt_head.
      ENDLOOP.
    ENDIF.

    IF iv_download_path IS INITIAL.
      add_file_save_dialog( CHANGING cv_filename = lv_filename
                                     cv_fullpath = lv_dir ).
    ELSE.
      lv_dir = iv_download_path.
    ENDIF.
    IF lv_dir IS INITIAL.
      MESSAGE 'Operation Canceled.' TYPE 'I'.
    ELSE.

      CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          filename                = lv_dir
          filetype                = 'ASC'
          write_field_separator   = 'X'
        TABLES
          data_tab                = it_tab
          fieldnames              = lt_head
        EXCEPTIONS
          file_write_error        = 1
          no_batch                = 2
          gui_refuse_filetransfer = 3
          invalid_type            = 4
          no_authority            = 5
          unknown_error           = 6
          header_not_allowed      = 7
          separator_not_allowed   = 8
          filesize_not_allowed    = 9
          header_too_long         = 10
          dp_error_create         = 11
          dp_error_send           = 12
          dp_error_write          = 13
          unknown_dp_error        = 14
          access_denied           = 15
          dp_out_of_memory        = 16
          disk_full               = 17
          dp_timeout              = 18
          file_not_found          = 19
          dataprovider_exception  = 20
          control_flush_error     = 21
          OTHERS                  = 22.

      IF sy-subrc <> 0.
        MESSAGE 'Error on generating sample file' TYPE 'I' DISPLAY LIKE 'E'.
      ELSE.
        MESSAGE 'File saved' TYPE 'S'.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD message.
    DATA : lv_str     TYPE string,
           lv_sub_str TYPE string.

    CASE iv_code.
      WHEN mc_msg-no_row_select.
        lv_str = TEXT-m01.
      WHEN mc_msg-no_change_data_found.
        lv_str = TEXT-m02.
      WHEN mc_msg-save_error.
        lv_str = TEXT-m03.
      WHEN mc_msg-save_success.
        IF iv_param1 IS NOT INITIAL.
          lv_str = TEXT-i01.
          lv_sub_str = iv_param1.
          CONDENSE lv_sub_str.
          REPLACE '&1' WITH lv_sub_str INTO lv_str.
        ENDIF.
        IF iv_param2 IS NOT INITIAL.
          lv_str = lv_str && TEXT-i02.
          lv_sub_str = iv_param2.
          CONDENSE lv_sub_str.
          REPLACE '&1' WITH lv_sub_str INTO lv_str.
        ENDIF.
        IF iv_param3 IS NOT INITIAL.
          lv_str = lv_str && TEXT-i03.
          lv_sub_str = iv_param3.
          CONDENSE lv_sub_str.
          REPLACE '&1' WITH lv_sub_str INTO lv_str.
        ENDIF.
        IF lv_str IS INITIAL.
          lv_str = TEXT-m04.
        ELSE.
          lv_str = lv_str.
        ENDIF.
      WHEN mc_msg-input_mandatory.
        lv_str = TEXT-m05.
    ENDCASE.

    rv_msg = lv_str.
  ENDMETHOD.


  METHOD message_popup.
    DATA: lo_table TYPE REF TO cl_salv_table.
    cl_salv_table=>factory( IMPORTING r_salv_table = lo_table
                            CHANGING  t_table = ct_msg ).
    lo_table->set_screen_popup( start_column = 1
                                end_column = 150
                                start_line = 1
                                end_line = 20 ).
    lo_table->display( ).
  ENDMETHOD.


  METHOD message_strip.
    DATA lv_str TYPE string.

    lv_str = message( EXPORTING iv_code = iv_code
                                iv_param1 = iv_param1
                                iv_param2 = iv_param2
                                iv_param3 = iv_param3
                                iv_param4 = iv_param4 ).
    IF iv_display IS INITIAL.
      MESSAGE lv_str TYPE iv_type.
    ELSE.
      MESSAGE lv_str TYPE iv_type DISPLAY LIKE iv_display.
    ENDIF.

  ENDMETHOD.


  METHOD move_itab_to_excel.
    DATA lo_table_descr TYPE REF TO cl_abap_tabledescr.
    DATA lo_struct_descr TYPE REF TO cl_abap_structdescr.
    DATA lt_columns TYPE abap_compdescr_tab.
    FIELD-SYMBOLS : <ls_column> LIKE LINE OF lt_columns,
                    <ls_data>   TYPE any,
                    <lv_value>  TYPE any.
    DATA : lv_row_index TYPE sy-tabix,
           lv_col_index TYPE sy-tabix,
           lv_msg       TYPE string.
    TYPES : BEGIN OF lty_15000,
              line TYPE c LENGTH 15000,
            END OF lty_15000.
    DATA : lt_str   TYPE TABLE OF lty_15000,
           lv_str   TYPE lty_15000,
           lv_value TYPE string
           .
    DATA : lv_col_cnt TYPE i,
           lv_row_cnt TYPE i,
           lv_rc      TYPE i.

    DATA : lo_range     TYPE ole2_object,
           lo_cell_from TYPE ole2_object,
           lo_cell_to   TYPE ole2_object,
           lo_interior  TYPE ole2_object.
    DATA ls_header TYPE zsbrd00130.


    lo_table_descr ?= cl_abap_typedescr=>describe_by_data( it_data ).
    lo_struct_descr ?= lo_table_descr->get_table_line_type( ).
    lt_columns = lo_struct_descr->components.
    DELETE lt_columns WHERE type_kind EQ 'h'.
    CLEAR lv_col_cnt.
    IF it_header[] IS INITIAL.
      CLEAR lv_str.
      LOOP AT lt_columns ASSIGNING <ls_column>.
        ADD 1 TO lv_col_cnt.
        CONCATENATE lv_str <ls_column>-name  INTO lv_str SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
      ENDLOOP.
      APPEND lv_str+1 TO lt_str.
      LOOP AT it_data ASSIGNING <ls_data>.
        CLEAR lv_str.
        LOOP AT lt_columns ASSIGNING <ls_column>.
          ASSIGN COMPONENT <ls_column>-name OF STRUCTURE <ls_data> TO <lv_value>.
          lv_value = <lv_value>.
          CONCATENATE lv_str lv_value INTO lv_str SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        ENDLOOP.
        APPEND lv_str+1 TO lt_str.
      ENDLOOP.
    ELSE.
      CLEAR lv_str.
      LOOP AT it_header INTO ls_header.
        ADD 1 TO lv_col_cnt.
        CONCATENATE lv_str ls_header-text  INTO lv_str SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
      ENDLOOP.
      APPEND lv_str+1 TO lt_str.
      LOOP AT it_data ASSIGNING <ls_data>.
        CLEAR lv_str.
        LOOP AT it_header INTO ls_header.
          ASSIGN COMPONENT ls_header-key OF STRUCTURE <ls_data> TO <lv_value>.
          CHECK sy-subrc EQ 0.
          lv_value = <lv_value>.
          CONCATENATE lv_str lv_value INTO lv_str SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        ENDLOOP.
        APPEND lv_str+1 TO lt_str.
      ENDLOOP.
    ENDIF.



    lv_row_cnt = lines( it_data ).

    lv_row_cnt = lv_row_cnt + 1. "header
    CALL METHOD cl_gui_frontend_services=>clipboard_export
      IMPORTING
        data                 = lt_str
      CHANGING
        rc                   = lv_rc
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4.

    CALL METHOD OF mo_excel 'Cells' = lo_cell_from
      EXPORTING
      #1 = 1
      #2 = 1.

    CALL METHOD OF mo_excel 'Cells' = lo_cell_to
      EXPORTING
      #1 = 1
      #2 = lv_col_cnt.

    CALL METHOD OF mo_excel 'Range' = lo_range
      EXPORTING
      #1 = lo_cell_from
      #2 = lo_cell_to.

    GET PROPERTY OF lo_range 'Interior' = lo_interior.
    SET PROPERTY OF lo_interior 'ColorIndex' = 15.


    CALL METHOD OF mo_excel 'Cells' = lo_cell_from
      EXPORTING
      #1 = 1
      #2 = 1.

    CALL METHOD OF mo_excel 'Cells' = lo_cell_to
      EXPORTING
      #1 = lv_row_cnt
      #2 = lv_col_cnt.

    CALL METHOD OF mo_excel 'Range' = lo_range
      EXPORTING
      #1 = lo_cell_from
      #2 = lo_cell_to.

    CALL METHOD OF lo_range 'Select'.

    CALL METHOD OF mo_sheet 'Paste'.

    CALL METHOD OF lo_range 'BorderAround'
      EXPORTING
        #1 = 1
        #2 = 4.


  ENDMETHOD.


  METHOD move_to_excel_itab.

    DATA : ls_data TYPE ty_txt,
           ls_itab TYPE soi_generic_item.
    DATA: lv_tabix LIKE sy-tabix,
          lv_col   TYPE kcd_ex_col.
    DATA: lv_fdpos     LIKE sy-fdpos.


    CLEAR : et_itab, ls_data.
    LOOP AT it_data INTO ls_data.
      lv_tabix = sy-tabix.
      lv_col = 0.

      WHILE ls_data CA cl_abap_char_utilities=>horizontal_tab.
        lv_fdpos = sy-fdpos.
        ADD 1 TO lv_col.

        divide_line_to_cell( EXPORTING iv_tabix = lv_tabix
                              CHANGING cs_data = ls_data
                                       ct_itab = et_itab
                                       cv_col = lv_col
                                       cv_fdpos = lv_fdpos ).

      ENDWHILE.
      IF ls_data <> space.
        CLEAR ls_itab.
        ls_itab-row = lv_tabix.
        ls_itab-column = lv_col + 1.
        ls_itab-value = ls_data.
        APPEND ls_itab TO et_itab.
      ENDIF.
      CLEAR ls_data.
    ENDLOOP.
  ENDMETHOD.


  METHOD refresh.
    DATA : ls_stable  TYPE lvc_s_stbl.
    IF iv_hard_refresh EQ abap_true.
      refresh_table_display( ).
    ELSE.
      ls_stable-col = ls_stable-row = abap_true.
      refresh_table_display( EXPORTING is_stable = ls_stable
                                       i_soft_refresh = abap_true ).
    ENDIF.
  ENDMETHOD.


  METHOD rollback_fail.
    MESSAGE 'Process Failed!!' TYPE 'I' DISPLAY LIKE 'E'.
    ROLLBACK WORK.
  ENDMETHOD.


  METHOD set_alv_mode.
    mv_mode = iv_mode.

    CASE iv_mode.
      WHEN mc_display_mode.
        CALL METHOD set_ready_for_input
          EXPORTING
            i_ready_for_input = 0.
      WHEN mc_change_mode.
        CALL METHOD set_ready_for_input
          EXPORTING
            i_ready_for_input = 1.
    ENDCASE.
  ENDMETHOD.


  METHOD set_block_alv_msg.
    TYPES : BEGIN OF lty_msg,
              msg(60),
            END OF lty_msg.
    DATA : lt_empty_tab  TYPE TABLE OF lty_msg,
           lt_empty_fcat TYPE lvc_t_fcat.

    DATA lt_toolbar_excluding TYPE ui_functions.


    CLEAR : lt_empty_tab, ms_fieldcat.
    ms_fieldcat-fieldname = 'MSG'.
    ms_fieldcat-datatype = 'CHAR'.
    ms_fieldcat-inttype = 'C'.
    ms_fieldcat-intlen = 60.
    APPEND ms_fieldcat TO lt_empty_fcat.
    APPEND 'This ALV report blocked by system, Contact to ITO please.' TO lt_empty_tab.

    lt_toolbar_excluding = get_all_exclude_toolbar( ).

    CALL METHOD set_table_for_first_display
      EXPORTING
        it_toolbar_excluding = lt_toolbar_excluding
      CHANGING
        it_outtab            = lt_empty_tab
        it_fieldcatalog      = lt_empty_fcat.

  ENDMETHOD.


  METHOD set_celltab_style.
    CLEAR ct_celltab.
*      IF ms_header_config-zcreate EQ abap_true
    CASE iv_mode.
      WHEN mc_change_mode.
        IF ms_header_config-zupdate EQ abap_false.
          EXIT.
        ENDIF.
        IF mt_change_celltab IS INITIAL.
          LOOP AT mt_config_fieldcat ASSIGNING FIELD-SYMBOL(<ls_fieldcat>) WHERE tech EQ abap_false.
            IF <ls_fieldcat>-zkey EQ abap_true.
              INSERT VALUE #( fieldname = <ls_fieldcat>-fieldname
                                style = cl_gui_alv_grid=>mc_style_disabled
                              ) INTO TABLE mt_change_celltab.
            ELSE.
              IF <ls_fieldcat>-chan_edit EQ abap_true.
                INSERT VALUE #( fieldname = <ls_fieldcat>-fieldname
                                style = cl_gui_alv_grid=>mc_style_enabled
                              ) INTO TABLE mt_change_celltab.
              ELSE.
                INSERT VALUE #( fieldname = <ls_fieldcat>-fieldname
                                style = cl_gui_alv_grid=>mc_style_disabled
                              ) INTO TABLE mt_change_celltab.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
        ct_celltab[] = mt_change_celltab[].
      WHEN mc_create_mode.
        IF mt_create_celltab IS INITIAL.
          LOOP AT mt_config_fieldcat ASSIGNING <ls_fieldcat> WHERE tech EQ abap_false.
            IF <ls_fieldcat>-crea_edit EQ abap_true.
              INSERT VALUE #( fieldname = <ls_fieldcat>-fieldname
                              style = cl_gui_alv_grid=>mc_style_enabled
                            ) INTO TABLE mt_create_celltab.
            ELSE.
              INSERT VALUE #( fieldname = <ls_fieldcat>-fieldname
                              style = cl_gui_alv_grid=>mc_style_disabled
                            ) INTO TABLE mt_create_celltab.
            ENDIF.
          ENDLOOP.
        ENDIF.
        ct_celltab[] = mt_create_celltab[].
    ENDCASE.
  ENDMETHOD.


  METHOD set_changing_flag.
    mv_on_chainging_flag = iv_flag.
  ENDMETHOD.


  METHOD set_company_code.
    mv_bukrs = iv_bukrs.
*    SELECT SINGLE waers INTO mv_bukrs_waers
*    FROM t001
*    WHERE bukrs = mv_bukrs.
*
*    IF sy-subrc NE 0.
*      mv_bukrs_waers = mc_bukrs_waers.
*    ENDIF.
    mv_bukrs_waers = mc_bukrs_waers.
  ENDMETHOD.


  METHOD set_default_exclude_toolbar.
    DATA : lv_ui_func TYPE ui_func.

    DEFINE _set_toolbar_exclude.
      CLEAR : lv_ui_func.
      lv_ui_func = &1.
      APPEND lv_ui_func TO mt_excluding_toolbar.
    END-OF-DEFINITION.

    CLEAR mt_excluding_toolbar.

*    CASE mv_mode.
*      WHEN mc_display_mode.
    _set_toolbar_exclude :
      mc_fc_loc_undo,
      mc_fc_auf,
*      mc_fc_average,
      mc_fc_back_classic,
      mc_fc_call_abc,
      mc_fc_call_chain,
      mc_fc_call_crbatch,
      mc_fc_call_crweb,

*      mc_fc_call_lineitems,
*      mc_fc_call_master_data,
*      mc_fc_call_more,
*      mc_fc_call_report,
*      mc_fc_call_xint,
*      mc_fc_call_xxl,
*      mc_fc_col_invisible,
*      mc_fc_col_optimize,

*      mc_fc_current_variant,
*      mc_fc_load_variant,
*      mc_fc_maintain_variant,
*      mc_fc_save_variant,
*      mc_fc_sum,

      mc_fc_data_save,
*      mc_fc_delete_filter,
      mc_fc_deselect_all,
*      mc_fc_detail,
      mc_fc_expcrdata,
      mc_fc_expcrdesig,
      mc_fc_expcrtempl,
      mc_fc_expmdb,
      mc_fc_extend,
      mc_fc_f4,
      mc_fc_fix_columns,
      mc_fc_graph,
      mc_fc_help,
      mc_fc_info,
      mc_fc_loc_copy,
      mc_fc_html,
      mc_fc_loc_copy_row,
      mc_fc_loc_cut,
      mc_fc_loc_delete_row,
      mc_fc_loc_insert_row,
      mc_fc_loc_move_row,
      mc_fc_loc_append_row,
      mc_fc_loc_paste,
      mc_fc_loc_paste_new_row,
      mc_fc_maximum,
      mc_fc_minimum,
      mc_fc_print,
      mc_fc_print_back,
      mc_fc_print_prev,
      mc_fc_refresh,
      mc_fc_reprep,
      mc_fc_select_all,
      mc_fc_send,
      mc_fc_separator,
      mc_fc_pc_file,
*      mc_mb_export,
*      mc_fc_subtot,
      mc_fc_to_office,
      mc_fc_to_rep_tree,
      mc_fc_unfix_columns,
      mc_fc_views,
      mc_fc_view_crystal,
      mc_fc_view_excel,
      mc_fc_view_grid,
      mc_fc_word_processor,
      mc_fc_url_copy_to_clipboard,
      mc_fc_check.
*      WHEN OTHERS.
**        CLEAR mt_toolbar.
*    ENDCASE.

  ENDMETHOD.


  METHOD set_default_fieldcat.
    IF mt_config_fieldcat IS INITIAL.
      set_native_fieldcat( EXPORTING it_data = it_data ).
    ELSE.
      set_fieldcat( ).
    ENDIF.
  ENDMETHOD.


  METHOD set_default_layout.
    CLEAR : ms_header_config, ms_layout.

    SELECT SINGLE * INTO CORRESPONDING FIELDS OF ms_header_config
    FROM ztbrd00010
    WHERE progid = mv_progid
      AND alv_key = mv_alv_key.

    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING ms_header_config TO ms_layout.
    ELSE.
      ms_layout-smalltitle  = 'X'.
      ms_layout-sel_mode     = 'D'.
      ms_layout-zebra        = 'X'.
      ms_layout-cwidth_opt   = ''.
      ms_layout-no_merging  = ' '.
    ENDIF.
  ENDMETHOD.


  METHOD set_default_sortcat.

    DATA : lt_config_scat TYPE TABLE OF ztbrd00020,
           ls_scat        TYPE lvc_s_sort.
    DATA lv_set_flag.
    DATA ls_config_scat TYPE ztbrd00020.

    SELECT fieldname sr_spos sr_up sr_down sr_group
           sr_subtot sr_comp sr_expa sr_seltext
           sr_obligatory sr_level sr_no_out sr_intopt
       INTO CORRESPONDING FIELDS OF TABLE lt_config_scat
    FROM ztbrd00020
    WHERE progid = mv_progid
      AND alv_key = mv_alv_key
      AND fcat_key = mv_fcat_key.

    LOOP AT lt_config_scat INTO ls_config_scat.
      READ TABLE mt_fieldcat TRANSPORTING NO FIELDS WITH KEY fieldname = ls_config_scat-fieldname.
      CHECK sy-subrc EQ 0.
      CLEAR : ls_scat, lv_set_flag.
      IF ls_config_scat-sr_up EQ abap_true.
        ls_scat-up = ls_config_scat-sr_up.
        lv_set_flag = abap_true.
      ENDIF.
      IF ls_config_scat-sr_down EQ abap_true.
        ls_scat-down = ls_config_scat-sr_down.
        lv_set_flag = abap_true.
      ENDIF.
      IF ls_config_scat-sr_group IS NOT INITIAL.
        ls_scat-group = ls_config_scat-sr_group.
        lv_set_flag = abap_true.
      ENDIF.
      IF ls_config_scat-sr_spos IS NOT INITIAL.
        ls_scat-spos = ls_config_scat-sr_spos.
        lv_set_flag = abap_true.
      ENDIF.
      IF ls_config_scat-sr_subtot EQ abap_true.
        ls_scat-subtot = ls_config_scat-sr_subtot.
        lv_set_flag = abap_true.
      ENDIF.
      IF ls_config_scat-sr_comp EQ abap_true.
        ls_scat-comp = ls_config_scat-sr_comp.
        lv_set_flag = abap_true.
      ENDIF.
      IF ls_config_scat-sr_expa EQ abap_true.
        ls_scat-expa = ls_config_scat-sr_expa.
        lv_set_flag = abap_true.
      ENDIF.
      IF ls_config_scat-sr_seltext IS NOT INITIAL.
        ls_scat-seltext = ls_config_scat-sr_seltext.
        lv_set_flag = abap_true.
      ENDIF.
      IF ls_config_scat-sr_obligatory EQ abap_true.
        ls_scat-obligatory = ls_config_scat-sr_obligatory.
        lv_set_flag = abap_true.
      ENDIF.
      IF ls_config_scat-sr_level IS NOT INITIAL.
        ls_scat-level = ls_config_scat-sr_level.
        lv_set_flag = abap_true.
      ENDIF.
      IF ls_config_scat-sr_no_out EQ abap_true.
        ls_scat-no_out = ls_config_scat-sr_no_out.
        lv_set_flag = abap_true.
      ENDIF.

      IF lv_set_flag = abap_true.
        ls_scat-fieldname = ls_config_scat-fieldname.
        APPEND ls_scat TO mt_sortcat.
      ENDIF.


    ENDLOOP.

  ENDMETHOD.


  METHOD set_events.
    SET HANDLER handle_toolbar FOR me.
    SET HANDLER handle_user_command FOR me.
    IF ms_header_config-after_refresh EQ abap_true.
      SET HANDLER handle_after_refresh FOR me.
    ENDIF.
    IF ms_header_config-db_click EQ abap_true.
      SET HANDLER handle_double_click FOR me.
    ENDIF.

    IF mv_is_field_button_exists = abap_true.
      SET HANDLER handle_button_click FOR me.
    ENDIF.
    IF mv_is_hot_spot_exists = abap_true.
      SET HANDLER handle_hotspot_click FOR me.
    ENDIF.

    IF ms_header_config-change_evt EQ abap_true.
      mv_is_set_change_evt = abap_true.
    ENDIF.

    IF mv_is_set_change_evt = abap_true.
      SET HANDLER handle_data_changed FOR me.

      CALL METHOD register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.
      CALL METHOD register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_enter.
    ENDIF.

    IF mv_is_f4_exists = abap_true.
      register_f4_for_fields( EXPORTING it_f4 = mt_f4_field[] ).
      SET HANDLER handle_onf4 FOR me.
    ENDIF.
  ENDMETHOD.


  METHOD set_fieldcat.
    DATA : ls_fcat        TYPE lvc_s_fcat,
           ls_fcat_origin TYPE lvc_s_fcat,
           lv_tabix       TYPE sy-tabix.
    DATA lt_fieldcat_frontend TYPE lvc_t_fcat.
    DATA : ls_config_fcat      TYPE ztbrd00020,
           ls_config_fcat_text TYPE ztbrd00070.

    CLEAR mt_fieldcat.

*    get_frontend_fieldcatalog( IMPORTING et_fieldcatalog = lt_fieldcat_frontend ).
    CLEAR mt_f4_field.
    LOOP AT mt_config_fieldcat INTO ls_config_fcat.

      CLEAR ls_fcat.
      MOVE-CORRESPONDING ls_config_fcat TO ls_fcat.
      ls_fcat-key = ls_config_fcat-zkey.

      CASE mv_mode.
        WHEN mc_display_mode. CLEAR ls_fcat-edit.
        WHEN mc_create_mode. ls_fcat-edit = ls_config_fcat-crea_edit.
          "change field controled by celltab
        WHEN mc_change_mode. ls_fcat-edit = abap_true."ls_config_fcat-chan_edit.
        WHEN mc_upload_mode. ls_fcat-edit = ls_config_fcat-upld_edit.
      ENDCASE.


      IF ls_config_fcat-button EQ abap_true.
        ls_fcat-style = cl_gui_alv_grid=>mc_style_button.
      ENDIF.

      IF ls_fcat-currency = 'T001'.
        ls_fcat-currency = mv_bukrs_waers.
      ENDIF.

      READ TABLE mt_config_fieldcat_text INTO ls_config_fcat_text
                       WITH KEY fieldname = ls_config_fcat-fieldname BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_fcat-reptext = ls_config_fcat_text-reptext.
        ls_fcat-scrtext_s = ls_config_fcat_text-scrtext_s.
        ls_fcat-scrtext_m = ls_config_fcat_text-scrtext_m.
        ls_fcat-scrtext_l = ls_config_fcat_text-scrtext_l.
      ENDIF.

*      CLEAR ls_fcat_origin.
*      READ TABLE lt_fieldcat_frontend INTO ls_fcat_origin WITH KEY fieldname = ls_config_fcat-fieldname.
*      lv_tabix = sy-tabix.
*      IF sy-subrc EQ 0.
*        ls_fcat-no_out = ls_fcat_origin-no_out.
*        ls_fcat-col_pos = ls_fcat_origin-col_pos.
*      ENDIF.

      READ TABLE mt_fieldcat TRANSPORTING NO FIELDS WITH KEY fieldname = ls_config_fcat-fieldname.
      lv_tabix = sy-tabix.
      IF sy-subrc EQ 0.
        MODIFY mt_fieldcat FROM ls_fcat INDEX lv_tabix.
      ELSE.
        APPEND ls_fcat TO mt_fieldcat.
      ENDIF.

      IF ls_config_fcat-button = abap_true.
        mv_is_field_button_exists = abap_true.
      ENDIF.
      IF ls_config_fcat-hotspot = abap_true.
        mv_is_hot_spot_exists = abap_true.
      ENDIF.
      IF ls_config_fcat-change_evt = abap_true.
        mv_is_set_change_evt = abap_true.
      ENDIF.

      IF ls_config_fcat-f4availabl = abap_true.
        mv_is_f4_exists = abap_true.
        ms_f4_field-fieldname  = ls_config_fcat-fieldname.
        ms_f4_field-register   = abap_true.
        ms_f4_field-getbefore  = space.
        ms_f4_field-chngeafter = abap_true.
        APPEND ms_f4_field TO mt_f4_field.
      ENDIF.

      CLEAR : ls_fcat, ls_config_fcat.
    ENDLOOP.
  ENDMETHOD.


  METHOD set_fieldcat_config.
    CLEAR : mt_config_fieldcat, mt_config_fieldcat_text.

    SELECT * INTO TABLE mt_config_fieldcat
    FROM ztbrd00020
    WHERE progid = mv_progid
      AND alv_key = mv_alv_key
      AND fcat_key = mv_fcat_key.

    IF sy-subrc NE 0.
      SELECT * INTO TABLE mt_config_fieldcat
      FROM ztbrd00020
      WHERE progid = mv_progid
        AND alv_key = mv_alv_key
        AND fcat_key = 'DEFAULT'.
    ENDIF.

    SORT mt_config_fieldcat BY fieldname.

    SELECT * INTO TABLE mt_config_fieldcat_text
    FROM ztbrd00070
    WHERE progid = mv_progid
      AND alv_key = mv_alv_key
      AND fcat_key = mv_fcat_key
      AND spras = sy-langu.

    SORT mt_config_fieldcat_text BY fieldname.
  ENDMETHOD.


  METHOD set_native_fieldcat.
    DATA:lt_slis_t_fieldcat_alv TYPE slis_t_fieldcat_alv,
         ls_slis_fieldcat_alv   TYPE slis_fieldcat_alv,
         ls_lvc_s_fcat          TYPE lvc_s_fcat.

    DATA table_descr TYPE REF TO cl_abap_tabledescr.
    DATA struct_descr TYPE REF TO cl_abap_structdescr.
    DATA columns TYPE abap_compdescr_tab.
    FIELD-SYMBOLS
    <column> LIKE LINE OF columns.


    CLEAR : mt_fieldcat[].

    table_descr ?= cl_abap_typedescr=>describe_by_data( it_data ).
    struct_descr ?= table_descr->get_table_line_type( ).
    columns = struct_descr->components.

    LOOP AT columns ASSIGNING <column>.
      IF <column>-type_kind EQ 'h'.
        CONTINUE.
      ENDIF.
      ls_lvc_s_fcat-fieldname = <column>-name.
      ls_lvc_s_fcat-scrtext_l  = <column>-name.
      ls_lvc_s_fcat-scrtext_m  = <column>-name.
      ls_lvc_s_fcat-scrtext_s  = <column>-name.
      ls_lvc_s_fcat-intlen = <column>-length.
      ls_lvc_s_fcat-decimals = <column>-decimals.
      APPEND ls_lvc_s_fcat TO mt_fieldcat.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
