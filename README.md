# 🧹 Windows System Maintenance Script

A simple yet powerful PowerShell script that automates common system maintenance tasks on Windows. Perfect for IT Support professionals, sysadmins, or power users looking to streamline routine cleanup and performance-improving operations.

---

## 📝 Features

This script performs the following tasks:

1. **Clear Temporary Files**  
   - Deletes contents of `%TEMP%` and `C:\Windows\Temp` directories.
2. **Flush DNS Cache**  
   - Clears the DNS resolver cache using `ipconfig /flushdns`.
3. **Restart Network Adapter**  
   - Detects and restarts all active network adapters.
4. **Update Installed Software**  
   - Uses [Windows Package Manager (winget)](https://learn.microsoft.com/en-us/windows/package-manager/) to silently upgrade all updatable applications.
5. **Logging**  
   - Logs all output and actions to `maintenance_log.txt` for audit or review.

---

## 🖥️ Requirements

- **Windows 10 / 11**
- **PowerShell 5.0 or later**
- **Administrator privileges**
- **Winget installed**  
  (Pre-installed on most Windows 10/11 builds. To check: run `winget` in PowerShell.)

---

## 🔐 Security Warning (Execution Policy)

- **If you see an error like:**
  - Running scripts is disabled on this system
- **Run the following command (only once, and only if it's your own system):**
  - `Set-ExecutionPolicy RemoteSigned`
- **Then press Y to confirm.**
  
---

## 📌 Example Output

- **When run, the script will produce output like:**
  - 🧹 Starting System Cleanup...
  - Clearing temp files...
  - Flushing DNS cache...
  - Restarting network adapter...
  - Updating installed software using winget...
  - ✅ Cleanup Complete.
- **And all of this will be logged in `maintenance_log.txt`.**  

---

## Screenshoots
<img src="https://imgur.com/9oXkrZx.png" width="50%"/>
