#!/bin/bash
##################################################################################################################
# Written to be used on 64-bit computers running XeroLinux
# Original Author             :   DarkXero
# Extensive modifications by  :   vlk (https://github.com/REALERvolker1)
# Website                     :   http://xerolinux.xyz
##################################################################################################################
#set -e
# shellcheck disable=2207,2317

# Set the window title to something pleasant and Attempt to fix on Konsole
for i in 2 30; do
    echo -en "\033]${i};XeroLinux Nvidia Setup\007"
done

shopt -s checkwinsize
(
    : # curse you, shfmt
    :
)
# define some useful characters that are hard to type
BOLD="[1m"
RESET="[0m"
# TAB=$'\t' # make shellcheck happy
LF=$'\n'

_print_header() {
    local surround htx i surround fsur width_pad color i_val
    local vert_pad=$'\n'
    local -i width
    local -i halfwidth
    local -i i_width
    local -a prints=()

    for i in "$@"; do
        i_val="${i#*=}" # preprocess
        case "$i" in
        '--width='*)
            width="$i_val"
            ;;
        '--surround_char='*)
            ((${#i_val} == 1)) && surround="$i_val"
            ;;
        '--full-surround') # if you want to have the text surrounded
            fsur=true
            ;;
        '--no-vertical-pad')
            vert_pad=''
            ;;
        '--color='*)
            color="$i_val"
            ;;
        *)
            prints+=("$i")
            ;;
        esac
    done

    ((${#surround} == 1)) || surround='#' # if the surround character is not 1 character long, set it to default
    ((width > 3)) || width="$COLUMNS"     # make sure width is a number, and it is enough to do fun things with later
    htx="$(printf "\e[1${color:+;$color}m%${width}s\e[0m" '')"
    htx="${htx// /$surround}" # first print a bunch of spaces of the desired width, then replace those spaces with the surround character
    if ((${#fsur})); then
        fsur="\e[1;${color:+;$color}m${surround}" # fsur is dual-purpose. If it is set, then turn it from a bool into a fmt string
        width="$((width - 2))"                    # make sure the width is small enough to be completely surrounded
    fi
    ((width % 2)) && width_pad=' ' # pad width with a space on one side if it is not an even number
    halfwidth="$((width / 2))"     # precompute half the width (as an integer)

    echo "${vert_pad:-}$htx"
    for i in "${prints[@]}"; do
        i_width="$((${#i} / 2))" # character count of $i, divided by two
        # if fsur is not set, set it to an empty string. Pad the width in spaces to be centered
        printf "${fsur:=}\e[${color:-0}m%$((i_width + halfwidth))s%$((halfwidth - i_width))s${width_pad:=}${fsur:-}\n" "$i"
    done
    echo "$htx${vert_pad:-}"
}

_pause_for_readability() {
    local delay="${1:?Error, a period of time to delay is required!}"
    echo -en "\e[2m(Pausing $delay seconds for readability)\e[0m"
    # [[ ${1:-} =~ ^([0-9]+)$ ]] && delay="${1:-}"
    # read -r -t "$delay" -p "[2mPress RETURN to skip the $delay-second delay..." delay
    read -r -t "$delay"
    echo -en "\e[2K\r" # Erase the text and return cursor position to normal
}

_wayland_setup() {
    local REBOOT_CHOICE i
    local -a required_packages

    declare -a vanilla_packages=(
        'nvidia-utils'
        'libxnvctrl'
        'opencl-nvidia'
        'lib32-opencl-nvidia'
        'lib32-nvidia-utils'
        'nvidia-settings'
        'libvdpau'
        'lib32-libvdpau'
        'vulkan-icd-loader'
        'lib32-vulkan-icd-loader'
    )

    local wayland_setup_gpu="
Current nvidia GPU(s):
$BOLD$(lspci -x | grep -oP '^.*VGA[^:]+:\s*\K.*NVIDIA.*\](?=\s*\(.*)' || :)$RESET
"

    case "${1:-}" in
    '--open')
        required_packages=('nvidia-open-dkms' "${vanilla_packages[@]}")
        # dkms_pkg="nvidia-open-dkms"
        _print_header \
            'Installing Experimental Open-dkms Drivers' \
            '' \
            'Provides Experimental Open-dkms Drivers' \
            'Limited to Turing Series GPUs & Up'

        printf '%s\n' 'This option installs the latest open-source nVidia kernel modules.' \
            'Recommended for tinkering and testing' \
            "${BOLD}Warning${RESET}: Only compatible with ${BOLD}Turing+${RESET} GPUs$RESET"

        echo "$wayland_setup_gpu"
        ;;
    *)
        required_packages=('nvidia-dkms' "${vanilla_packages[@]}")
        # dkms_pkg="nvidia-dkms"
        _print_header \
            'Installing Clean Vanilla Drivers (NFB)' \
            '' \
            'Provides Clean Vanilla Drivers' \
            'Limiting you to only 900 Series & Up'

        printf '%s\n' 'This option installs the latest proprietary kernel modules.' \
            'Recommended for most use cases'

        echo "$wayland_setup_gpu"
        ;;
    esac

    # printf ' %s\n' \
    #     '##############################################################################################################' \
    #     "[0;1m[[91mWARNING[0;1m][0;33m If you selected the [1;93mwrong option[0;33m, the [1;93monly[0;33m way to revert the changes is with a [1;93mfresh OS installation[0m" \
    #     '##############################################################################################################' \
    #     ''
    _print_header --full-surround --width=100 --color=93 \
        'Make sure you selected correct option. Otherwise, the only way back will be a fresh OS install.' \
        'Not sure? Ask us on Discord before installing.'

    read -r -p "You sure you selected correct driver, continue?${LF}[y/N] > " continue_install
    [[ "${continue_install:-x}" == y ]] || return 1

    # _pause_for_readability 5
    local should_install_cuda
    _print_header --width=55 'Do you want to include CUDA for Machine Learning?' \
        "${BOLD}WARNING${RESET}: This takes ${BOLD}4.3${RESET} GiB of disk space!!!"
    read -r -p "Do you want to install Cuda ? [y/N] > " should_install_cuda

    # if we do not have sudo perms, warn the user. Redirect all output (stdout, stderr, etc) to /dev/null
    ((DRY)) || sudo -vn &>/dev/null || echo "${BOLD}[Sudo required]${RESET}"
    # read, unmangle backslashes, return false after 5 seconds, only read 1 character, prompt with string, no variable
    # read -r -t 5 -n 1 -p "${prompt_str:-}Press Enter to continue, or wait 5 seconds...${LF}"

    [[ ${should_install_cuda:-} == y ]] && required_packages+=(cuda)

    # pacman sends currently installed packages to stdout, and not-installed packages to stderr.
    # Take stderr and get only the package name. Disregard any colors.
    local oldifs="$IFS"
    local IFS=$'\n'
    local -a needed_packages=()
    while read -r i; do
        needed_packages+=("$i")
    done < <(pacman -Q "${required_packages[@]}" 2> >(grep -oP --color=never "^error:[^']*'\K[^']*") >/dev/null)
    IFS="$oldifs"

    _print_header --width=35 "Installing packages"
    printf '%s\n' "${needed_packages[@]}"
    _pause_for_readability 5
    $SUDO pacman -S --needed --noconfirm "${required_packages[@]}" # install everything though because you need to have it all

    _print_header --width=35 'Applying Wayland Specific Stuff.'
    _pause_for_readability 3

    if ((DRY != 1)); then
        if ! pacman -Q "${required_packages[@]}" &>/dev/null; then
            echo "Critical Error! Missing required nvidia packages on your system! Skipping boot configuration!"
            return 1
        fi
    fi
    local DESKTOP_ENVIRONMENT="${XDG_CURRENT_DESKTOP,,}"

    _boot_cfg --grub
    _boot_cfg --mkinitcpio

    [[ -e /etc/gdm/custom.conf ]] && $SUDO sed -i 's/WaylandEnable=false/#&/' /etc/gdm/custom.conf
    $SUDO mkinitcpio -P

    local -a services=(nvidia-{hibernate,resume,suspend})

    local needs_nvidia_powerd
    read -r -p "Do you want to enable 'nvidia-powerd'? For Ampere (RTX 30 series+) laptop GPUs. [y/N] > " needs_nvidia_powerd
    [[ ${needs_nvidia_powerd:-} == 'y' ]] && services+=('nvidia-powerd')

    _print_header --width=35 'Enabling power services' "${services[@]}"
    _pause_for_readability 2

    $SUDO systemctl enable "${services[@]}" # &>/dev/null # it's always good to just double check
    if ((DRY)); then
        echo "Dry run selected. Skipping reboot"
    else
        _print_header "Reboot required. Press Enter to reboot or any other key to exit."
        read -r REBOOT_CHOICE
        if [[ -z ${REBOOT_CHOICE:-} ]]; then
            $SUDO reboot
        else
            echo "${LF}Please reboot your system later to apply the changes."
        fi
    fi
}

_boot_cfg() {
    local file dryfile fp entry_str i
    local -i MAX_BACKUP_FILES=99999
    local -a modules
    local -a current
    local -a apply_command
    local -A strcfg

    case "${1:-}" in
    --grub)
        file="/etc/default/grub"
        dryfile="$HOME/.dry-run-grub"
        entry_str='GRUB_CMDLINE_LINUX_DEFAULT'
        strcfg=([start]='"' [end]='"' [prefix]='' [comment]='#')
        modules=('quiet' 'loglevel=3' 'nowatchdog' 'nvme_load=yes' 'rd.driver.blacklist=nouveau' 'modprobe.blacklist=nouveau' 'nvidia-drm.modeset=1')
        apply_command=(update-grub)
        ;;
    --mkinitcpio)
        file="/etc/mkinitcpio.conf"
        dryfile="$HOME/.dry-run-mkinitcpio"
        entry_str='MODULES'
        strcfg=([start]='(' [end]=')' [prefix]="\\" [comment]='#')
        modules=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
        apply_command=(mkinitcpio '-P')
        ;;
    *) return 1 ;;
    esac

    if ((DRY)); then
        cp -i "$file" "$dryfile"
        echo "Dry run selected. Copying file to $dryfile"
        file="$dryfile"
    fi

    while IFS= read -r i; do
        # echo "Line 283 debug, printing current grub module: $i"
        current+=("$i")
    done < <(grep -oP "^${entry_str}=${strcfg[prefix]}${strcfg[start]}\\K[^${strcfg[prefix]}${strcfg[end]}]*" "$file" | tr -s '[:blank:]' '\n' || :)

    local -a new
    # take everything, if it isn't already in the flags, put it in the flags
    for i in "${modules[@]}" "${current[@]}"; do
        [[ "${new[*]}" != *"${i:-x}"* ]] && new+=("${i:-}")
    done

    # echo "Line 305 debug, printing new grub modules"
    # printf '%s\n' "${new[@]}"

    if [[ "${current[*]}" == "${new[*]}" ]]; then
        echo "Skipping -- no module changes needed"
        return
    fi
    _print_header --width=36 "Applying driver changes to system" 'DO NOT CANCEL THIS SCRIPT'

    local module_string="${entry_str}=${strcfg[start]}${new[*]}${strcfg[end]}"

    # Make backup of current
    for ((i = 0; i <= MAX_BACKUP_FILES; i++)); do
        fp="${file}.${i}.bak"
        [[ -e "$fp" ]] && continue # skip creation if backup file already exists
        if ((DRY)); then
            echo "Skipping file copy -- $file -> $fp"
        else
            $SUDO cp "$file" "$fp"
        fi
        break
    done

    # comment out old lines, read the rest to an array
    local -a file_contents
    while IFS= read -r line; do
        [[ "$line" == "$entry_str"* ]] && line="${strcfg[comment]}$line"
        file_contents+=("$line")
    done <"$file"

    local -a file_arr
    local -i has_replaced=0

    for i in "${file_contents[@]}"; do
        file_arr+=("$i")
        ((has_replaced)) && continue
        if [[ "$i" == "${strcfg[comment]}$entry_str"* ]]; then
            file_arr+=("$module_string")
            has_replaced=1
        fi
    done
    # handle if it had empties
    ((has_replaced)) || file_arr+=("$module_string")

    printf '%s\n' "${file_arr[@]}" | (
        if ((DRY)); then
            tee "$file"
        else
            $SUDO tee "$file"
        fi
    ) >/dev/null

    $SUDO "${apply_command[@]}"
}

_check_update() {
    if ! command -v checkupdates &>/dev/null; then
        echo "Error, required dependency 'checkupdates' was not found!
Press RETURN to exit!"
        read -r
        exit 2
    fi
    (($(checkupdates | wc -l || echo 1))) || return
    read -r -p "Updates required. Press RETURN to continue."
    if $SUDO pacman -Syu; then
        # successful update
        _print_header --full-surround "Updates successful!" 'Restarting installer'
        _pause_for_readability 5
        exec "${BASH_SOURCE[0]}"
    else
        read -r -p "Error installing updates. Press RETURN to exit."
        exit 3
    fi
}

__reset_everything() {
    if [[ $* == *'--header'* ]]; then
        _print_header --width=49 'Done!' 'Press ENTER to return to main screen'
        read -r
    fi
    echo -en "${RESET}" # clear formatting
    clear
    # sh '/usr/share/xerowelcome/scripts/nVidia_drivers.sh' # DANGEROUS RECURSION!!
}

declare -i DRY=0
SUDO='sudo'
# argument parsing
for i in "$@"; do
    case "${i:-}" in
    '--dry-run' | -d)
        DRY=1
        SUDO='echo sudo'
        ;;
    '-'*)
        # ARGZERO (the script name), greedily matched until the last slash
        # turns '/home/vlk/Downloads/nVidia_driversNov.sh' into 'nVidia_driversNov.sh'
        echo "${0##*/} [--dry-run (-d)]"
        echo "run ${0##*/} with no args to run the script as usual"
        exit 1
        ;;
    esac
done

# save everything to a variable
header_text="$(
    _print_header --color=91 --no-vertical-pad --full-surround \
        'XeroLinux Wayland-ready nVidia (Proprietary) Driver Installer' \
        "Note : nvidia-settings GUI isn't Yet Wayland Ready, Plz Use Terminal." \
        'Normally This is Enough For Hybrid Setups, If Not, More Research is Needed.' \
        'This script should cover most use cases. If not, please consult the wiki.'

    lspci_output="$(lspci | grep -oP '^.*VGA[^:]+:\s*\K.*NVIDIA.*\](?=\s*\(.*)' | sed -E 's/(\[)/\1[0;1;91m/g ; s/(\])/[0m\1/g' | grep -v '^\s*$' || :)"
    if [[ -n "${lspci_output:-}" ]]; then
        printf '%s\n' \
            '' \
            '###################### Detected GPUs ######################' \
            '' \
            "Hello ${USER:=$(whoami)}, you have the following nVidia GPUs:" \
            '' \
            "$lspci_output"
    else
        echo "${LF}Hello ${USER:=$(whoami)}, you seem to have no nVidia GPUs."
    fi

    echo "
############## Vanilla Drivers (Recommended) ##############

${BOLD}1${RESET}. Latest Vanilla Drivers (900 Series & up).
${BOLD}2${RESET}. Latest Open-dkms Drivers (Experimental/Turing+).

Type Your Selection. To Exit, press ${BOLD}q${RESET} or close Window.
${RESET}
"
)"

if ((DRY)); then
    echo "Skipping update check"
else
    _check_update
fi

while :; do
    __reset_everything
    CHOICE=''
    # print the header every time
    # read, unmangle backslashes, stop after 1 character, prompt with string, variable
    read -r -n 1 -p "$header_text${LF}${INVALID_OPTION_STR:-}[1|2|3|q] > ${BOLD}" CHOICE
    INVALID_OPTION_STR=''
    echo "${RESET}" # user's answer is bolded. This is required to reset
    case "${CHOICE:=}" in
    1)
        _wayland_setup && __reset_everything --header
        ;;
    2)
        _wayland_setup --open && __reset_everything --header
        ;;
    q)
        exit 0
        ;;
    *)
        # _print_header --width=33 'Choose a valid option!' # no one will see this
        INVALID_OPTION_STR="Invalid option: '${CHOICE:-}' "
        clear
        continue # re-prompt
        ;;

    esac

done
