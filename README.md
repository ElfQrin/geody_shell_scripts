# geody_shell_scripts

https://labs.geody.com/geody_shell_scripts/

A bunch of useful shell scripts.

- Conn (showconn.sh , you can alias it as conn ) is a shell script that counts estabilished connections (Total / TCP / UDP / SSH (port 22) / HTTPS (port 443) / HTTP (port 80) / Other), showing the number of current connections in real time, and min / max / average connections since the script started. Optionally it also shows current total / used / free / available memory.
- Swap Files (you may alias it just as swap ) is a shell script to swap two files or directories. It moves temporarily the first file into the /tmp/ directory.
- Terminal Lock (TermLock) is a shell script to lock your terminal. It traps signals and interrupts to block Ctrl+C , Ctrl+\ , Ctrl+Z , Ctrl+D, uses a hashed password and can log failed attempts.
swapfiles

Other shell scripts have their own repositories:
- systatus (sysinfo)
- iptools
- dirmem
- shellmenu
