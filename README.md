# Configs / settings / preferences

## iTerm2 color scheme

- [Preferences](iterm2)
- [Visual Studio Code terminal color scheme](https://github.com/tallpants/vscode-theme-iterm2)

## zsh autosuggestions like fish

- [Autosuggestions](https://unix.stackexchange.com/a/418365)
- [Faster copy & paste](https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-557642542)

## Viscosity kill switch

```sh
sudo mkdir /Library/Application\ Support/ViscosityScripts
sudo cp disablenetwork.py /Library/Application\ Support/ViscosityScripts/
```

Add the following line under *Advanced* for the *Extra OpenVPN configuration cmmands*:

```
route-pre-down "/Library/Application\\ Support/ViscosityScripts/disablenetwork.py"
```

Run the following once before connecting:

```sh
/Applications/Viscosity.app/Contents/MacOS/Viscosity -setSecureGlobalSetting YES -setting AllowOpenVPNScripts -value YES
```
