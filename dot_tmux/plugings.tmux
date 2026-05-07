# Loading pluings without plug manager
# Need Tmux 3.1+
#
# Enable tmux-resurrect
if-shell "[ -d ~/.tmux/tmux-resurrect ]" {
    run-shell ~/.tmux/tmux-resurrect/resurrect.tmux
    set -g @resurrect-capture-pane-contents "on"
}

# Enable tmux-continuum
if-shell "[ -d ~/.tmux/tmux-continuum ]" {
    run-shell ~/.tmux/tmux-continuum/continuum.tmux
    set -g @continuum-save-interval "60"
    #set -g @continuum-save-interval "60"
    #set -g @continuum-boot "on"
    #set -g @continuum-restore "on" # 启用自动恢复
}

# Tmux translation plugin powered by popup window.
if-shell '[ -d ~/.tmux/tmux-translator ]' {
    run-shell ~/.tmux/tmux-translator/main.tmux
    set -g @tmux-translator "t"
    set -g @tmux-translator-from "en"
    set -g @tmux-translator-to "zh"
    set -g @tmux-translator-engine "google"
}

# extrakto for tmux - quickly select, copy/insert/complete text without a mouse 
if-shell '[ -d ~/.tmux/extrakto ]' {
    run-shell ~/.tmux/extrakto/extrakto.tmux
    set -g @extrakto_popup_size "70%"
}
