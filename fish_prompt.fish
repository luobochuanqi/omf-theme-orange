# Orange - 优雅现代的 Fish Shell 主题
# 特点：双行设计、优雅配色、及时信息反馈

# ===========================
# 颜色配置（优雅暖色调）
# ===========================

# 如果没有设置颜色，使用默认值
set -q color_orange_bg; or set -g color_orange_bg FF9F43
set -q color_orange_str; or set -g color_orange_str FFFFFF
set -q color_path_bg; or set -g color_path_bg 2C3E50
set -q color_path_str; or set -g color_path_str ECF0F1
set -q color_git_clean_bg; or set -g color_git_clean_bg 27AE60
set -q color_git_clean_str; or set -g color_git_clean_str FFFFFF
set -q color_git_dirty_bg; or set -g color_git_dirty_bg E74C3C
set -q color_git_dirty_str; or set -g color_git_dirty_str FFFFFF
set -q color_status_success; or set -g color_status_success 2ECC71
set -q color_status_error; or set -g color_status_error E74C3C

# ===========================
# 辅助函数
# ===========================

function __orange_git_branch -d "获取当前 Git 分支"
    command git symbolic-ref --short HEAD 2>/dev/null
    or command git describe --tags --exact-match 2>/dev/null
    or command git rev-parse --short HEAD 2>/dev/null
end

function __orange_git_status -d "获取 Git 状态"
    set -l git_status (command git status --porcelain 2>/dev/null)
    if test -n "$git_status"
        echo "dirty"
    else
        echo "clean"
    end
end

function __orange_get_pwd -d "获取格式化的当前目录"
    set -l pwd (prompt_pwd)
    # 如果路径太长，进行智能截断
    if test (string length $pwd) -gt 40
        set pwd (string replace -r "^(.{15}).*(.{20})" '$1...$2' $pwd)
    end
    echo $pwd
end

# ===========================
# 主提示符
# ===========================

function fish_prompt -d "Orange 主题主提示符"
    set -l last_status $status
    
    # 保存光标位置，用于右侧提示符对齐
    set -l pwd_str (__orange_get_pwd)
    set -l git_info ""
    
    # 检查 Git 状态
    if command git rev-parse --git-dir >/dev/null 2>&1
        set -l git_branch (__orange_git_branch)
        set -l git_status (__orange_git_status)
        
        if test "$git_status" = "clean"
            set git_info "  $git_branch"
        else
            set git_info "  $git_branch ±"
        end
    end
    
    # 第一行：信息行
    echo ""
    
    # 目录段（带背景色）
    set_color -b $color_path_bg
    set_color $color_path_str
    echo -n " $pwd_str "
    set_color normal
    
    # Git 状态段（如果有）
    if test -n "$git_info"
        if string match -q "*±*" $git_info
            # 未提交的更改 - 红色
            set_color -b $color_git_dirty_bg
            set_color $color_path_bg
            echo -n ""
            set_color $color_git_dirty_str
            echo -n "$git_info "
            set_color normal
            set_color $color_git_dirty_bg
        else
            # 干净的 - 绿色
            set_color -b $color_git_clean_bg
            set_color $color_path_bg
            echo -n ""
            set_color $color_git_clean_str
            echo -n "$git_info "
            set_color normal
            set_color $color_git_clean_bg
        end
        echo -n ""
    else
        # 没有 Git，直接结束目录段
        set_color $color_path_bg
        echo -n ""
    end
    
    set_color normal
    echo ""
    
    # 第二行：输入提示行
    # 显示状态符号（根据上一条命令）
    if test $last_status -eq 0
        set_color $color_status_success
        echo -n "✓ "
    else
        set_color $color_status_error
        echo -n "✗ "
    end
    set_color normal
    
    # 输入指示器（橙色箭头）
    set_color -b $color_orange_bg
    set_color FFFFFF
    echo -n " ❯ "
    set_color normal
    set_color $color_orange_bg
    echo -n ""
    set_color normal
    echo -n " "
end
