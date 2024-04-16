# remarvin

> [!Warning]
> Development of reMarvin is currently stalled. I have updated xochitl beyond 3.8 and therefor lost the possibility to use rm2fb.
> The script itself should work, though. Be careful with it and you're welcome to report any issues or provide fixes as PRs.
> See also https://github.com/plan5/remarvin/issues/8

> [!Caution]
> **Passwords end up in the system logs**
> Be aware that reMarvin uses rmkit simple apps for its interface, which logs all keypresses.
> As I recall, the log used to reside in volatile storage but it seems to be located in the root directory.
> This means that anyone equipped with a pogo-pin adapter and a usb-c breakout board (or with ssh access) can read out your password.
> To make sure nobody can read the password, use gocryptfs directly until https://github.com/plan5/remarvin/issues/8 has been closed.
> I have not tried this but you may be able to create a symlink for the logfile to go into tmpfs by entering

``rm /home/root/log.txt*; ln -s /home/root/log.txt /tmp/log.txt``


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

