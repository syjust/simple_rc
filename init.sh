#!/bin/bash
# interactive script to initialize rc files
# USAGE : $0 [name] [email]


#{{{ colorize
# assume colors are exported
#
colorize() {
    echo -e "${!1}${2}${_esc}"
}
#}}}
#{{{ info
#
info() {
   colorize _cyan "$1" 
}
#}}}
#{{{ warning
#
warning() {
   colorize _yellow "$1" 
}
#}}}
#{{{ success
#
success() {
   colorize _green "$1" 
}
#}}}
#{{{ error
#
error() {
   colorize _red "$1" 
}
#}}}

echo
info "interactive script to initialize rc files"
info "USAGE : $0 [name] [email]"
echo

name="$1"
email="$2"

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
"
for file in $rc_files ; do
    info "processing $file ... "
    if [ -e $file ] ; then
        if [ -e ~/$file ] ; then
            warning "~/$file already exists"
            done=0
            while [ $done -eq 0 ] ; do
                info "Do you want append $file >> ~/$file (y/N)"
                read resp
                case $resp in
                    y|Y)
                        sed 's#{USER.NAME}#'"$name"'#g;s#{USER.EMAIL}#'"$email"'#g' $file >> ~/$file \
                            && success "processing $file ... SUCCESS" \
                            || error "processing $file ... ERROR"
                        done=1
                    ;;
                    n|N) done=1 ;;
                    *)
                        error "'$resp' bad response !"
                        warning "please write 'y' or 'n'"
                        done=0
                        ;;
                esac
            done
        else
            sed 's#{USER.NAME}#'"$name"'#g;s#{USER.EMAIL}#'"$email"'#g' $file > ~/$file \
                && success "processing $file ... SUCCESS" \
                || error "processing $file ... ERROR"
        fi
    else
        error "FILE NOT FOUND"
    fi
done
