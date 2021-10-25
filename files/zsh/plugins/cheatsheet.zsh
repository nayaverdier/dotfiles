function cht() {
    lang="$1"
    shift;
    IFS="+" query="$*"
    curl "https://cht.sh/$lang/$query"
}

function chtp() {
    cht python "$@"
}

function chtr() {
    cht rust "$@"
}
