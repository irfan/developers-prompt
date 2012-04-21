# ~/.bashrc file
#
# https://github.com/irfan/developers-prompt
# http://irfandurmus.com/projetcs/developers-prompt
#
# it shows pretty good terminal prompt
# writed couple of years ago but committed in April of 2012
# It shorter your prompt text but also make the prompt more understandable!
#
# Just copy to your home directory as .bashrc to installation.
#
# !!!! Attendion !!!!
# If you already have the ~/.bashrc file please backup it before use this file
#
# Examples:
# /opt/local/etc                :   /opt/local/etc
# /opt/local/etc/openssl/misc   :   /opt/../openssl/misc
#
# In home directory:
# /Users/irfan                                          : ~
# ~/projects/javascript/jquery-plugins                  : ~/projects/javascript/jquery-plugins $
# ~/projects/javascript/jquery-plugins/star-rating/min  : ~/projects/../star-rating/min $
#
#
# If the directory into an svn or git project, the branch name going to add your prompt like that;
# 
# ~/projects/javascript/jquery-plugins                  : ~/projects/javascript/jquery-plugins [master] $ 
# ~/projects/javascript/jquery-plugins/star-rating/min  : ~/projects/../star-rating/min [trunk] $
# 

SUFFIX=".git"
BRANCH=""

function git_branch ()
{
    ARG=$1
    if [ ! ${#ARG} -lt 4 ]; then
        if [ ! -d "$ARG$SUFFIX" ]; then
            BRANCH=""
            ARG=`echo $ARG | sed -e "s|[^\/]*\/$||g"`
            git_branch "$ARG"
        else
            CMD=`git branch | grep \* | sed -e "s|\* ||"`
            BRANCH=" [$CMD]"
        fi
    fi
}


function svn_branch () {
    svn info | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk' | egrep -o '[^/]+$'
}

function pretty_prompt () {
	_IFS=$IFS;
	DIR=`pwd|sed -e "s|$HOME|~|"`;
	IFS="/" && S=($DIR);
	L=${#S[@]};
	IFS=$_IFS;
	if [ $L -gt 4 ]; then 
		DIR="${S[0]:0:1}/${S[1]}/../${S[$L-2]}/${S[$L-1]}";
	fi
    
    if [ -d ".svn" ]; then
        DIR=$DIR:" `svn_branch`"
    else
        # set $BRANCH variable as git branch name
        git_branch `pwd`"/"
        DIR="$DIR$BRANCH"
    fi
}


PROMPT_COMMAND=pretty_prompt;

export PS1="\$DIR \$ "

