if [[ "$OSTYPE" == "darwin"* ]]; then
    make -C libopencm3 -j$(sysctl -n hw.logicalcpu)
else
    make -C libopencm3 -j$(nproc)
fi