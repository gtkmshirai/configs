# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

source /home/leus/.bashrc.jsk
export LD_LIBRARY_PATH=/usr/lib32:$LD_LIBRARY_PATH

source /home/leus/ros/electric/setup.bash
#source /home/leus/.bashrc.electric.ros

export export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/leus/ros/electric/gazebo_tutorials
export export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/leus/ros/electric/gazebo_simple_gripper
export export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/leus/prog/euslib/demo/s-fujii/sifi-ros-pkgs
export export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/leus/prog/euslib/demo/motegi/perception

#For ROS Network Setup of Kojiro
function rossetrobot() {
    export ROS_MASTER_URI=http://tucana:11311
    echo -e "\e[1;31mset ROS_MASTER_URI to $ROS_MASTER_URI\e[m"
}
function rossetgilbert() {
    export ROS_MASTER_URI=http://gilbert:11311
    echo -e "\e[1;31mset ROS_MASTER_URI to $ROS_MASTER_URI\e[m"
}
function rossetlocal() {
    export ROS_MASTER_URI=http://localhost:11311
    echo -e "\e[1;31mset ROS_MASTER_URI to $ROS_MASTER_URI\e[m"
}
function rossetrosip() {
  export ROS_IP=`LANGUAGE=en LANG=C ifconfig | grep inet\  | grep -v 127.0.0.1 | sed 's/.*inet addr:\([0-9\.]*\).*/\1/' | head -1`
  export ROS_HOSTNAME=$ROS_IP
  echo -e "\e[1;31mset ROS_IP and ROS_HOSTNAME to $ROS_IP\e[m"
}
rossetrosip

export H8LIBDIR=/home/leus/prog/h8lib2007
export PATH=$PATH:/opt/rmtp-sdk/bin:/opt/rmtp-sdk/rmtsim/bin

#euslib
export CVSDIR=~/prog
source $(rospack find euslisp)/jskeus/bashrc.eus

# rviz
export OGRE_RTT_MODE=Copy  # ノートPCの人は

# openrtm (openrtmのmakeを通す必要がある???)
export PYTHONPATH=$PYTHONPATH:`rospack find openrtm`/src/openrtm
export PYTHONPATH=$PYTHONPATH:`rospack find openrtm`/lib/python2.6/site-packages/OpenRTM_aist/RTM_IDL
#export PYTHONPATH=$PYTHONPATH:`rospack find openrtm`/build/OpenRTM-aist-Python-1.0.1/OpenRTM-aist

# 以下はrosmake openrtm --rosdep-install をすると生成されるはず
source `rospack find openrtm`/scripts/rtshell-setup.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`rospack find openrtm`/lib

#end