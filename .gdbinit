# set follow-fork-mode child
# set detach-on-fork off

source /opt/pwndbg/gdbinit.py
# source /opt/gef.py

source /opt/splitmind/gdbinit.py
# python
# import splitmind
# (splitmind.Mind()
#   .tell_splitter(show_titles=True)
#   .tell_splitter(set_title="Main")
#   .below(display="backtrace", size="20%")
#   .left(of="main", display="disasm", size="70%", banner="top")
#   .show("code", on="disasm", banner="none")
#   .right(cmd='tty; tail -f /dev/null', size="55%", clearing=False)
#   .tell_splitter(set_title='Input / Output')
#   .above(display="stack", size="75%")
#   .above(display="legend", size="20")
#   .show("regs", on="legend")
#   .right(of="backtrace", cmd="ipython3", size="70%")
# ).build(nobanner=True)
# end
# set context-code-lines 20

python
import splitmind
(splitmind.Mind()
  .tell_splitter(show_titles=True)
  .tell_splitter(set_title="Main")
  .right(display="backtrace", size="25%")
  .above(of="main", display="disasm", size="60%", banner="top")
  .show("code", on="disasm", banner="none")
  .right(cmd='tty; tail -f /dev/null', size="55%", clearing=False)
  .tell_splitter(set_title='Input / Output')
  .above(display="stack", size="85%")
  .above(display="legend", size="20")
  .show("regs", on="legend")
  .below(of="backtrace", cmd="ipython", size="40%")
).build(nobanner=True)
end
set context-code-lines 15

set context-sections  "regs args code disasm stack backtrace"
