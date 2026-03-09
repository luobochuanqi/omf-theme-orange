# Orange 主题 - 终端窗口标题

function fish_title -d "设置终端窗口标题"
    set -l current_dir (basename (prompt_pwd))
    set -l current_command $argv[1]
    
    if test -n "$current_command"
        # 如果有正在运行的命令，显示命令和目录
        echo "$current_command — $current_dir"
    else
        # 否则只显示目录
        echo "$current_dir"
    end
end