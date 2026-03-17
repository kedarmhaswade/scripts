#!/bin/bash
# intel_gpu_flicker_diag.sh
# Flicker-optimized Intel GPU diagnostic snapshot

echo "=============================="
echo "   Intel GPU Flicker Snapshot"
echo "=============================="
echo "Timestamp: $(date)"
echo

# 1️⃣ Kernel & i915 driver
echo "== Kernel =="
uname -r
echo
echo "== i915 driver loaded =="
lsmod | grep i915 || echo "i915 not loaded"

# 2️⃣ Recent i915 dmesg messages (last 100 lines)
echo
echo "== Last 100 i915 dmesg messages =="
sudo dmesg | tail -n 100 | grep -i i915 || echo "No recent i915 messages"

# 3️⃣ GPU clocks / power states
echo
echo "== GPU Frequency / Power States =="
if command -v intel_gpu_frequency >/dev/null 2>&1; then
    sudo intel_gpu_frequency
else
    echo "intel_gpu_frequency not installed"
fi

# 4️⃣ intel_gpu_top snapshot (5s)
echo
echo "== intel_gpu_top snapshot (5s, JSON) =="
if command -v intel_gpu_top >/dev/null 2>&1; then
    sudo intel_gpu_top -J -l 5 | head -n 50
else
    echo "intel_gpu_top not installed"
fi

# 5️⃣ Active monitor & VRR status
echo
echo "== Active Display & VRR =="
ACTIVE_MONITOR=$(xrandr | grep ' connected' | awk '{print $1}' | head -n1)
xrandr --verbose | grep -A5 "$ACTIVE_MONITOR" || echo "xrandr info not found"

# 6️⃣ OpenGL / Mesa
echo
echo "== OpenGL / Mesa =="
if command -v glxinfo >/dev/null 2>&1; then
    glxinfo | grep -i "OpenGL"
else
    echo "glxinfo not installed"
fi

# 7️⃣ Vulkan (optional)
echo
echo "== Vulkan =="
if command -v vulkaninfo >/dev/null 2>&1; then
    vulkaninfo | grep "Vulkan Instance Version"
else
    echo "vulkaninfo not installed"
fi

# 8️⃣ Last 50 lines of Xorg log
echo
echo "== Last 50 lines of Xorg log =="
if [ -f /var/log/Xorg.0.log ]; then
    tail -n 50 /var/log/Xorg.0.log
else
    echo "Xorg log not found"
fi

echo
echo "== Snapshot Complete =="
echo "=============================="

