---
title: Install 
---
<!-- hide the `ex` bits, they're only useful in this script
  set -ex
-->

Try `just install`.

## Configure 1Password desktop

No additional runtime configuration is currently required for the Desktop application.
This may change while addressing the outstanding feature requests and bugs.

## Configure 1Password CLI

The following is modified from `1password-cli.install` in <https://aur.archlinux.org/packages/1password-cli>.
Alternatively, the instructions for official, manual installation also suggest these commands.

## Fedora Atomic group creation
Fedora Atomic has some bugs with `groupadd` due to some `ostree` limitations. <

  fedora_atomic_groupadd() {
      grep -E "^$1:" /usr/lib/group | sudo tee -a /etc/group
  }

We are:
-   Creating the `onepassword-cli` group if it does not exist
-   Ensuring that the `op` CLI binary is owned by the `onepassword-cli` group
-   Enabling `setgid` bit on the binary, to ensure that it runs under the `onepassword-cli` group (this is important for biometrics)



```shell
  getent group onepassword-cli || fedora_atomic_groupadd onepassword-cli
```

## Configure and enable systemd-sysext

```shell
  sudo mv build/extensions/1password.raw /var/lib/extensions/1password.raw
  sudo systemctl enable systemd-sysext
  sudo systemctl start systemd-sysext
  sudo systemd-sysext refresh
  systemd-sysext status
```

## Debugging:

    systemd-sysext status
    sudo systemd-sysext merge
    sudo systemd-sysext refresh
