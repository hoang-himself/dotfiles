# Installing Fedora IoT on RPi4

## Flash the image

The following command will wipe and write Fedora IoT with a nologin root account:

```shell
arm-image-installer \
  --image Fedora-IoT.aarch64.raw.xz --target rpi4 \
  --media /dev/mmcblk0 --resizefs \
  --addkey .ssh/id_ed25519.pub --norootpass
```

where:

- `image` is the path to the raw image
- `media` is the path to the storage device, can be obtained with `lsblk`
- `addkey` is the path to an SSH public key

## Post-installation configurations

The device can only be logged in via SSH using the configured key

### Disable unneeded services

```shell
for service in zezere_ignition.timer zezere_ignition zezere_ignition_banner; do
  systemctl stop $service
  systemctl disable $service
  systemctl mask $service
done
```

### Users and groups

```shell
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers.d/wheel-nopasswd
groupadd -g 1000 user

# Initially the user has no password to be logged in with
useradd -g user -G wheel -m -u 1000 user
passwd user

# Copy the pre-configured SSH key
mkdir -p /var/home/user/.ssh
cp /root/.ssh/authorized_keys /var/home/user/.ssh/authorized_keys
chmod 700 /var/home/user/.ssh
chmod 600 /var/home/user/.ssh/authorized_keys
chown -R user:user /var/home/user
```

### Connect to wifi

First, see available wifi networks

```shell
nmcli device wifi list
```

You can also force a re-scan before viewing available networks

```shell
nmcli device wifi rescan
```

Then connect to this network

```shell
nmcli device wifi connect <SSID> password <PASSWORD>
```

You can check if the wifi connection is active

```shell
nmcli connection show --active
```

### Set static IP address, hostname and enable mDNS

```shell
rpm-ostree install avahi nss-mdns
hostnamectl hostname raspberrypi.local

nmcli connection add type ethernet ifname <INTERFACE> con-name <NAME> ip4 <ADDRESS> gw4 <GATEWAY> -- +ipv4.dns <DNS> +connection.mdns 2
nmcli connection up <NAME>

rpm-ostree install -y avahi nss-mdns
firewall-cmd --permanent --add-service mdns
firewall-cmd --reload
```

where:

- `<INTERFACE>` can be obtained with `nmcli device`
- Relevant IPv6 configurations can be added by replacing `4` with `6`

### Change SSHD port

First, enable the new port in SELinux and the firewall

```shell
semanage port -a -t ssh_port_t -p tcp 69420

firewall-cmd --permanent --service ssh --add-port 69420/tcp
#firewall-cmd --permanent --add-port 69420/tcp
#firewall-cmd --runtime-to-permanent
firewall-cmd --reload
```

Then, change revelant `sshd` configs in `/etc/ssh`, then restart `sshd` service

### Set timezone

Since this is a server image, it is recommended to set the timezone to UTC

If your applications require a different time zone, in most cases, it is possible to set a different time zone than the system one for individual applications by setting the `TZ` environment variable

```shell
timedatectl set-timezone UTC
timedatectl set-local-rtc no
```
