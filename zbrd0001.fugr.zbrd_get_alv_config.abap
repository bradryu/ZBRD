FUNCTION zbrd_get_alv_config.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_PROGID) TYPE  CPROG
*"     VALUE(IV_ALV_KEY) TYPE  CHAR10
*"     VALUE(IV_FCAT_KEY) TYPE  CHAR10
*"  TABLES
*"      T_DATA STRUCTURE  ZTBRD00020
*"----------------------------------------------------------------------
*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
**************************************************************************
* Modules / Sub Module : SG / Z
*&---------------------------------------------------------------------
* WRITER             : BRAD.RYU
* DATE               : 2020.07.30
* TYPE               : RFC
* Description        : Get ALV Configuration From Other System
*                      DEV의 BALV Config를 QA, PRD에서 copy하게 한다.
*************************************************************************
*              Changed History
*&---------------------------------------------------------------------**
*Changed Number     Changed Date   Writer    Changed      Description
*&---------------------------------------------------------------------**
*      N            2020.07.30    BRAD.RYU   CREATE       CREATE       *
*************************************************************************


  SELECT * INTO CORRESPONDING FIELDS OF TABLE t_data
    FROM ztbrd00020
    WHERE progid = iv_progid
    AND alv_key = iv_alv_key
    AND fcat_key = iv_fcat_key.



ENDFUNCTION.
