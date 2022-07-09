# remarvin
## Work in progress
A (work in progress) multi-account manager for remarkable

This Readme helps drafting remarvin for now. Once it is in a working state, the contents will be moved to a new file or they will be removed.

remarvin is being built with [simple app script](https://rmkit.dev/apps/sas)

**Instructions below.**

### Basic idea
1. remarvin starts at boot instead of/before xochitl/launchers
2. Accounts are managed as bind mounts or gocryptfs mounts. e.g. /home/root/.local-user1 is mounted to /home/root/.local
    * Not necessarily /home/root/.local What is the best directory level to do this? Using /home/root could interfere with toltec files.
3. To change the user, the device needs to reboot.
4. Available functions in the GUI:
    * Create new account
    * Select account
    * Select launcher
    * Launch selected launcher
    * Decrypt (if selected account is encrypted)
    * Danger Zone (partially possible with included shell scripts)
      * Delete an account
      * *Optional:* Encrypt an account
      * *Optional:* Permanently decrypt account

### Setting it up
1. **Create a Backup!** Seriously, things might still go wrong.
Your notebooks will be moved around and might be deleted during setup (although they shouldn't).

2. **Disable cloud synchronization!** The user settings currently remain the same across profiles. That means you may lose files if you change your profile and keep synchronizing. Alternatively, you can take care not to activate Wi-Fi.

3. On your device: Run `prepare.sh` to set up your environment. This makes sure that xochitl can't write any notebooks to the empty profile when no profile is loaded. It also adds a warning about being write-only.

4. On your device: Run remarvin.sh (requires rm2fb). You can also add a launcher file to run it from there. You can close remarvin after opening a profile.

5. (Optional) Install gocryptfs via toltec and set up encryption by running the following inside /home/root/.local/Profile-Main. You will be asked to choose/enter a password. Depending on the size of your notebook collection, this may take a while. Make sure the rM is charged. Afterwards, reMarvin will recognize the encrypted profile and offer to decrypt it.
```
mv remarkable remarkable-temp
mkdir remarkable remarkable-cipher
chattr +i remarkable
gocryptfs -init remarkable-cipher
gocryptfs remarkable-cipher remarkable
mv remarkable-tmp/* remarkable
fusermount -u remarkable
```

