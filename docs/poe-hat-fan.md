# Configuring POE HAT fan speed

> [https://github.com/raspberrypi/firmware/tree/master/boot/overlays](https://github.com/raspberrypi/firmware/tree/master/boot/overlays)

```text
dtoverlay=rpi-poe-plus
dtparam=poe_fan_temp0=48000
dtparam=poe_fan_temp0_hyst=6000
dtparam=poe_fan_temp1=60000
dtparam=poe_fan_temp1_hyst=6000
dtparam=poe_fan_temp2=72000
dtparam=poe_fan_temp2_hyst=6000
dtparam=poe_fan_temp3=84000
dtparam=poe_fan_temp3_hyst=6000
```
