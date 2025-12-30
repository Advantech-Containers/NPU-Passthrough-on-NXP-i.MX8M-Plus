
#!/bin/bash

LOG_FILE="/workspace/wise-bench.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Append timestamp to start of each run
{
  echo "==========================================================="
  echo ">>> Diagnostic Run Started at: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "==========================================================="
} >> "$LOG_FILE"

# Save original stdout and stderr
exec 3>&1 4>&2
# Redirect stdout & stderr to both console and file (append mode)
exec > >(tee -a "$LOG_FILE") 2>&1

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}${BOLD}+------------------------------------------------------+${NC}"
echo -e "${BLUE}${BOLD}|    ${PURPLE}Advantech_COE NXP Hardware Diagnostics Tool${BLUE}    |${NC}"
echo -e "${BLUE}${BOLD}+------------------------------------------------------+${NC}"
echo

echo -e "${BLUE}"
echo "       █████╗ ██████╗ ██╗   ██╗ █████╗ ███╗   ██╗████████╗███████╗ ██████╗██╗  ██╗     ██████╗ ██████╗ ███████╗"
echo "      ██╔══██╗██╔══██╗██║   ██║██╔══██╗████╗  ██║╚══██╔══╝██╔════╝██╔════╝██║  ██║    ██╔════╝██╔═══██╗██╔════╝"
echo "      ███████║██║  ██║██║   ██║███████║██╔██╗ ██║   ██║   █████╗  ██║     ███████║    ██║     ██║   ██║█████╗  "
echo "      ██╔══██║██║  ██║╚██╗ ██╔╝██╔══██║██║╚██╗██║   ██║   ██╔══╝  ██║     ██╔══██║    ██║     ██║   ██║██╔══╝  "
echo "      ██║  ██║██████╔╝ ╚████╔╝ ██║  ██║██║ ╚████║   ██║   ███████╗╚██████╗██║  ██║    ╚██████╗╚██████╔╝███████╗"
echo "      ╚═╝  ╚═╝╚═════╝   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚══════╝"
echo -e "${WHITE}                                  Center of Excellence${NC}"
echo
echo -e "${YELLOW}${BOLD}▶ Starting hardware acceleration tests...${NC}"
echo -e "${CYAN}  This may take a moment...${NC}"
echo
sleep 2

# Print helpers
print_header() {
    echo ""
    echo "==== $1 ===="
}

print_table_header() {
    echo "=============================="
    echo "$1"
    echo "=============================="
}

print_table_row() {
    printf "%-20s : %s\n" "$1" "$2"
}

print_table_footer() {
    echo "=============================="
}

# ------------------- SYSTEM INFO -------------------
print_header "SYSTEM INFORMATION"
print_table_header "SYSTEM DETAILS"

KERNEL=$(uname -r)
ARCHITECTURE=$(uname -m)
HOSTNAME=$(hostname)
OS=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "Unknown")
MEMORY_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
MEMORY_USED=$(free -h | awk '/^Mem:/ {print $3}')
CPU_MODEL=$(lscpu | grep "Model name" | cut -d':' -f2- | sed 's/^[ \t]*//' | head -1 || echo "Unknown")
CPU_CORES=$(nproc --all)
UPTIME=$(uptime -p | sed 's/^up //')

print_table_row "Hostname" "$HOSTNAME"
print_table_row "OS" "$OS"
print_table_row "Kernel" "$KERNEL"
print_table_row "Architecture" "$ARCHITECTURE"
print_table_row "CPU" "$CPU_MODEL ($CPU_CORES cores)"
print_table_row "Memory" "$MEMORY_USED / $MEMORY_TOTAL"
print_table_row "Uptime" "$UPTIME"
print_table_row "Date" "$(date "+%a %b %d %H:%M:%S %Y")"
print_table_footer

# ------------------- TFLITE -------------------
print_header "TENSORFLOW LITE TEST"

# TensorFlow Lite ASCII
echo -e "${CYAN}"
echo "████████╗███████╗███╗   ██╗███████╗ ██████╗ ██████╗ ███████╗██╗      ██████╗ ██╗    ██╗"
echo "╚══██╔══╝██╔════╝████╗  ██║██╔════╝██╔═══██╗██╔══██╗██╔════╝██║     ██╔═══██╗██║    ██║"
echo "   ██║   █████╗  ██╔██╗ ██║███████╗██║   ██║██████╔╝█████╗  ██║     ██║   ██║██║ █╗ ██║"
echo "   ██║   ██╔══╝  ██║╚██╗██║╚════██║██║   ██║██╔══██╗██╔══╝  ██║     ██║   ██║██║███╗██║"
echo "   ██║   ███████╗██║ ╚████║███████║╚██████╔╝██║  ██║██║     ███████╗╚██████╔╝╚███╔███╔╝"
echo "   ╚═╝   ╚══════╝╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚══════╝ ╚═════╝  ╚══╝╚══╝ "
echo -e "${NC}"


echo -ne "▶ Checking TensorFlow Lite configuration... "
for i in {1..5}; do
    for c in ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷; do
        echo -ne "\b$c"; sleep 0.1
    done
done
echo -ne "\b✓\n"

# --- TFLite Runtime only ---
TFLITE_VERSION=$(python3 -c "import tflite_runtime; print(tflite_runtime.__version__)" 2>/dev/null)

[[ -z "$TFLITE_VERSION" ]] && TFLITE_VERSION="NA"

print_table_header "TFLITE RUNTIME" "DETAILS"
print_table_row "TFLite version" "$TFLITE_VERSION"
print_table_footer

# ------------------- GSTREAMER -------------------
print_header "GSTREAMER HARDWARE & VIDEO FORMAT CHECK"

# GStr eamer ASCII
echo -e "${MAGENTA}"
echo "   ██████╗  ██████╗████████╗██████╗ ███████╗ █████╗ ███╗   ███╗███████╗██████╗ "
echo "  ██╔════╝ ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝██╔══██╗"
echo "  ██║  ███╗ ████╗     ██║   ██████╔╝█████╗  ███████║██╔████╔██║█████╗  ██████╔╝"
echo "  ██║   ██║╚════██╗   ██║   ██╔══██╗██╔══╝  ██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗"
echo "  ╚██████╔╝██████╔╝   ██║   ██║  ██║███████╗██║  ██║██║ ╚═╝ ██║███████╗██║  ██║"
echo "   ╚═════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝"
echo -e "${NC}"

echo -ne "▶ Detecting hardware encoders, decoders, sinks, sources... "

for i in {1..5}; do
    for c in ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷; do
        echo -ne "\b$c"; sleep 0.1
    done
done
echo -ne "\b✓\n"

# Detect GStreamer version
GST_VERSION=$(gst-launch-1.0 --version 2>/dev/null | grep "GStreamer" | head -n1 | awk '{print $2}')
[[ -z "$GST_VERSION" ]] && GST_VERSION="NA"

echo ""
echo "==== GSTREAMER DETAILS ===="
echo "GStreamer Version: $GST_VERSION"

# --- Table helpers ---
print_table_h() {
    local title="$1"
    echo ""
    echo "==== $title ===="
	
	echo "+----------------------+--------------+------------+--------------+------------------------------------------------------------------------------------------------------------------------+"
    printf "| %-20s | %-12s | %-10s | %-12s | %-118s |\n" "Plugin" "Status" "Version" "Category" "Description"
    echo "+----------------------+--------------+------------+--------------+------------------------------------------------------------------------------------------------------------------------+"
}

print_table_r() {
    printf "| %-20s | %-12s | %-10s | %-12s | %-118s |\n" "$1" "$2" "$3" "$4" "$5"
}

print_table_foo() {
    echo "+----------------------+--------------+------------+--------------+------------------------------------------------------------------------------------------------------------------------+"
}

# --- Check plugin availability, version, and description ---
check_plugin() {
    local plugin=$1
    local category=$2
    if gst-inspect-1.0 "$plugin" >/dev/null 2>&1; then
        local version=$(gst-inspect-1.0 "$plugin" 2>/dev/null | grep "Version" | head -n1 | awk '{print $2}')
        [[ -z "$version" ]] && version="N/A"
        local description=$(gst-inspect-1.0 "$plugin" 2>/dev/null \
            | grep "Description" \
            | head -n1 \
            | awk -F'Description' '{print $2}' \
            | sed 's/^ *//')
        [[ -z "$description" ]] && description="N/A"
        print_table_r "$plugin" "Available" "$version" "$category" "$description"
    else
        print_table_r "$plugin" "✗ Missing" "-" "$category" "N/A"
    fi
}

# --- Start unified table ---
print_table_h "ALL PLUGINS"

# Core plugins
for plugin in filesrc tee queue videoconvert videorate videoscale fakesink filesink ximagesink cairooverlay qtdemux; do
    check_plugin "$plugin" "Core"
done

# Video plugins
for plugin in autovideosrc v4l2src videotestsrc autovideosink glimagesink waylandsink fpsdisplaysink; do
    check_plugin "$plugin" "Video"
done

# HW acceleration plugins (i.MX8MP)
for plugin in imxvideoconvert_g2d imxcompositor_g2d vpudec vpuenc_h264 vpuenc_hevc; do
    check_plugin "$plugin" "HW Accel"
done

print_table_foo


MAGENTA='\033[1;35m'
NC='\033[0m'

print_header "NNSTREAMER CHECK"
# Banner
echo -e "${MAGENTA}"
echo "███╗   ██╗███╗   ██╗███████╗████████╗██████╗ ███████╗ █████╗ ███╗   ███╗███████╗██████╗ "
echo "████╗  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝██╔══██╗"
echo "██╔██╗ ██║██╔██╗ ██║███████╗   ██║   ██████╔╝█████╗  ███████║██╔████╔██║█████╗  ██████╔╝"
echo "██║╚██╗██║██║╚██╗██║╚════██║   ██║   ██╔══██╗██╔══╝  ██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗"
echo "██║ ╚████║██║ ╚████║███████║   ██║   ██║  ██║███████╗██║  ██║██║ ╚═╝ ██║███████╗██║  ██║"
echo "╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝"
echo -e "${NC}"

echo -ne "▶ Detecting NNStreamer support... "
for i in {1..5}; do
    for c in ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷; do
        echo -ne "\b$c"; sleep 0.1
    done
done
echo -ne "\b✓\n"

check_nn_plugin() {
    local plugin=$1
    if gst-inspect-1.0 "$plugin" >/dev/null 2>&1; then
        local version=$(gst-inspect-1.0 "$plugin" 2>/dev/null | grep "Version" | head -n1 | awk '{print $2}')
        [[ -z "$version" ]] && version="N/A"
        local description=$(gst-inspect-1.0 "$plugin" 2>/dev/null \
            | grep "Description" \
            | head -n1 \
            | awk -F'Description' '{print $2}' \
            | sed 's/^ *//')
        [[ -z "$description" ]] && description="N/A"
        print_table_r "$plugin" "Available" "$version" "NNStreamer" "$description"
    else
        print_table_r "$plugin" "✗ Missing" "-" "NNStreamer" "N/A"
    fi
}

# --- NNStreamer version ---
NNSTREAMER_VERSION=$(nnstreamer-check 2>/dev/null | grep "NNStreamer version" | awk '{print $3}')
[[ -z "$NNSTREAMER_VERSION" ]] && NNSTREAMER_VERSION="NA"
echo ""
echo "==== NNSTREAMER DETAILS ===="
echo "NNStreamer Version: $NNSTREAMER_VERSION"

# --- Start NNStreamer plugins table ---
print_table_h "NNSTREAMER PLUGINS"

for plugin in tensor_filter tensor_converter tensor_sink tensor_transform tensor_mux tensor_demux; do
    check_nn_plugin "$plugin"
done

print_table_foo

print_header "NPU PASSTHROUGH/DELEGATION TEST (TFLITE)"
# NPU ASCII
echo -e "${MAGENTA}"
echo "  ███╗   ██╗██████╗ ██╗   ██╗"
echo "  ████╗  ██║██╔══██╗██║   ██║"
echo "  ██╔██╗ ██║██████╔╝██║   ██║"
echo "  ██║╚██╗██║██╔═══╝ ██║   ██║"
echo "  ██║ ╚████║██║     ╚██████╔╝"
echo "  ╚═╝  ╚═══╝╚═╝      ╚═════╝ "
echo -e "${NC}"

echo -ne "▶ Checking NPU availability... "
for i in {1..5}; do
    for c in ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷; do
        echo -ne "\b$c"; sleep 0.1
    done
done
echo -ne "\b✓\n"
NPU_delegate=$(python3 <<'EOF'
import numpy as np
import tflite_runtime.interpreter as tflite
import os
import sys
 
# Paths
MODEL_PATH = "/usr/bin/tensorflow-lite-2.9.1/examples/mobilenet_v1_1.0_224_quant.tflite"
DELEGATE_PATH = "/usr/lib/libvx_delegate.so"
LABEL_PATH = "/usr/bin/tensorflow-lite-2.9.1/examples/labels.txt"
 
# Use NPU if available
USE_NPU = True
# Extract model name
MODEL_NAME = os.path.basename(MODEL_PATH)

# Print model details
print("========== Model Info ==========")
print(f"Model Path : {MODEL_PATH}")
print(f"Model Name : {MODEL_NAME}")
print("================================")

# Check model exists
if not os.path.exists(MODEL_PATH):
    print(f"Model not found: {MODEL_PATH}")
    sys.exit(1)
# Load delegate
try:
    if USE_NPU:
        delegate = tflite.load_delegate(DELEGATE_PATH)
        interpreter = tflite.Interpreter(model_path=MODEL_PATH, experimental_delegates=[delegate])
        print("NPU delegate loaded.")
    else:
        raise Exception("NPU disabled")
except Exception as e:
    print(f"Falling back to CPU. Reason: {e}")
    interpreter = tflite.Interpreter(model_path=MODEL_PATH)
 
interpreter.allocate_tensors()
 
# Get input/output details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
 
input_index = input_details[0]['index']
input_shape = input_details[0]['shape']
input_scale, input_zero_point = input_details[0]['quantization']
input_dtype = input_details[0]['dtype']
 
print(f"Model expects input shape: {input_shape} and dtype: {input_dtype}")
 
# Simulate image input
# You can replace this with actual camera input or image preprocessing
input_image = np.random.rand(*input_shape).astype(np.float32)
 
if input_dtype == np.uint8:
    input_image = (input_image / input_scale + input_zero_point).astype(np.uint8)
 
interpreter.set_tensor(input_index, input_image)
 
# Inference
print("Running inference...")
interpreter.invoke()
print("Done.")
 
# Read output
output_index = output_details[0]['index']
output_data = interpreter.get_tensor(output_index)[0]  # shape: [1001]
 
# Dequantize if needed
output_scale, output_zero_point = output_details[0]['quantization']
output = (output_data.astype(np.float32) - output_zero_point) * output_scale
 
# Load labels (if available)
if os.path.exists(LABEL_PATH):
    with open(LABEL_PATH, 'r') as f:
        labels = [line.strip() for line in f.readlines()]
else:
    labels = [f"Class {i}" for i in range(len(output))]
 
# Get top prediction
top_k = output.argsort()[-5:][::-1]
print("Top predictions:")
for i in top_k:
    print(f"{labels[i]}: {output[i]:.4f}")
EOF
)

if echo "$NPU_delegate" | grep -q "NPU delegate loaded"; then
    NPU_RESULT="NPU delegated"
elif echo "$NPU_delegate" | grep -q "Falling back to CPU"; then
    NPU_RESULT="CPU fallback"
else
    NPU_RESULT="Error"
fi

print_table_header "NPU TEST DETAILS"
echo "$NPU_delegate"
print_table_footer

echo

print_table_header "Final summary "
for i in $(seq 1 5); do
    for c in ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷; do echo -ne "\b$c"; sleep 0.1; done
done
echo -ne "\n"

# ---------- Table print helpers ----------
print_header() {
    echo "==============================="
    echo " $1"
    echo "==============================="
}

print_table_header() {
    printf "%-25s %-20s %-15s\n" "$1" "$2" "$3"
    echo "-----------------------------------------------------------------------"
}

print_table_row() {
    printf "%-25s %-20s %-15s\n" "$1" "$2" "$3"
}

print_table_footer() {
    echo "-----------------------------------------------------------------------"
}

# Example values (these come from your detection logic)
OPENCV_VERSION="$OPENCV_VERSION"
TFLITE_VERSION="$TFLITE_VERSION"
GST_VERSION="$GST_VERSION"
NNSTREAMER="$NNSTREAMER_VERSION"
TFLITE_NPU="$NPU_RESULT"


MAX=4
TFLITE_STATUS=0
GST_STATUS=0
NNSTREAMER_STATUS=0
TFLITE_NPU_STATUS=0

print_table_header "Summary Results" "Version/Details" "Status"

# TFLite
if [[ -n "$TFLITE_VERSION" && "$TFLITE_VERSION" != "NA" ]]; then
    print_table_row "TFLite" "$TFLITE_VERSION" "Supported"
    TFLITE_STATUS=1
else
    print_table_row "TFLite" "NA" "Not Supported"
fi

# GStreamer
if [[ -n "$GST_VERSION" && "$GST_VERSION" != "NA"  ]]; then
    print_table_row "GStreamer" "$GST_VERSION" "Supported"
    GST_STATUS=1
else
    print_table_row "GStreamer" "NA" "Not Supported"
fi

# NNStreamer
if [[ -n "$NNSTREAMER" && "$NNSTREAMER" != "NA" ]]; then
    print_table_row "NNStreamer" "$NNSTREAMER" "Supported"
    NNSTREAMER_STATUS=1
else
    print_table_row "NNStreamer" "NA" "Not Supported"
fi

# TFLite NPU Delegation
if [[ -n "$TFLITE_NPU" && "$TFLITE_NPU" == "NPU delegated" && "$TFLITE_NPU" != "NA" ]]; then
    print_table_row "TFLite NPU Delegation" "$TFLITE_NPU" "Supported"
    TFLITE_NPU_STATUS=1
else
    print_table_row "TFLite NPU Delegation" "NA" "Not Supported"
fi
print_table_footer




# ---- Calculate overall score ----
TOTAL=$((TFLITE_STATUS + GST_STATUS + NNSTREAMER_STATUS + TFLITE_NPU_STATUS))
PERCENTAGE=$((TOTAL * 100 / MAX))

print_table_row "Overall Score" "$PERCENTAGE% ($TOTAL/$MAX)"


# ---- Visual progress bar ----
BAR_SIZE=20
FILLED=$((BAR_SIZE * TOTAL / MAX))
EMPTY=$((BAR_SIZE - FILLED))

BAR=""
for ((i=0; i<FILLED; i++)); do
    BAR="${BAR}█"
done
for ((i=0; i<EMPTY; i++)); do
    BAR="${BAR}░"
done

print_table_row "Progress" "$BAR"


print_header "DIAGNOSTICS COMPLETE"
print_header "All diagnostics completed"


echo -e "${BOLD}>>> Diagnostic Completed at: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo

# At the end, restore original stdout and stderr
exec >&3 2>&4
exec 3>&- 4>&-

exit 0
