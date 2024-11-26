## Description #################################################################
#
# This file contains the definition of keys in libncurses.
#
################################################################################

KEY_CTRL(c::Char)=UInt8(c-'A'+1)
const KEY_DOWN=0o402
const KEY_LEFT=0o404
const KEY_UP=0o403
const KEY_RIGHT=0o405
const KEY_HOME=0o406
const KEY_BACKSPACE=0o407
KEY_F(i)=0o410+i
const KEY_DC=0o512
const KEY_IC=0o513
const KEY_SF=0o520
const KEY_SR=0o521
const KEY_NPAGE=0o522
const KEY_PPAGE=0o523
const KEY_ENTER=0o527
const KEY_BTAB=0o541
const KEY_BEG=0o542
const KEY_END=0o550
const KEY_SDELETE=0o577
const KEY_SEND=0o602
const KEY_SHOME=0o607
const KEY_SIC=0o610
const KEY_SLEFT=0o611
const KEY_SNEXT=0o614
const KEY_SPREVIOUS=0o616
const KEY_SRIGHT=0o622
const KEY_MOUSE=0o631
KEY_ALT(c::Char)=0o641+c-'A'
const KEY_CTRL_DC=0o1020
const KEY_CTRL_DOWN=0o1026
const KEY_CTRL_END=0o1033
const KEY_CTRL_LEFT=0o1052
const KEY_CTRL_HOME=0o1040
const KEY_CTRL_NPAGE=0o1057
const KEY_CTRL_PPAGE=0o1064
const KEY_CTRL_RIGHT=0o1071
const KEY_CTRL_UP=0o1077
const KEY_PAD_PLUS=0o1107
const KEY_PAD_DIV=0o1111
const KEY_PAD_TIMES=0o1113
const KEY_PAD_MINUS=0o1114
