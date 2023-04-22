# HV Geometry for Signal Comparison

This repository provides the code and data associated with the paper "HV geometry for signal comparison". In this paper, we investigate a Riemannian geometry on the space of signals in order to compare and interpolate signals. The metric allows for discontinuous signals and measures both horizontal and vertical deformations. Moreover, it allows for signed signals, which overcomes the main deficiency of optimal transportation-based metrics in signal processing. 

## Getting Started

### Prerequisites

- MATLAB

### Installation

1. Clone this repository:

   ```
   git clone https://github.com/yunany/Compute-HV-distance-between-signals.git
   ```

## Usage

The main script to run the experiments is `main.m` and `main_paper_examples.m`. In `main_paper_examples.m`, we reproduce all the examples in the paper. In `main.m`, shows you how to use the code for more general user-defined signals. 

## License

This project is licensed under the BSD-3 License. 

## References

- Ruiyu Han, Dejan Slepvev and Yunan Yang (2023). HV geometry for signal comparison. Preprint
