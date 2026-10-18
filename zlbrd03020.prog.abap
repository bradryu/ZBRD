*************************************************************************
* MODULES / SUB MODULE :  /
*&---------------------------------------------------------------------
* T_CODE             : ZLBRD03020
* WRITER             : BALV
* DATE               : 2025.11.19
* TYPE               : REPORT
* DESCRIPTION        :
*
*************************************************************************
*              CHANGED HISTORY
*&---------------------------------------------------------------------**
*CHANGED  CHANGED DATE   WRITER       CR No.     DESCRIPTION
*&---------------------------------------------------------------------**
*  N      2025.11.19     BALV                    CREATE       *
*************************************************************************
REPORT zlbrd03020 NO STANDARD PAGE HEADING.

INCLUDE zbalv_std_inc01.
INCLUDE zbalv_std_inc02.
INCLUDE zlbrd03020top.
INCLUDE zlbrd03020f01.
*&---------------------------------------------------------------------**
* INITIALIZATION.
*&---------------------------------------------------------------------**
INITIALIZATION.
  PERFORM create_init_dyn_obj.
  PERFORM set_init_value.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION.
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM check_authority.
  PERFORM get_balv_data.
*---------------------------------------------------------------------*
* END-OF-SELECTION.
*---------------------------------------------------------------------*
END-OF-SELECTION.
  IF sy-batch IS INITIAL.
    CALL SCREEN 100.
  ENDIF.
