FROM alpine:3.16.1
RUN apk -U add qemu-system-aarch64
RUN mkdir /root/output/images
COPY Image /root/output/images
COPY rootfs.ext4 /root/output/images

CMD qemu-system-aarch64 \
  -M virt \
  -append "rootwait root=/dev/vda console=ttyAMA0" \
  -cpu cortex-a53 \
  -device virtio-blk-device,drive=hd0 \
  -device virtio-net-device,netdev=eth0 \
  -drive file=/root/output/images/rootfs.ext4,if=none,format=raw,id=hd0 \
  -kernel /root/output/images/Image \
  -netdev user,id=eth0 \
  -nographic \
  -smp 1 \
  -drive file=fat:/mount,index=0,media=disk,readonly=on
