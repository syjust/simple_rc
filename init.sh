#!/bin/bash
# interactive script to initialize rc files
# USAGE : $0 [name] [email]
DIR="`dirname $0`"
SCRIPT="`basename ${0/.sh/}`"
TMP="`mktemp /tmp/$SCRIPT.tmp.XXXXXX`"

if [ -e "$DIR/.log.inc.sh" ] ; then
    source "$DIR/.log.inc.sh"
else
    echo ".log.inc.sh not found... can't continue !"
    exit 2
fi

name="$1"
email="$2"

#{{{ process
#
process() {
    local action="$1" target="$2"
    [ -z "$action" -o -z "$target" ] && quit "action:'$action' & target:'$target' must be given"
    if [ "$action" != 'dir' -a -f "$target" ] ; then
       sed 's#{USER.NAME}#'"$name"'#g;s#{USER.EMAIL}#'"$email"'#g' $target > $TMP
    fi
    case $action in
        dir)
          if [ ! -d ~/$target ] ; then
            if [ ! -e ~/$target ] ; then
              mkdir -p -v ~/$target
            else
              warning "~/$target is a file, can't create directory"
              [ ! -e ~/$target ]
            fi
          else
            info "~/$target directory already exists"
          fi
        ;;
        new|replace)
            cp $TMP ~/$target
        ;;
        append)
            cat $TMP >> ~/$target
        ;;
        diff)
            diff -U3 $TMP ~/$target | less -R
        ;;
        vimdiff)
            diff $TMP ~/$target
        ;;
        *) quit "can't process action '$action' on target '$target' !!!" ;;
    esac
    [ $? -eq 0 ] \
        && success "processing $action $target ... SUCCESS" \
        || error "processing $target ... ERROR"
}
#}}}

echo
info "interactive script to initialize rc files"
info "USAGE : $0 [name] [email]"
echo


while [ -z "$name" ] ; do
    info "please give me your name : "
    read name
    [ -z "$name" ] \
        && warning "please give me a valid name"
done
success "name:'$name'"
while [ -z "$email" ] ; do
    info "please give me your email : "
    read email
    [ -z "$email" ] \
        && warning "please give me a valid email"
done
success "email:'$email'"

rc_files="
.colors
.bashrc
.gitconfig
.screenrc
.vimrc
.tmux.conf
.log.inc.sh
"
for file in $rc_files ; do
    info "processing $file ... "
    if [ -e $file ] ; then
        if [ -e ~/$file ] ; then
            warning "~/$file already exists"
            done=0
            while [ $done -eq 0 ] ; do
                info "What do you want to do now with '$file' ?"
                select resp in append replace diff vimdiff nothing ; do
                    case $resp in
                        append|replace)
                            if (yes_no "Are you sure you want $resp from $file to ~/$file") ; then
                                process $resp $file \
                                && done=1 \
                                || done=0
                            else
                                done=0
                            fi
                        break ;;
                        diff|vimdiff)
                            process $resp $file
                            done=0
                        break ;;
                        nothing) done=1 ; break ;;
                        *)  error "'$resp' bad response !"
                            warning "please write only one of purposes 'append', 'replace', 'diff' or 'nothing'"
                            done=0
                        break ;;
                    esac
                done
            done
        else
            process new $file
        fi
    else
        quit "FILE NOT FOUND"
    fi
done
rc_dirs="
  .vim/undo
"
for dir in $rc_dirs ; do
  process dir $dir
done
