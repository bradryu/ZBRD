FUNCTION-POOL zbrd0002.                     "MESSAGE-ID ..

* INCLUDE LZBRD0002D...                      " Local class definition
DATA gv_error TYPE flag.
DATA gs_log TYPE ztbrd00110.

TYPES:
  BEGIN OF ty_dynpro,
    header     TYPE rpy_dyhead,
    containers TYPE dycatt_tab,
    fields     TYPE dyfatc_tab,
    flow_logic TYPE swydyflow,
  END OF ty_dynpro ,
  tt_dynpro TYPE TABLE OF ty_dynpro.
