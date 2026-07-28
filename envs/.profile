# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -z "$XDG_CONFIG_HOME" ]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -f "$XDG_CONFIG_HOME/theme.env" ]; then
    . "$XDG_CONFIG_HOME/theme.env"
fi

# UI fonts (GNOME/GTK settings used by some apps beyond settings.ini)
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface font-name 'VictorMono Nerd Font 10' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface document-font-name 'VictorMono Nerd Font 10' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface monospace-font-name 'VictorMono Nerd Font 10' 2>/dev/null || true
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

