source /opt/pwndbg/gdbinit.py
# source /opt/gef.py

source /opt/splitmind/gdbinit.py
set context-clear-screen on
set follow-fork-mode parent
python
import splitmind
(splitmind.Mind()
  .tell_splitter(show_titles=True)
  .tell_splitter(set_title="Main")
  .below(display="backtrace", size="18%")
  .left(of="main", display="disasm", size="72%", banner="top")
  .show("code", on="disasm", banner="none")
  .right(cmd='tty; tail -f /dev/null', size="55%", clearing=False)
  .tell_splitter(set_title='Input / Output')
  .above(display="stack", size="75%")
  .above(display="legend", size="20")
  .show("regs", on="legend")
  .right(of="backtrace", cmd="ipython3", size="70%")
).build(nobanner=True)
end
set context-code-lines 30
set context-source-code-lines 30
set context-sections  "regs args code disasm stack backtrace"
