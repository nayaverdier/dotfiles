# dotfiles

See [ARCH.md](ARCH.md) for a barebones system installation

On a clean arch installation, as root (or with sudo) run the following (instater
will prompt for the user password)

```bash
pacman -Sy git

# assuming no users are created and yay is not installed
cd /tmp
git clone https://aur.archlinux.org/instater.git
chown -R nobody instater
cd instater
pacman -Sy python-jinja python-passlib python-rich python-yaml
pacman -Sy python-build python-install python-setuptools python-wheel
sudo -u nobody makepkg
pacman -U instater-0.10.0-1-any.pkg.tar.zst

# if yay is installed
yay -Sy instater


git clone https://github.com/nayaverdier/dotfiles.git
cd dotfiles
instater --vars "install_model=dell-xps-7590"
```

The `install_model` variable defaults to `virtualbox`

After instater is run for the first time, it creates a
`setup-dell-xps-7590` (or similar) script within `/usr/local/bin` that can be
invoked directly (with sudo) rather than calling instater.

For example:

```bash
sudo setup-dell-xps-7590

sudo setup-dell-xps-7590 --dry-run # dry run and show the expected changes
sudo setup-dell-xps-7590 --tags zsh # only run tasks with a particular tag
```
