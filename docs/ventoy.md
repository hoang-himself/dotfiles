# Ventoy

## Testing with a Windows NT 10.0 virtual machine

This section is documented accordingly to Hyper-V, but may apply to other hypervisors as well

### Preparing a Ventoy virtual hard disk

First, prepare a virtual hard disk for Ventoy

1. Use Hyper-V Manager or Disk Management to create a virtual hard disk
2. Mount this disk
3. Open Disk Management, find the disk, right click and choose `Initialize Disk`

Then, install Ventoy on this virtual hard disk

1. Open Ventoy
2. In `Option`, enable `Show All Devices`
3. Select `Msft Virtual Disk` and other options to your liking
4. Click `Install`

To apply this repo and make the Ventoy virtual hard disk bootable

1. This repo assumes the installation of Windows NT 10.0, so download the latest [VHD boot template](https://github.com/ventoy/vhdiso) and copy `/ventoy_vhdboot/Win10Based/ventoy_vhdboot.img` into `/ventoy/`
2. Build the `tela` theme, or edit `ventoy.json` to not use it at all
3. This repo installs 7-Zip and Office as part of the Windows bootstrap process, so you need to update the `bootstrap` folder accordingly

### Installing a Windows NT 10.0 OS in Hyper-V

This section assumes a virtual machine with its own hard disk has already been created

Then, in the `Settings` of this virtual machine

1. Add the Ventoy virtual hard drive into a `SCSI Controller`
2. In `Firmware`, set Boot Order to the hard drive of the virtual machine, then the Ventoy drive, then `Network Adapter`
3. In `Security`, set Secure Boot template to `Microsoft UEFI Certificate Authority`

You will need to enroll Ventoy's key or hash on first boot, then the installation works normally

After the installation succeeds, change the Secure Boot template to `Microsoft Windows`, and optionally enable `TPM`
