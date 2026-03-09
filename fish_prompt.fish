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

# Powerline 分隔符
set -g segment_separator \uE0B0
set -g segment_separator_thin \uE0B1
set -g prompt_symbol \uE0B8

# ===========================
# 辅助函数
# ===========================

function __orange_prompt_segment -d "绘制一个提示符段"
    set -l bg $argv[1]
    set -l fg $argv[2]
    set -l content $argv[3]
    
    set_color -b $bg
    set_color $fg
    echo -n " $content "
end

function __orange_prompt_end -d "结束提示符段"
    set -l bg $argv[1]
    set_color -b normal
    set_color $bg
    echo -n "$segment_separator"
    set_color normal
end

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
    
    # 第一行：信息行
    echo -n "
"
    
    # 起始分隔符（根据上一条命令状态变色）
    if test $last_status -eq 0
        set_color $color_status_success
    else
        set_color $color_status_error
    end
    echo -n " $segment_separator "
    set_color normal
    
    # 目录段
    set -l pwd (__orange_get_pwd)
    __orange_prompt_segment $color_path_bg $color_path_str $pwd
    __orange_prompt_end $color_path_bg
    
    # Git 状态段（如果在 git 仓库中）
    if command git rev-parse --git-dir >/dev/null 2>&1
        set -l git_branch (__orange_git_branch)
        set -l git_status (__orange_git_status)
        
        if test "$git_status" = "clean"
            set_color -b $color_git_clean_bg
            set_color $color_path_bg
            echo -n "$segment_separator"
            __orange_prompt_segment $color_git_clean_bg $color_git_clean_str "\uE0A0 $git_branch"
            __orange_prompt_end $color_git_clean_bg
        else
            set_color -b $color_git_dirty_bg
            set_color $color_path_bg
            echo -n "$segment_separator"
            __orange_prompt_segment $color_git_dirty_bg $color_git_dirty_str "\uE0A0 $git_branch"
            __orange_prompt_end $color_git_dirty_bg
        end
    end
    
    echo -n " "
    
    # 第二行：输入提示行（圆滑曲线指向）
    echo -n "
"
    
    # 左侧的圆滑曲线
    set_color $color_orange_bg
    echo -n " $prompt_symbol "
    set_color normal
    
    # 输入指示器
    set_color -b $color_orange_bg
    set_color $color_orange_str
    echo -n " ❯ "
    set_color normal
    set_color $color_orange_bg
    echo -n "$segment_separator"
    set_color normal
    echo -n " "
end