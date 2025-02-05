#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi


display_cpu_usage() {
  echo "\n=== CPU Usage ==="
  top -bn1 | grep "Cpu(s)" | \
    awk '{print "Total CPU Usage: " 100 - $8 "% used"}'
}


display_memory_usage() {
  echo "\n=== Memory Usage ==="
  free -m | awk 'NR==2{printf "Used: %s MB, Free: %s MB, Usage: %.2f%%\n", $3, $4, $3*100/$2 }'
}


display_disk_usage() {
  echo "\n=== Disk Usage ==="
  df -h --total | awk 'END{printf "Used: %s, Free: %s, Usage: %s\n", $3, $4, $5}'
}


display_top_cpu_processes() {
  echo "\n=== Top 5 Processes by CPU Usage ==="
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}


display_top_memory_processes() {
  echo "\n=== Top 5 Processes by Memory Usage ==="
  ps -eo pid,comm,%mem --sort=-%mem | head -n 6
}


display_optional_stats() {
  echo "\n=== Optional Stats ==="
  echo "Operating System: $(lsb_release -d | cut -f2)"
  echo "Uptime: $(uptime -p)"
  echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
  echo "Logged In Users: $(who | wc -l)"
  echo "Failed Login Attempts: $(grep -c 'Failed password' /var/log/auth.log 2>/dev/null || echo "Log not available")"
}


clear
echo "Server Performance Statistics"
echo "=============================="

display_cpu_usage
display_memory_usage
display_disk_usage
display_top_cpu_processes
display_top_memory_processes


display_optional_stats

