# remarvin
A (work in progress) multi-account manager for remarkable

This Readme helps drafting remarvin for now. Once it is in a working state, the contents will be moved to a new file or they will be removed.

## Basic idea
1. remarvin starts at boot instead of/before xochitl/launchers
2. Accounts are managed as bind mounts or gocryptfs mounts. e.g. /home/root/.local-user1 is mounted to /home/root/.local
  * Not necessarily /home/root/.local What is the best directory level to do this? Using /home/root could interfere with toltec files.
3. To change the user, the device needs to reboot.
4. Available functions in the GUI:
  * Create new account
  * Select account
  * Select launcher
  * Decrypt (if selected account is encrypted)
  * Danger Zone
    * Delete an account
    * Encrypt an account
    * Permanently decrypt account
