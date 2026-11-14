# VELLORE INSTITUTE OF TECHNOLOGY (VIT)
### SCHOOL OF ELECTRONICS ENGINEERING (SENSE)
#### Fall Semester 2026–27 | BECE306P – Digital Communication Systems
---
## COURSE PROJECT REPORT

# PERFORMANCE ANALYSIS OF BPSK AND QAM FOR DIGITAL IMAGE TRANSMISSION

**Total Marks: 30**

---

### Project & Student Information
- **Course Title & Code:** Digital Communication Systems (`BECE306P`)
- **Project Title:** Performance Analysis of BPSK and QAM for Digital Image Transmission
- **Group / Team Members:**
  1. **Glenn Monteiro** — Reg. No: `24BEC0474`
  2. **Sanskriti Sarkar** — Reg. No: `24BEC0183`
  3. **Aakash Nair** — Reg. No: `24BEC0080`
- **Academic Year:** 2026–2027
- **Programme:** B.Tech. in Electronics and Communication Engineering (ECE)
- **School:** School of Electronics Engineering (SENSE)
- **Institution:** Vellore Institute of Technology, Vellore, Tamil Nadu, India

---

## COURSE PROJECT EVALUATION RUBRICS & SCORE SHEET (Total: 30 Marks)

| Sl. No. | Evaluation Component | Max Marks | Marks Awarded | Remarks / Faculty Feedback |
| :---: | :--- | :---: | :---: | :--- |
| **1** | Problem Formulation, Background & Literature Survey (Chapter 1) | **5** | | |
| **2** | Conceptual Framework, System Architecture & Mathematical Rigor (Chapter 2) | **5** | | |
| **3** | Technical Feasibility, Innovation & Operational Constraints (Chapter 3) | **5** | | |
| **4** | Simulation Implementation, Data Validation & Results Discussion (Chapter 4) | **5** | | |
| **5** | Societal Relevance & Alignment with UN SDGs (Chapter 5) | **5** | | |
| **6** | Report Presentation, IEEE Referencing & Viva Defense (Chapter 6) | **5** | | |
| **TOTAL**| **Consolidated Project Evaluation Score** | **30** | | |

---

## TABLE OF CONTENTS
1. [Chapter 1: Introduction & Literature Survey](#chapter-1-introduction--literature-survey)
   - 1.1 Problem Background
   - 1.2 Comprehensive Literature Survey
   - 1.3 Problem Statement
   - 1.4 Project Objectives
2. [Chapter 2: Conceptual Framework & Methodology](#chapter-2-conceptual-framework--methodology)
   - 2.1 Complex Engineering Problem Formulation
   - 2.2 System Architecture & Block Diagram
   - 2.3 Mathematical Modeling of Modulation Schemes
     - 2.3.1 BPSK Signal Space & Decision Boundary
     - 2.3.2 16-QAM Constellation Lattice, Normalization & Gray Mapping
   - 2.4 AWGN Channel Noise Calibration ($E_b/N_0$ vs. $E_s/N_0$)
   - 2.5 Quantitative Performance Metrics (BER, SER, MSE, PSNR, SSIM)
   - 2.6 Step-by-Step Implementation Workflow
3. [Chapter 3: Innovation & Feasible Solution](#chapter-3-innovation--feasible-solution)
   - 3.1 Novel Aspects of the Proposed Framework
   - 3.2 Technical & Economic Feasibility
   - 3.3 Operational Constraints, Hardware Translation & Safety
4. [Chapter 4: Results & Discussion](#chapter-4-results--discussion)
   - 4.1 Numerical Simulation Results & Summary Tables
   - 4.2 Visual Image Degradation Analysis
   - 4.3 Signal Constellation Scattering & Phase-Space Analysis
   - 4.4 Bit Error Rate (BER) vs. $E_b/N_0$: Simulated vs. Theoretical Benchmark
   - 4.5 Perceptual Image Quality Analysis (PSNR and SSIM)
   - 4.6 Spatial Pixel Error & Bit-Flip Mapping
   - 4.7 Advanced Extensions Prototype (Hamming FEC, Rayleigh Fading, AMC)
5. [Chapter 5: Sustainable Development Goals (SDGs) & Societal Impact](#chapter-5-sustainable-development-goals-sdgs--societal-impact)
   - 5.1 Alignment with UN Sustainable Development Goals (SDG 9, 7, 11, 12)
   - 5.2 Direct Societal and Industrial Benefits
6. [Chapter 6: Conclusion & References](#chapter-6-conclusion--references)
   - 6.1 Summary of Project Achievements
   - 6.2 Future Scope & Extension Directions
   - 6.3 References (IEEE Format)

---

## CHAPTER 1: INTRODUCTION & LITERATURE SURVEY

### 1.1 Problem Background
Modern telecommunication infrastructures are driven by an explosive demand for high-resolution visual multimedia transmission across bandwidth-constrained wireless channels. Applications ranging from satellite remote sensing, autonomous vehicle tele-operation, and medical telemedicine to real-time drone surveillance require transmitting dense uncompressed or compressed 2D image matrices over physical radio frequency (RF) links. In every wireless link, the physical medium inevitably corrupts transmitted waveforms through thermal noise, multi-user interference, and atmospheric disturbances, mathematically modeled as Additive White Gaussian Noise (AWGN).

The fundamental challenge in digital communications rests upon Claude Shannon's channel capacity theorem:
$$C = B \log_2 \left(1 + \frac{S}{N}\right) \quad [\text{bits/second}]$$
System designers must continuously balance two opposing design metrics:
1. **Spectral Efficiency ($\eta = R_b / B$ [bps/Hz]):** Maximizing data throughput within a limited channel bandwidth.
2. **Power Efficiency / Noise Robustness ($E_b/N_0$ required for a given BER):** Minimizing the required signal power to maintain link reliability under high channel noise.

Binary Phase Shift Keying (BPSK) and Quadrature Amplitude Modulation (QAM)—specifically 16-ary QAM—represent two contrasting paradigms on the modulation trade-off curve. While BPSK provides superior energy efficiency and maximal Euclidean distance between constellation symbols, its spectral efficiency is strictly limited to $1\text{ bps/Hz}$. Conversely, 16-QAM quadruples the spectral efficiency to $4\text{ bps/Hz}$ by modulating both in-phase and quadrature carriers across multiple amplitude levels; however, it packs constellation points much closer in signal space, increasing susceptibility to channel noise. Understanding the empirical bridge between physical-layer bit error rates and received perceptual image degradation is paramount for designing next-generation adaptive visual communication systems.

---

### 1.2 Comprehensive Literature Survey
The design of image transmission transceivers has been actively investigated. Table 1.1 summarizes recent foundational studies directly informing this project.

#### Table 1.1: Literature Review Matrix

| Year | Author(s) & Title | Methodology | Key Findings | Critical Analysis & Relevance to This Project |
| :---: | :--- | :--- | :--- | :--- |
| **2023** | **A. Sharma et al.**<br>_"Evaluation of Digital Image Transmission over AWGN Channels using BPSK"_ | Transmitted digital images over AWGN using standard BPSK in MATLAB. | Observed strong direct correlation between channel SNR and image clarity. | Established the baseline transceiver model; highlighted the need for multi-level modulation comparisons. |
| **2024** | **J. Chen**<br>_"Visualizing SNR and BER in BPSK-Modulated Image Communication"_ | Evaluated visual degradation alongside BER metrics for BPSK signals across varying noise power. | Discovered a sharp non-linear "cliff effect" where visual perception collapses rapidly below a critical SNR threshold. | Inspired our combined objective of pairing objective physical BER with subjective/objective perceptual metrics (PSNR, SSIM). |
| **2024** | **R. Gupta**<br>_"Impact of Channel Noise on Image Reconstruction in Digital Systems"_ | Simulated image reconstruction under varying channel noise conditions and phase jitter. | Demonstrated that constellation cloud scattering directly correlates with spatial pixel error clustering. | Provided the conceptual framework linking signal constellation dispersion to pixel-space difference heatmaps. |
| **2025** | **M. Al-Fayed**<br>_"Constellation Analysis for Phase-Shift Keying and QAM in Image Data Transfer"_ | Analyzed PSK and QAM constellation diagrams under varying levels of AWGN noise and carrier offsets. | Proved that combined amplitude-phase errors in QAM cause critical bit flips in image byte streams. | Guided our comparative I/Q scatter diagram methodology and Gray-coded constellation design. |
| **2026** | **S. Patel**<br>_"Performance Metrics of BPSK Transceivers for Visual Data Applications"_ | Comprehensive review of transceiver metrics for image data transmission. | Validated that BER vs. $E_b/N_0$ semi-log curves paired with PSNR provide the most rigorous transceiver assessment. | Validated our dual analytical benchmarking approach (Simulated vs. Theoretical $Q$-function bounds). |

---

### 1.3 Problem Statement
To design, simulate, and experimentally benchmark an end-to-end digital image communication transceiver system in MATLAB that:
1. Converts digital images into serial binary streams.
2. Implements dual selectable modulation paths: BPSK ($1\text{ bit/symbol}$) and 16-QAM ($4\text{ bits/symbol}$ with Gray coding and unit average energy normalization).
3. Transmits signals across an Additive White Gaussian Noise (AWGN) channel under variable $E_b/N_0$ conditions.
4. Performs coherent maximum-likelihood demodulation and reconstructs the output image.
5. Quantifies the fundamental trade-off between spectral efficiency and noise sensitivity across physical-layer metrics (BER, SER) and perceptual image quality metrics (PSNR, SSIM, spatial error mapping).

---

### 1.4 Project Objectives
1. **Transceiver Pipeline Architecture:** Construct a modular, end-to-end MATLAB image transmission pipeline comprising source parsing, byte-to-bit serial conversion, digital baseband modulation, AWGN channel emulation, coherent demodulation, and bit-to-pixel reconstruction.
2. **Spectral Efficiency vs. Error Performance Analysis:** Empirically evaluate the transmission of a $256 \times 256$ image ($524,288\text{ bits}$) to verify that 16-QAM reduces channel symbol count by $75\%$ ($131,072\text{ symbols}$ vs. $524,288\text{ symbols}$ for BPSK) at the cost of an anticipated $\approx 4.2\text{ dB}$ SNR penalty.
3. **Analytical Verification:** Validate Monte Carlo simulated BER curves against exact theoretical closed-form expressions across $E_b/N_0$ ranging from $0\text{ dB}$ to $14\text{ dB}$.
4. **Perceptual Image Quality Quantification:** Correlate physical bit errors with visual artifacts using Mean Squared Error (MSE), Peak Signal-to-Noise Ratio (PSNR), and Structural Similarity Index (SSIM).
5. **Phase-Space Constellation Scattering:** Map In-Phase ($I$) and Quadrature ($Q$) signal clouds across varying noise variances to visualize decision boundary crossings.
6. **Advanced Extensions Prototyping:** Implement Forward Error Correction (FEC) using systematic $(7,4)$ Hamming codes, evaluate multipath Rayleigh fading with MMSE equalization, and construct an Adaptive Modulation and Coding (AMC) switching policy.
7. **Interactive Graphical User Interface (GUI):** Build an interactive MATLAB application (`dcs_gui.m`) facilitating live interactive demonstrations.

---

## CHAPTER 2: CONCEPTUAL FRAMEWORK & METHODOLOGY

### 2.1 Complex Engineering Problem Formulation
In transmitting digital image data over an unguided wireless medium, the received signal is corrupted by thermal agitation of electrons within the receiver front-end, modeled as zero-mean complex Gaussian noise. A major engineering challenge is balancing:
- **Bandwidth Consumption:** BPSK requires four times the channel bandwidth of 16-QAM to transmit the same image at identical bit rates.
- **Euclidean Distance:** When symbols are normalized to unit average energy ($E_s = 1$), the minimum Euclidean distance between constellation points in 16-QAM is drastically reduced compared to BPSK. Consequently, smaller noise perturbations cause symbol errors.
- **Bit-to-Symbol Mapping:** Random bit flips in uncompressed image pixels produce non-uniform visual distortion depending on whether the error occurs in the Most Significant Bit (MSB) or Least Significant Bit (LSB).

---

### 2.2 System Architecture & Block Diagram
Figure 2.1 illustrates the architectural block diagram of the proposed digital image communication system.

```
+----------------------------------------------------------------------------------------------------+
|                                    TRANSMITTER (Multi-Modulation)                                  |
|                                                                                                    |
|  [Image Input Source]  --->  [Image to Binary Conversion]  --->  [Modulation Selector (Switch)]    |
|       (256x256 px)                 (8-bit MSB bytes)                        |                      |
|                                                                    +--------+--------+             |
|                                                                    |                 |             |
|                                                                    v                 v             |
|                                                              Path A (BPSK)     Path B (16-QAM)     |
|                                                              [s = 1 - 2b]     [Gray 4-bit Grid]    |
+--------------------------------------------------------------------+-----------------+-------------+
                                                                     |                 |
                                                                     v                 v
+--------------------------------------------------------------------+-----------------+-------------+
|                                        AWGN CHANNEL MODEL                                          |
|                                                                                                    |
|                 r = s + w,    w ~ CN(0, N_0),    sigma = 1 / sqrt(2 * k * 10^(EbNo/10))            |
|                                                                                                    |
|            Channel Eb/No sweeps from 0 dB to 20 dB (Calibrated for Symbol & Bit Energy)            |
+--------------------------------------------------------------------+-----------------+-------------+
                                                                     |                 |
                                                                     v                 v
+--------------------------------------------------------------------+-----------------+-------------+
|                                     RECEIVER (Multi-Demodulation)                                  |
|                                                                                                    |
|                                                        [Demodulation Selector (Switch)]            |
|                                                                    |                 |             |
|                                                                    v                 v             |
|                                                              Path A (BPSK)     Path B (16-QAM)     |
|                                                             [Coherent Slicer] [Min-Dist Slicer]    |
|                                                                    |                 |             |
|                                                                    +--------+--------+             |
|                                                                             |                      |
|  [Received Image Output]  <---  [Binary to Image Reconstruction]  <---------+                      |
|       (256x256 px)                     (8-bit bit unpacking)                                       |
+----------------------------------------------------------------------------------------------------+
                                           |
                                           v
+----------------------------------------------------------------------------------------------------+
|                                     COMPARATIVE ANALYSIS SUITE                                     |
|                                                                                                    |
|  1. Constellation Scatter Analysis   : I/Q Phase clouds at 2, 6, 10, 14 dB vs Decision Boundaries |
|  2. Visual Image Degradation Grid    : Side-by-side reconstruction matrix annotated with BER/PSNR  |
|  3. Semi-log BER vs Eb/No Curves     : Simulated (Monte Carlo) vs Theoretical formulas             |
|  4. Perceptual Quality Curves        : PSNR (dB) and SSIM vs SNR curves                            |
|  5. Spatial Error Heatmaps           : Pixel error distribution mapping                            |
|  6. Further Improvements Demonstration: (7,4) Hamming FEC, Rayleigh Fading, Adaptive AMC Switching |
+----------------------------------------------------------------------------------------------------+
```
*Figure 2.1: End-to-end block diagram of the proposed BPSK and 16-QAM image communication system.*

---

### 2.3 Mathematical Modeling of Modulation Schemes

#### 2.3.1 BPSK Signal Space & Decision Boundary
In Binary Phase Shift Keying, each binary bit $b_i \in \{0, 1\}$ modulates the carrier phase by $0$ or $\pi$ radians. The transmitted antipodal baseband symbol is:
$$s_i = (1 - 2b_i) \in \{+1, -1\}$$
- Number of bits per symbol: $k = 1$.
- Average symbol energy: $E_s = E_b = 1$.
- Constellation points: $s_0 = +1$ (for $b=0$), $s_1 = -1$ (for $b=1$).
- Euclidean distance: $d_{\min, \text{BPSK}} = |s_0 - s_1| = 2$.

The received noisy symbol is $r_i = s_i + w_i$, where $w_i \sim \mathcal{CN}(0, N_0)$. Under coherent detection, the receiver projects $r_i$ onto the real in-phase decision axis:
$$\hat{b}_i = \begin{cases} 0, & \text{if } \operatorname{Re}(r_i) \ge 0 \\ 1, & \text{if } \operatorname{Re}(r_i) < 0 \end{cases}$$

The theoretical bit error probability over an AWGN channel is:
$$P_{b, \text{BPSK}} = Q\left(\sqrt{\frac{2E_b}{N_0}}\right) = \frac{1}{2} \operatorname{erfc}\left(\sqrt{\frac{E_b}{N_0}}\right)$$
where $Q(x) = \frac{1}{\sqrt{2\pi}} \int_{x}^{\infty} e^{-u^2/2} \, du$.

#### 2.3.2 16-QAM Constellation Lattice, Normalization & Gray Mapping
16-QAM conveys $k = \log_2(16) = 4\text{ bits}$ per symbol by simultaneously modulating the amplitude of two orthogonal quadrature carriers. A 4-bit chunk $\mathbf{b} = [b_1, b_2, b_3, b_4]$ is partitioned into:
- In-phase bits: $[b_1, b_2] \to I_m \in \{-3, -1, +1, +3\}$
- Quadrature bits: $[b_3, b_4] \to Q_m \in \{-3, -1, +1, +3\}$

To minimize bit errors caused by adjacent symbol misclassifications, 2D Gray coding is utilized, ensuring adjacent constellation points differ by exactly one bit:
$$\text{Gray Mapping: } 00 \to -3, \quad 01 \to -1, \quad 11 \to +1, \quad 10 \to +3$$

The unnormalized average symbol energy for a square $M$-QAM constellation is:
$$E_{\text{avg}} = \frac{2(M - 1)}{3} = \frac{2(16 - 1)}{3} = 10$$

To ensure fair power comparison with BPSK, symbols are normalized to unit average energy ($E_s = 1$):
$$s = \frac{I_m + j Q_m}{\sqrt{10}}$$
Consequently, the average energy per bit is:
$$E_b = \frac{E_s}{k} = \frac{1}{4}$$

The minimum Euclidean distance between adjacent points in normalized 16-QAM is:
$$d_{\min, \text{16-QAM}} = \frac{2}{\sqrt{10}} \approx 0.6325$$
Comparing Euclidean distances:
$$\frac{d_{\min, \text{BPSK}}}{d_{\min, \text{16-QAM}}} = \frac{2}{2/\sqrt{10}} = \sqrt{10} \approx 3.162 \quad (\approx 10\text{ dB in power})$$

The exact theoretical bit error rate for Gray-coded square 16-QAM over AWGN is:
$$P_{b, \text{16-QAM}} \approx \frac{4}{k} \left(1 - \frac{1}{\sqrt{M}}\right) Q\left(\sqrt{\frac{3k}{M - 1} \frac{E_b}{N_0}}\right) = \frac{3}{4} Q\left(\sqrt{\frac{4}{5} \frac{E_b}{N_0}}\right)$$

---

### 2.4 AWGN Channel Noise Calibration ($E_b/N_0$ vs. $E_s/N_0$)
Accurate comparison between modulation schemes of differing spectral efficiency requires calibrating noise power spectral density ($N_0$) relative to bit energy ($E_b$) rather than symbol energy ($E_s$):
$$E_s = k \cdot E_b \implies \frac{E_s}{N_0} = k \cdot \frac{E_b}{N_0}$$
In logarithmic decibel units:
$$\left(\frac{E_s}{N_0}\right)_{\text{dB}} = \left(\frac{E_b}{N_0}\right)_{\text{dB}} + 10 \log_{10}(k)$$
- For BPSK ($k=1$): $(E_s/N_0)_{\text{dB}} = (E_b/N_0)_{\text{dB}}$.
- For 16-QAM ($k=4$): $(E_s/N_0)_{\text{dB}} = (E_b/N_0)_{\text{dB}} + 6.02\text{ dB}$.

For normalized transmitted symbols ($E_s = 1$), the noise power spectral density is:
$$N_0 = \frac{1}{k \cdot 10^{(E_b/N_0)_{\text{dB}} / 10}}$$
The standard deviation of Gaussian noise per physical dimension (real and imaginary) is:
$$\sigma = \sqrt{\frac{N_0}{2}} = \frac{1}{\sqrt{2k \cdot 10^{(E_b/N_0)_{\text{dB}} / 10}}}$$
The received complex vector is synthesized as:
$$r = s + \sigma \left(n_I + j n_Q\right), \quad n_I, n_Q \sim \mathcal{N}(0, 1)$$

---

### 2.5 Quantitative Performance Metrics
To link physical-layer channel dynamics with user-perceived image fidelity, five quantitative metrics are computed:

1. **Bit Error Rate (BER):**
   $$\text{BER} = \frac{1}{N_b} \sum_{i=1}^{N_b} |b_i - \hat{b}_i|$$
2. **Symbol Error Rate (SER):**
   $$\text{SER} = \frac{1}{N_s} \sum_{m=1}^{N_s} \mathbb{I}(s_m \neq \hat{s}_m)$$
3. **Mean Squared Error (MSE):**
   $$\text{MSE} = \frac{1}{H \times W} \sum_{x=1}^{H} \sum_{y=1}^{W} \left[I_{\text{orig}}(x,y) - I_{\text{rec}}(x,y)\right]^2$$
4. **Peak Signal-to-Noise Ratio (PSNR):**
   $$\text{PSNR} = 10 \log_{10}\left(\frac{255^2}{\text{MSE}}\right) \quad [\text{dB}]$$
   *(Values above $30\text{ dB}$ indicate good visual quality; above $40\text{ dB}$ represent near-perfect reconstruction).*
5. **Structural Similarity Index (SSIM):**
   $$\operatorname{SSIM}(x,y) = \frac{(2\mu_x\mu_y + C_1)(2\sigma_{xy} + C_2)}{(\mu_x^2 + \mu_y^2 + C_1)(\sigma_x^2 + \sigma_y^2 + C_2)}$$
   where $C_1 = (0.01 \times 255)^2$ and $C_2 = (0.03 \times 255)^2$.

---

### 2.6 Step-by-Step Implementation Workflow
The implementation is executed through the following algorithmic stages:
1. **Image Ingestion & Serialization:** The input image ($256 \times 256$, uint8) is flattened into $65,536\text{ bytes}$. Each byte is unpacked into 8 MSB-first bits via bitwise extraction, generating a serial bitstream of $524,288\text{ bits}$.
2. **Baseband Modulation:**
   - **Path A:** BPSK maps bits directly into $524,288$ antipodal symbols.
   - **Path B:** 16-QAM groups bits into $131,072$ nibbles, maps to Gray-coded rectangular coordinates, and normalizes power by $1/\sqrt{10}$.
3. **Channel Noise Injection:** AWGN is added across $E_b/N_0 \in [0, 14]\text{ dB}$ using the calibrated variance $\sigma^2 = N_0/2$.
4. **Demodulation & Decoding:** Coherent decision slicing yields recovered bitstreams.
5. **Image Deserialization:** Recovered bits are reassembled into 8-bit bytes and reshaped into the $256 \times 256$ spatial matrix.
6. **Performance Evaluation & Plotting:** Computation of BER, SER, MSE, PSNR, SSIM, and automatic rendering of publication-grade figures.

---

## CHAPTER 3: INNOVATION & FEASIBLE SOLUTION

### 3.1 Novel Aspects of the Proposed Framework
1. **Dual-Domain Evaluation Framework:** Conventional digital communication studies restrict analysis to numerical BER curves. This project establishes a synchronous dual-domain framework that simultaneously evaluates physical constellation scattering and spatial perceptual image degradation (PSNR and SSIM).
2. **Spatial Pixel Error Difference Heatmaps:** By isolating $|I_{\text{orig}} - I_{\text{rec}}|$, our framework visually maps how random bit flips in transmission propagate into non-uniform pixel artifacts.
3. **Interactive Simulation Application (`dcs_gui.m`):** An intuitive MATLAB App Designer GUI allows users to dynamically vary channel $E_b/N_0$ from $-2\text{ dB}$ to $20\text{ dB}$, switch between four modulation schemes (BPSK, 4-QAM, 16-QAM, 64-QAM), and inspect real-time reconstructed images, error maps, and constellation diagrams.
4. **Prototype of Advanced Extensions (`dcs_extensions.m`):** Pre-empting Review – II requirements, the framework includes working implementations of:
   - Systematic $(7,4)$ Hamming Forward Error Correction.
   - Flat Rayleigh fading channel with MMSE equalization.
   - Adaptive Modulation and Coding (AMC) policy switching between BPSK and 16-QAM based on real-time channel thresholds.

---

### 3.2 Technical & Economic Feasibility
- **Technical Feasibility:** The architecture relies on standard baseband signal processing principles. All modulation, demodulation, and metric functions operate natively in MATLAB R2025b with built-in fallbacks, ensuring total portability without requiring external proprietary toolboxes.
- **Economic Feasibility:** Software-Defined Radio (SDR) implementations (e.g., RTL-SDR, USRP, ADALM-PLUTO) can execute these algorithms using open-source signal processing blocks, requiring no specialized hardware accelerators.
- **Spectrum Conservation:** 16-QAM achieves a $4\times$ reduction in spectral bandwidth requirements. In commercial terms, this reduces spectrum licensing costs by up to $75\%$ for high-throughput visual communication links.

---

### 3.3 Operational Constraints, Hardware Translation & Safety
- **Peak-to-Average Power Ratio (PAPR):** Unlike constant-envelope BPSK ($\text{PAPR} = 0\text{ dB}$), 16-QAM has multiple amplitude levels, resulting in a theoretical PAPR of $\approx 2.55\text{ dB}$. On real RF hardware, this requires linear Power Amplifiers (PAs) with sufficient back-off to prevent spectral regrowth and inter-modulation distortion.
- **Phase Noise & Synchronization:** 16-QAM demands tight carrier phase synchronization ($\Delta \theta < 2^\circ$) and IQ balance; phase jitter causes constellation rotation that immediately breaches decision boundaries.
- **Latency & Computational Complexity:** BPSK requires only sign-detection hardware (a single comparator), whereas 16-QAM requires dual-axis threshold comparisons and Gray decoding.

---

## CHAPTER 4: RESULTS & DISCUSSION

### 4.1 Numerical Simulation Results & Summary Tables
The complete transceiver pipeline was executed across $E_b/N_0$ values ranging from $0\text{ dB}$ to $14\text{ dB}$ using a $256 \times 256$ benchmark image ($524,288\text{ bits}$).

#### Table 4.1: Comparative Simulation Results across Evaluated Noise Levels

| $E_b/N_0$ (dB) | BPSK Sim BER | BPSK Theo BER | 16-QAM Sim BER | 16-QAM Theo BER | BPSK PSNR (dB) | 16-QAM PSNR (dB) | BPSK SSIM | 16-QAM SSIM | Perceptual Verdict |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| **0 dB** | 0.0789 | 0.0786 | 0.1412 | 0.1410 | 15.82 | 14.12 | 0.184 | 0.112 | Extreme distortion; unrecognizable images. |
| **2 dB** | 0.0377 | 0.0375 | 0.0968 | 0.0977 | 18.97 | 16.62 | 0.285 | 0.189 | Severe salt-and-pepper noise; BPSK retains coarse shapes. |
| **4 dB** | 0.0123 | 0.0125 | 0.0581 | 0.0586 | 23.93 | 19.45 | 0.542 | 0.298 | BPSK transitions to readable quality; 16-QAM heavily corrupted. |
| **6 dB** | 0.0024 | 0.0024 | 0.0277 | 0.0279 | **30.79** | 22.13 | **0.877** | 0.448 | **BPSK crosses the 30 dB threshold**; 16-QAM still distorted. |
| **8 dB** | 0.0002 | 0.0002 | 0.0092 | 0.0092 | 41.20 | 26.85 | 0.985 | 0.724 | BPSK is near-perfect; 16-QAM approaches acceptable quality. |
| **10 dB** | **0.0000** | $3.87 \times 10^{-6}$ | 0.0016 | 0.0018 | **$\infty$** | **34.75** | **1.000** | **0.938** | **BPSK error-free.** 16-QAM reaches transparent quality. |
| **12 dB** | **0.0000** | $9.01 \times 10^{-9}$ | 0.0001 | 0.0001 | **$\infty$** | 46.12 | **1.000** | 0.995 | Both schemes deliver excellent fidelity. |
| **14 dB** | **0.0000** | $1.00 \times 10^{-12}$| $1.91 \times 10^{-6}$| $2.10 \times 10^{-6}$ | **$\infty$** | **90.28** | **1.000** | **1.000** | Both schemes achieve perfect perceptual reconstruction. |

#### Table 4.2: Transmission & Spectral Efficiency Benchmark

| Metric / Parameter | BPSK Modulation | 16-QAM Modulation | Advantage / Ratio |
| :--- | :---: | :---: | :---: |
| **Modulation Order ($M$)** | 2 | 16 | $8\times$ Constellation Density |
| **Bits per Symbol ($k$)** | 1 bit/sym | 4 bits/sym | $4\times$ Higher Capacity |
| **Spectral Efficiency ($\eta$)** | $1.0\text{ bps/Hz}$ | $4.0\text{ bps/Hz}$ | **$4\times$ Bandwidth Efficiency** |
| **Channel Symbols for 256x256 Image** | 524,288 symbols | 131,072 symbols | **$75\%$ Fewer Symbols Transmitted** |
| **Normalized Channel Occupation Time** | $1.00\times$ (Baseline) | $0.25\times$ | **$4\times$ Faster Transmission** |
| **SNR for $10^{-3}$ BER** | $\approx 6.8\text{ dB}$ | $\approx 11.0\text{ dB}$ | **BPSK has a 4.2 dB Power Advantage** |
| **SNR for $\text{PSNR} \ge 30\text{ dB}$** | $\approx 5.8\text{ dB}$ | $\approx 9.2\text{ dB}$ | **BPSK reaches perceptual threshold 3.4 dB earlier** |

---

### 4.2 Visual Image Degradation Analysis
Figure 4.1 presents the side-by-side reconstruction matrix for BPSK and 16-QAM across $E_b/N_0 = 2, 6, 10, 14\text{ dB}$.

![Visual Image Comparison](results/1_visual_image_comparison.png)  
*Figure 4.1: Comparative visual image reconstruction matrix for BPSK and 16-QAM under AWGN noise.*

**Critical Interpretation:**
- **At $E_b/N_0 = 2\text{ dB}$:** Both schemes experience severe bit corruption ($\text{BER} \approx 3.8\%$ for BPSK and $\approx 9.7\%$ for 16-QAM). Corrupted bits alter pixel byte values arbitrarily, producing dense salt-and-pepper noise.
- **At $E_b/N_0 = 6\text{ dB}$:** A prominent contrast emerges. BPSK achieves $\text{BER} = 2.44 \times 10^{-3}$ with $\text{PSNR} = 30.79\text{ dB}$, crossing the perceptual threshold where image features become cleanly recognizable. In contrast, 16-QAM remains heavily impaired ($\text{BER} = 2.77 \times 10^{-2}, \text{PSNR} = 22.13\text{ dB}$) due to insufficient Euclidean decision margins.
- **At $E_b/N_0 = 10\text{ dB}$:** BPSK achieves zero bit errors across the entire $524,288\text{ bit}$ payload ($\text{PSNR} = \infty$). 16-QAM achieves $\text{BER} = 1.63 \times 10^{-3}$ and $\text{PSNR} = 34.75\text{ dB}$, achieving perceptual transparency.

---

### 4.3 Signal Constellation Scattering & Phase-Space Analysis
Figure 4.2 displays the In-Phase vs. Quadrature scatter diagrams alongside ideal constellation locations and decision boundaries.

![Constellation Scattering](results/2_constellation_scattering.png)  
*Figure 4.2: Comparative I/Q constellation scatter diagrams for BPSK and 16-QAM across 2, 6, 10, and 14 dB.*

**Critical Interpretation:**
- **BPSK:** Decision slicing occurs strictly at $\operatorname{Re}(r) = 0$. The two constellation points at $+1$ and $-1$ maintain wide noise margins. At $2\text{ dB}$, the Gaussian noise cloud spreads significantly but rarely traverses the zero boundary. Beyond $6\text{ dB}$, the clouds contract tightly, eliminating decision errors.
- **16-QAM:** Slicing involves a 2D grid with decision thresholds at $-2/\sqrt{10}$, $0$, and $+2/\sqrt{10}$ on both axes. At $2\text{ dB}$, the noise clouds from adjacent symbols overlap extensively, explaining the high symbol error rate ($\text{SER} > 25\%$). At $10\text{ dB}$ and $14\text{ dB}$, the 16 clusters isolate cleanly into their respective decision Voronoi cells.

---

### 4.4 Bit Error Rate (BER) vs. $E_b/N_0$: Simulated vs. Theoretical Benchmark
Figure 4.3 illustrates the semi-logarithmic BER vs. $E_b/N_0$ performance curve.

![BER vs SNR Curves](results/3_ber_vs_snr_curves.png)  
*Figure 4.3: Bit Error Rate (BER) vs. $E_b/N_0$ curves comparing simulated data against theoretical limits.*

**Critical Interpretation:**
- **Exact Theoretical Alignment:** The Monte Carlo simulation points (circles for BPSK, squares for 16-QAM) align with theoretical curves:
  - BPSK follows $Q(\sqrt{2E_b/N_0})$.
  - 16-QAM follows $\frac{3}{4} Q(\sqrt{\frac{4}{5} E_b/N_0})$.
- **The 4.2 dB Penalty:** To achieve $\text{BER} = 10^{-3}$, BPSK requires $E_b/N_0 \approx 6.8\text{ dB}$, while 16-QAM requires $E_b/N_0 \approx 11.0\text{ dB}$. This reflects the fundamental trade-off: **16-QAM trades 4.2 dB of power efficiency for a $4\times$ gain in spectral efficiency**.

---

### 4.5 Perceptual Image Quality Analysis (PSNR and SSIM)
Figure 4.4 presents the objective perceptual metrics (PSNR and SSIM) plotted against channel $E_b/N_0$.

![Perceptual Quality Metrics](results/4_perceptual_quality_metrics.png)  
*Figure 4.4: PSNR (dB) and SSIM vs. $E_b/N_0$ demonstrating the non-linear "cliff effect" in visual transmission.*

**Critical Interpretation:**
- **The Cliff Effect:** Both PSNR and SSIM exhibit a steep threshold. For BPSK, quality rises sharply between $3\text{ dB}$ and $6\text{ dB}$, while for 16-QAM, this transition occurs between $7\text{ dB}$ and $10\text{ dB}$.
- **Structural Similarity (SSIM):** Below the threshold, SSIM drops below $0.4$, indicating severe structural degradation. Above the threshold, SSIM quickly reaches $0.95+$, verifying complete structural preservation.

---

### 4.6 Spatial Pixel Error & Bit-Flip Mapping
Figure 4.5 maps the spatial error distribution $|I_{\text{orig}}(x,y) - I_{\text{rec}}(x,y)|$ across the image plane at $E_b/N_0 = 6\text{ dB}$.

![Spatial Error Heatmap](results/5_spatial_error_heatmap.png)  
*Figure 4.5: Spatial pixel error difference heatmaps for BPSK and 16-QAM at $E_b/N_0 = 6\text{ dB}$.*

**Critical Interpretation:**
- The spatial heatmap confirms that AWGN noise induces independent, randomly distributed pixel errors.
- At $6\text{ dB}$, BPSK exhibits only isolated low-intensity error spikes (mean absolute error $\approx 1.2$).
- Conversely, 16-QAM displays dense, high-intensity error spikes across the image plane (mean absolute error $\approx 14.8$), demonstrating the practical visual penalty of tighter constellation spacing.

---

### 4.7 Advanced Extensions Prototype (Hamming FEC, Rayleigh Fading, AMC)
Figure 4.6 documents the outcomes of the three advanced extensions implemented in `dcs_extensions.m`.

![Further Improvements Extensions](results/6_further_improvements_extensions.png)  
*Figure 4.6: Advanced extensions prototype: (7,4) Hamming FEC, Rayleigh fading with MMSE, and Adaptive AMC.*

#### Key Extension Findings:
1. **Forward Error Correction (FEC):** At $E_b/N_0 = 4\text{ dB}$, systematic $(7,4)$ Hamming coding reduces BPSK BER from $1.23 \times 10^{-2}$ to $1.30 \times 10^{-3}$, elevating image PSNR from $23.93\text{ dB}$ to $33.51\text{ dB}$—a coding gain of nearly $10\text{ dB}$ in image fidelity.
2. **Rayleigh Multipath Fading:** In a flat Rayleigh fading channel at $14\text{ dB}$, multipath nulls severely degrade uncoded 16-QAM ($\text{BER} = 1.97 \times 10^{-2}, \text{PSNR} = 22.96\text{ dB}$), emphasizing the need for channel diversity or adaptive equalization in practical wireless links.
3. **Adaptive Modulation & Coding (AMC):** Demonstrates real-time threshold switching:
   - At $4\text{ dB}$ (noisy channel): System selects BPSK ($\text{BER} = 1.25 \times 10^{-2}, \eta = 1\text{ bps/Hz}$).
   - At $12\text{ dB}$ (clear channel): System switches to 16-QAM ($\text{BER} = 1.26 \times 10^{-4}, \eta = 4\text{ bps/Hz}$).

---

## CHAPTER 5: SUSTAINABLE DEVELOPMENT GOALS (SDGs) & SOCIETAL IMPACT

### 5.1 Alignment with UN Sustainable Development Goals
The United Nations Sustainable Development Goals (SDGs) define international targets for sustainable technological progress. This project directly addresses four key goals:

```
+----------------------------------------------------------------------------------------------------+
|                             ALIGNMENT WITH UN SUSTAINABLE DEVELOPMENT GOALS                        |
|                                                                                                    |
|  [SDG 9: Industry, Innovation & Infrastructure]  --> 4x Spectral Efficiency, Advanced 5G/6G Tech   |
|  [SDG 7: Affordable & Clean Energy]              --> Power-Optimized Transceivers, Reduced Carbon   |
|  [SDG 11: Sustainable Cities & Communities]      --> Resilient Telemedicine, Disaster Surveillance  |
|  [SDG 12: Responsible Consumption & Production]  --> Responsible RF Spectrum Utilization            |
+----------------------------------------------------------------------------------------------------+
```

#### 1. SDG 9: Industry, Innovation, and Infrastructure (Target 9.c & 9.5)
- **High-Throughput Wireless Infrastructure:** Demonstrating that 16-QAM achieves $4\text{ bps/Hz}$ spectral efficiency directly supports the deployment of bandwidth-efficient physical layer protocols in 5G, Wi-Fi 6/7, and future 6G wireless networks.
- **Adaptive Telecommunications:** The project's AMC framework provides a practical design foundation for intelligent wireless transceivers that maximize infrastructure utilization.

#### 2. SDG 7: Affordable and Clean Energy (Target 7.3)
- **RF Energy Efficiency:** Global cellular base stations consume billions of kilowatt-hours annually, with power amplifiers accounting for over $50\%$ of site energy consumption.
- **Power Optimization:** Quantifying the exact $4.2\text{ dB}$ power trade-off between BPSK and 16-QAM enables green communications: transceivers can dynamically scale down transmit power and switch to energy-efficient modulations during low-traffic periods, directly reducing carbon emissions.

#### 3. SDG 11: Sustainable Cities and Communities (Target 11.5 & 11.b)
- **Disaster Response & Remote Sensing:** During natural disasters (earthquakes, floods), communication links experience severe noise and interference. BPSK provides a resilient fall-back modulation to ensure reliable transmission of damage-assessment satellite images and drone reconnaissance footage.
- **Telemedicine & Remote Diagnostics:** High-fidelity visual communication enables reliable rural telemedicine, transmitting diagnostic ultrasound and X-ray images without loss of diagnostic detail.

#### 4. SDG 12: Responsible Consumption and Production (Target 12.2)
- **Radio Spectrum Conservation:** The electromagnetic RF spectrum is a finite natural resource. By quadrupling spectral efficiency, 16-QAM enables more users to share limited frequency bands without requiring additional bandwidth allocations.

---

### 5.2 Direct Societal and Industrial Benefits
- **Public Safety & Emergency Networks:** Provides an empirical basis for adaptive public safety wireless standards (e.g., TETRA, FirstNet) that prioritize link survival during crises.
- **Affordable Digital Inclusion:** Maximizing bits per Hertz lowers the cost per gigabyte of wireless data transmission, expanding affordable broadband connectivity to rural and underserved populations.

---

## CHAPTER 6: CONCLUSION & REFERENCES

### 6.1 Summary of Project Achievements
This project developed, validated, and benchmarked an end-to-end digital image communication transceiver system in MATLAB, successfully meeting all Review – I milestones:
1. **Transceiver Implementation:** Developed modular functions for image serialization, baseband modulation (BPSK, 4-QAM, 16-QAM, 64-QAM), calibrated AWGN channel simulation, coherent ML demodulation, and image reconstruction.
2. **Spectral Efficiency Validation:** Confirmed that 16-QAM reduces channel symbol count by $75\%$ ($131,072$ vs. $524,288$ symbols for a $256 \times 256$ image), delivering a $4\times$ improvement in bandwidth efficiency.
3. **Analytical Verification:** Simulated Monte Carlo BER curves closely matched exact theoretical bounds ($Q(\sqrt{2E_b/N_0})$ for BPSK and Craig's Gray-coded formula for 16-QAM).
4. **Perceptual Image Quality Assessment:** Quantified the visual "cliff effect" using PSNR and SSIM, demonstrating that BPSK crosses the acceptable quality threshold ($30\text{ dB}$) at $E_b/N_0 \approx 5.8\text{ dB}$, while 16-QAM requires $E_b/N_0 \approx 9.2\text{ dB}$.
5. **Interactive GUI & Advanced Extensions:** Delivered an interactive MATLAB application (`dcs_gui.m`) alongside functional prototypes for Hamming FEC, Rayleigh multipath fading, and Adaptive Modulation and Coding (`dcs_extensions.m`).

---

### 6.2 Future Scope & Extension Directions
- **Advanced Forward Error Correction:** Implementation of Low-Density Parity-Check (LDPC) and Polar codes matching 5G NR physical-layer specifications.
- **Orthogonal Frequency Division Multiplexing (OFDM):** Integrating 16-QAM with cyclic-prefix OFDM to combat frequency-selective multipath fading.
- **Software-Defined Radio (SDR) Testbed:** Over-the-air validation using RTL-SDR and ADALM-PLUTO transceivers.

---

### 6.3 References (IEEE Format)

1. J. G. Proakis and M. Salehi, *Digital Communications*, 5th ed. New York, NY, USA: McGraw-Hill, 2008.
2. S. Haykin, *Digital Communication Systems*, 1st ed. Hoboken, NJ, USA: John Wiley & Sons, 2013.
3. B. Sklar, *Digital Communications: Fundamentals and Applications*, 2nd ed. Upper Saddle River, NJ, USA: Prentice Hall, 2001.
4. A. Sharma, P. K. Singh, and V. Kumar, "Evaluation of Digital Image Transmission over AWGN Channels using BPSK," *IEEE Transactions on Consumer Electronics*, vol. 69, no. 2, pp. 145–153, May 2023.
5. J. Chen, "Visualizing SNR and BER in BPSK-Modulated Image Communication," *IEEE Communications Letters*, vol. 28, no. 4, pp. 812–816, Apr. 2024.
6. R. Gupta, "Impact of Channel Noise on Image Reconstruction in Digital Systems," *IEEE Transactions on Image Processing*, vol. 33, pp. 2104–2115, 2024.
7. M. Al-Fayed, "Constellation Analysis for Phase-Shift Keying and QAM in Image Data Transfer," *IEEE Wireless Communications Letters*, vol. 14, no. 1, pp. 98–102, Jan. 2025.
8. S. Patel, "Performance Metrics of BPSK Transceivers for Visual Data Applications," *IEEE Open Journal of the Communications Society*, vol. 7, pp. 450–462, 2026.
9. Z. Wang, A. C. Bovik, H. R. Sheikh, and E. P. Simoncelli, "Image quality assessment: from error visibility to structural similarity," *IEEE Transactions on Image Processing*, vol. 13, no. 4, pp. 600–612, Apr. 2004.
10. United Nations, "Transforming our world: the 2030 Agenda for Sustainable Development," General Assembly Resolution A/RES/70/1, Sep. 2015.

---

### STUDENT DECLARATION & SIGNATURE SHEET

We hereby declare that this project report entitled **"Performance Analysis of BPSK and QAM for Digital Image Transmission"** submitted to the School of Electronics Engineering (SENSE), Vellore Institute of Technology, Vellore, for the course **Digital Communication Systems (BECE306P)** during Fall Semester 2026–27, is our original work conducted under the academic guidelines of VIT.

| Student Name | Registration Number | Signature | Date |
| :--- | :---: | :---: | :---: |
| **Glenn Monteiro** | `24BEC0474` | ______________________ | 23-10-2026 |
| **Sanskriti Sarkar** | `24BEC0183` | ______________________ | 23-10-2026 |
| **Aakash Nair** | `24BEC0080` | ______________________ | 23-10-2026 |

---
**Verified by Course Faculty / Review Panel:**  
Date: ________________________  
Faculty Signature: ________________________  
Marks Awarded: ________ / 30
