# Orange 主题 - 炫酷启动问候语 (Neofetch 风格)
# 双栏布局：左侧 Ubuntu ASCII Art，右侧系统信息

function __orange_get_os_info -d "获取操作系统信息"
    if test -f /etc/os-release
        set -l name (head -1 /etc/os-release | string replace "PRETTY_NAME=" "" | string trim -c '"')
        if test -n "$name"
            echo $name
        else
            set -l name_line (grep "^NAME=" /etc/os-release | string replace "NAME=" "" | string trim -c '"')
            set -l ver_line (grep "^VERSION_ID=" /etc/os-release | string replace "VERSION_ID=" "" | string trim -c '"')
            echo "$name_line $ver_line"
        end
    else
        uname -s -r
    end
end

function __orange_get_kernel -d "获取内核版本"
    uname -r
end

function __orange_get_packages -d "获取已安装软件包数量"
    if type -q dpkg
        dpkg -l 2>/dev/null | wc -l | string trim
    else if type -q pacman
        pacman -Q 2>/dev/null | wc -l | string trim
    else if type -q brew
        brew list 2>/dev/null | wc -l | string trim
    else
        echo "N/A"
    end
end

function __orange_get_resolution -d "获取屏幕分辨率"
    if type -q xdpyinfo
        xdpyinfo 2>/dev/null | grep dimensions | awk '{print $2}'
    else
        echo "N/A"
    end
end

function __orange_get_de -d "获取桌面环境"
    if test -n "$XDG_CURRENT_DESKTOP"
        echo $XDG_CURRENT_DESKTOP
    else if test -n "$DESKTOP_SESSION"
        echo $DESKTOP_SESSION
    else
        echo "N/A"
    end
end

function __orange_get_theme -d "获取 GTK 主题"
    if test -n "$GTK_THEME"
        echo $GTK_THEME
    else
        echo "N/A"
    end
end

function __orange_get_cpu -d "获取 CPU 信息"
    if test -f /proc/cpuinfo
        grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | string trim
    else
        echo "N/A"
    end
end

function __orange_get_memory -d "获取内存信息"
    if test -f /proc/meminfo
        set -l mem_total (grep "MemTotal:" /proc/meminfo | awk '{print $2}')
        set -l mem_available (grep "MemAvailable:" /proc/meminfo 2>/dev/null | awk '{print $2}')
        if test -z "$mem_available"
            set mem_available (grep "MemFree:" /proc/meminfo | awk '{print $2}')
        end
        
        if test -n "$mem_total" -a "$mem_total" -gt 0
            set -l used (math "$mem_total - $mem_available")
            set -l used_mb (math "$used / 1024")
            set -l total_mb (math "$mem_total / 1024")
            echo "$used_mb"MiB "/" "$total_mb"MiB
        else
            echo "N/A"
        end
    else
        echo "N/A"
    end
end

function __orange_get_disk -d "获取磁盘使用情况"
    df -h / 2>/dev/null | tail -1 | awk '{print $3 " / " $2 " (" $5 ")"}'
end

function __orange_get_local_ip -d "获取本地 IP"
    ip addr show 2>/dev/null | grep "inet " | grep -v "127.0.0.1" | head -1 | awk '{print $2}' | cut -d'/' -f1
    or hostname -I 2>/dev/null | awk '{print $1}'
    or echo "N/A"
end

function fish_greeting -d "显示炫酷的 Orange 主题启动界面"
    # 获取所有系统信息
    set -l user (whoami)
    set -l host_name (hostname -s 2>/dev/null; or hostname)
    set -l os_info (__orange_get_os_info)
    set -l kernel (__orange_get_kernel)
    set -l uptime_info (uptime -p 2>/dev/null | string replace "up " "" | string replace " days" "d" | string replace " day" "d" | string replace " hours" "h" | string replace " hour" "h" | string replace " minutes" "m" | string replace " minute" "m" | string replace ", " " "; or echo "N/A")
    set -l packages (__orange_get_packages)
    set -l resolution (__orange_get_resolution)
    set -l de (__orange_get_de)
    set -l theme (__orange_get_theme)
    set -l cpu (__orange_get_cpu)
    set -l memory (__orange_get_memory)
    set -l disk (__orange_get_disk)
    set -l local_ip (__orange_get_local_ip)
    set -l shell_ver $FISH_VERSION
    set -l date_str (date "+%Y-%m-%d")
    set -l time_str (date "+%H:%M:%S")
    
    # 颜色定义
    set -l orange FF9F43
    set -l orange_bold FF6B35
    set -l ubuntu_red E95420
    set -l ubuntu_orange E95420
    set -l ubuntu_yellow F4AA00
    set -l blue 3498DB
    set -l green 2ECC71
    set -l cyan 1ABC9C
    set -l yellow F1C40F
    set -l gray 95A5A6
    set -l white FFFFFF
    
    echo ""
    
    # ═══════════════════════════════════════════════════════════
    # 经典 Ubuntu ASCII Art + 系统信息 (Neofetch 风格)
    # ═══════════════════════════════════════════════════════════
    
    # 第1行
    set_color $ubuntu_red
    echo -n "            .-/+oossssoo+/-.               "
    set_color $white
    echo "$user"@"$host_name"
    
    # 第2行
    set_color $ubuntu_red
    echo -n "        `:+ssssssssssssssssss+:`           "
    set_color $white
    echo -n "OS: "
    set_color $white
    echo $os_info
    
    # 第3行
    set_color $ubuntu_red
    echo -n "      -+ssssssssssssssssssyyssss+-         "
    set_color $white
    echo -n "Kernel: "
    set_color $white
    echo $kernel
    
    # 第4行
    set_color $ubuntu_yellow
    echo -n "    .ossssssssssssssssssdMMMNysssso.       "
    set_color $white
    echo -n "Uptime: "
    set_color $green
    echo $uptime_info
    
    # 第5行
    set_color $ubuntu_yellow
    echo -n "   /ssssssssssshdmmNNmmyNMMMMhssssss/      "
    set_color $white
    echo -n "Packages: "
    set_color $white
    echo $packages
    
    # 第6行
    set_color $ubuntu_yellow
    echo -n "  +sssssssssshmydMMMMMMMNddddyssssssss+    "
    set_color $white
    echo -n "Shell: "
    set_color $white
    echo "fish $shell_ver"
    
    # 第7行
    set_color $ubuntu_yellow
    echo -n " /sssssssshNMMMyhhyyyyhmNMMMNhssssssss/    "
    set_color $white
    echo -n "Resolution: "
    set_color $white
    echo $resolution
    
    # 第8行
    set_color $ubuntu_red
    echo -n ".ssssssssdMMMNhsssssssssshNMMMdssssssss.   "
    set_color $white
    echo -n "DE: "
    set_color $white
    echo $de
    
    # 第9行
    set_color $ubuntu_red
    echo -n "+sssshhhyNMMNyssssssssssssyNMMMysssssss+   "
    set_color $white
    echo -n "Theme: "
    set_color $white
    echo $theme
    
    # 第10行
    set_color $ubuntu_red
    echo -n "ossyNMMMNyMMhssssssssssssshmyhsssssssoss   "
    set_color $white
    echo -n "CPU: "
    set_color $white
    echo $cpu
    
    # 第11行
    set_color $ubuntu_red
    echo -n "ossyNMMMNyMMhssssssssssssshmyhsssssssoss   "
    set_color $white
    echo -n "Memory: "
    set_color $cyan
    echo $memory
    
    # 第12行
    set_color $ubuntu_yellow
    echo -n "+sssshhhyNMMNyssssssssssssyNMMMysssssss+   "
    set_color $white
    echo -n "Disk: "
    set_color $yellow
    echo $disk
    
    # 第13行
    set_color $ubuntu_yellow
    echo -n ".ssssssssdMMMNhsssssssssshNMMMdssssssss.   "
    set_color $white
    echo -n "IP: "
    set_color $green
    echo $local_ip
    
    # 第14行
    set_color $ubuntu_yellow
    echo -n " /sssssssshNMMMyhhyyyyhdNMMMNhssssssss/    "
    set_color $gray
    echo "═══════════════════════════════════════"
    
    # 第15行
    set_color $ubuntu_yellow
    echo -n "  +ssssssssssdmydMMMMMNddddyssssssss+    "
    set_color $orange
    echo -n "  🍊 "
    set_color $white
    echo "Orange Theme Ready!"
    
    # 第16行
    set_color $ubuntu_red
    echo -n "   /ssssssssssshdmNNNNmyNMMMMhssssss/      "
    set_color $gray
    echo "Date: $date_str | Time: $time_str"
    
    # 第17行
    set_color $ubuntu_red
    echo -n "    .ossssssssssssssssssdMMMNysssso.       "
    set_color normal
    echo ""
    
    # 第18行
    set_color $ubuntu_red
    echo -n "      -+sssssssssssssssssyyyssss+-         "
    set_color normal
    echo ""
    
    # 第19行
    set_color $ubuntu_red
    echo -n "        `:+ssssssssssssssssss+:`           "
    set_color normal
    echo ""
    
    # 第20行
    set_color $ubuntu_red
    echo -n "            .-/+oossssoo+/-.               "
    set_color $orange
    echo "  ➜ Welcome back, $user!"
    
    set_color normal
    echo ""
end