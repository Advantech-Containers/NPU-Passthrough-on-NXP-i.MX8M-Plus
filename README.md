# NPU Passthrough on NXP i.MX8M Plus

**Version:** 1.0
**Release Date:** Aug 2025  
**Copyright:** © 2025 Advantech Corporation. All rights reserved.

## Overview

The `NPU Passthrough on NXP i.MX` container image provides a comprehensive environment for building and deploying AI applications on NXP i.MX 8MP hardware. This container features full hardware acceleration support, optimized AI frameworks, and industrial-grade reliability. With this container, developers can quickly prototype and deploy AI use cases such as computer vision without the burden of solving time-consuming dependency issues or manually setting up complex toolchains. All required runtimes, libraries, and drivers are pre-configured, ensuring seamless integration with NXP AI acceleration stack.

## Key Features

- **Complete AI Framework Stack:** Pre-integrated runtimes including LiteRT for seamless execution of a wide variety of model formats ( .tflite). Developers can deploy models without worrying about low-level compatibility issues.

- **Edge AI Capabilities:** Optimized support for computer vision leveraging NXP NPU acceleration.

- **Hardware Acceleration:** Direct passthrough access to NPU hardware ensures high-performance and low-latency inference with minimal power consumption.

- **Preconfigured Environment:** Eliminates time-consuming setup by bundling drivers, toolchains, and AI libraries, so developers can focus directly on building applications.

- **Rapid Prototyping & Deployment:** Ideal for quickly testing AI models, validating PoCs, and deployment without rebuilding from scratch.


## Hardware Specifications

| Component       | Specification      |
|-----------------|--------------------|
| Target Hardware | [Advantech EPC-R3720](https://www.advantech.com/en/products/880a61e5-3fed-41f3-bf53-8be2410c0f19/epc-r3720/mod_fde326be-b36e-4044-ba9a-28c4c49a25c6) |
| SoC             | [NXP i.MX8MPlus](https://www.nxp.com/products/IMX8MPLUS?tab=Documentation_Tab)   |
| GPU             | Vivante GC7000UL       |
| NPU             | Vivante GC7000UL       |
| Memory          | 6 GB LPDDR4       |

## Operating System

| Environment        | Operating System                                    |
|--------------------|-----------------------------------------------------|
| **Device Host**    | Yocto (5.15-kirkstone)                              |
| **Container**      | Ubuntu:22.04                                        |


## Software Components

| Component   | Version | Description                                                                                  |
|-------------|---------|----------------------------------------------------------------------------------------------|
| LiteRT      | 2.9.1   | Provides TFLite Delegate support for GPU and NPU acceleration                            |
| GStreamer   | 1.20.0  | Multimedia framework for building flexible audio/video pipelines                             |
| NNStreamer   | 2.1.1 | NNStreamer is a pipeline-centric multimedia framework enabling flexible audio/video processing integrated with TFLite and other ML backends.                             |
| Python   | 3.10  | Python runtime for building applications                             |


## Supported AI Capabilities

### Vision Models

| Model                               | Format       | Note                                                                 |
|-------------------------------------|--------------|----------------------------------------------------------------------|
| PoseNet (ResNet50)              | TFLite       | Provide By NXP Demo Experience   |                                      
| MobileNet V1             | TFLite   | Provide By NXP Demo Experience                                       |
| SSD Mobilenet V2              | TFLite | Provide By NXP Demo Experience                                       |
| Facenet       | TFLite       | Provide By NXP Demo Experience                                      |

> **Note:** The above tables highlight a subset of commonly used models validated for this environment. Other transformer-based or vision models may also be supported depending on runtime compatibility and hardware resources. For the most detailed and updated list of supported models and runtimes, please refer to the NXP official [NXP Demo Experience](https://github.com/nxp-imx-support/nxp-demo-experience-assets/tree/lf-5.15.52_2.1.0/models).



## Supported AI Model Formats

| Runtime | Format  | Compatible Versions | 
|---------|---------|---------------------|
| LiteRT  | .tflite |       2.9.1        | 

## Hardware Acceleration Support

| Accelerator | Support Level | Compatible Libraries |
|-------------|---------------|----------------------|
| NPU         |  INT8 (primary), limited mixed precision, (INT16/FP16 → quantized internally)       | TensorFlow Lite (VX Delegate), NNStreamer  |             
| GPU         |  FP32 / FP16         | TensorFlow Lite (GPU delegate)    |             


### Precision Support

| Precision  | Support Level | Notes |
|------------|---------------|-------|
| FP32       | CPU, GPU      | Highest accuracy, slower performance |
| FP16      | NPU     | Not directly exposed via NPU |
| INT16       | NPU (internal mixed ops)     |Some operators quantized into 16-bit internally |
| INT8       | NPU,CPU      |Primary mode for NPU acceleration, best performance-per-watt |

## Repository Structure
```
NPU-Passthrough-on-NXP-iMX/
├── .env                                    # Environment configuration
├── data                                    # Readme Data (images, gifs)
├── README.md                               # Overview and quick start steps
├── windows-git-setup.md                    # Steps to fix LF/CRLF issues on windows while copying to device
├── build.sh                                # Build script
├── docker-compose.yml                      # Docker Compose setup
└── wise-bench.sh                           # Script to verify acceleration and software stack inside container
```

## Quick Start Guide

### Prerequisites
* Please ensure docker & docker compose are available and accessible on device host OS
* Since default eMMC boot provides only 16 GB storage which is in-sufficient to run/build the container image, it is required to boot the Host OS using a 32 GB (minimum) SD card.

### Clone the Repository (on your development machine)

> **Note for Windows Users:**  
> If you are using **Linux**, no changes are needed — LF line endings are used by default.  
> If you are on **Windows**, please follow the steps in [Windows Git Line Ending Setup](./windows-git-setup.md) before cloning to ensure scripts and configuration files work correctly on Device.

```bash
git clone https://github.com/Advantech-EdgeSync-Containers/Nagarro-Container-Project.git
cd Nagarro-Container-Project
```

### Transfer the `NPU-Passthrough-on-NXP-iMX` folder to EPC-R3720 device

If you cloned the repo on a **separate development machine**, use `scp` to transfer only the relevant folder:

```bash
# From your development machine (Ubuntu or Windows PowerShell if SCP is installed)
scp -r ./NPU-Passthrough-on-NXP-iMX\ <username>@<epcr3720-ip>:/home/<username>/
```

Replace:

* `<username>` – Login username on the EPC-R3720 board (e.g., `root`)
* `<epcr3720-ip>` – IP address of the EPC-R3720 board (e.g., `192.168.1.42`)

This will copy the folder to `/home/<username>/NPU-Passthrough-on-NXP-iMX`.

Then SSH into the NXP device:

```bash
ssh <username>@<epcr3720-ip>  (add '-X' tag for X11 display)
cd ~/NPU-Passthrough-on-NXP-iMX
```

### Installation

```bash
# Make the build script executable
chmod +x build.sh

# Launch the container
./build.sh
```
### AI Accelerator and Software Stack Verification (Optional)
```bash
# Verify AI Accelerator and Software Stack Inside Docker Container
chmod +x wise-bench.sh
./wise-bench.sh
```

![nxp-cv-wise-bench.png](%2Fdata%2Fimages%2Fnxp-cv-wise-bench.png)

Wise-bench logs are saved in the `wise-bench.log` file under `/workspace`


## Best Practices

### Precision Selection
- **Prefer INT8 for NPU acceleration:** The i.MX8MP NPU is optimized for quantized INT8 models. Always convert to INT8 using post-training quantization or quantization-aware training for maximum performance and efficiency.

- **Fallback to FP16/FP32 when INT8 unsupported:** If some operators cannot be quantized, LiteRT may run those parts on CPU/GPU in FP32. FP16 is not natively accelerated but can sometimes reduce memory usage.

- **Accuracy validation post-quantization:** Benchmark the INT8 model against FP32 baseline on-device using NNStreamer pipelines to ensure accuracy is acceptable before deployment.

### Model Optimization
- **Use lightweight backbones:** Models like MobileNetV1/V2, EfficientNet-Lite, SSD-MobileNet, or YOLOv4-Tiny quantized are best suited for real-time workloads on i.MX8MP.

- **Leverage pre-tested models:** Start with NXP-provided sample models (mobilenet, ssd_mobilenet_v2, etc.) or Ultralytics-exported YOLO models already verified with TFLite.

- **Prune and compress:** Reduce model size via pruning and weight clustering to lower memory footprint and improve NPU throughput without major accuracy loss


### Deployment Practices
- **Pin LiteRT & NNStreamer versions:** Ensure NNStreamer and LiteRT delegate (libvx_delegate.so) match the BSP release. Mismatches often cause runtime errors or silent CPU fallback.

- **Batch size = 1 for streaming:** Since pipelines are real-time (camera, video), keep batch size = 1 to minimize latency.

- **Benchmark on the board:** Always run inference tests on the actual i.MX8MP board using gst-launch or NNStreamer Python apps, as desktop benchmarks do not reflect NPU performance.

### Resource Management
- **Balance compute units:** Assign models to NPU via LiteRT delegate when supported. If an operator is not supported, LiteRT will fall back to CPU/GPU. Monitor CPU load to detect silent fallbacks.

- **Optimize memory usage:** Use INT8 models to stay within i.MX8MP’s limited DRAM and avoid OOM. Keep video preprocessing in hardware (VPU/G2D) via NNStreamer plugins.

- **Thermal/power awareness:** Sustained NPU workloads may cause throttling on passively cooled boards. Profile under expected load for long-running deployments.

### Troubleshooting Tips
- **Unsupported operators:** If LiteRT logs show "delegate failed," unsupported ops will fallback to CPU. Simplify/re-train the model to use supported ops.

- **Conversion issues (TFLite → NPU):** Use TFLite quantized .tflite models with int8 input/output tensors. Mismatched quantization formats can prevent delegate usage.

- **Accuracy drop after quantization:** Re-calibrate with a diverse dataset or apply quantization-aware training. Sensitive models (e.g., keypoint/pose) often need QAT.

- **Runtime crashes/missing libs:** Verify libvx_delegate.so is present in /usr/lib/ and matches the LiteRT version in your BSP.

- **Performance too low:** Check GST_DEBUG=nnstreamer*:5 logs — if inference is running on CPU instead of NPU, adjust the model or delegate configuration.


## Known Limitations
- **Minimum storage** Storage required for running Docker containers is 32 GB

- **LiteRT delegate coverage:** Not all TFLite ops are supported by the NPU; unsupported layers fall back to CPU/GPU, reducing FPS.

- **Operator coverage gaps:** Advanced layers (attention, deformable conv, some postprocessing ops) are not supported on NPU. Custom handling is required.

- **Quantization trade-offs:** INT8 is mandatory for NPU, but aggressive quantization can degrade accuracy.

- **Resource constraints:** Large models (YOLOv8l, transformers >100M params) won’t run in real-time or may not fit in memory. Stick to quantized tiny/small variants.

- **Version sensitivity:** BSP release defines supported NNStreamer + LiteRT versions. Using mismatched SDKs (e.g., newer TFLite) can break delegate acceleration.

## Possible Use Cases

1. **Smart Surveillance & Security**  
   - Real-time object detection and person tracking using SSD MobileNet V2 models.  
   - Intrusion detection, face recognition, and abnormal behavior monitoring on edge devices without cloud dependency.  

2. **Industrial Automation & Robotics**  
   - Defect detection in manufacturing lines with computer vision.  
   - Gesture or pose estimation for human–robot collaboration.  
   - Autonomous navigation and obstacle avoidance for robots and drones.  

3. **Healthcare & Wellness**  
   - Contactless vital sign monitoring using vision models.  
   - Fall detection and activity recognition for elderly care.  
   - Medical imaging assistance with lightweight segmentation models.  

4. **Retail & Smart Spaces**  
   - Customer flow analysis, heatmap generation, and people counting.  
   - Shelf stock monitoring and automated checkout solutions.  
   - Emotion detection for personalized customer experiences.  

5. **Transportation & Mobility**  
   - Driver monitoring (drowsiness, distraction detection).  
   - Traffic analysis and smart signaling.  
   - Vehicle and license plate recognition at the edge.  


Copyright © 2025 Advantech Corporation. All rights reserved.
