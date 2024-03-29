# geody_shell_scripts

https://labs.geody.com/geody_shell_scripts/

A bunch of useful shell scripts.

- AptUp: a script to update your packages (it uses apt-get, apt, dpkg). It checks for incorrect installations and broken dependencies, shows available updates, and simulates the upgrade.
- Bell: a script to ring the system bell. Once, or as many times as specified in the first argument.
- Conn (showconn.sh , you can alias it as conn ): a script that counts estabilished connections (Total / TCP / UDP / SSH (port 22) / HTTPS (port 443) / HTTP (port 80) / Other), showing the number of current connections in real time, and min / max / average connections since the script started. Optionally it also shows current total / used / free / available memory.
- cs (or cl): a script that changes and lists directory.
- Hello World: a script that says Hello World!
- Log This: a script that appends a line of text to a log file with current date and time and other information specified in the configuration.
- Simple Charts: a script that plots a bar graph from integer numbers passed as arguments or from an array set in the configuration.
- SService: a script to start / stop / restart / get status for multiple services.
- Swap Files (you may alias it as swap ): a script that swaps two files or directories. It moves temporarily the first file into the /tmp/ directory.
- Terminal Lock (TermLock, you can alias it as lock ): a script to lock your terminal. It traps signals and interrupts to block Ctrl+C , Ctrl+\ , Ctrl+Z , Ctrl+D, uses a hashed password and can log failed attempts.

Other shell scripts have their own repositories:
- systatus (sysinfo)
- iptools
- dirmem
- shellmenu

<img src="https://raw.githubusercontent.com/ElfQrin/geody_shell_scripts/main/geody_shell_scripts_logo.png" alt="GeodyLabs Geody Shell Scripts" />
