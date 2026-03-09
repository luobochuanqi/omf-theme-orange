# Orange 主题 - 炫酷启动问候语
# 双栏布局：左侧 Ubuntu 字符画，右侧系统信息

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

function __orange_get_shell_version -d "获取 Shell 版本"
    echo $FISH_VERSION
end

function __orange_get_load_avg -d "获取系统负载"
    uptime | awk -F'load average:' '{print $2}' | string trim
end

function __orange_get_disk_usage -d "获取磁盘使用情况"
    df -h / 2>/dev/null | tail -1 | awk '{print $5 " (" $3 "/" $2 ")"}'
end

function __orange_get_local_ip -d "获取本地 IP"
    ip addr show 2>/dev/null | grep "inet " | grep -v "127.0.0.1" | head -1 | awk '{print $2}' | cut -d'/' -f1
    or hostname -I 2>/dev/null | awk '{print $1}'
    or echo "N/A"
end

function __orange_get_quote -d "获取随机欢迎语"
    set -l quotes \
        "Stay hungry, stay foolish." \
        "Talk is cheap. Show me the code." \
        "The only way to do great work is to love what you do." \
        "Simplicity is the ultimate sophistication." \
        "Code is like humor. When you have to explain it, it's bad." \
        "First, solve the problem. Then, write the code." \
        "Make it work, make it right, make it fast." \
        "🍊 今天也是充满希望的一天！" \
        "🚀 准备好开始编程了吗？" \
        "✨ 让代码改变世界！"
    
    set -l index (random 1 (count $quotes))
    echo $quotes[$index]
end

function fish_greeting -d "显示炫酷的 Orange 主题启动界面"
    # 获取系统信息
    set -l user (whoami)
    set -l host_name (hostname -s 2>/dev/null; or hostname)
    set -l os_info (__orange_get_os_info)
    set -l shell_ver (__orange_get_shell_version)
    set -l date_str (date "+%Y-%m-%d %a")
    set -l time_str (date "+%H:%M:%S")
    set -l uptime_info (uptime -p 2>/dev/null | string replace "up " "" | string replace " days" "d" | string replace " day" "d" | string replace " hours" "h" | string replace " hour" "h" | string replace " minutes" "m" | string replace " minute" "m" | string replace ", " " "; or echo "N/A")
    set -l load_avg (__orange_get_load_avg)
    set -l disk_usage (__orange_get_disk_usage)
    set -l local_ip (__orange_get_local_ip)
    set -l quote (__orange_get_quote)
    
    # 颜色定义
    set -l orange FF9F43
    set -l orange_bold FF6B35
    set -l purple 9B59B6
    set -l blue 3498DB
    set -l green 2ECC71
    set -l cyan 1ABC9C
    set -l yellow F1C40F
    set -l red E74C3C
    set -l gray 95A5A6
    set -l dark 2C3E50
    set -l white FFFFFF
    
    # 清屏（可选，让界面更整洁）
    # clear
    
    echo ""
    
    # ═══════════════════════════════════════════════════════════
    # 双栏布局：左侧字符画，右侧信息
    # ═══════════════════════════════════════════════════════════
    
    # 第 1 行：顶部装饰线
    set_color $orange
    echo -n "  ╭───────────────────────────────╮  "
    set_color $orange
    echo "╭──────────────────────────────────────────╮"
    set_color normal
    
    # 第 2 行：Ubuntu 字符画顶部 + 系统标题
    set_color $orange
    echo -n "  │  ⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣤⣄        │  "
    set_color $orange_bold
    echo -n "│  🍊 "
    set_color $white
    set_color -b $orange
    echo -n "  O R A N G E   T H E M E  "
    set_color normal
    set_color $orange
    echo "  │"
    set_color normal
    
    # 第 3 行：字符画 + 分隔线
    set_color $orange
    echo -n "  │  ⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧       │  "
    set_color $orange
    echo "├──────────────────────────────────────────┤"
    set_color normal
    
    # 第 4 行：字符画 + 用户信息
    set_color $orange
    echo -n "  │  ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿       │  "
    set_color $orange
    echo -n "│  👤 "
    set_color $white
    echo -n "User: "
    set_color $cyan
    printf "%-34s" "$user@$host_name"
    set_color $orange
    echo "│"
    set_color normal
    
    # 第 5 行：字符画 + 日期时间
    set_color $orange
    echo -n "  │  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇      │  "
    set_color $orange
    echo -n "│  📅 "
    set_color $white
    echo -n "Date: "
    set_color $yellow
    printf "%-34s" "$date_str"
    set_color $orange
    echo "│"
    set_color normal
    
    # 第 6 行：字符画 + 时间
    set_color $orange
    echo -n "  │  ⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃      │  "
    set_color $orange
    echo -n "│  🕐 "
    set_color $white
    echo -n "Time: "
    set_color $green
    printf "%-34s" "$time_str"
    set_color $orange
    echo "│"
    set_color normal
    
    # 第 7 行：字符画 + 操作系统
    set_color $orange
    echo -n "  │  ⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏       │  "
    set_color $orange
    echo -n "│  🐧 "
    set_color $white
    echo -n "OS:   "
    set_color $blue
    printf "%-34s" "$os_info"
    set_color $orange
    echo "│"
    set_color normal
    
    # 第 8 行：字符画 + Shell 版本
    set_color $orange
    echo -n "  │   ⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟        │  "
    set_color $orange
    echo -n "│  🐟 "
    set_color $white
    echo -n "Fish: "
    set_color $purple
    printf "%-34s" "v$shell_ver"
    set_color $orange
    echo "│"
    set_color normal
    
    # 第 9 行：字符画 + 分隔线
    set_color $orange
    echo -n "  │    ⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋         │  "
    set_color $orange
    echo "├──────────────────────────────────────────┤"
    set_color normal
    
    # 第 10 行：字符画 + 系统负载
    set_color $orange
    echo -n "  │      ⠈⠛⠿⣿⣿⣿⣿⣿⠿⠛⠁           │  "
    set_color $orange
    echo -n "│  ⚡ "
    set_color $white
    echo -n "Load: "
    set_color (test (echo $load_avg | cut -d',' -f1 | string trim | cut -d'.' -f1) -lt 2 2>/dev/null; and echo $green; or echo $red)
    printf "%-34s" "$load_avg"
    set_color $orange
    echo "│"
    set_color normal
    
    # 第 11 行：字符画 + 运行时长
    set_color $orange
    echo -n "  │         ⣀⣀⣀⣀⣀⣀⣀             │  "
    set_color $orange
    echo -n "│  ⏱️  "
    set_color $white
    echo -n "Up:   "
    set_color $cyan
    printf "%-34s" "$uptime_info"
    set_color $orange
    echo "│"
    set_color normal
    
    # 第 12 行：字符画 + 磁盘使用
    set_color $orange
    echo -n "  │         ⠛⠛⠛⠛⠛⠛⠛⠛             │  "
    set_color $orange
    echo -n "│  💾 "
    set_color $white
    echo -n "Disk: "
    set_color $yellow
    printf "%-34s" "$disk_usage"
    set_color $orange
    echo "│"
    set_color normal
    
    # 第 13 行：字符画 + IP 地址
    set_color $orange
    echo -n "  │                            │  "
    set_color $orange
    echo -n "│  🌐 "
    set_color $white
    echo -n "IP:   "
    set_color $green
    printf "%-34s" "$local_ip"
    set_color $orange
    echo "│"
    set_color normal
    
    # 第 14 行：底部装饰
    set_color $orange
    echo -n "  ╰───────────────────────────────╯  "
    set_color $orange
    echo "╰──────────────────────────────────────────╯"
    set_color normal
    
    # 名言区域
    echo ""
    set_color $gray
    echo -n "  💭 "
    set_color $white
    echo "$quote"
    set_color normal
    
    # 底部提示
    echo ""
    set_color $orange
    echo -n "  ➜ "
    set_color $gray
    echo " Welcome back, $user! Ready to make something awesome?"
    set_color normal
    echo ""
end
