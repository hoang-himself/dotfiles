# Random notes

## Bulk reset author in git

```shell
git -c rebase.instructionFormat='%s%nexec GIT_AUTHOR_DATE="%aD" GIT_COMMITTER_DATE="%cD" git commit --amend --no-edit --reset-author' rebase
```

See:

- [Commit Information](https://git-scm.com/docs/git-commit#_commit_information)
- [Placeholders that expand to information extracted from the commit](https://git-scm.com/docs/git-log#Documentation/git-log.txt-emHem)

## PN532 read/write via I2C

### Prepare the Pi

- Install `i2c-tools` and `libnfc-examples` or equivalent
- Enable `dtparam=i2c_arm=on` in `/boot/efi/config.txt` and reboot

### Wire up I2C

- VCC <=> GPIO1
- GND <=> GPIO9
- SDA <=> GPIO2
- SCL <=> GPIO3

### Assert I2C connectivity

- `i2cdetect -y 1`

### Define PN532 device in libnfc

```text
# /etc/nfc/devices.d/pn532_i2c.conf
name = "PN532 Over I2C"
connstring = "pn532_i2c:/dev/i2c-1"
```

### Find your device

- `nfc-scan-device -v`
- `nfc-list -v`

### Clone Mifare Classic

- `nfc-mfclassic r a u card.mfd`
- `nfc-mfclassic W a u card.mfd`
