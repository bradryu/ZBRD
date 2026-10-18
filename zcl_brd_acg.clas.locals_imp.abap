*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
DEFINE _set1.
  CLEAR mv_code.
  mv_code = &1.
  APPEND mv_code TO mt_code.
  CLEAR mv_code.
end-OF-DEFINITION.
DEFINE _set2.
  CLEAR mv_code.
  mv_code = &1 && &2.
  APPEND mv_code TO mt_code.
  CLEAR mv_code.
end-OF-DEFINITION.
DEFINE _set3.
  CLEAR mv_code.
  mv_code = &1 && &2 && &3.
  APPEND mv_code TO mt_code.
  CLEAR mv_code.
end-OF-DEFINITION.
DEFINE _set4.
  CLEAR mv_code.
  mv_code = &1 && &2 && &3 && &4.
  APPEND mv_code TO mt_code.
  CLEAR mv_code.
end-OF-DEFINITION.
DEFINE _set5.
  CLEAR mv_code.
  mv_code = &1 && &2 && &3 && &4 && &5.
  APPEND mv_code TO mt_code.
  CLEAR mv_code.
end-OF-DEFINITION.
DEFINE _set6.
  CLEAR mv_code.
  mv_code = &1 && &2 && &3 && &4 && &5 && &6.
  APPEND mv_code TO mt_code.
  CLEAR mv_code.
end-OF-DEFINITION.
DEFINE _set7.
  CLEAR mv_code.
  mv_code = &1 && &2 && &3 && &4 && &5 && &6 && &7.
  APPEND mv_code TO mt_code.
  CLEAR mv_code.
end-OF-DEFINITION.
DEFINE _add1.
  mv_code = mv_code && &1.
end-OF-DEFINITION.
DEFINE _add2.
  mv_code = mv_code && &1 && &2.
end-OF-DEFINITION.
DEFINE _add3.
  mv_code = mv_code && &1 && &2 && &3.
end-OF-DEFINITION.
DEFINE _add4.
  mv_code = mv_code && &1 && &2 && &3 && &4.
end-OF-DEFINITION.
DEFINE _add5.
  mv_code = mv_code && &1 && &2 && &3 && &4 && &5.
end-OF-DEFINITION.
DEFINE _add6.
  mv_code = mv_code && &1 && &2 && &3 && &4 && &5 && &6.
end-OF-DEFINITION.
DEFINE _add7.
  mv_code = mv_code && &1 && &2 && &3 && &4 && &5 && &6 && &7.
end-OF-DEFINITION.
DEFINE _append.
  APPEND mv_code TO mt_code.
  CLEAR mv_code.
end-OF-DEFINITION.
