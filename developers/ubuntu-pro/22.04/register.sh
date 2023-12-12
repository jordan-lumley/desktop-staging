#! /usr/bin/env bash

BLUE="\e[34m"
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

NEWLINE='\n'


user_input() {
    RESULT=$(zenity --entry --title="$1" --text="$2")
    if [ -z "$RESULT" ]; then
        echo ""
    else
        echo "$RESULT"
    fi

    echo ""
}

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

    printf ${NEWLINE}

    output_info "Installing prerequisites..."
    output_info "   adding packages..."
    sudo apt-get install zenity ubuntu-advantage-tools landscape-client -y -qq
    output_success "    done"

    printf ${NEWLINE}

    output_info "Requesting key..."
    KEY=$(user_input "Ubuntu Pro Key" "Please enter your Ubuntu Pro key:")
    if [ -z "$KEY" ]; then
        echo "No key provided, exiting..."
        exit 1
    else
        echo "Key provided: $KEY"
    fi

    printf ${NEWLINE}

    # ask for the required full name
    output_info "Gathering user information..."
    NAMETAG=$(user_input "Name tag" "please enter your first initial followed by full last name (i.e jlumley, charvey, esheehan)")
    if [ -z "$NAMETAG"]; 
    then
        echo "No name provided, exiting..."
        exit 1
    else
        echo "Name tag provided: $NAMETAG"
    fi
    printf ${NEWLINE}

    output_info "Gathering System Information..."
    output_info "   date:" $(date)
    output_info "   user:" $USERNAME
    output_info "   name tag:" $NAMETAG
    output_info "   host:" $(uname -n)
    output_info "   kernel:" $(uname -s)
    output_info "   kernel release:" $(uname -r)
    output_info "   processor:" $(uname -p)
    output_info "   architecture:" $(uname -m)
    output_info "   operating system:" $(uname -o)

    printf ${NEWLINE}

    output_info "Initializing Ubuntu Pro..."
    output_info "   adding key(${GREEN}${KEY}${BLUE})..."
    sudo pro attach $1
    sudo apt-get update -qq && sudo apt-get upgrade -qq
    output_success "    done"

    printf ${NEWLINE}

    output_info "Initializing Landscape..."
    output_info "   adding machine..."
    sudo landscape-config --computer-title "$(uname -n)" --account-name round-2-pos --silent --script-users ALL --tags $NAMETAG
end_output_section
