confirm() {
    read -r -p "${1:+$1 Are you sure? [y/N]: }" yesNo

    case "$yesNo" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}
