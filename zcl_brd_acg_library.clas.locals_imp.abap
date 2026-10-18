*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
DEFINE _set1.
  clear mv_code.
  mv_code = &1.
  append mv_code to mt_code.
  clear mv_code.
end-OF-DEFINITION.
DEFINE _set2.
  clear mv_code.
  mv_code = &1 && &2.
  append mv_code to mt_code.
  clear mv_code.
end-OF-DEFINITION.
DEFINE _set3.
  clear mv_code.
  mv_code = &1 && &2 && &3.
  append mv_code to mt_code.
  clear mv_code.
end-OF-DEFINITION.
DEFINE _set4.
  clear mv_code.
  mv_code = &1 && &2 && &3 && &4.
  append mv_code to mt_code.
  clear mv_code.
end-OF-DEFINITION.
DEFINE _set5.
  clear mv_code.
  mv_code = &1 && &2 && &3 && &4 && &5.
  append mv_code to mt_code.
  clear mv_code.
end-OF-DEFINITION.
DEFINE _set6.
  clear mv_code.
  mv_code = &1 && &2 && &3 && &4 && &5 && &6.
  append mv_code to mt_code.
  clear mv_code.
end-OF-DEFINITION.
DEFINE _set7.
  clear mv_code.
  mv_code = &1 && &2 && &3 && &4 && &5 && &6 && &7.
  append mv_code to mt_code.
  clear mv_code.
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
  append mv_code to mt_code.
  clear mv_code.
end-OF-DEFINITION.
