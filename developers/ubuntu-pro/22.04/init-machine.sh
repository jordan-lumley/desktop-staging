#! /usr/bin/env bash

BLUE="\e[34m"
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

output_info () {
    echo "${BLUE}$1${ENDCOLOR} $2"
}

output_success () {
    echo "${GREEN}$1${ENDCOLOR} $2"
}

output_error () {
    echo "${RED}$1${ENDCOLOR} $2"
}

begin_output_section(){
    echo "${BLUE}===================="
    echo "$1"
}

end_output_section(){
    echo "${BLUE}====================${ENDCOLOR}"
    echo 
    echo 
}


echo "Initializing machine..."

begin_output_section "  Checking parameters..."
    if [ $# -eq 0 ]; then
        output_error "   no Ubuntu Pro key provided"
        exit 1
    fi
    output_success "        key provided: $1"
end_output_section


begin_output_section "  Gathering System Information..."
    output_info "       date:" $(date)
    output_info "       user:" $USERNAME
    output_info "       host:" $(uname -n)
    output_info "       kernel:" $(uname -s)
    output_info "       kernel release:" $(uname -r)
    output_info "       processor:" $(uname -p)
    output_info "       architecture:" $(uname -m)
    output_info "       operating system:" $(uname -o)
end_output_section


begin_output_section "  Checking for updates..."
    output_info "       updating..." 
    sudo apt-get update -qq
    output_success "            done"

    output_info "       upgrading..." 
    sudo apt-get upgrade -qq
    output_success "            done"

    output_info "       cleaning..." 
    sudo apt-get autoremove -qq
    output_success "            done"
end_output_section

begin_output_section "Installing prerequisites..."
    output_info "       adding packages..."
    sudo apt-get install ubuntu-advantage-tools landscape-client -y -qq
    output_success "            done"
end_output_section


begin_output_section "Initializing Ubuntu Pro..."
    output_info "       adding key($1)..."
    sudo pro attach $1
    sudo apt-get update -qq && sudo apt-get upgrade -qq
    output_success "            done"
end_output_section

begin_output_section "Initializing Landscape..."
    output_info "       adding machine..."
    sudo landscape-config --computer-title "$(uname -n)" --account-name round-2-pos --silent --script-users ALL
end_output_section
