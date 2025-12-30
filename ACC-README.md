Enable real-time, offline CV on NXP i.MX8MP using TensorFlow Lite + VX Delegate (NPU) with NNStreamer and FastAPI a modular, hardware-accelerated toolkit for edge vision.
This container enables real-time, offline computer-vision workflows on NXP i.MX 8M Plus. It bundles FastAPI endpoints with a GStreamer/NNStreamer video pipeline and TensorFlow Lite accelerated by the i.MX8MP’s on-chip NPU via the VX Delegate (libvx_delegate.so). Build and deploy detection, classification, and pose-estimation use cases with reproducible pipelines, low latency, and efficient perf/Watt on the edge no cloud required.

# NPU Passthrough on NXP i.MX

### About Advantech Container Catalog

The Advantech Container Catalog offers plug-and-play solutions for Edge AI. The NPU Passthrough on NXP i.MX container image provides a comprehensive environment for building and deploying AI applications on NXP i.MX8MP hardware. This container features full hardware acceleration support, optimized AI frameworks, and industrial-grade reliability. With it, developers can quickly prototype and deploy AI use cases—such as computer vision—without the burden of solving time-consuming dependency issues or manually setting up complex toolchains. All required runtimes, libraries, and drivers come pre-configured, ensuring seamless integration with the NXP AI acceleration stack.

### Key benefits of the Container Catalog include:

| Feature / Benefit | Description |
|-------------------------------------|--------------------------------------------------------------------------|
| Accelerated Edge AI Development | Ready-to-use containerized solutions for fast prototyping and deployment |
| Hardware Compatibility Solved | Eliminates embedded hardware and AI software package incompatibility |
| GPU/NPU Access Ready | Supports passthrough for efficient hardware acceleration |
| Model Conversion & Optimization | Built-in AI model quantization and format conversion support |
| Optimized for CV  | Pre-optimized containers for computer vision and large language models |
| Open Ecosystem | 3rd-party developers can integrate new apps to expand the platform. |

## Container Overview

The Pose Estimation Runtime on NXP i.MX8MP provides a plug-and-play AI environment for human skeleton tracking and activity recognition, integrating TensorFlow Lite models(posenet_resnet) with NNStreamer pipelines.

Designed for real-time computer vision on the i.MX NPU, this container offers:

- Offline, on-device inference using TFLite with the VX Delegate (libvx_delegate.so) for NPU acceleration (no internet required post-setup)
- FastAPI middleware for modular CV pipelines and remote control of inference services
- Built-in post-processing modules (bounding box decoding, non-max suppression, class labeling)
- Agent-like orchestration to combine detection with tracking, counting, or rule-based decision logic
- Frame-level context handling to support multi-object tracking and event triggers
- Optional Web UI for real-time video preview and results overlay
- REST API endpoints for seamless integration with external systems
- Customizable model parameters (anchors, thresholds, input resolution) via environment variables or config file

## Container Demo


## Use Cases

### 1. Fitness & Rehabilitation

- Real-time exercise feedback: AI observe and correct posture during workouts for form optimization and injury prevention.
- Physical therapy training: Monitor patient movement and progression during rehab, enabling remote guidance.

### 2. Sports Analytics

- Performance analysis: Track athlete movements to analyze techniques, optimize form, and reduce injury risks.

### 3. Animation, AR/VR & Gaming

- Markerless motion capture: Drive character animations and virtual avatars using live body pose data from cameras.
- Immersive gameplay: Enable gesture-based controls for a more engaging experience.

### 4. Healthcare & Assisted Living

- Postural monitoring: Detect poor ergonomics or risky body alignment in real time—useful for workplaces or elder care.
- Fall detection: Identify and respond to falls or sudden movements in assisted living scenarios.

### 5. Surveillance & Behavior Analysis

- Abnormal activity detection: Analyze body postures and gestures to flag suspicious behavior or loose safety compliance.

### 6. Human–Robot Interaction

- Gesture-driven control: Robots interpret user pose for intuitive interactions, like teleoperation or cooperative tasks.

### 7. Retail & AR Applications

- Virtual try-ons: Use pose detection to enhance virtual fitting rooms—simulate apparel on users in real time.
- Interaction tracking: Monitor customer postures and gestures to improve retail UX.

### 8. Human–Computer Interaction & Gesture Recognition

- Touchless interfaces: Enable users to control systems or express intent using body pose or gestures (e.g., in sign language applications).

## Key Features

- FastAPI Middleware: Modular service layer to expose pose estimation APIs and orchestrate pipelines
- VX Delegate Integration: Hardware-accelerated inference on the i.MX8MP NPU via TensorFlow Lite
- Complete CV Stack: Pre-integrated support for TFLite and NNStreamer for preprocessing and visualization
- Industrial Vision Ready: Optimized GStreamer pipelines with camera/RTSP input, resizing, and skeleton/keypoint overlay
- Edge AI Focus: Real-time pose estimation using the posenet_resnet model with offline, on-device execution
- Performance Optimized: Tuned specifically for the NXP i.MX8MP (Quad Cortex-A53 + NPU) to deliver low-latency inference and efficient power usage

## Host Device Prerequisites

| Item | Specification |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Compatible Hardware | [Advantech EPC-R3720](https://www.advantech.com/en/products/880a61e5-3fed-41f3-bf53-8be2410c0f19/epc-r3720/mod_fde326be-b36e-4044-ba9a-28c4c49a25c6)
| Host OS | Yocto (5.15-kirkstone)  |
| Required Software Packages | Refer to Below |


## Container Environment Overview

### Software Components on Container Image

| Component   | Version | Description                                                                                  |
|-------------|---------|----------------------------------------------------------------------------------------------|
| LiteRT      | 2.9.1   | Provides TFLite Delegate support for GPU and NPU acceleration                            |
| GStreamer   | 1.20.0  | Multimedia framework for building flexible audio/video pipelines                             |
| NNStreamer   | 2.1.1 | NNStreamer is a pipeline-centric multimedia framework enabling flexible audio/video processing integrated with TFLite and other ML backends.                             |
| Python   | 3.10  | Python runtime for building applications                             |


### Container Quick Start Guide

For container quick start, including the docker-compose file and more, please refer
to [README](https://github.com/Advantech-EdgeSync-Containers/Nagarro-Container-Project/blob/main/NPU-Passthrough-on-NXP-iMX/README.md)

### Supported AI Capabilities

#### Vision Models

| Model                               | Format       |
|-------------------------------------|--------------|
| PoseNet (ResNet50)              | TFLite       | 
| MobileNet V1             | TFLite   |
| SSD Mobilenet V2              | TFLite | 
| Facenet       | TFLite       | 

## Supported AI Model Formats

| Runtime | Format  | Compatible Versions | 
|---------|---------|---------------------|
| LiteRT  | .tflite |       2.9.1        | 

## Hardware Acceleration Support

| Accelerator | Support Level | Compatible Libraries |
|-------------|---------------|----------------------|
| NPU         |  INT8 (primary), limited mixed precision, (INT16/FP16 → quantized internally)       | TensorFlow Lite (VX Delegate), NNStreamer  |             
| GPU         |  FP32 / FP16         | TensorFlow Lite (GPU delegate)    |             