*----------------------------------------------------------------------*
***INCLUDE LZBRD0002F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CHECK_LICENSE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_ERROR
*&---------------------------------------------------------------------*
FORM check_license.

  SELECT SINGLE acg_cnt INTO @DATA(lv_cnt)
  FROM ztbrd00100
  WHERE uname = @sy-uname.

  IF sy-subrc EQ 0.
    IF lv_cnt > 0.
      ADD -1 TO lv_cnt.
      UPDATE ztbrd00100
      SET acg_cnt = lv_cnt
      WHERE uname = sy-uname.
    ELSE.
      RAISE license_expired.
    ENDIF.
  ENDIF.

  gs_log-zguid = cl_system_uuid=>create_uuid_c32_static( ).
  gs_log-uname = sy-uname.
  gs_log-erdat = sy-datum.
  gs_log-erzet = sy-uzeit.

  INSERT ztbrd00110 FROM gs_log.
ENDFORM.
