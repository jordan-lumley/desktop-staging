#! /usr/bin/env bash

BLUE="\e[34m"
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

NEWLINE='\n'

output_info () {
    printf "${BLUE}$1${ENDCOLOR} $2"
    printf ${NEWLINE}
}

output_success () {
    printf "${GREEN}$1${ENDCOLOR} $2"
    printf ${NEWLINE}
}

output_error () {
    printf "${RED}$1${ENDCOLOR} $2"
    printf ${NEWLINE}
}

begin_output_section () {
    printf ${NEWLINE}
    printf "${BLUE}**************************************"
    printf ${NEWLINE}
    printf "$1"
    printf ${NEWLINE}
}

end_output_section () {
    printf "\n"
    printf "${BLUE}**************************************${ENDCOLOR}"
    printf ${NEWLINE}
}

clear 

printf "Initializing machine..."

begin_output_section
    output_info "Checking for parameter keys..."
    if [ $# -eq 0 ]; then
        output_error "   no Ubuntu Pro key provided, exiting..."
        exit 1
    fi
    output_info "   key provided:" $1

    # ask for the required full name
    output_info "Gathering user information..."
    read -p "$(printf ${BLUE}"   please enter your first initial followed by full last name (i.e jlumley, charvey, esheehan): "${ENDCOLOR})" FULLNAME
    if [ -z "$FULLNAME" ]; then
        output_error "   no full name provided, exiting..."
        exit 1
    fi



    output_info "Gathering System Information..."
    output_info "   date:" $(date)
    output_info "   user:" $USERNAME
    output_info "   full name:" $FULLNAME
    output_info "   host:" $(uname -n)
    output_info "   kernel:" $(uname -s)
    output_info "   kernel release:" $(uname -r)
    output_info "   processor:" $(uname -p)
    output_info "   architecture:" $(uname -m)
    output_info "   operating system:" $(uname -o)

    output_info "Checking for updates..."
    output_info "   updating..." 
    sudo apt-get update -qq
    output_success "    done"

    output_info "   upgrading..." 
    sudo apt-get upgrade -qq
    output_success "    done"

    output_info "   cleaning..." 
    sudo apt-get autoremove -qq
    output_success "    done"

    output_info "Installing prerequisites..."
    output_info "   adding packages..."
    sudo apt-get install ubuntu-advantage-tools landscape-client -y -qq
    output_success "    done"


    output_info "Initializing Ubuntu Pro..."
    output_info "   adding key(${GREEN}$1${BLUE})..."
    sudo pro attach $1
    sudo apt-get update -qq && sudo apt-get upgrade -qq
    output_success "    done"

    output_info "Initializing Landscape..."
    output_info "   adding machine..."
    sudo landscape-config --computer-title "$(uname -n)" --account-name round-2-pos --silent --script-users ALL --tags $FULLNAME
end_output_section
