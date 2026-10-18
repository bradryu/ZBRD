*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
class ZCL_BRD_TREE_ALV definition
  public
  inheriting from CL_GUI_ALV_TREE
  create public .

public section.

  types TS_FCAT_CONFIG type ZTBRD00021 .
  types TS_HEADER_CONFIG type ZTBRD00011 .
  types TT_FCAT_CONFIG type ZYBRD00021 .

  data MT_FIELDCAT type LVC_T_FCAT .
  class-data MC_DISPLAY_MODE type CHAR04 read-only value 'DISP' ##NO_TEXT.
  class-data MC_UPLOAD_MODE type CHAR04 read-only value 'UPLD' ##NO_TEXT.
  class-data MC_CANCEL_MODE type CHAR04 read-only value 'CANC' ##NO_TEXT.
  class-data MC_CREATE_MODE type CHAR04 read-only value 'CREA' ##NO_TEXT.
  class-data MC_CHANGE_MODE type CHAR04 read-only value 'CHAN' ##NO_TEXT.
  constants RELAT_FIRST_CHILD type I value 4 ##NO_TEXT.
  constants RELAT_FIRST_SIBLING type I value 5 ##NO_TEXT.
  constants RELAT_LAST_CHILD type I value 6 ##NO_TEXT.
  constants RELAT_LAST_SIBLING type I value 1 ##NO_TEXT.
  constants RELAT_NEXT_SIBLING type I value 2 ##NO_TEXT.
  constants RELAT_PREV_SIBLING type I value 3 ##NO_TEXT.
  constants ITEM_CLASS_BUTTON type I value 4 ##NO_TEXT.
  constants ITEM_CLASS_CHECKBOX type I value 3 ##NO_TEXT.
  constants ITEM_CLASS_LINK type I value 5 ##NO_TEXT.
  constants ITEM_CLASS_TEXT type I value 2 ##NO_TEXT.
  constants ITEM_FONT_DEFAULT type I value 0 ##NO_TEXT.
  constants ITEM_FONT_FIXED type I value 1 ##NO_TEXT.
  constants ITEM_FONT_PROP type I value 2 ##NO_TEXT.
  constants EVENTID_DEF_CONTEXT_MENU_REQ type I value 42 ##NO_TEXT.
  constants EVENTID_EXPAND_NO_CHILDREN type I value 18 ##NO_TEXT.
  constants EVENTID_NODE_CONTEXT_MENU_REQ type I value 36 ##NO_TEXT.
  constants EVENTID_NODE_DOUBLE_CLICK type I value 25 ##NO_TEXT.
  constants EVENTID_NODE_KEYPRESS type I value 40 ##NO_TEXT.
  constants EVENTID_SELECTION_CHANGED type I value 21 ##NO_TEXT.
  constants EVENTID_ITEM_CONTEXT_MENU_REQ type I value 26 ##NO_TEXT.
  constants EVENTID_ITEM_DOUBLE_CLICK type I value 22 ##NO_TEXT.
  constants EVENTID_ITEM_KEYPRESS type I value 39 ##NO_TEXT.
  constants EVENTID_LINK_CLICK type I value 35 ##NO_TEXT.
  constants EVENTID_HEADER_CLICK type I value 28 ##NO_TEXT.
  constants EVENTID_HEADER_CONTEXT_MEN_REQ type I value 41 ##NO_TEXT.

  methods GET_LINE
    importing
      !I_NODE_KEY type LVC_NKEY
    exporting
      !E_NODE_TEXT type LVC_VALUE
      !ET_ITEM_LAYOUT type LVC_T_LAYI
      !ES_NODE_LAYOUT type LVC_S_LAYN
    changing
      !C_OUTTAB_LINE type ANY
    exceptions
      NODE_NOT_FOUND .
  methods CONSTRUCTOR
    importing
      value(IO_PARENT) type ref to CL_GUI_CONTAINER optional
      value(IV_PROGID) type SY-CPROG default SY-CPROG
      value(IV_ALV_KEY) type CHAR10 default 'TALV'
      value(IV_FCAT_KEY) type CHAR10 default 'DEFAULT'
      !IS_LAYOUT_CBO type ZTBRD00011 optional
    exceptions
      CNTL_ERROR
      CNTL_SYSTEM_ERROR
      CREATE_ERROR
      LIFETIME_ERROR
      ILLEGAL_NODE_SELECTION_MODE
      FAILED
      ILLEGAL_COLUMN_NAME .
  methods DISPLAY
    importing
      !IT_FIELDCAT type LVC_T_FCAT optional
      !IV_MODE type CHAR04 default 'DISP'
      !IT_TOOLBAR_EXCLUDING type UI_FUNCTIONS optional
      !IV_FCAT_KEY type CHAR10 default 'DEFAULT'
      !IT_SORTCAT type LVC_T_SORT optional
      !IT_DROP_DOWN type LVC_T_DRAL optional
      !IT_FIELDCAT_CBO type ZYBRD00021 optional
    changing
      !CT_DATA type TABLE .
  methods ADD_NODE_FREELY
    importing
      !IV_RELAT_NODE_KEY type ANY
      !IV_RELATIONSHIP type INT4 optional
      !IS_OUTTAB_LINE type ANY
      !IS_NODE_LAYOUT type LVC_S_LAYN optional
      !IT_ITEM_LAYOUT type LVC_T_LAYI optional
      !IV_NODE_TEXT type ANY
    exporting
      !E_NEW_NODE_KEY type LVC_NKEY .
  methods SET_ITEM_CHECKBOX_CHECKED
    importing
      !IV_FIELDNAME type FIELDNAME
      !IV_ROWNUM type SY-TABIX
      !IV_FLAG type CHAR01 .
  class-methods CONFIRM_SAVE
    returning
      value(RV_RETURN) type CHAR1 .
  class-methods CONFIRM_CANCEL
    returning
      value(RV_RETURN) type CHAR1 .
  class-methods CONFIRM_DELETE
    returning
      value(RV_RETURN) type CHAR1 .
  class-methods CONFIRM_MSG
    importing
      !IV_TITLE type STRING
      !IV_QUESTION type STRING
      !IV_BTN1 type STRING default 'YES'
      !IV_BTN2 type STRING default 'NO'
    returning
      value(RV_RETURN) type CHAR1 .
  class-methods COMMIT_SAVE
    importing
      !IV_COUNT type I optional .
  class-methods ROLLBACK_FAIL .
  class-methods COMMIT_DELETE
    importing
      !IV_COUNT type I optional .
  methods SET_LINE
    importing
      !IV_NODE_KEY type LVC_NKEY
      !IS_OUTTAB_LINE type ANY
      !IS_NODE_LAYOUT type LVC_S_LACN optional
      !IT_ITEM_LAYOUT type LVC_T_LACI optional
      !IV_NODE_TEXT type LVC_VALUE optional
      !IV_U_NODE_TEXT type AS4FLAG optional
    exceptions
      NODE_NOT_FOUND .
  methods REFRESH .
  methods GET_FIELDCAT_CONFIG
    importing
      value(IV_PROGID) type SY-CPROG optional
      value(IV_ALV_KEY) type CHAR10 optional
      value(IV_FCAT_KEY) type CHAR10 optional
    returning
      value(RT_FCAT) type LVC_T_FCAT .
  methods GET_HEADER_CONFIG
    importing
      value(IV_PROGID) type SY-CPROG optional
      value(IV_ALV_KEY) type CHAR10 optional
    returning
      value(RS_TREEV_HHDR) type TREEV_HHDR .
  methods GET_INDEX_OUTTAB
    returning
      value(RT_TAB) type LVC_T_ITON .
  methods SET_COMPANY_CODE
    importing
      !IV_BUKRS type BUKRS .
  methods RELOAD
    importing
      !IT_SORTCAT type LVC_T_SORT optional
    changing
      !CT_DATA type TABLE .
  PROTECTED SECTION.

    DATA item_selection TYPE as4flag .
  PRIVATE SECTION.

    TYPES:
      BEGIN OF lvc_s_item_layout,
        node_key(100),
        item_layout   TYPE lvc_t_layi,
      END OF lvc_s_item_layout .

    DATA mv_is_reload TYPE char1 .
    DATA mv_progid TYPE cprog .
    DATA mv_alv_key TYPE char10 .
    DATA mv_fcat_key TYPE char10 .
    DATA ms_layout TYPE lvc_s_layo .
    DATA ms_fieldcat TYPE lvc_s_fcat .
    DATA ms_header_config TYPE ztbrd00011 .
    DATA mv_mode TYPE char04 .
    DATA ms_treev_hhdr TYPE treev_hhdr .
    DATA ms_variant TYPE disvariant .
    DATA:
      mt_config_fieldcat TYPE TABLE OF ztbrd00021 .
    DATA:
      mt_config_fieldcat_text TYPE TABLE OF ztbrd00071 .
    DATA ms_config_fieldcat TYPE ztbrd00021 .
    DATA mv_node_id_field TYPE fieldname .
    DATA mv_parents_node_id_field TYPE fieldname .
    DATA mv_sort_field TYPE fieldname .
    DATA mv_node_text_field TYPE fieldname .
    DATA mt_data TYPE REF TO data .
    DATA ms_balv_item_layout TYPE lvc_s_item_layout .
    DATA:
      mt_checkbox_field TYPE TABLE OF fieldname .
    DATA:
      mt_balv_item_layout TYPE STANDARD TABLE OF lvc_s_item_layout
        WITH KEY node_key .
    DATA mv_bukrs TYPE bukrs .
    DATA mv_bukrs_waers TYPE waers .
    CONSTANTS mc_bukrs_waers TYPE waers VALUE 'KRW' ##NO_TEXT.
    DATA ms_node_layout TYPE lvc_s_layn .

    METHODS set_fieldcat .
    METHODS set_fieldcat_config .
    METHODS set_tree_alv_event .
    METHODS set_default_layout .
    METHODS set_default_fieldcat
      IMPORTING
        !it_data TYPE table .
    METHODS set_native_fieldcat
      IMPORTING
        !it_data TYPE table .
    METHODS add_item_node
      IMPORTING
        !iv_pnid TYPE any
        !iv_nid  TYPE lvc_nkey .
    METHODS handle_node_double_click
        FOR EVENT node_double_click OF cl_gui_alv_tree
      IMPORTING
        !node_key .
    METHODS handle_item_double_click
        FOR EVENT item_double_click OF cl_gui_alv_tree
      IMPORTING
        !fieldname
        !node_key .
    METHODS handle_item_context_request
        FOR EVENT item_context_menu_request OF cl_gui_alv_tree
      IMPORTING
        !fieldname
        !menu
        !node_key .
    METHODS handle_item_context_selected
        FOR EVENT item_context_menu_selected OF cl_gui_alv_tree
      IMPORTING
        !fcode
        !fieldname
        !node_key .
    METHODS handle_header_context_request
        FOR EVENT header_context_menu_request OF cl_gui_alv_tree
      IMPORTING
        !fieldname
        !menu .
    METHODS handle_header_context_select
        FOR EVENT header_context_menu_select OF cl_gui_alv_tree
      IMPORTING
        !fieldname
        !fcode .
    METHODS handle_node_context_request
        FOR EVENT node_context_menu_request OF cl_gui_alv_tree
      IMPORTING
        !menu
        !node_key .
    METHODS handle_node_context_selected
        FOR EVENT node_context_menu_selected OF cl_gui_alv_tree
      IMPORTING
        !fcode
        !node_key .
    METHODS handle_expand_nc
        FOR EVENT expand_nc OF cl_gui_alv_tree
      IMPORTING
        !node_key .
ENDCLASS.



CLASS ZCL_BRD_TREE_ALV IMPLEMENTATION.


  METHOD add_item_node.
    DATA : lv_tabix     TYPE sy-tabix,
           lv_tabix2    TYPE sy-tabix,
           lv_nodeid    TYPE lvc_nkey,
           lv_fieldname TYPE fieldname,
           lv_node_text TYPE lvc_value.
    DATA ls_item_layout TYPE lvc_s_layi.

    FIELD-SYMBOLS : <lt_data>      TYPE STANDARD TABLE,
                    <ls_data>      TYPE any,
                    <lv_pnode>     TYPE any,
                    <lv_node>      TYPE any,
                    <lv_node_text> TYPE any,
                    <lv_checkbox>  TYPE c.
    DATA : lo_data TYPE REF TO data.


    ASSIGN mt_data->* TO <lt_data>.
    CREATE DATA lo_data LIKE LINE OF <lt_data>.
    ASSIGN lo_data->* TO <ls_data>.

    READ TABLE <lt_data> TRANSPORTING NO FIELDS WITH KEY (mv_parents_node_id_field) = iv_pnid BINARY SEARCH.
    lv_tabix = sy-tabix.
    IF sy-subrc EQ 0.
      LOOP AT <lt_data> INTO <ls_data> FROM lv_tabix.
        lv_tabix2 = sy-tabix.

        ASSIGN COMPONENT mv_parents_node_id_field OF STRUCTURE <ls_data> TO <lv_pnode>.
        IF <lv_pnode> NE iv_pnid.
          EXIT.
        ENDIF.
        ASSIGN COMPONENT mv_node_id_field OF STRUCTURE <ls_data> TO <lv_node>.
        IF <lv_pnode> = <lv_node>.
          CONTINUE.
        ENDIF.

        "node layout
        CLEAR : ms_balv_item_layout.
        LOOP AT mt_checkbox_field INTO lv_fieldname."check box
          CLEAR : ls_item_layout.
          ls_item_layout-fieldname = lv_fieldname.
          ls_item_layout-class = me->item_class_checkbox.
          ASSIGN COMPONENT lv_fieldname OF STRUCTURE <ls_data> TO <lv_checkbox>.
          ls_item_layout-chosen = <lv_checkbox>.
          CLEAR <lv_checkbox>.
          APPEND ls_item_layout TO ms_balv_item_layout-item_layout.
        ENDLOOP.
        ms_balv_item_layout-node_key = <lv_node>.
        APPEND ms_balv_item_layout TO mt_balv_item_layout.

        ASSIGN COMPONENT mv_node_text_field OF STRUCTURE <ls_data> TO <lv_node_text>.
        lv_node_text = <lv_node_text>.
        CLEAR ms_node_layout.
        MOVE-CORRESPONDING <ls_data> TO ms_node_layout.

        add_node(
          EXPORTING
            i_relat_node_key = iv_nid
            i_relationship   = me->relat_last_child
            i_node_text      = lv_node_text
            is_node_layout = ms_node_layout
            is_outtab_line   = <ls_data>
            it_item_layout = ms_balv_item_layout-item_layout
          IMPORTING
            e_new_node_key   = lv_nodeid ).

        add_item_node( EXPORTING iv_pnid = <lv_node>
                                 iv_nid = lv_nodeid ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD add_node_freely.
    DATA : lv_relat_node_key TYPE lvc_nkey,
           lv_relationship   TYPE int4,
           ls_node_layout    TYPE lvc_s_layn,
           lt_item_layout    TYPE lvc_t_layi,
           lv_node_text      TYPE lvc_value,
           lv_new_node_key   TYPE lvc_nkey,
           lt_fcat           TYPE lvc_t_fcat,
           ls_fcat           TYPE lvc_s_fcat.
    DATA ls_item_layout TYPE lvc_s_layi.
    DATA : lv_fieldname      TYPE fieldname.
    DATA : lo_outtab      TYPE REF TO data.
    FIELD-SYMBOLS : <ls_outtab>   TYPE any,
                    <lv_checkbox> TYPE c.

    lv_relat_node_key = iv_relat_node_key.
    IF iv_relationship IS SUPPLIED.
      lv_relationship = iv_relationship.
    ELSE.
      lv_relationship = me->relat_last_child.
    ENDIF.
    lv_node_text = iv_node_text.

    LOOP AT mt_fieldcat INTO ms_fieldcat.
      MOVE-CORRESPONDING ms_fieldcat TO ls_fcat.
      IF ms_fieldcat-checkbox EQ abap_true.
        CLEAR ls_fcat-checkbox.
      ENDIF.
      APPEND ls_fcat TO lt_fcat.
    ENDLOOP.

    CREATE DATA lo_outtab LIKE is_outtab_line.
    ASSIGN lo_outtab->* TO <ls_outtab>.
    MOVE-CORRESPONDING is_outtab_line TO <ls_outtab>.

    CLEAR : ms_balv_item_layout.
    LOOP AT mt_checkbox_field INTO lv_fieldname.
      CLEAR : ls_item_layout.
      ls_item_layout-fieldname = lv_fieldname.
      ls_item_layout-class = me->item_class_checkbox.
      ASSIGN COMPONENT lv_fieldname OF STRUCTURE <ls_outtab> TO <lv_checkbox>.
      ls_item_layout-chosen = <lv_checkbox>.
      CLEAR <lv_checkbox>.
      APPEND ls_item_layout TO ms_balv_item_layout-item_layout.
    ENDLOOP.

    add_node(
         EXPORTING
           i_relat_node_key = lv_relat_node_key
           i_relationship   = me->relat_last_child
           i_node_text      = lv_node_text
           is_outtab_line   =  <ls_outtab>
           it_item_layout = ms_balv_item_layout-item_layout
         IMPORTING
           e_new_node_key   = lv_new_node_key ).

    ms_balv_item_layout-node_key = lv_new_node_key.
    APPEND ms_balv_item_layout TO mt_balv_item_layout.

    e_new_node_key = lv_new_node_key.
  ENDMETHOD.


  METHOD commit_delete.
    DATA lv_str TYPE string.
    IF iv_count EQ 0.
      MESSAGE 'Data Deleted!!' TYPE 'S'.
    ELSE.
      lv_str = iv_count.
      CONCATENATE lv_str ` Record(s) Deleted!!` INTO lv_str.
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
                 RECEIVING rv_return   = rv_return ).
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

    DATA : lo_parent        TYPE REF TO cl_gui_container,
           ls_header_config TYPE ztbrd00011.

    IF io_parent IS NOT INITIAL.
      lo_parent = io_parent.
    ELSE.
      lo_parent = cl_gui_container=>default_screen.
    ENDIF.

    CLEAR ls_header_config.
    IF is_layout_cbo IS INITIAL.

      SELECT SINGLE * INTO ls_header_config
      FROM ztbrd00011
      WHERE progid EQ iv_progid
        AND alv_key EQ iv_alv_key.
    ELSE.
      MOVE-CORRESPONDING is_layout_cbo TO ls_header_config.
    ENDIF.
    CALL METHOD super->constructor
      EXPORTING
        parent                      = lo_parent
        node_selection_mode         = ls_header_config-node_selection_mode
        item_selection              = ls_header_config-item_selection
        no_toolbar                  = ls_header_config-no_toolbar
        no_html_header              = ls_header_config-no_html_header
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        illegal_node_selection_mode = 5
        failed                      = 6
        illegal_column_name         = 7
        OTHERS                      = 8.


    MOVE-CORRESPONDING ls_header_config TO ms_header_config.
    ms_treev_hhdr-heading = ms_header_config-heading.
    ms_treev_hhdr-tooltip = ms_header_config-tooltip.
    ms_treev_hhdr-width = ms_header_config-width.
    ms_treev_hhdr-width_pix = ms_header_config-width_pix.

    ms_variant-report = mv_progid = iv_progid.


    CLEAR mv_is_reload .

    IF iv_alv_key IS NOT INITIAL.
      mv_alv_key = iv_alv_key.
    ENDIF.
    IF iv_fcat_key IS NOT INITIAL.
      mv_fcat_key = iv_fcat_key.
    ENDIF.
*    set_default_layout( ).

    mv_bukrs_waers = mc_bukrs_waers.

  ENDMETHOD.


  METHOD display.
    FIELD-SYMBOLS : <lt_outtab>       TYPE STANDARD TABLE,
                    <lt_root>         TYPE STANDARD TABLE,
                    <ls_root>         TYPE any,
                    <lt_outtab_empty> TYPE STANDARD TABLE,
                    <mt_data>         TYPE STANDARD TABLE,
                    <ls_outtab>       TYPE any,
                    <lv_pnode>        TYPE any,
                    <lv_node>         TYPE any,
                    <lv_node_text>    TYPE any,
                    <lv_checkbox>     TYPE c.

    DATA : lo_root         TYPE REF TO data,
           lo_root_line    TYPE REF TO data,
           lo_outtab       TYPE REF TO data,
           lo_outtab_empty TYPE REF TO data,
           lt_fcat         TYPE lvc_t_fcat,
           ls_fcat         TYPE lvc_s_fcat,
           lv_nodeid       TYPE lvc_nkey,
           lv_tabix        TYPE sy-tabix,
           lv_node_text    TYPE lvc_value.
    DATA : lt_otab TYPE abap_sortorder_tab,
           ls_otab TYPE abap_sortorder.
    DATA ls_item_layout TYPE lvc_s_layi.
    DATA : lv_fieldname      TYPE fieldname.

    mv_mode = iv_mode.




    IF iv_fcat_key IS NOT INITIAL.
      mv_fcat_key = iv_fcat_key.
      set_fieldcat_config( ).
    ENDIF.

    IF it_fieldcat IS INITIAL AND it_fieldcat_cbo IS INITIAL.
      set_default_fieldcat( EXPORTING it_data = ct_data ).
    ENDIF.
    IF it_fieldcat IS NOT INITIAL.
      mt_fieldcat = it_fieldcat.
    ENDIF.
    IF it_fieldcat_cbo IS NOT INITIAL.
      mt_config_fieldcat = it_fieldcat_cbo.
      SORT mt_config_fieldcat BY fieldname.
      set_fieldcat( ).
    ENDIF.

    SORT mt_fieldcat BY col_pos.

    CLEAR mt_checkbox_field.
    LOOP AT mt_fieldcat INTO ms_fieldcat.
      MOVE-CORRESPONDING ms_fieldcat TO ls_fcat.
      IF ms_fieldcat-checkbox EQ abap_true.
        CLEAR lv_fieldname.
        lv_fieldname = ms_fieldcat-fieldname.
        APPEND lv_fieldname TO mt_checkbox_field.

        CLEAR ls_fcat-checkbox.
      ENDIF.
      APPEND ls_fcat TO lt_fcat.
    ENDLOOP.

    SORT mt_checkbox_field.


    "Dynamic itab create
    CREATE DATA lo_root LIKE ct_data.
    ASSIGN lo_root->* TO <lt_root>.
    CREATE DATA lo_root_line LIKE LINE OF <lt_root>.
    ASSIGN lo_root_line->* TO <ls_root>.

    CREATE DATA lo_outtab_empty LIKE ct_data.
    ASSIGN lo_outtab_empty->* TO <lt_outtab_empty>.

    CREATE DATA mt_data LIKE ct_data.
    ASSIGN mt_data->* TO <mt_data>.
    "build tree alv data
    ASSIGN ct_data TO <lt_outtab>.

    LOOP AT <lt_outtab> ASSIGNING <ls_outtab>.
      ASSIGN COMPONENT mv_parents_node_id_field OF STRUCTURE <ls_outtab> TO <lv_pnode>.
      ASSIGN COMPONENT mv_node_id_field OF STRUCTURE <ls_outtab> TO <lv_node>.
      CLEAR <ls_root>.
      MOVE-CORRESPONDING <ls_outtab> TO <ls_root>.
      IF <lv_pnode> EQ <lv_node> OR <lv_pnode> IS INITIAL.
        APPEND <ls_root> TO <lt_root>.
      ENDIF.
      APPEND <ls_root> TO <mt_data>.
    ENDLOOP.


    "first display with empty itab
    set_table_for_first_display(
      EXPORTING
        is_hierarchy_header = ms_treev_hhdr
        i_save              = 'U'
        is_variant          = ms_variant
      CHANGING
        it_outtab           = <lt_outtab_empty>
        it_fieldcatalog     = lt_fcat ).

    "set event
    set_tree_alv_event( ).


    "set sort
    CLEAR  : lt_otab, ls_otab.
    ls_otab-name = mv_sort_field. APPEND ls_otab TO lt_otab.
    CLEAR ls_otab.
    ls_otab-name = mv_node_id_field. APPEND ls_otab TO lt_otab.

    SORT <lt_root> BY (lt_otab).

    CLEAR  : lt_otab, ls_otab.
    ls_otab-name = mv_parents_node_id_field. APPEND ls_otab TO lt_otab.
    CLEAR ls_otab.
    ls_otab-name = mv_sort_field. APPEND ls_otab TO lt_otab.

    SORT <mt_data> BY (lt_otab).

    "node display
    LOOP AT <lt_root> ASSIGNING <ls_root>.

      ASSIGN COMPONENT mv_node_id_field OF STRUCTURE <ls_root> TO <lv_node>.

      "node layout
      CLEAR : ms_balv_item_layout.
      LOOP AT mt_checkbox_field INTO lv_fieldname."checkbox
        CLEAR : ls_item_layout.
        ls_item_layout-fieldname = lv_fieldname.
        ls_item_layout-class = me->item_class_checkbox.
        ASSIGN COMPONENT lv_fieldname OF STRUCTURE <ls_root> TO <lv_checkbox>.
        ls_item_layout-chosen = <lv_checkbox>.
        CLEAR <lv_checkbox>.
        APPEND ls_item_layout TO ms_balv_item_layout-item_layout.
      ENDLOOP.



      ms_balv_item_layout-node_key = <lv_node>.
      APPEND ms_balv_item_layout TO mt_balv_item_layout.

      "node text
      ASSIGN COMPONENT mv_node_text_field OF STRUCTURE <ls_root> TO <lv_node_text>.
      lv_node_text = <lv_node_text>.

      CLEAR ms_node_layout.
      MOVE-CORRESPONDING <ls_root> TO ms_node_layout.
      add_node(
         EXPORTING
           i_relat_node_key = space
           i_relationship   = me->relat_last_child
           i_node_text      = lv_node_text
           is_node_layout  = ms_node_layout
           is_outtab_line   = <ls_root>
           it_item_layout = ms_balv_item_layout-item_layout
         IMPORTING
           e_new_node_key   = lv_nodeid ).



      add_item_node( EXPORTING iv_pnid = <lv_node>
                          iv_nid = lv_nodeid ).
      CLEAR <ls_root>.
    ENDLOOP.



    frontend_update( ).
    IF ms_header_config-optimize_all_cols EQ abap_true.
      column_optimize( ).
    ENDIF.
    mv_is_reload = abap_true.

  ENDMETHOD.


  METHOD get_fieldcat_config.

    DATA lt_config_fcat TYPE TABLE OF ztbrd00021.
    FIELD-SYMBOLS <ls_fcat> TYPE ztbrd00021.

    IF iv_progid IS INITIAL.
      iv_progid = mv_progid .
    ENDIF.
    IF iv_alv_key IS INITIAL.
      iv_alv_key = mv_alv_key.
    ENDIF.
    IF iv_fcat_key IS INITIAL.
      iv_fcat_key = mv_fcat_key.
    ENDIF.


    SELECT * INTO TABLE lt_config_fcat
      FROM ztbrd00021
      WHERE progid = iv_progid
        AND alv_key = iv_alv_key
        AND fcat_key = iv_fcat_key.
    IF sy-subrc NE 0.
      SELECT * INTO TABLE lt_config_fcat
      FROM ztbrd00021
      WHERE progid = iv_progid
        AND alv_key = iv_alv_key
        AND fcat_key = 'DEFAULT'.
    ENDIF.

    LOOP AT lt_config_fcat ASSIGNING <ls_fcat>.
      CLEAR ms_fieldcat.
      MOVE-CORRESPONDING <ls_fcat> TO ms_fieldcat.
      ms_fieldcat-key = <ls_fcat>-zkey.
      APPEND ms_fieldcat TO rt_fcat.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_header_config.
    DATA ls_header_config TYPE ztbrd00011.

    IF iv_progid IS INITIAL.
      iv_progid = mv_progid.
    ENDIF.
    IF iv_alv_key IS INITIAL.
      iv_alv_key = mv_alv_key.
    ENDIF.

    "layout
    SELECT SINGLE * INTO ls_header_config
    FROM ztbrd00011
    WHERE progid EQ iv_progid
      AND alv_key EQ iv_alv_key.

    rs_treev_hhdr-heading = ls_header_config-heading.
    rs_treev_hhdr-tooltip = ls_header_config-tooltip.
    rs_treev_hhdr-width = ls_header_config-width.
    rs_treev_hhdr-width_pix = ls_header_config-width_pix.


  ENDMETHOD.


  METHOD get_index_outtab.
    rt_tab = mt_index_outtab.
  ENDMETHOD.


  METHOD get_line.

* ...

    FIELD-SYMBOLS: <wa>   TYPE any, <tab1> TYPE STANDARD TABLE.
    DATA: l_dref_wa TYPE REF TO data.

    ASSIGN mt_outtab->* TO <tab1>.
    CREATE DATA l_dref_wa LIKE LINE OF <tab1>.
    ASSIGN l_dref_wa->* TO <wa>.

* read the new lines corresponding old line
    DATA: l_index    TYPE lvc_index.
    DATA: l_node_key TYPE lvc_nkey.
    l_node_key = i_node_key.             "NODEKEY CAST
    CALL METHOD me->get_index_from_node_key
      EXPORTING
        i_node_key     = l_node_key
      IMPORTING
        e_index        = l_index
      EXCEPTIONS
        node_not_found = 1.
    IF sy-subrc = 1.
      RAISE node_not_found.
    ENDIF.

    IF c_outtab_line IS REQUESTED.
      READ TABLE <tab1> INTO <wa> INDEX l_index.
      MOVE-CORRESPONDING <wa> TO c_outtab_line.
*    e_outtab_line = <wa>.
    ENDIF.

* get node-text
    IF e_node_text IS REQUESTED.
      CALL METHOD me->tree_get_node_text
        EXPORTING
          i_node_key  = l_node_key
        IMPORTING
          e_node_text = e_node_text.
    ENDIF.

* get item_layout
    DATA ls_item_layout TYPE lvc_s_lyin.
    DATA ls_item_layi   TYPE lvc_s_layi.
    IF et_item_layout IS REQUESTED.
      LOOP AT mt_item_layout INTO ls_item_layout
                          WHERE node_key = i_node_key.
*     get checkbox-state
        READ TABLE mt_checked_items WITH TABLE KEY
                             nodekey = i_node_key
                             fieldname = ls_item_layout-fieldname
                             TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          ls_item_layout-chosen = 'X'.
        ELSE.
          ls_item_layout-chosen = ''.
        ENDIF.
*      append ls_item_layout to et_item_layout.
        "LVC_T_LYIN -> LVC_T_LAYI incompatible move.
        MOVE-CORRESPONDING ls_item_layout TO ls_item_layi.
        " ls_Item_layout-node_key is not present in layi.
        APPEND ls_item_layi TO et_item_layout.
      ENDLOOP.
    ENDIF.

* get node_layout
    DATA ls_node_layout TYPE lvc_s_layn.
    IF es_node_layout IS REQUESTED.
      CALL METHOD me->tree_get_node_layout
        EXPORTING
          i_node_key     = i_node_key
        IMPORTING
          es_node_layout = es_node_layout.
    ENDIF.


  ENDMETHOD.


  METHOD handle_expand_nc.
    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.

    CONCATENATE mv_alv_key '_NODE_EXPAND' INTO lv_form_name.

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_progid) USING '&Node' node_key IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD handle_header_context_request.
    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.

    CONCATENATE mv_alv_key '_CONTEXT_REQUEST' INTO lv_form_name.

    TRY.
        menu->clear( ).
        PERFORM (lv_form_name) IN PROGRAM (mv_progid) USING '&Header' fieldname menu '&Header' IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD handle_header_context_select.
    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.

    CONCATENATE mv_alv_key '_CONTEXT_SELECT' INTO lv_form_name.

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_progid) USING '&Header' fcode fieldname '&Header' IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.

  ENDMETHOD.


  METHOD handle_item_context_request.

    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.

    CONCATENATE mv_alv_key '_CONTEXT_REQUEST' INTO lv_form_name.

    TRY.
        menu->clear( ).
        PERFORM (lv_form_name) IN PROGRAM (mv_progid) USING '&Item' fieldname menu node_key IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.

  ENDMETHOD.


  METHOD handle_item_context_selected.

    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.


    CONCATENATE mv_alv_key '_CONTEXT_SELECT' INTO lv_form_name.

    TRY.

        PERFORM (lv_form_name) IN PROGRAM (mv_progid) USING '&Item' fcode fieldname node_key IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.

  ENDMETHOD.


  METHOD handle_item_double_click.
    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.

    CONCATENATE mv_alv_key '_DOUBLE_CLICK' INTO lv_form_name.

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_progid) USING fieldname node_key IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD handle_node_context_request.
    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.

    CONCATENATE mv_alv_key '_CONTEXT_REQUEST' INTO lv_form_name.

    TRY.
        menu->clear( ).
        PERFORM (lv_form_name) IN PROGRAM (mv_progid) USING '&Node' '&Node' menu node_key IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD handle_node_context_selected.
    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.

    CONCATENATE mv_alv_key '_CONTEXT_SELECT' INTO lv_form_name.

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_progid) USING '&Node' fcode '&Node' node_key IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD handle_node_double_click.
    DATA lv_form_name TYPE string.
    DATA lv_str       TYPE string.

    CONCATENATE mv_alv_key '_DOUBLE_CLICK' INTO lv_form_name.

    TRY.
        PERFORM (lv_form_name) IN PROGRAM (mv_progid) USING '&Node' node_key IF FOUND.
      CATCH cx_sy_dyn_call_param_not_found.
        CONCATENATE lv_form_name ` subroutine parameters are not competable!!` INTO lv_str.
        MESSAGE lv_str TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD refresh.

    update_calculations( ).
    frontend_update( ).
    cl_gui_cfw=>flush( ).
  ENDMETHOD.


  METHOD reload.
    FIELD-SYMBOLS : <lt_outtab>       TYPE STANDARD TABLE,
                    <lt_root>         TYPE STANDARD TABLE,
                    <ls_root>         TYPE any,
                    <lt_outtab_empty> TYPE STANDARD TABLE,
                    <mt_data>         TYPE STANDARD TABLE,
                    <ls_outtab>       TYPE any,
                    <lv_pnode>        TYPE any,
                    <lv_node>         TYPE any,
                    <lv_node_text>    TYPE any,
                    <lv_checkbox>     TYPE c.

    DATA : lo_root         TYPE REF TO data,
           lo_root_line    TYPE REF TO data,
           lo_outtab       TYPE REF TO data,
           lo_outtab_empty TYPE REF TO data,
           lv_nodeid       TYPE lvc_nkey,
           lv_tabix        TYPE sy-tabix,
           lv_node_text    TYPE lvc_value.
    DATA : lt_otab TYPE abap_sortorder_tab,
           ls_otab TYPE abap_sortorder.
    DATA ls_item_layout TYPE lvc_s_layi.
    DATA : lv_fieldname      TYPE fieldname.

    delete_all_nodes( ).

    "Dynamic itab create
    CREATE DATA lo_root LIKE ct_data.
    ASSIGN lo_root->* TO <lt_root>.
    CREATE DATA lo_root_line LIKE LINE OF <lt_root>.
    ASSIGN lo_root_line->* TO <ls_root>.

    CREATE DATA lo_outtab_empty LIKE ct_data.
    ASSIGN lo_outtab_empty->* TO <lt_outtab_empty>.

    CREATE DATA mt_data LIKE ct_data.
    ASSIGN mt_data->* TO <mt_data>.
    "build tree alv data
    ASSIGN ct_data TO <lt_outtab>.

    LOOP AT <lt_outtab> ASSIGNING <ls_outtab>.
      ASSIGN COMPONENT mv_parents_node_id_field OF STRUCTURE <ls_outtab> TO <lv_pnode>.
      ASSIGN COMPONENT mv_node_id_field OF STRUCTURE <ls_outtab> TO <lv_node>.
      CLEAR <ls_root>.
      MOVE-CORRESPONDING <ls_outtab> TO <ls_root>.
      IF <lv_pnode> EQ <lv_node> OR <lv_pnode> IS INITIAL.
        APPEND <ls_root> TO <lt_root>.
      ENDIF.
      APPEND <ls_root> TO <mt_data>.
    ENDLOOP.

    "set sort
    CLEAR  : lt_otab, ls_otab.
    ls_otab-name = mv_sort_field. APPEND ls_otab TO lt_otab.
    CLEAR ls_otab.
    ls_otab-name = mv_node_id_field. APPEND ls_otab TO lt_otab.

    SORT <lt_root> BY (lt_otab).

    CLEAR  : lt_otab, ls_otab.
    ls_otab-name = mv_parents_node_id_field. APPEND ls_otab TO lt_otab.
    CLEAR ls_otab.
    ls_otab-name = mv_sort_field. APPEND ls_otab TO lt_otab.

    SORT <mt_data> BY (lt_otab).

    "node display
    LOOP AT <lt_root> ASSIGNING <ls_root>.

      ASSIGN COMPONENT mv_node_id_field OF STRUCTURE <ls_root> TO <lv_node>.

      "node layout
      CLEAR : ms_balv_item_layout.
      LOOP AT mt_checkbox_field INTO lv_fieldname."checkbox
        CLEAR : ls_item_layout.
        ls_item_layout-fieldname = lv_fieldname.
        ls_item_layout-class = me->item_class_checkbox.
        ASSIGN COMPONENT lv_fieldname OF STRUCTURE <ls_root> TO <lv_checkbox>.
        ls_item_layout-chosen = <lv_checkbox>.
        CLEAR <lv_checkbox>.
        APPEND ls_item_layout TO ms_balv_item_layout-item_layout.
      ENDLOOP.

      ms_balv_item_layout-node_key = <lv_node>.
      APPEND ms_balv_item_layout TO mt_balv_item_layout.

      "node text
      ASSIGN COMPONENT mv_node_text_field OF STRUCTURE <ls_root> TO <lv_node_text>.
      lv_node_text = <lv_node_text>.

      CLEAR ms_node_layout.
      MOVE-CORRESPONDING <ls_root> TO ms_node_layout.
      add_node(
         EXPORTING
           i_relat_node_key = space
           i_relationship   = me->relat_last_child
           i_node_text      = lv_node_text
           is_node_layout  = ms_node_layout
           is_outtab_line   = <ls_root>
           it_item_layout = ms_balv_item_layout-item_layout
         IMPORTING
           e_new_node_key   = lv_nodeid ).



      add_item_node( EXPORTING iv_pnid = <lv_node>
                          iv_nid = lv_nodeid ).
      CLEAR <ls_root>.
    ENDLOOP.

    frontend_update( ).
    IF ms_header_config-optimize_all_cols EQ abap_true.
      column_optimize( ).
    ENDIF.
    mv_is_reload = abap_true.

  ENDMETHOD.


  METHOD rollback_fail.
    MESSAGE 'Process Failed!!' TYPE 'I' DISPLAY LIKE 'E'.
    ROLLBACK WORK.
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


  METHOD set_default_fieldcat.

    IF mt_config_fieldcat IS INITIAL.
      set_native_fieldcat( EXPORTING it_data = it_data ).
    ELSE.
      set_fieldcat( ).
    ENDIF.

  ENDMETHOD.


  METHOD set_default_layout.
    CLEAR : ms_treev_hhdr, ms_variant.
    "layout
    SELECT SINGLE * INTO ms_header_config
    FROM ztbrd00011
    WHERE progid EQ mv_progid
      AND alv_key EQ mv_alv_key.

    ms_treev_hhdr-heading = ms_header_config-heading.
    ms_treev_hhdr-tooltip = ms_header_config-tooltip.
    ms_treev_hhdr-width = ms_header_config-width.
    ms_treev_hhdr-width_pix = ms_header_config-width_pix.

    ms_variant-report = mv_progid.

  ENDMETHOD.


  METHOD set_fieldcat.
    DATA : ls_fcat  TYPE lvc_s_fcat,
           lv_tabix TYPE sy-tabix.
    DATA : ls_config_fcat      TYPE ztbrd00021,
           ls_config_fcat_text TYPE ztbrd00071.
    LOOP AT mt_config_fieldcat INTO ls_config_fcat.
      CLEAR ls_fcat.
      MOVE-CORRESPONDING ls_config_fcat TO ls_fcat.
      ls_fcat-key = ls_config_fcat-zkey.

      IF ls_config_fcat-node EQ abap_true.
        mv_node_id_field = ls_fcat-fieldname.
      ENDIF.

      IF ls_config_fcat-parents_node EQ abap_true.
        mv_parents_node_id_field = ls_fcat-fieldname.
      ENDIF.

      IF ls_config_fcat-sortidx EQ abap_true.
        mv_sort_field = ls_fcat-fieldname.
      ENDIF.

      IF ls_config_fcat-node_txt EQ abap_true.
        mv_node_text_field = ls_fcat-fieldname.
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


      READ TABLE mt_fieldcat TRANSPORTING NO FIELDS WITH KEY fieldname = ls_config_fcat-fieldname.
      lv_tabix = sy-tabix.
      IF sy-subrc EQ 0.
        MODIFY mt_fieldcat FROM ls_fcat INDEX lv_tabix.
      ELSE.
        APPEND ls_fcat TO mt_fieldcat.
      ENDIF.


      CLEAR : ls_fcat, ls_config_fcat.
    ENDLOOP.
  ENDMETHOD.


  METHOD set_fieldcat_config.
    CLEAR : mt_config_fieldcat.

    SELECT * INTO TABLE mt_config_fieldcat
    FROM ztbrd00021
    WHERE progid = mv_progid
      AND alv_key = mv_alv_key
      AND fcat_key = mv_fcat_key.

    IF sy-subrc NE 0.
      SELECT * INTO TABLE mt_config_fieldcat
      FROM ztbrd00021
      WHERE progid = mv_progid
        AND alv_key = mv_alv_key
        AND fcat_key = 'DEFAULT'.
    ENDIF.

    SORT mt_config_fieldcat BY fieldname.

    SELECT * INTO TABLE mt_config_fieldcat_text
    FROM ztbrd00071
    WHERE progid = mv_progid
      AND alv_key = mv_alv_key
      AND fcat_key = mv_fcat_key
      AND spras = sy-langu.

    SORT mt_config_fieldcat_text BY fieldname.
  ENDMETHOD.


  METHOD set_item_checkbox_checked.
  ENDMETHOD.


  METHOD set_line.

    FIELD-SYMBOLS : <lv_node>     TYPE any,
                    <lv_checkbox> TYPE c.

    DATA : lv_fieldname   TYPE fieldname,
           lv_tabix       TYPE sy-tabix,
           lv_tabix2      TYPE sy-tabix,
           ls_item_layout TYPE lvc_s_layi.
    DATA : lt_item_layout TYPE lvc_t_laci,
           ls_layout      TYPE lvc_s_laci.
    DATA lo_outtab TYPE REF TO data.
    FIELD-SYMBOLS <ls_outtab> TYPE any.

    CREATE DATA lo_outtab LIKE is_outtab_line.
    ASSIGN lo_outtab->* TO <ls_outtab>.
    MOVE-CORRESPONDING is_outtab_line TO <ls_outtab>.

    ASSIGN COMPONENT mv_node_id_field OF STRUCTURE <ls_outtab> TO <lv_node>.

    LOOP AT mt_checkbox_field INTO lv_fieldname.

      READ TABLE mt_balv_item_layout INTO ms_balv_item_layout WITH KEY node_key = <lv_node>.
      lv_tabix = sy-tabix.
      IF sy-subrc EQ 0.

        READ TABLE ms_balv_item_layout-item_layout INTO ls_item_layout WITH KEY fieldname = lv_fieldname.
        lv_tabix2 = sy-tabix.
        IF sy-subrc EQ 0.
          ASSIGN COMPONENT lv_fieldname OF STRUCTURE <ls_outtab> TO <lv_checkbox>.
          ls_item_layout-chosen = <lv_checkbox>.
          CLEAR <lv_checkbox>.
          MODIFY ms_balv_item_layout-item_layout FROM ls_item_layout INDEX lv_tabix2 TRANSPORTING chosen.
        ENDIF.
        MODIFY mt_balv_item_layout FROM ms_balv_item_layout INDEX lv_tabix.
      ENDIF.

    ENDLOOP.


    IF it_item_layout IS INITIAL.
      CLEAR : lt_item_layout, ls_layout.
      READ TABLE mt_balv_item_layout INTO ms_balv_item_layout WITH KEY node_key = <lv_node>.
      IF sy-subrc EQ 0.
        LOOP AT ms_balv_item_layout-item_layout INTO ls_item_layout.
          MOVE-CORRESPONDING ls_item_layout TO ls_layout.
          ls_layout-u_chosen = abap_true. "check box가 수정됐다고 표시
          APPEND ls_layout TO lt_item_layout.
          CLEAR : ls_item_layout, ls_layout.
        ENDLOOP.
      ENDIF.
    ELSE.
      lt_item_layout[] = it_item_layout[].
    ENDIF.

    CALL METHOD me->change_line
      EXPORTING
        i_node_key     = iv_node_key
        i_outtab_line  = <ls_outtab>
        is_node_layout = is_node_layout
        it_item_layout = lt_item_layout
        i_node_text    = iv_node_text
        i_u_node_text  = iv_u_node_text
      EXCEPTIONS
        node_not_found = 1.
    IF sy-subrc <> 0.
      RAISE node_not_found.
    ENDIF.

  ENDMETHOD.


  METHOD set_native_fieldcat.
    DATA : ls_lvc_s_fcat TYPE lvc_s_fcat,
           table_descr   TYPE REF TO cl_abap_tabledescr,
           struct_descr  TYPE REF TO cl_abap_structdescr,
           columns       TYPE abap_compdescr_tab.

    FIELD-SYMBOLS <column> LIKE LINE OF columns.


    CLEAR : mt_fieldcat[].

    table_descr ?= cl_abap_typedescr=>describe_by_data( it_data ).
    struct_descr ?= table_descr->get_table_line_type( ).
    columns = struct_descr->components.

    LOOP AT columns ASSIGNING <column>.
      IF <column>-type_kind EQ 'h'.
        CONTINUE.
      ENDIF.
      IF <column>-name = 'BALV_TREE_NODEID'.
        CONTINUE.
      ENDIF.
      IF <column>-name = 'BALV_TREE_PNODEID'.
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


  METHOD set_tree_alv_event.
    DATA: ls_event TYPE cntl_simple_event,
          lt_event TYPE cntl_simple_events.

    IF mv_is_reload NE abap_true.
      CLEAR: ls_event, lt_event.
      get_registered_events( IMPORTING events = lt_event ).


      ls_event-eventid = me->eventid_expand_no_children.
      APPEND ls_event TO lt_event.
      SET HANDLER handle_expand_nc FOR me.

      IF ms_header_config-db_click EQ abap_true.
        ls_event-eventid    = me->eventid_node_double_click.
        APPEND ls_event  TO lt_event.
        ls_event-eventid    = me->eventid_item_double_click.
        APPEND ls_event  TO lt_event.

        SET HANDLER handle_node_double_click FOR me.
        SET HANDLER handle_item_double_click FOR me.
      ENDIF.

      IF ms_header_config-context_menu EQ abap_true.
        ls_event-eventid    = me->eventid_item_context_menu_req.
        APPEND ls_event  TO lt_event.
        ls_event-eventid    = me->eventid_node_context_menu_req.
        APPEND ls_event  TO lt_event.
        ls_event-eventid    = me->eventid_header_context_men_req.
        APPEND ls_event  TO lt_event.
        SET HANDLER handle_item_context_request FOR me.
        SET HANDLER handle_item_context_selected FOR me.
        SET HANDLER handle_header_context_request FOR me.
        SET HANDLER handle_header_context_select FOR me.
        SET HANDLER handle_node_context_request FOR me.
        SET HANDLER handle_node_context_selected FOR me.
      ENDIF.

      set_registered_events( EXPORTING events = lt_event ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
