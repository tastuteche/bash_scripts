#!/usr/bin/env bash
opacity=0.6
wclass='Gnome-terminal'
function gnome_looking_glass() {
    local ret
    ret="$(gdbus call --session --dest org.gnome.Shell \
         --object-path /org/gnome/Shell \
         --method org.gnome.Shell.Eval "$1")"
    [ "${ret:0:8}" = "(true, '" ] \
        || { echo "bad output from Gnome looking glass: $ret"; exit 1; }
    [ -n "${ret:8:-2}" ] && echo "${ret:8:-2}"
}

function set_magic_window_opacity() {
    local search_term="$1"
    gnome_looking_glass "global.get_window_actors()
                   .filter(w => w.get_meta_window()
                   .get_wm_class().toLowerCase()
                   .contains('$search_term'.toLowerCase())).forEach(win => win.set_opacity($opacity))"
}


set_magic_window_opacity "$wclass"

