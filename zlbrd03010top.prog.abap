*************************************************************************
* 이 프로그램은 저작권 법에 따라 보호받는 BR Developer Group의 지적 재산으로서,
* 무단 사용, 무단 복제하는 행위는 금지되어 있으며 법적제재를 받을 수 있습니다.
* 한국 저작권 위원회 등록번호 : C-2018-000076
* Copyright 2018 BR Developer Group All right reserved.
* http://www.brdev.co.kr:8080/flp
* bradryu@hotmail.com
*************************************************************************
*&---------------------------------------------------------------------*
*&  INCLUDE           ZLBRD03010TOP
*&---------------------------------------------------------------------*

TABLES : ztbrd00010, ztbrd00020.

*&---------------------------------------------------------------------*
*&  CONSTANTS
*&---------------------------------------------------------------------*
CONSTANTS: BEGIN OF c_field_head,
             zdesc TYPE fieldname VALUE 'ZDESC',
             repid TYPE fieldname VALUE 'REPID',
             tabnm TYPE fieldname VALUE 'TABNM',
             ernam TYPE fieldname VALUE 'ERNAM',
             erdat TYPE fieldname VALUE 'ERDAT',
             erzet TYPE fieldname VALUE 'ERZET',
             aenam TYPE fieldname VALUE 'AENAM',
             aedat TYPE fieldname VALUE 'AEDAT',
             aezet TYPE fieldname VALUE 'AEZET',
             mandt TYPE fieldname VALUE 'MANDT',
             zdel  TYPE fieldname VALUE 'ZDEL',
             zguid TYPE fieldname VALUE 'ZGUID',
           END OF c_field_head.
*&---------------------------------------------------------------------*
*&  DATA
*&---------------------------------------------------------------------*
TYPES ts_textedit TYPE c LENGTH 1009.

DATA : go_head           TYPE REF TO zcl_brd_alv_n,
       go_container_head TYPE REF TO cl_gui_container.
DATA : gt_top         TYPE TABLE OF char2000,
       gt_main        TYPE TABLE OF char2000,
       gt_f01         TYPE TABLE OF char2000,
       gt_editor_text TYPE TABLE OF ts_textedit. "stringtab.

DATA : go_splitter_container TYPE REF TO cl_gui_splitter_container,
       go_textedit_json      TYPE REF TO cl_gui_textedit,
       go_textedit_top       TYPE REF TO cl_gui_textedit,
       go_textedit_main      TYPE REF TO cl_gui_textedit,
       go_textedit_f01       TYPE REF TO cl_gui_textedit.

DATA go_container_editor TYPE REF TO cl_gui_custom_container .
DATA : go_container_top	 TYPE REF TO cl_gui_container,
       go_container_main TYPE REF TO cl_gui_container,
       go_container_f01  TYPE REF TO cl_gui_container,
       go_container_100  TYPE REF TO cl_gui_container.
DATA : gs_alv_config TYPE   ztbrd00010,
       gt_alv_fcat   TYPE   zybrd00020,
       gs_alv_fcat   TYPE LINE OF zybrd00020.

*&---------------------------------------------------------------------*
*&  DATA
*&---------------------------------------------------------------------*
DATA : go_item           TYPE REF TO zcl_brd_alv_n,
       go_container_item TYPE REF TO cl_gui_container.
TYPES : BEGIN OF gty_head,
          repid TYPE repid,
          tabnm TYPE tabname,
          excel TYPE flag,
        END OF gty_head.
DATA : gs_head TYPE gty_head.

TYPES : BEGIN OF ts_fcat,
          balv_status_icon TYPE icon-id,
          progid           TYPE ztbrd00020-progid,
          alv_key          TYPE ztbrd00020-alv_key,
          fcat_key         TYPE ztbrd00020-fcat_key,
          fieldname        TYPE ztbrd00020-fieldname,
          row_pos          TYPE ztbrd00020-row_pos,
          col_pos          TYPE ztbrd00020-col_pos,
          tabname          TYPE ztbrd00020-tabname,
          currency         TYPE ztbrd00020-currency,
          cfieldname       TYPE ztbrd00020-cfieldname,
          quantity         TYPE ztbrd00020-quantity,
          qfieldname       TYPE ztbrd00020-qfieldname,
          ifieldname       TYPE ztbrd00020-ifieldname,
          round            TYPE ztbrd00020-round,
          exponent         TYPE ztbrd00020-exponent,
          zkey             TYPE ztbrd00020-zkey,
          key_sel          TYPE ztbrd00020-key_sel,
          icon             TYPE ztbrd00020-icon,
          symbol           TYPE ztbrd00020-symbol,
          checkbox         TYPE ztbrd00020-checkbox,
          just             TYPE ztbrd00020-just,
          lzero            TYPE ztbrd00020-lzero,
          no_sign          TYPE ztbrd00020-no_sign,
          no_zero          TYPE ztbrd00020-no_zero,
          no_convext       TYPE ztbrd00020-no_convext,
          edit_mask        TYPE ztbrd00020-edit_mask,
          emphasize        TYPE ztbrd00020-emphasize,
          fix_column       TYPE ztbrd00020-fix_column,
          do_sum           TYPE ztbrd00020-do_sum,
          no_sum           TYPE ztbrd00020-no_sum,
          no_out           TYPE ztbrd00020-no_out,
          tech             TYPE ztbrd00020-tech,
          outputlen        TYPE ztbrd00020-outputlen,
          convexit         TYPE ztbrd00020-convexit,
          seltext          TYPE ztbrd00020-seltext,
          tooltip          TYPE ztbrd00020-tooltip,
          rollname         TYPE ztbrd00020-rollname,
          datatype         TYPE ztbrd00020-datatype,
          inttype          TYPE ztbrd00020-inttype,
          intlen           TYPE ztbrd00020-intlen,
          lowercase        TYPE ztbrd00020-lowercase,
          reptext          TYPE ztbrd00020-reptext,
          hier_level       TYPE ztbrd00020-hier_level,
          reprep           TYPE ztbrd00020-reprep,
          domname          TYPE ztbrd00020-domname,
          sp_group         TYPE ztbrd00020-sp_group,
          hotspot          TYPE ztbrd00020-hotspot,
          dfieldname       TYPE ztbrd00020-dfieldname,
          col_id           TYPE ztbrd00020-col_id,
          f4availabl       TYPE ztbrd00020-f4availabl,
          auto_value       TYPE ztbrd00020-auto_value,
          checktable       TYPE ztbrd00020-checktable,
          valexi           TYPE ztbrd00020-valexi,
          web_field        TYPE ztbrd00020-web_field,
          href_hndl        TYPE ztbrd00020-href_hndl,
          style            TYPE ztbrd00020-style,
          style2           TYPE ztbrd00020-style2,
          style3           TYPE ztbrd00020-style3,
          style4           TYPE ztbrd00020-style4,
          drdn_hndl        TYPE ztbrd00020-drdn_hndl,
          drdn_field       TYPE ztbrd00020-drdn_field,
          no_merging       TYPE ztbrd00020-no_merging,
          h_ftype          TYPE ztbrd00020-h_ftype,
          col_opt          TYPE ztbrd00020-col_opt,
          no_init_ch       TYPE ztbrd00020-no_init_ch,
          drdn_alias       TYPE ztbrd00020-drdn_alias,
          decfloat_style   TYPE ztbrd00020-decfloat_style,
          parameter0       TYPE ztbrd00020-parameter0,
          parameter1       TYPE ztbrd00020-parameter1,
          parameter2       TYPE ztbrd00020-parameter2,
          parameter3       TYPE ztbrd00020-parameter3,
          parameter4       TYPE ztbrd00020-parameter4,
          parameter5       TYPE ztbrd00020-parameter5,
          parameter6       TYPE ztbrd00020-parameter6,
          parameter7       TYPE ztbrd00020-parameter7,
          parameter8       TYPE ztbrd00020-parameter8,
          parameter9       TYPE ztbrd00020-parameter9,
          ref_field        TYPE ztbrd00020-ref_field,
          ref_table        TYPE ztbrd00020-ref_table,
          txt_field        TYPE ztbrd00020-txt_field,
          roundfield       TYPE ztbrd00020-roundfield,
          decimals_o       TYPE ztbrd00020-decimals_o,
          decmlfield       TYPE ztbrd00020-decmlfield,
          dd_outlen        TYPE ztbrd00020-dd_outlen,
          decimals         TYPE ztbrd00020-decimals,
          coltext          TYPE ztbrd00020-coltext,
          scrtext_l        TYPE ztbrd00020-scrtext_l,
          scrtext_m        TYPE ztbrd00020-scrtext_m,
          scrtext_s        TYPE ztbrd00020-scrtext_s,
          colddictxt       TYPE ztbrd00020-colddictxt,
          selddictxt       TYPE ztbrd00020-selddictxt,
          tipddictxt       TYPE ztbrd00020-tipddictxt,
          crea_edit        TYPE ztbrd00020-crea_edit,
          chan_edit        TYPE ztbrd00020-chan_edit,
          upld_edit        TYPE ztbrd00020-upld_edit,
          tech_col         TYPE ztbrd00020-tech_col,
          tech_form        TYPE ztbrd00020-tech_form,
          tech_comp        TYPE ztbrd00020-tech_comp,
          hier_cpos        TYPE ztbrd00020-hier_cpos,
          h_col_key        TYPE ztbrd00020-h_col_key,
          h_select         TYPE ztbrd00020-h_select,
          dd_roll          TYPE ztbrd00020-dd_roll,
          dragdropid       TYPE ztbrd00020-dragdropid,
          mac              TYPE ztbrd00020-mac,
          indx_field       TYPE ztbrd00020-indx_field,
          indx_cfiel       TYPE ztbrd00020-indx_cfiel,
          indx_qfiel       TYPE ztbrd00020-indx_qfiel,
          indx_ifiel       TYPE ztbrd00020-indx_ifiel,
          indx_round       TYPE ztbrd00020-indx_round,
          indx_decml       TYPE ztbrd00020-indx_decml,
          get_style        TYPE ztbrd00020-get_style,
          mark             TYPE ztbrd00020-mark,
          sr_spos          TYPE ztbrd00020-sr_spos,
          sr_up            TYPE ztbrd00020-sr_up,
          sr_down          TYPE ztbrd00020-sr_down,
          sr_group         TYPE ztbrd00020-sr_group,
          sr_subtot        TYPE ztbrd00020-sr_subtot,
          sr_comp          TYPE ztbrd00020-sr_comp,
          sr_expa          TYPE ztbrd00020-sr_expa,
          sr_seltext       TYPE ztbrd00020-sr_seltext,
          sr_obligatory    TYPE ztbrd00020-sr_obligatory,
          sr_level         TYPE ztbrd00020-sr_level,
          sr_no_out        TYPE ztbrd00020-sr_no_out,
          sr_intopt        TYPE ztbrd00020-sr_intopt,
          button           TYPE ztbrd00020-button,
          change_evt       TYPE ztbrd00020-change_evt,
          ernam            TYPE ztbrd00020-ernam,
          erdat            TYPE ztbrd00020-erdat,
          erzet            TYPE ztbrd00020-erzet,
          aenam            TYPE ztbrd00020-aenam,
          aedat            TYPE ztbrd00020-aedat,
          aezet            TYPE ztbrd00020-aezet,
          zdel             TYPE ztbrd00020-zdel,
          mandt            TYPE ztbrd00020-mandt,
        END OF ts_fcat,
        tt_fcat TYPE TABLE OF ts_fcat.
DATA : BEGIN OF gs_fcat.
         .INCLUDE TYPE ts_fcat.
         DATA : celltab   TYPE lvc_t_styl,
         coltab    TYPE lvc_t_scol,
         rcolor(4), "c_alv_yellow, blue, green, red
       END OF gs_fcat,
       gt_fcat LIKE TABLE OF gs_fcat.
