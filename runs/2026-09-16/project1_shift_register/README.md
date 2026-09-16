# Project 1: Shift Register

Actual execution: 2026-09-16, Icarus Verilog 14.0. **PASS: 31 checked cycles; errors = 0.**

## Actual program screenshots

- `evidence/gtkwave_full.png and gtkwave_detail.png`: the running GTKWave application displaying the simulator VCD.
- `evidence/vscode_rtl_testbench.png`: the actual VS Code editor with RTL and testbench side by side.
- `evidence/structure.png` / `.svg`: a separately drawn, RTL-derived gate/register schematic. This is not an application screenshot or a synthesized FPGA technology netlist.

Screenshots contain the real application pixels. GTKWave captures only trim the surrounding desktop; no waveform, result label or editor content was composited. The PNG encoding is documented in the bundle capture manifest.

## Reproduce

Run `python run_free.py` with Icarus Verilog on PATH, or keep the supplied `fpga_free_tools` folder beside the project. Raw VCDs and compile/simulation logs are in `results/`.
Open the VCD in GTKWave and load `results/view.gtkw`; `results/view.gtkwrc` contains the display settings. On Windows, run `05_OPEN_GTKWAVE.bat` (optional scenario argument 1–3 for Project 3).

The DUT RTL is unchanged. Original stimulus retained, with an independent cycle-history checker added.
Timing: N selects the Nth newest input including the current edge; invalid output data is zero.
The 3-bit iDelay port selects only 1–7. Stages 7–9 have no output selection path.

## Optional vendor tool projects

Quartus and ModelSim were not executed in this run. Their supplied configurations are for later use. No synthesis, PPA, resource count or timing-closure claim is made for this run. The structure diagrams show RTL logic, not confirmed MLAB/BRAM mapping.

과제용 PNG는 실제 GTKWave 파형 캡처를 사용하세요. 실제 VS Code 코드·테스트벤치 캡처와 RTL 구조도는 별도 파일입니다.
