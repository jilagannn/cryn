#!/bin/bash

# shellcheck disable=SC1091
# shellcheck disable=SC2154
# source https://www.bashsupport.com/manual/inspections/
source "$(dirname "$0")/styling.sh"

# if anything fails -> exit
set -eou pipefail

# for checking if the user will have the programs like gh cli, jq etc
check_program() {
  if ! command -v "$1" > /dev/null 2>&1; then
    echo "${red}Looks like you don't have $1 (⌣́_⌣̀)${reset}"
    echo "Install $1 and come back."
    exit 1
  fi
}

check_program "node"
check_program "npm"
check_program "jq"
check_program "gh"

# for installing packages with npm
install_package() {
  local package="$1"
  local flags="${2:-}"

  if ! npm i "$package" "$flags" 2>> "${ERRORS_LOG_PATH}" > "${POST_LOG_PATH}"; then
    write_log "$?" "Failed to install $package" "${ERRORS_LOG_PATH}"
    echo "${bold}${red}Failed to install $package T.T${reset}"
    exit 1
  fi
}

configure_package_json() {
    sleep 2
    jq '
    .scripts["test:watch"] = "jest --watch" |
    .scripts.test = "jest" |
    .scripts["test:coverage"] = "jest --coverage" |
    .scripts.build = "tsc" |
    .scripts.start = "ts-node src/server.ts" |
    .directories.test = "test"
    ' package.json > placeholder.json && mv placeholder.json package.json 
    echo "${italic}${reverse}package.json configured in '/'${reset}"
}
# parent directory of script
script_path="$(cd "$(dirname "$0")" && /bin/pwd)"

# this will get us the path to configs since dirname strips the cwd and gets parent dir -> parent dir of script cryn/
cryn_configs_path="$(dirname "${script_path}")"

magic_word_guard() {
    echo "You are actually a lazy chud. What's the magic word? ( ﾟヮﾟ)"
    read -r word
    capitalized_input="${word^}"

    while [ "$capitalized_input" != "Please" ]
    do 
        clear
        echo "Guess you actually have to work. I don't think we want to stay here forever waiting for a simple word... ( ﾟヮﾟ)"
        read -r word
        capitalized_input="${word^}"
    done
    echo
    echo "Fine (ㆆ_ㆆ), I'll configure your project directory for you..."
    echo
    echo "Stealing template from Dave. Poor Dave."
    echo "${italic}Stole template.${reset}"
    echo
}

create_github_repo() {
    echo "Name the repo please: "
    echo "${bold}${red}(alphanumeric + hyphens, underscores, and periods are allowed)${reset}"
    read -r repo_name
    echo
    if [[ $repo_name =~ ^[a-zA-Z0-9._-]+$ ]]; then
        echo "Trying to make repository with '${repo_name}'..."
        if gh repo create "$repo_name" -p DaveRRC/BED-template -c --private; then
            echo "Sigh... (⌣́_⌣̀) I guess I'm creating the repo named: ${repo_name} "
            echo
            echo "Repo created (could've been more creative though)."
            echo "Also cloned repository locally (this is why i'm the goat)."
            echo
            echo "Moving our cwd to the cloned repo (thank me later ^.^)."
            cd "${repo_name}" || exit
            echo
        else
            echo "${red}Failed to create the GitHub repository '${repo_name}'.${reset}"
            echo "${red}Common issues:${reset} authentication problems (did you forget to log in?), the repository already exists (I knew that name was bad), or network connectivity errors (I heard ethernet is good)."
            echo "Figure out what went wrong and then run the script again ( ━☞◔‿ゝ◔)━☞"
            exit 1
        fi
    else
        echo "${red}I'm pretty lenient when it comes to names but lets stay within the means here (ㆆ_ㆆ)... run the script again T.T${reset}"
        exit
    fi
}

create_node_env() {
    echo "${bold}${reverse}${lime_green}Alright, starting Node.js ⇒${reset}"
    if ! npm init -y 2> "${ERRORS_LOG_PATH}" > "${POST_LOG}"; then
        write_log "$?" "Failed to start node / npm." "${ERRORS_LOG_PATH}"
        echo "${reverse}Node initialized.${reset}"
        exit 1
    fi
    echo
}

print_dependencies_to_be_installed() {
    echo "${italic}${underline}Acquiring dependencies to install...${reset}"
    sleep 2
    echo "${reverse}${bold}Express (goated docs btw) (っ◕‿◕)っ.${reset}"
    echo "${bold}${reverse}${green}TypeScript, the mother of all Types (⚆ _ ⚆).${reset}"
    echo "${bold}${reverse}${red}Pain... erm I mean Jest... ╥﹏╥${reset}"
    echo "${bold}${reverse}${yellow}SuperTest ƪ(˘⌣˘)ʃ${reset}"
    echo "${bold}${reverse}${green}Morgan '(ᗒᗣᗕ)՞${reset}"
    echo "${bold}${reverse}${yellow}Joi ʕ•ᴥ•ʔ${reset}"
    echo "${bold}${reverse}${orange}Firebase ᕙ(⇀‸↼')ᕗ${reset}"
    echo
}

install_all_dependencies() {
    echo "${italic}${underline}Installing build and dev dependencies.${reset}"
    # express in build and in development dependencies
    install_package "express"
    install_package "@types/express" --save-dev 
    sleep 1
     # typescript in development dependencies
    install_package "typescript" --save-dev
    install_package "ts-node" --save-dev
    install_package "@types/node" --save-dev
    sleep 1
    # jest in development dependencies
    install_package "jest" --save-dev
    install_package "ts-jest" --save-dev
    install_package "@types/jest" --save-dev
    sleep 1
    # supertest in development dependencies
    install_package "supertest" --save-dev
    install_package "@types/supertest" --save-dev
    sleep 1
    # morgan
    install_package "morgan"
    install_package "@types/morgan" --save-dev
    sleep 1
    install_package "joi"
    sleep 1
    install_package "firebase-admin"
    echo "Build and dev dependencies installed O=('-'Q)"
    echo
    echo
    write_log "$?" "Successfully installed Express.js, TypeScript, Jest, Supertest, Morgan, Joi, and Firebase." "./post-processing.log"
}

configure_base_files() {
    echo "Creating API project directory ⇒"
    mkdir -p config/ test/integration/ test/unit/ src/constants/ src/api/v1/services/ src/api/v1/controllers/ src/api/v1/routes/ src/api/v1/middleware/ src/api/v1/repositories/ src/api/v1/models/ src/api/v1/validations/ src/api/v1/utils/
    sleep 2
    echo "${italic}${reverse}API structure created => 'src/api/v1', 'src/constants/', 'test/', 'config/'${reset}"
    sleep 2

    # base files
    touch sandbox.ts src/app.ts src/server.ts src/constants/httpConstants.ts src/api/v1/models/healthModel.ts src/api/v1/routes/healthRoutes.ts test/integration/app.test.ts test/integration/healthRoutes.test.ts
    echo "${italic}${reverse}Base files created => 'sandbox.ts','src/app.ts', 'src/server.ts', 'src/constants/httpConstants.ts', 'src/api/v1/models/healthModel.ts', 'src/api/v1/routes/healthRoutes.ts' ${reset}"
    echo

    echo "Creating base Express API ⇒"
    cp "${cryn_configs_path}/configs/back-end/express/app.txt" "src/app.ts"
    sleep 1
    echo "${italic}${reverse}Basic express app created for 'src/app.ts'${reset}"

    cp "${cryn_configs_path}/configs/back-end/express/server.txt" "src/server.ts"
    sleep 1
    echo "${italic}${reverse}Server component created on 'src/server.ts'${reset}"

    cp "${cryn_configs_path}/configs/back-end/files/httpConstants.txt" "src/constants/httpConstants.ts"
    sleep 1
    echo "${italic}${reverse}Constants created on 'src/constants/httpConstants.ts'${reset}"

    cp "${cryn_configs_path}/configs/back-end/files/healthModel.txt" "src/api/v1/models/healthModel.ts"
    sleep 1
    cp "${cryn_configs_path}/configs/back-end/files/healthRoutes.txt" "src/api/v1/routes/healthRoutes.ts"
    sleep 1
    echo "${italic}${reverse}Health check endpoint created on 'src/api/v1/models, src/api/v1/routes'${reset}"

    cp "${cryn_configs_path}/configs/back-end/files/appTest.txt" "test/integration/app.test.ts"
    sleep 1
    cp "${cryn_configs_path}/configs/back-end/files/healthRoutesTest.txt" "test/integration/healthRoutes.test.ts"
    sleep 1
    echo "${italic}${reverse}Configured base tests in 'test/integration/'${reset}"
    echo
    echo
    write_log "$?" "Successfully configured base directory and files" "./post-processing.log"
}

configure_config_files() {
    echo "Oh yah, the config files because you don't want to T.T"
    echo "Please wait, it's the best you could do -.-"
    sleep 2
    cp "${cryn_configs_path}/configs/back-end/node/jest-config.txt" "jest.config.js"
    echo "${italic}${reverse}jest.config.js configured in '/'${reset}"

    # update package.json for the scripts and jest testing
    configure_package_json

    sleep 2
    cp "${cryn_configs_path}/configs/back-end/actions/ci-yml.txt" ".github/workflows/ci.yml"
    echo "${italic}${reverse}ci.yml configured in '/.github/workflows'${reset}"
    echo
    echo "${bold}${italic}I configured them for you - (¬‿¬) you're welcome.${reset}"
    echo
    echo
    write_log "$?" "Successfully set up config files" "./post-processing.log"
}

wrap_up() {
    echo "API Structure:"
    ls -lR -I node_modules
    echo
    echo
    echo "Until next time chud (¬_¬)"
}

POST_LOG_PATH="./post-processing.log"
ERRORS_LOG_PATH="./errors.log"

create_logs() {
    log_file=${1}
    touch "${log_file}"
}

write_log() {
    date=$(date '+%Y-%m-%d %H:%M:%S')
    exit_code=${1}
    logged_message=${2}
    log_file=${3}
    echo "${date}, ${exit_code}, ${logged_message}" | tee -a "${log_file}"
}

main() {
    create_logs "post-processing.log"
    create_logs "errors.log"
    write_log "$?" "Choncc Initialized." "${POST_LOG_PATH}"
    magic_word_guard
    create_github_repo
    create_node_env
    print_dependencies_to_be_installed
    install_all_dependencies
    configure_base_files
    configure_config_files
    wrap_up
    write_log "$?" "Completed Script." "${POST_LOG_PATH}"
    write_log "$?" "Total runtime -> $SECONDS seconds." "${POST_LOG_PATH}"
}

main