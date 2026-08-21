# SystemVerilog for Design and Verification

## Introduction
These labs tasks are part of the Cadence training course [SystemVerilog for Design and
Verification](https://www.cadence.com/en_US/home/training/all-courses/82143.html) and demonstrate
the use of SystemVerilog language constructs to complete simple, common design tasks. Since Cadence
wasnt available at the time of uploading this resource material Vivado 2025.1 was used to run,
simulate and verify these lab exercises on Windows 11.

## Setting up and running the project
- Make sure you have sourced Vivado Tcl shell in your current terminal and are running it in `tcl`
mode.
- To setup the vivado project simply run the following command which will all the project files and
setup the project for the Basys3 board:
    ```tcl
    source ./scripts/setup_prj_vivado.tcl
    ```
- To simulate the lab exercises simply run the following command. Comment out the lab exercises
which you dont want to run. All simulation, elaboration and waveform logs and dumps can be found in
the directory `./bin`.
    ```tcl
    ./scripts/sim_labs.tcl
    ```
- The manual for these exercises is also available as a [Typst](https://typst.app) doc in
`./docs/manual.typ`. To generate a pdf make sure you have typst installed.
    ```bash
    # Ubuntu
    sudo apt install typst
    # Fedora
    sudo dnf install typst
    # Homebrew (MacOS)
    brew install typst

    # compile the doc to generate the pdf
    typst compile ./docs/manual.typ ./docs/manual.pdf
    ```
