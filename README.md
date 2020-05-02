# Abyss

The main purpose of the project is to install a fresh Void Linux system with
Full Disk Encryption. It will not install anything you don't need (see below)
and will leave the system almost like if you would install it by yourself when
following official installation instructions.

To keep it simple, the following choises were made:

- Only UEFI systems are supported (yet?).
- Only `glibc` is supported (yet?).
- An entire disk is required for the installation.
- Only Btrfs on LUKS is supported.
- Only GRUB bootloader is supported.

After installation you'll end up with a system which you can log in into but 
there's nothing which can start a graphical session. The only optional package
that will be installed is `fish-shell` which is a runtime dependency and can be
removed right away.

## Bugs

Right now GRUB is always targetings `x86_64-efi` systems which prevents
installation on non x86-64 machines. This is a bug and will be fixed soonj.

## Usage

- Boot from USB drive and install runtime dependencies.
- Clone the repository.
  - Alternatively, download latest sources from [here](https://github.com/rabbitinspace/abyss/archive/master.zip).
- Ajust configuration in the [`config.fish`](config.fish).
  - Be sure to change `SUPER_STRONG_PASSWORD` to an actual strong LUSK/user password.
  - If you don't have SSD, then remove `ssd` from `MOUNT_OPTS` and disable `EXT_TRIM`.
- Run `./main.fish` after `cd`'ing into the project root.

### Extended Setup

You can also choose to do an extended installation which includes few additional
steps:

- Installs and enables a Cron daemon (`cronie`).
- Installs and enables a NTP daemon (`openntpd`).
- Installs and enables a syslog daemon (`socklog`).
- Enables `iptables` (with shipped rules).
- Enables `dhcpcd`.
- Enables some `sysctl` rules for kernel and networking stack hardening.
- Enables TRIM job for SSD.

Each of the steps are optional and can be disabled/enabled in [`config.fish`](config.fish).

### Runtime Dependencies

Before installing the system, install these packages:

- `fish-shell` - shell to run the script.
- `gptfdisk` - GPT-compatible partition utility.

## After Installation

You should be able to boot into the system and log in with the user which you
specified in the configuration file. Now it's time to setup Xorg or Wayland.

For a quick Xorg installation and configuration you can borrow [bootstrap](https://github.com/rabbitinspace/dotfiles/blob/master/bootstrap)
script from my [dotfiles](https://github.com/rabbitinspace/dotfiles).

## Alternatives

Abyss was inspired by a great [`voidvault`](https://github.com/atweiden/voidvault)
project and provides a subset of it's functionality. Check it out if Abyss 
doesn't meet your requirements. 
