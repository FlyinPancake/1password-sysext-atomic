---
title: About
---

## systemd system extension (`systemd-sysext`) for [Fedora Atomic](https://fedoraproject.org/atomic-desktops/)

> **Notice:** This is a work in progress. See [open issues](https://github.com/flyinpancake/1password-sysext-atomic/issues). 
> In particular <https://github.com/sebble/1password-sysext-steam-deck/issues/11> (Firefox integration not great any more)

This repository contains instructions to build a system extension for use on Fedora's Atomic variants.
A systemd system extension allows you to install software without modifying the read-only file system on `/usr`.

Last tested with:

- SteamOS Holo 3.4.6 (20230313.1)
- 1Password for Linux 8.10.3 (81003012)
- Mozilla Firefox Flatpak 111.0
- 1Password CLI 2.16.1

**Features**

-   Desktop GUI application appears with icons
-   System tray with _Quick Access_ popup
-   ~~1Password links from Firefox open in desktop GUI, including registering accounts~~ https://github.com/sebble/1password-sysext-steam-deck/issues/11
-   **SSH Agent can be used from Terminal, including commit signing**
-   **System authentication prompt**
-   **1Password CLI works**

**Note:** Ensure a full system restart after any updates, this resolves most errors with op CLI in my limited experience.

### Instructions

**Quick start**

You must run this from a normal SteamOS Terminal within this repo, not within, e.g., VS Code Flatpak.

```shell
./scripts/10_download.sh
./scripts/20_build.sh
./scripts/30_install.sh
```

Or read through the source-code which has been written with in-line documentation. [On GitHub (source)](https://github.com/sebble/1password-sysext-steam-deck). [On GitHub Pages (rendered)](https://sebble.github.io/1password-sysext-steam-deck/download)

> TODO: Work out how to either use make on the Terminal, or set root file ownership within Flatpaks.

**Setting up SSH Agent**

Add the following to your `~/.bashrc` (or `~/.zshrc`) if you want all SSH Agent connections to use 1Password.

```shell
export SSH_AUTH_SOCK=~/.1password/agent.sock
```

For fish shell use 

### F.A.Q.

**Why not use the official Arch installation instructions?**

See <https://support.1password.com/install-linux/#arch-linux>.

This will fail at `makepkg`, installing the missing dependency will then fail at `fakeroot`.

**Why not use the official Flatpak?**

See <https://support.1password.com/install-linux/#flatpak>.

-   You’ll need to lock and unlock 1Password in your browser separately from the app.
-   You won’t be able to unlock 1Password or 1Password CLI with system authentication.
-   You won’t be able to use the SSH agent.

**Why not follow the instructions for other distributions?**

See <https://support.1password.com/install-linux/#other-distributions-or-arm-targz>.

The installation script `sudo /opt/1Password/after-install.sh` will fail when trying to update _Polkit_ as the `/usr` partition is read-only (even as sudo).

You could use `sudo steamos-readonly disable` but I have chosen not to. See the next question.

**Why not enable Steam Deck developer mode and/or make the `/usr` partition writable?**

See <https://help.steampowered.com/en/faqs/view/671A-4453-E8D2-323C>.

I don't want to. System updates will probably revert any changes you have made in here.

**What are the downsides of this approach?**

Firstly, I made this with very little initial knowledge of `systemd-sysext`, _Arch_, and a few other things. This is for personal use.

Secondly, see <https://blogs.igalia.com/berto/2022/09/13/adding-software-to-the-steam-deck-with-systemd-sysext/> (section "Limitations and caveats") for some very good reasons to be wary of using `systemd-sysext`.

<details>
<summary>Copy of the above blog in case it is not available. [2023-01-14]</summary>

> Using extensions is easy (you put them in the directory and voilà!). However, creating extensions is not necessarily always easy. To begin with, any libraries, files, etc., that your extensions may need should be either present in the root filesystem or provided by the extension itself. You may need to combine files from different sources or packages into a single extension, or compile them yourself.
>
> In particular, if the extension contains binaries they should probably come from the Steam Deck repository or they should be built to work with those packages. If you need to build your own binaries then having a SteamOS virtual machine can be handy. There you can install all development files and also test that everything works as expected. One could also create a Steam Deck SDK extension with all the necessary files to develop directly on the Deck 🙂
>
> Extensions are not distribution packages, they don’t have dependency information and therefore they should be self-contained. They also lack triggers and other features available in packages. For desktop applications I still recommend using a system like Flatpak when possible.
>
> Extensions are tied to a particular version of the OS and, as explained above, the ID and VERSION_ID of each extension must match the values from /etc/os-release. If the fields don’t match then the extension will be ignored. This is to be expected because there’s no guarantee that a particular extension is going to work with a different version of the OS. This can happen after a system update. In the best case one simply needs to update the extension’s VERSION_ID, but in some cases it might be necessary to create the extension again with different/updated files.
>
> Extensions only install files in /usr and /opt. Any other file in the image will be ignored. This can be a problem if a particular piece of software needs files in other directories.
>
> When extensions are enabled the /usr and /opt directories become read-only because they are now part of an overlayfs. They will remain read-only even if you run steamos-readonly disable !!. If you really want to make the rootfs read-write you need to disable the extensions (systemd-sysext unmerge) first.
>
> Unlike Flatpak or Podman (including toolbox / distrobox), this is (by design) not meant to isolate the contents of the extension from the rest of the system, so you should be careful with what you’re installing. On the other hand, this lack of isolation makes systemd-sysext better suited to some use cases than those container-based systems.

</details>

**Could this be achieved with more permissive Flatpak policies?**

I don't know. I assume not, but when reading about Visual Studio Code Flatpak issues perhaps there are other approaches..? Please share if you have ideas. P.S. I do not know Flatpak either so I would not be able to implement this.

**My `os-release` is `22.08`**

If you run the build script within a VS Code Flatpak you will not get the correct values for `os-release` and other system properties.

Use a system Terminal session.

**Where is the documentation?**

I have added comments inline with the main scripts, these are converted to markdown (as long as I remembered to type `make docs` before committing). See <https://sebble.github.io/1password-sysext-steam-deck/>.

**I cannot use Make**

See "_My `os-release` is `22.08`_", but this time `make` is not installed on SteamOS in general, only _inside_ the VS Code Flatpak. Ignore the Makefile, use the `scripts/*.sh` directly. There's nothing special in the `Makefile` and install won't work, some file ownership also won't work.

**Why do the scripts look funny?**

If you mean the `# '''shell` lines, that's because every script is also valid markdown if you remove all `^# `. See "Where is the documentation?".

### To-do

-   Verify signatures of downloaded files
-   Install icons
-   Install CLI shell completion
-   Fix integration between CLI and desktop
-   Document SSH Agent usage better
-   Make CLI optional
-   Verify more functionality
-   Better dev notes
-   Make a blog post?
-   Work out commit signing

### References

-   [Steam Deck system extension](https://blogs.igalia.com/berto/2022/09/13/adding-software-to-the-steam-deck-with-systemd-sysext/)
-   [CLI connection to Desktop app](https://1password.community/discussion/128029/can-not-connect-to-desktop-app)
-   [Reddit Discussion](https://www.reddit.com/r/1Password/comments/vz5pqb/possible_to_install_on_steam_deck/)
