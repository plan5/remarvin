# remarvin

> **Warning**
> remarvin is currently (2022-12-19) not working properly alongside oxide. This is presumably related to tarnish (the wrapper service for oxide) running xochitl in a chroot that doesn't include the bind mount as intended by remarvin. Investigation on how to fix this started here: https://github.com/plan5/remarvin/issues/6
> To fix this temporarily, copy [this modified xochitl.conf](https://raw.githubusercontent.com/plan5/oxide/master/assets/opt/usr/share/applications/xochitl.oxide) to /opt/usr/share/applications/ overwriting the current file. This needs to be repeated after any update to tarnish/oxide until https://github.com/Eeems-Org/oxide/pull/275 is merged and available on toltec.

## Overview
A (work in progress) multi-account manager for remarkable with an interface to gocryptfs to encrypt and decrypt notebooks on the device (no encryption for the cloud).

remarvin is built with [simple app script](https://rmkit.dev/apps/sas)

### Prerequisites
You may install the following as packages from [toltec](https://github.com/toltec-dev/toltec).
* remarvin uses rmkit `simple` to draw its interface.
* On a reMarkable 2 device, for `simple`, `rm2fb` is needed (this will be the available if you use a launcher).
* For encryption/decryption, `gocryptfs` is needed.

### Setting it up
1. **Create a Backup!** Seriously, things might still go wrong.
Your notebooks will be moved around and might be deleted during setup (although they shouldn't).

2. **Disable cloud synchronization or WiFi!** The user settings currently remain the same across profiles. That means you may lose files if you change your profile and keep synchronizing. If you use only one profile, or disable WiFi there should be no problems. Note that the files on the cloud will not be encrypted.

3. Install `simple` (best way to do this is via toltec).

4. Run remarvin.sh in your preferred way, it's been tested with `oxide` launcher.

5. Remarvin will now show you a list with one entry: `Profile-Main`. Tap on it to mount it. You will see a message in the bottom if it worked. (Restart remarvin to unmount).

6. (Optional): Add another profile via the `Add profile` button. You will be prompted a name for the new profile. Select it and run xochitl to use it. **Again, remember not to use cloud synchronization in this case.**

7. (Optional) Install `gocryptfs` via toltec and set up encryption by selecting a profile in `remarvin` and then selecting `Encrypt`, then follow the onscreen instructions. The perfomance impact of using encryption seems negligible to me for writing. I've experienced some crashes when drawing, so fast and complex penstrokes might be an issue with the writing delay due to encryption. 

### Status / Ideas
1. remarvin can be started by a launcher ~~or at boot instead of/before xochitl/launchers~~
    * I haven't found a way to launch gocryptfs from a .service file yet, where it doesn't die at some point.
3. Accounts are managed as bind mounts or gocryptfs mounts. e.g. /home/root/.local/Profile-Main is mounted to /home/root/.local/share
    * This currently doesn't include ~/.config/remarkable/xochitl.conf so there are no separate user settings including cloud sync, which may cause problems!
4. To change the user, the script needs to be rerun (or the device needs a reboot, if launched before).
5. Available functions in the GUI:
    * Create new account
    * Select account
    * Decrypt (if selected account is encrypted)
    * Danger Zone (partially possible with included shell scripts)
    * Encrypt an account
    * Permanently decrypt account
    * Scroll account list (if there are too many accounts)
6. Future functions in the GUI:
    * Select launcher (if remarvin is run before launchers).
    * Start selected launcher
    * Delete an account

