# remarvin
## Work in progress
A (work in progress) multi-account manager for remarkable

This Readme helps drafting remarvin for now. Once it is in a working state, the contents will be moved to a new file or they will be removed.

remarvin is being built with [simple app script](https://rmkit.dev/apps/sas)

**Instructions below.**

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
      * *Optional:* Encrypt an account
      * *Optional:* Permanently decrypt account
6. Future functions in the GUI:
    * Select launcher (if run before launchers).
    * Start selected launcher
    * Delete an account
    * Scroll account list (currently it may overflow if too many accounts exist)

### Prerequisites
You may install the following as packages from [toltec](https://github.com/toltec-dev/toltec).
* reMarvin uses rmkit `simple` to draw its interface.
* For `simple`, `rm2fb` is needed (this will be the available if you use a launcher).
* For decryption, `gocryptfs` is needed.

### Setting it up
1. **Create a Backup!** Seriously, things might still go wrong.
Your notebooks will be moved around and might be deleted during setup (although they shouldn't).

2. **Disable cloud synchronization!** The user settings currently remain the same across profiles. That means you may lose files if you change your profile and keep synchronizing. Alternatively, you can take care not to activate Wi-Fi.

3. On your device: Run `remarvin.sh` (requires `rm2fb`). In a standard environment, it will offer to set up your environment. This makes sure that xochitl can't write any notebooks to the empty profile when no profile is loaded (using `chattr +i`).

4. Remarvin will now show you a list with one entry: `Profile-Main`. Tap on it to mount it. You will see a message in the bottom if it worked. (Restart reMarvin to unmount).

5. (Optional): Add another profile via the `Add profile` button. You will be prompted a name for the new profile. Select it and run xochitl to use it. **Again, remember not to use cloud synchronization in this case.**

6. (Optional) Install gocryptfs via toltec and set up encryption by running the following inside /home/root/.local/Profile-Main. You will be asked to choose/enter a password. Depending on the size of your notebook collection, this may take a while. Make sure the rM is charged. Afterwards, reMarvin will recognize the encrypted profile and offer to decrypt it.
```
mv remarkable remarkable-temp
mkdir remarkable remarkable-cipher
chattr +i remarkable
gocryptfs -init remarkable-cipher
gocryptfs remarkable-cipher remarkable
mv remarkable-tmp/* remarkable
fusermount -u remarkable
```

