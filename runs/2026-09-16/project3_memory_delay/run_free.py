from pathlib import Path
import os, subprocess, sys
P=Path(__file__).resolve().parent
TOOLS=P.parent/'fpga_free_tools'
os.environ['PATH']=str(TOOLS/'bin')+os.pathsep+str(TOOLS/'lib')+os.pathsep+os.environ['PATH']
cfg=__import__('json').loads((P/'project.json').read_text())
iverilog=str(TOOLS/'bin/iverilog.exe') if TOOLS.exists() else 'iverilog'
vvp=str(TOOLS/'bin/vvp.exe') if TOOLS.exists() else 'vvp'
(P/'results').mkdir(exist_ok=True)
def run(cmd,log):
    r=subprocess.run(cmd,cwd=P,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
    print(r.stdout);(P/'results'/log).write_text(r.stdout,encoding='utf-8')
    if r.returncode:raise SystemExit(r.returncode)
    return r.stdout
sources=(P/'sources.txt').read_text().splitlines()
run([iverilog,'-g2012','-Wall','-s',cfg['tb'],'-s','dump_trace','-o','results/simulation.vvp',*sources,'tb/dump_trace.sv'],'iverilog_compile.log')
for n in ([1,2,3] if cfg['project']==3 else [0]):
    suffix=f'_scenario{n}' if n else ''
    result=run([vvp,'results/simulation.vvp',f'+SCENARIO={n}'],'icarus'+suffix+'.log')
    if '[TEST PASS]' not in result:raise SystemExit('No PASS marker')
    if n:(P/'results/simulation.vcd').replace(P/f'results/simulation{suffix}.vcd')
print('All requested simulations passed.')
