************************************************************************
* MODULES / SUB MODULE :
*&---------------------------------------------------------------------
* T_CODE             : ZLBRD00040
* WRITER             :
* DATE               :
* TYPE               :
* DESCRIPTION        :
*
************************************************************************
*              CHANGED HISTORY
*&---------------------------------------------------------------------*
*CHANGED  CHANGED DATE   WRITER       CR No.     DESCRIPTION
*&---------------------------------------------------------------------*
*  N                                             CREATE                *
************************************************************************
REPORT zlbrd00040 NO STANDARD PAGE HEADING.

INCLUDE znbrd00010.
INCLUDE znbrd00020.
INCLUDE zlbrd00040t01.
INCLUDE zlbrd00040f01.
INCLUDE zlbrd00020f05." Program Generate


*&---------------------------------------------------------------------*
*& INITIALIZATION.
*&---------------------------------------------------------------------*
INITIALIZATION.
  text003 = 'Mandatory Input'.
  text009 = 'Description'.
  text010 = 'Program ID'.
  text011 = 'Table ID'.
  text012 = 'ALV Key'.
  text017 = 'ALV Class'.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION.
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  gv_alv_class = pa_cls.
  gv_repti = pa_repti.

  SELECT COUNT( * ) INTO sy-dbcnt
  FROM ztbrd00010
  WHERE progid = pa_prog
    AND alv_key = pa_alv.

  IF sy-dbcnt > 0.
    zcl_brd_alv=>confirm_msg( EXPORTING iv_title = 'Confirm'
                                      iv_question = 'Already Exists, overwrite?'
                            RECEIVING rv_return = gv_flag ).
    IF gv_flag NE abap_true.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSE.
    zcl_brd_alv=>confirm_msg( EXPORTING iv_title = 'Confirm'
                                      iv_question = 'Generate?'
                            RECEIVING rv_return = gv_flag ).
    IF gv_flag NE abap_true.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.

  CLEAR : gs_header, gt_item[], gs_acg_config, gs_dynpro, gv_repti.
  CLEAR : gt_top[], gt_main[], gt_f01[], gt_100[], gt_item[].

  PERFORM create_config_data.

*  DELETE FROM ztbrd00010 WHERE progid = gs_header-progid AND alv_key = gs_header-alv_key.
*  DELETE FROM ztbrd00020 WHERE progid = gs_header-progid
*                           AND alv_key = gs_header-alv_key
*                           AND fcat_key = 'DEFAULT'.

  MODIFY ztbrd00010 FROM gs_header.
  MODIFY ztbrd00020 FROM TABLE gt_item.

  DELETE gt_item WHERE fieldname = 'BALV_STATUS_ICON'.
  PERFORM gen_source_code.
  PERFORM generate_program.
