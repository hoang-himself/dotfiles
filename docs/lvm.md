# Extending Linux LVM partition size

> Partition -> Physical volume -> Volume group -> Logical volume -> File system

```shell
growpart /dev/sda 3
pvresize /dev/sda3
lvextend -l +100%FREE /dev/fedora/root
xfs_growfs /dev/fedora/root
```
