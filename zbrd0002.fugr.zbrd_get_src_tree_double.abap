FUNCTION zbrd_get_src_tree_double.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_I_CONFIG) TYPE  ZTBRD00010
*"     VALUE(IS_H_CONFIG) TYPE  ZTBRD00011
*"     VALUE(IS_ACG_CONFIG_HEADER) TYPE  ZSBRD00140
*"     VALUE(IS_ACG_CONFIG_ITEM) TYPE  ZSBRD00140
*"  EXPORTING
*"     VALUE(ET_FIELDS) TYPE  DYFATC_TAB
*"     VALUE(ET_CONTAINER) TYPE  DYCATT_TAB
*"  TABLES
*"      T_TOP TYPE  ZYBRD00100
*"      T_MAIN TYPE  ZYBRD00100
*"      T_F01 TYPE  ZYBRD00100
*"      T_100 TYPE  ZYBRD00100
*"      T_KEY_MAP TYPE  ZYBRD00110
*"      T_I_FCAT TYPE  ZYBRD00020
*"      T_H_FCAT TYPE  ZYBRD00021
*"  EXCEPTIONS
*"      LICENSE_EXPIRED
*"----------------------------------------------------------------------
*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
  CLEAR gs_log.
  gs_log-acg_type = 'TREEDOUBLE'.
  gs_log-progid = is_acg_config_header-progid.
  gs_log-alv_key1 = is_acg_config_header-alv_key.
  gs_log-fcat_key1 = is_acg_config_header-fcat_key.
  gs_log-alv_key2 = is_acg_config_item-alv_key.
  gs_log-fcat_key2 = is_acg_config_item-fcat_key.

  PERFORM check_license.

  DATA : lo_acg      TYPE REF TO zcl_brd_acg_tree_grid_double.
  DATA : lt_top  TYPE zcl_brd_acg=>gty_src,
         lt_main TYPE zcl_brd_acg=>gty_src,
         lt_f01  TYPE zcl_brd_acg=>gty_src,
         lt_100  TYPE zcl_brd_acg=>gty_src.
  CREATE OBJECT lo_acg
    EXPORTING
      is_acg_config_header = is_acg_config_header
      is_acg_config_item   = is_acg_config_item
      it_key_map           = t_key_map[]
      is_i_config          = is_i_config
      it_i_fcat            = t_i_fcat[]
      is_h_config          = is_h_config
      it_h_fcat            = t_h_fcat[].

  lo_acg->get_top_src( IMPORTING et_src = lt_top ).
  lo_acg->get_main_src( IMPORTING et_src = lt_main ).
  lo_acg->get_f01_src( IMPORTING et_src = lt_f01 ).
  lo_acg->get_100_src( IMPORTING et_src = lt_100 ).
  lo_acg->get_100_attr( IMPORTING et_fields = et_fields
                                et_container = et_container ).

  MOVE lt_top[] TO t_top[].
  MOVE lt_main[] TO t_main[].
  MOVE lt_f01[] TO t_f01[].
  MOVE lt_100[] TO t_100[].

ENDFUNCTION.
