# Orange 主题 - 右侧提示符
# 显示：时间戳、CPU 占用、内存占用

# ===========================
# 颜色配置
# ===========================
set -q color_time_bg; or set -g color_time_bg 34495E
set -q color_time_str; or set -g color_time_str BDC3C7
set -q color_cpu_bg; or set -g color_cpu_bg 16A085
set -q color_cpu_str; or set -g color_cpu_str FFFFFF
set -q color_mem_bg; or set -g color_mem_bg 8E44AD
set -q color_mem_str; or set -g color_mem_str FFFFFF

# ===========================
# 系统资源监控函数
# ===========================

function __orange_get_cpu_usage -d "获取 CPU 使用率"
    # 从 /proc/stat 读取 CPU 信息
    if test -f /proc/stat
        set -l cpu_line (head -1 /proc/stat)
        set -l cpu_values (string split " " $cpu_line)
        
        # 计算总时间和空闲时间
        set -l user $cpu_values[2]
        set -l nice $cpu_values[3]
        set -l system $cpu_values[4]
        set -l idle $cpu_values[5]
        set -l iowait $cpu_values[6]
        set -l irq $cpu_values[7]
        set -l softirq $cpu_values[8]
        
        set -l total (math "$user + $nice + $system + $idle + $iowait + $irq + $softirq")
        set -l used (math "$total - $idle")
        
        if test $total -gt 0
            set -l usage (math -s0 "($used * 100) / $total")
            echo $usage
        else
            echo "N/A"
        end
    else
        echo "N/A"
 end
end

function __orange_get_memory_usage -d "获取内存使用率"
    if test -f /proc/meminfo
        set -l mem_total (grep "MemTotal:" /proc/meminfo | awk '{print $2}')
        set -l mem_available (grep "MemAvailable:" /proc/meminfo 2>/dev/null | awk '{print $2}')
        
        if test -z "$mem_available"
            # 如果 MemAvailable 不存在，使用 MemFree + Buffers + Cached
            set -l mem_free (grep "MemFree:" /proc/meminfo | awk '{print $2}')
            set -l buffers (grep "Buffers:" /proc/meminfo | awk '{print $2}')
            set -l cached (grep "^Cached:" /proc/meminfo | awk '{print $2}')
            set mem_available (math "$mem_free + $buffers + $cached")
        end
        
        if test -n "$mem_total" -a "$mem_total" -gt 0
            set -l used (math "$mem_total - $mem_available")
            set -l usage (math -s0 "($used * 100) / $mem_total")
            echo $usage
        else
            echo "N/A"
        end
    else
        echo "N/A"
    end
end

function __orange_format_bytes -d "将 KB 转换为人类可读格式"
    set -l kb $argv[1]
    if test -z "$kb" -o "$kb" = "N/A"
        echo "N/A"
        return
    end
    
    if test $kb -gt 1048576
        set -l gb (math -s2 "$kb / 1048576")
        echo "$gb"G
    else if test $kb -gt 1024
        set -l mb (math -s1 "$kb / 1024")
        echo "$mb"M
    else
        echo "$kb"K
    end
end

# ===========================
# 右侧提示符
# ===========================

function fish_right_prompt -d "Orange 主题右侧提示符"
    set -l cpu_usage (__orange_get_cpu_usage)
    set -l mem_usage (__orange_get_memory_usage)
    
    # 使用纯文字标签
    set -l label_mem "MEM"     # 内存标签
    set -l label_cpu "CPU"     # CPU 标签
    set -l label_time "TIME"   # 时间标签
    set -l separator "◀"       # 分隔符
    
    # 内存段
    if test "$mem_usage" != "N/A"
        set_color $color_mem_bg
        echo -n "$separator"
        set_color -b $color_mem_bg
        set_color $color_mem_str
        echo -n " $label_mem $mem_usage% "
        set_color normal
    end
    
    # CPU 段
    if test "$cpu_usage" != "N/A"
        set_color -b $color_cpu_bg
        set_color $color_mem_bg
        echo -n "$separator"
        set_color $color_cpu_str
        echo -n " $label_cpu $cpu_usage% "
    end
    
    # 时间戳段
    set_color -b $color_time_bg
    if test "$cpu_usage" != "N/A"
        set_color $color_cpu_bg
    else
        set_color normal
    end
    echo -n "$separator"
    set_color $color_time_str
    echo -n " $label_time "(date "+%H:%M:%S")" "
    set_color normal
    
    # 结束空格
    echo -n " "
end