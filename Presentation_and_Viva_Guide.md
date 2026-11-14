# DCS Course Project Presentation Guide & Viva Defense

**Vellore Institute of Technology | School of Electronics Engineering (SENSE)**  
**Course:** Digital Communication Systems (DCS)  
**Project:** Performance Analysis of BPSK and QAM for Digital Image Transmission  
**Academic Year:** 2026–27  

**Team Members:**
- **Glenn Monteiro** (`24BEC0474`)
- **Sanskriti Sarkar** (`24BEC0183`)
- **Aakash Nair** (`24BEC0080`)

---

## 1. Team Speaking Roles & Slide Allocation

| Slide | Topic | Primary Speaker | Supporting Role |
| :---: | :--- | :--- | :--- |
| **Slide 1** | Title & Introduction of Team | **Glenn Monteiro** | All members |
| **Slide 2** | Introduction & System Overview | **Glenn Monteiro** | Aakash Nair |
| **Slide 3** | Literature Survey & Foundation | **Sanskriti Sarkar** | Glenn Monteiro |
| **Slide 4** | Block Diagram & Proposed Architecture | **Aakash Nair** | Sanskriti Sarkar |
| **Slide 5** | Issues, Challenges & Research Gap | **Sanskriti Sarkar** | Glenn Monteiro |
| **Slide 6** | Outcomes, Live Demo & Further Improvements | **Aakash Nair** | All members (Q&A) |

---

## 2. Slide-by-Slide Presentation Script

### Slide 1: Title Slide
**Speaker: Glenn Monteiro**
> *"Respected panel members and professors, a very pleasant morning. Today, my team members Sanskriti Sarkar, Aakash Nair, and I, Glenn Monteiro, are presenting our Digital Communication Systems project titled: **'Performance Analysis of BPSK and QAM for Digital Image Transmission'** under the School of Electronics Engineering."*

---

### Slide 2: Introduction
**Speaker: Glenn Monteiro**
> *"In modern wireless visual communication systems—ranging from satellite earth observation to real-time multimedia streaming—the choice of digital modulation governs the fundamental trade-off between bandwidth consumption and error resilience.*
>
> *Our project designs and simulates a complete MATLAB-based communication pipeline. We transform raw digital images into binary bitstreams, modulate them using two contrasting modulation archetypes—Binary Phase Shift Keying (BPSK) and 16-ary Quadrature Amplitude Modulation (16-QAM)—pass them through an Additive White Gaussian Noise (AWGN) channel under variable SNR conditions, and reconstruct the received images.*
>
> *Beyond standard bit error rate analysis, our study bridges physical-layer communication metrics with perceptual image quality measures including PSNR, SSIM, and I/Q constellation scatter dispersion."*

---

### Slide 3: Literature Survey
**Speaker: Sanskriti Sarkar**
> *"To establish a solid scientific baseline, we reviewed key literature in digital image transmission:*
>
> 1. *Sharma et al. (2023) demonstrated the baseline correlation between channel SNR and image clarity over AWGN using BPSK.*
> 2. *Chen (2024) proved that visual degradation exhibits a non-linear 'cliff effect' below specific SNR thresholds.*
> 3. *Gupta (2024) investigated constellation scattering and demonstrated how channel variance induces bit flips that propagate into pixel luminance distortion.*
> 4. *Al-Fayed (2025) contrasted PSK and QAM constellations under AWGN, showing that amplitude-phase coupling in QAM makes decision boundaries significantly tighter.*
> 5. *Patel (2026) verified that comparative BER vs. SNR curves, alongside perceptual PSNR and SSIM, provide the most comprehensive evaluation for visual communication transceivers.*
>
> *These foundational studies directly motivated our dual-pipeline comparative framework."*

---

### Slide 4: Block Diagram of Proposed System
**Speaker: Aakash Nair**
> *"Here is the complete architectural block diagram of our system. It consists of three primary subsystems:*
>
> 1. * **Transmitter (Multi-Modulation):** The source image (such as our 256x256 benchmark image, carrying 524,288 bits) is converted into an 8-bit MSB-first bitstream. A modulation selector switch routes bits either to Path A (BPSK Modulator, mapping bits antipodally to $\pm 1$) or Path B (16-QAM Modulator, grouping bits into 4-bit symbols on a 2D Gray-coded grid normalized to unit average energy).*
> 2. * **Channel:** An AWGN channel introduces circularly symmetric complex Gaussian noise calibrated precisely for $E_b/N_0$.*
> 3. * **Receiver (Multi-Demodulation):** The demodulation selector executes coherent maximum-likelihood slicing. For BPSK, a simple sign test on the in-phase axis recovers the bits. For 16-QAM, minimum Euclidean distance slicing detects the symbols and decodes the Gray bits. The bitstream is then repacked and reshaped into the output image.*
>
> *Our analysis engine performs simultaneous comparative evaluations:*
> - * **Signal Constellation Analysis:** Visualizing scatter clouds across SNR levels against exact decision boundaries.*
> - * **Image & BER Performance Analysis:** Comparing reconstructed visual degradation, semi-log BER vs. $E_b/N_0$ curves against theoretical benchmarks, and spatial pixel error heatmaps."*

---

### Slide 5: Issues, Challenges & Research Gap
**Speaker: Sanskriti Sarkar**
> *"The core challenge in digital communication is balancing spectral efficiency against noise sensitivity:*
> - * **BPSK** offers supreme noise immunity because its constellation points are separated by a wide Euclidean distance ($\Delta d = 2$), but it only transmits $1\text{ bit/symbol}$ ($\eta = 1\text{ bps/Hz}$).*
> - * **16-QAM** packs $4\text{ bits/symbol}$ ($\eta = 4\text{ bps/Hz}$), transmitting the entire 256x256 image in only 131,072 channel symbols—a $75\%$ reduction in channel occupation time. However, to maintain unit average power, the minimum distance between adjacent points shrinks to $\frac{2}{\sqrt{10}} \approx 0.632$, making it substantially more vulnerable to AWGN.*
>
> *Our research fills three crucial gaps:*
> 1. *Implementing synchronized dual BPSK and QAM pipelines in MATLAB to observe practical visual degradation side-by-side.*
> 2. *Quantifying the exact ~4.2 dB SNR trade-off penalty required by 16-QAM to match BPSK reliability.*
> 3. *Mapping how physical constellation dispersion directly translates into spatial image distortion."*

---

### Slide 6: Outcomes, Live Demonstration & Further Improvement
**Speaker: Aakash Nair**
> *"We have successfully implemented the entire system in MATLAB. Here are our validated quantitative outcomes:*
> - *At $E_b/N_0 = 6\text{ dB}$, BPSK achieves a BER of $2.44 \times 10^{-3}$ and an image PSNR of $30.8\text{ dB}$ (reaching acceptable visual clarity), whereas 16-QAM suffers a BER of $2.77 \times 10^{-2}$ and a PSNR of $22.1\text{ dB}$ (severely degraded).*
> - *At $E_b/N_0 = 10\text{ dB}$, BPSK is completely error-free ($\text{BER} = 0$), while 16-QAM reaches pristine visual quality ($\text{PSNR} = 34.8\text{ dB}, \text{SSIM} = 0.938$).*
> - *Our Monte Carlo simulated BER curves match the exact theoretical curves $Q(\sqrt{2E_b/N_0})$ for BPSK and Gray-coded 16-QAM.*
>
> *Furthermore, as demonstrated in our extensions module (`dcs_extensions.m`), we have already prototyped:*
> 1. * **Forward Error Correction (FEC):** A systematic $(7,4)$ Hamming code that improves image PSNR by nearly $10\text{ dB}$ at low SNR.*
> 2. * **Multipath Rayleigh Fading:** Simulating deep fading and MMSE equalization.*
> 3. * **Adaptive Modulation & Coding (AMC):** Dynamically switching from BPSK to 16-QAM when channel SNR exceeds $10\text{ dB}$ to achieve both high speed and zero visible errors.*
>
> *We would now like to demonstrate our interactive MATLAB GUI (`dcs_gui`). Thank you, and we welcome your questions."*

---

## 3. Top 10 Project Viva Questions & Model Answers

### Q1: Why did you choose BPSK and 16-QAM for comparison instead of QPSK and 16-QAM?
**Answer:**  
*"BPSK represents the fundamental benchmark of digital phase modulation with maximum noise immunity and $1\text{ bit/symbol}$ ($1\text{ bps/Hz}$). 16-QAM represents multi-level combined amplitude and phase modulation with $4\text{ bits/symbol}$ ($4\text{ bps/Hz}$). Comparing BPSK and 16-QAM directly illustrates the extreme trade-off: a $4\times$ throughput enhancement versus a $\sim 4.2\text{ dB}$ SNR penalty in noise sensitivity. Additionally, our system also supports QPSK/4-QAM and 64-QAM in our modular codebase."*

---

### Q2: What is the theoretical distance between constellation points for normalized BPSK vs. 16-QAM?
**Answer:**  
*"For unit average symbol energy ($E_s = 1$):*
- *In **BPSK**, symbols are at $+1$ and $-1$. The Euclidean distance is $\Delta d_{\text{BPSK}} = |1 - (-1)| = 2.0$.*
- *In **16-QAM**, the unnormalized grid has points at $\{\pm 1, \pm 3\} + j\{\pm 1, \pm 3\}$ with average energy $E_{\text{avg}} = 10$. Normalizing to $E_s = 1$ scales all points by $\frac{1}{\sqrt{10}}$. The minimum distance between adjacent points is $\Delta d_{\text{16-QAM}} = \frac{2}{\sqrt{10}} \approx 0.6325$.*
*Because the decision region boundary distance is $3.16\times$ smaller in 16-QAM, Gaussian noise vectors can push received symbols across the boundary much more easily, explaining why 16-QAM requires higher SNR."*

---

### Q3: Why is Gray coding essential in 16-QAM?
**Answer:**  
*"In Gray coding, adjacent constellation points differ by only a single bit. Because noise errors at moderate-to-high SNR almost always push a symbol into an immediately adjacent decision region, a symbol error results in only **1 bit error out of 4 bits**. Without Gray coding (e.g., natural binary), an adjacent symbol error could flip 2, 3, or even 4 bits, drastically worsening the Bit Error Rate for the exact same Symbol Error Rate."*

---

### Q4: How did you ensure your AWGN channel correctly scales between $E_b/N_0$ and SNR?
**Answer:**  
*"In digital communications, comparing modulation schemes fairly requires plotting against $E_b/N_0$ (energy per bit to noise power spectral density ratio), not raw symbol SNR. Since $E_s = k \cdot E_b$, where $k = \log_2(M)$:*
- *For BPSK ($k=1$), $E_s/N_0 = E_b/N_0$.*
- *For 16-QAM ($k=4$), $E_s/N_0 = 4 \cdot E_b/N_0 \implies \text{SNR}_{\text{symbol, dB}} = (E_b/N_0)_{\text{dB}} + 10\log_{10}(4) \approx (E_b/N_0)_{\text{dB}} + 6.02\text{ dB}$.*
*In our `awgn_channel.m` function, the per-dimension noise variance is computed as $\sigma = \frac{1}{\sqrt{2 \cdot k \cdot 10^{(E_b/N_0)/10}}}$. This calibration ensures that our simulated BER exactly matches the theoretical BER curves."*

---

### Q5: What is the 'Cliff Effect' or threshold in digital image transmission?
**Answer:**  
*"Unlike analog FM/AM transmission where image quality degrades gracefully with noise, digital image transmission exhibits a sharp threshold or 'cliff effect'. When the channel SNR is above the threshold ($\sim 6\text{ dB}$ for BPSK, $\sim 10\text{ dB}$ for 16-QAM), the BER is below $10^{-3}$, and the human visual system perceives an almost flawless image ($\text{PSNR} > 30\text{ dB}, \text{SSIM} > 0.9$). However, when SNR drops by just $2\text{ dB}$ below this threshold, the BER surges exponentially, flipping the Most Significant Bits (MSBs) of pixel bytes and causing catastrophic visual salt-and-pepper distortion."*

---

### Q6: Why did you use PSNR and SSIM instead of only BER?
**Answer:**  
*"BER measures raw bit flips uniformly. However, in visual data, the perceptual impact of a bit error depends on bit position. If the Most Significant Bit (Bit 8, weight 128) flips, the pixel luminance changes dramatically. If the Least Significant Bit (Bit 1, weight 1) flips, the human eye cannot detect the change. PSNR quantifies the logarithmic power of pixel error variance, while SSIM measures degradation of structural luminance, contrast, and correlation. Combining BER, PSNR, and SSIM gives both physical-layer and perceptual-layer validation."*

---

### Q7: What are the axes in the constellation diagram and what causes the cloud dispersion?
**Answer:**  
*"The horizontal axis is the In-Phase component ($I$, representing the cosine carrier $\cos(2\pi f_c t)$) and the vertical axis is the Quadrature component ($Q$, representing the negative sine carrier $-\sin(2\pi f_c t)$). The spreading of points into circular clouds around the ideal constellation coordinates is caused by the zero-mean Gaussian noise vectors $w_I, w_Q \sim \mathcal{N}(0, \sigma^2)$ added by the AWGN channel. The radius of the cloud is proportional to $\sigma \propto 10^{-\text{SNR}/20}$."*

---

### Q8: What did your spatial error heatmap reveal about channel noise?
**Answer:**  
*"Our spatial error map (`plot_error_map.m`) plots $|I_{\text{orig}}(x,y) - I_{\text{rec}}(x,y)|$. It reveals that channel noise creates spatially independent, randomly distributed pixel errors corresponding to binomial bit-flip events. Under 16-QAM at 6 dB, the heatmap shows high error concentration throughout the entire image plane with mean absolute pixel error $\sim 15\text{ intensity levels}$, whereas BPSK exhibits only sparse isolated points."*

---

### Q9: How does Forward Error Correction (FEC) improve the system?
**Answer:**  
*"In our extension module `fec_hamming.m`, we implemented a systematic $(7,4)$ Hamming code. For every 4 data bits, 3 parity check bits are added using generator matrix $G = [I_4 | P]$. At the receiver, the syndrome $S = r H^T$ detects and corrects any single-bit error per 7-bit block. At $E_b/N_0 = 4\text{ dB}$, FEC reduced the BER from $1.23 \times 10^{-2}$ down to $1.30 \times 10^{-3}$, increasing image PSNR from $23.9\text{ dB}$ to $33.5\text{ dB}$, demonstrating a significant coding gain."*

---

### Q10: How does Adaptive Modulation and Coding (AMC) solve the spectral efficiency vs. noise trade-off?
**Answer:**  
*"AMC monitors the channel quality in real-time. When channel conditions are degraded ($\text{SNR} < 10\text{ dB}$), AMC selects BPSK to prevent visual corruption. When the channel improves ($\text{SNR} \ge 10\text{ dB}$), AMC seamlessly shifts to 16-QAM to quadruple the data transmission rate ($4\text{ bps/Hz}$), maximizing overall network throughput without sacrificing image fidelity."*
