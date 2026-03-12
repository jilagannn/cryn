#!/bin/bash

# shellcheck disable=SC1091
# shellcheck disable=SC2154
# source https://www.bashsupport.com/manual/inspections/
source "$(dirname "$0")/styling.sh"

# if anything fails -> exit
set -eou pipefail

# Constants
readonly SHORT_DELAY=1
readonly LONG_DELAY=2
readonly EXIT_FAILURE=1

# for checking if the user will have the programs like gh cli, jq etc
check_program() {
  if ! command -v "$1" > /dev/null 2>&1; then
    echo "${red}Looks like you don't have $1 (⌣́_⌣̀)${reset}"
    echo "Install $1 and come back."
    exit "${EXIT_FAILURE}"
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

  if ! npm i "$package" "$flags" 2>> "${ERRORS_LOG_PATH}" 1>> "${POST_LOG_PATH}"; then
    write_log "ERROR" "${EXIT_CODE}" "${EXIT_CODE}" "Failed to install $package" "${ERRORS_LOG_PATH}"
    echo "${bold}${red}Failed to install $package T.T${reset}"
    exit "${EXIT_FAILURE}"
  fi
}

configure_package_json() {
    sleep "${LONG_DELAY}"
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
            exit "${EXIT_FAILURE}"
        fi
    else
        echo "${red}I'm pretty lenient when it comes to names but lets stay within the means here (ㆆ_ㆆ)... run the script again T.T${reset}"
        exit
    fi
}

create_node_env() {
    echo "${bold}${reverse}${lime_green}Alright, starting Node.js ⇒${reset}"
    if ! npm init -y 2>> "${ERRORS_LOG_PATH}" 1>> "${POST_LOG_PATH}"; then
        write_log "ERROR" "${EXIT_CODE}" "Failed to start node / npm." "${ERRORS_LOG_PATH}"
        exit "${EXIT_FAILURE}"
    fi
    echo "${reverse}Node initialized.${reset}"
    write_log "INFO" "${EXIT_CODE}" "Initialized Node environment." "${POST_LOG_PATH}"
    echo
}

print_dependencies_to_be_installed() {
    echo "${italic}${underline}Acquiring dependencies to install...${reset}"
    sleep "${LONG_DELAY}"
    echo "${reverse}${bold}Express (goated docs btw) (っ◕‿◕)っ.${reset}"
    echo "${bold}${reverse}${green}TypeScript, the mother of all Types (⚆ _ ⚆).${reset}"
    echo "${bold}${reverse}${red}Pain... erm I mean Jest... ╥﹏╥${reset}"
    echo "${bold}${reverse}${yellow}SuperTest ƪ(˘⌣˘)ʃ${reset}"
    echo "${bold}${reverse}${green}Morgan '(ᗒᗣᗕ)՞${reset}"
    echo "${bold}${reverse}${yellow}Joi ʕ•ᴥ•ʔ${reset}"
    echo "${bold}${reverse}${orange}Firebase ᕙ(⇀‸↼')ᕗ${reset}"
    echo "${bold}${reverse}${orange}dotenv (shhh... keep it a secret) (꒪ȏ꒪;)${reset}"
    echo "${bold}${reverse}${orange}Helmet ヽ(^◇^*)/${reset}"
    echo "${bold}${reverse}${orange}cors 〴⋋_⋌〵${reset}"
    echo "${bold}${reverse}${orange}Swagger ( ・◇・)?${reset}"
    echo "${bold}${reverse}${orange}Redocly CLI ‹•.•›${reset}"
    echo
}

install_all_dependencies() {
    echo "${italic}${underline}Installing build and dev dependencies.${reset}"
    # express in build and in development dependencies
    install_package "express"
    install_package "@types/express" --save-dev 
    sleep "${SHORT_DELAY}"
     # typescript in development dependencies
    install_package "typescript" --save-dev
    install_package "ts-node" --save-dev
    install_package "@types/node" --save-dev
    sleep "${SHORT_DELAY}"
    # jest in development dependencies
    install_package "jest" --save-dev
    install_package "ts-jest" --save-dev
    install_package "@types/jest" --save-dev
    sleep "${SHORT_DELAY}"
    # supertest in development dependencies
    install_package "supertest" --save-dev
    install_package "@types/supertest" --save-dev
    sleep "${SHORT_DELAY}"
    # morgan
    install_package "morgan"
    install_package "@types/morgan" --save-dev
    sleep "${SHORT_DELAY}"
    install_package "joi"
    sleep "${SHORT_DELAY}"
    install_package "firebase-admin"
    install_package "firebase"
    sleep "${SHORT_DELAY}"
    install_package "dotenv"
    sleep "${SHORT_DELAY}"
    install_package "helmet"
    sleep "${SHORT_DELAY}"
    install_package "cors"
    install_package "@types/cors" --save-dev
    sleep "${SHORT_DELAY}"
    install_package "swagger-ui-express"
    install_package "swagger-jsdoc"
    sleep "${SHORT_DELAY}"
    install_package "@redocly/cli" --save-dev
    echo "Build and dev dependencies installed O=('-'Q)"
    echo
    echo
    write_log "INFO" "${EXIT_CODE}" "Successfully installed Express.js, TypeScript, Jest, Supertest, Morgan, Joi, Firebase, cors, Helmet, and Swagger." "${POST_LOG_PATH}"
}

configure_base_files() {
    echo "Creating API project directory ⇒"
    mkdir -p config/ test/integration/ test/unit/ src/constants/ src/logs src/api/v1/services/ src/api/v1/controllers/ src/api/v1/routes/ src/api/v1/middleware/ src/api/v1/repositories/ src/api/v1/models/ src/api/v1/validations/ src/api/v1/utils/ src/api/v1/types/ src/api/v1/errors/ 
    sleep "${LONG_DELAY}"
    echo "${italic}${reverse}API structure created => 'src/api/v1', 'src/constants/', 'src/logs' 'test/', 'config/'${reset}"
    sleep "${LONG_DELAY}"

    # base files
    touch sandbox.ts config/firebaseConfig.ts config/corsConfig.ts config/helmetConfig.ts /src/app.ts src/server.ts src/constants/httpConstants.ts src/api/v1/models/healthModel.ts src/api/v1/models/responseModel.ts src/api/v1/models/authorizationOptions.ts src/api/v1/types/expressTypes.ts src/api/v1/types/firestoreDataTypes.ts src/api/v1/middleware/authenticate.ts src/api/v1/middleware/authorize.ts src/api/v1/middleware/errorHandler.ts src/api/v1/middleware/logger.ts src/api/v1/middleware/validate.ts src/api/v1/errors/error.ts src/api/v1/repositories/firestoreRepository.ts src/api/v1/utils/errorUtils.ts src/api/v1/routes/healthRoutes.ts test/integration/app.test.ts test/integration/healthRoutes.test.ts test/jest.setup.ts

    echo -e "${italic}${reverse}Base files created => 'sandbox.ts', \n'config/firebaseConfig.ts', config/helmetConfig.ts', config/corsConfig.ts', \n'src/app.ts', 'src/server.ts', \n'src/constants/httpConstants.ts', \n'src/api/v1/models/healthModel.ts', 'src/api/v1/models/responseModel.ts', 'src/api/v1/models/authorizationOptions.ts', \n'src/api/v1/routes/healthRoutes.ts', /n'src/api/v1/types/expressTypes.ts', 'src/api/v1/types/firestoreDataTypes.ts', \n'src/api/v1/middleware/authenticate.ts', 'src/api/v1/middleware/authorize.ts', 'src/api/v1/middleware/errorHandler.ts', 'src/api/v1/middleware/logger.ts', 'src/api/v1/middleware/validate.ts', \n'src/api/v1/errors/error.ts', \n'src/api/v1/repositories/firestoreRepository.ts', \n'src/api/v1/utils/errorUtils.ts' ${reset}"
    echo

    echo "Creating base Express API ⇒"

    # config files
    cp "${cryn_configs_path}/configs/back-end/configs/firebaseConfig.txt" "config/firebaseConfig.ts"
    cp "${cryn_configs_path}/configs/back-end/configs/corsConfig.txt" "config/corsConfig.ts"
    cp "${cryn_configs_path}/configs/back-end/configs/helmetConfig.txt" "config/helmetConfig.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Configs created in 'config/'${reset}"

    # express app
    cp "${cryn_configs_path}/configs/back-end/express/app.txt" "src/app.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Basic express app created for 'src/app.ts'${reset}"

    cp "${cryn_configs_path}/configs/back-end/express/server.txt" "src/server.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Server component created in 'src/server.ts'${reset}"

    # constants
    cp "${cryn_configs_path}/configs/back-end/constants/httpConstants.txt" "src/constants/httpConstants.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Constants created in 'src/constants/httpConstants.ts'${reset}"

    # models
    cp "${cryn_configs_path}/configs/back-end/models/authorizationOptions.txt" "src/api/v1/models/authorizationOptions.ts"
    cp "${cryn_configs_path}/configs/back-end/models/responseModel.txt" "src/api/v1/models/responseModel.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Models created in 'src/api/v1/models/'${reset}"

    # types
    cp "${cryn_configs_path}/configs/back-end/types/expressTypes.txt" "src/api/v1/types/expressTypes.ts"
    cp "${cryn_configs_path}/configs/back-end/types/firestoreDataTypes.txt" "src/api/v1/types/firestoreDataTypes.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Types created in 'src/api/v1/types/'${reset}"

    # errors
    cp "${cryn_configs_path}/configs/back-end/errors/errors.txt" "src/api/v1/errors/errors.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Errors created in 'src/api/v1/errors/'${reset}"

    # repositories
    cp "${cryn_configs_path}/configs/back-end/repositories/firestoreRepository.txt" "src/api/v1/repositories/firestoreRepository.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Repositories created in 'src/api/v1/repositories/'${reset}"

    # middleware
    cp "${cryn_configs_path}/configs/back-end/middleware/authenticate.txt" "src/api/v1/middleware/authenticate.ts"
    cp "${cryn_configs_path}/configs/back-end/middleware/authorize.txt" "src/api/v1/middleware/authorize.ts"
    cp "${cryn_configs_path}/configs/back-end/middleware/errorHandler.txt" "src/api/v1/middleware/errorHandler.ts"
    cp "${cryn_configs_path}/configs/back-end/middleware/logger.txt" "src/api/v1/middleware/logger.ts"
    cp "${cryn_configs_path}/configs/back-end/middleware/validate.txt" "src/api/v1/middleware/validate.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Middlewares set up in 'src/api/v1/middleware/'${reset}"

    # utils
    cp "${cryn_configs_path}/configs/back-end/utils/errorUtils.txt" "src/api/v1/utils/errorUtils.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Utils created in 'src/api/v1/middleware/'${reset}"

    # health check public endpoint
    cp "${cryn_configs_path}/configs/back-end/models/healthModel.txt" "src/api/v1/models/healthModel.ts"
    cp "${cryn_configs_path}/configs/back-end/endpoints/healthRoutes.txt" "src/api/v1/routes/healthRoutes.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Health check endpoint created in 'src/api/v1/models, src/api/v1/routes', 'src/app.ts'${reset}"

    # test (like integration tests and the setup with mocking)
    cp "${cryn_configs_path}/configs/back-end/test/appTest.txt" "test/integration/app.test.ts"
    cp "${cryn_configs_path}/configs/back-end/test/healthRoutesTest.txt" "test/integration/healthRoutes.test.ts"
    cp "${cryn_configs_path}/configs/back-end/test/jestSetup.txt" "test/jest.setup.ts"
    sleep "${SHORT_DELAY}"
    echo "${italic}${reverse}Configured base tests in 'test/'${reset}"
    echo
    echo
    write_log "INFO" "${EXIT_CODE}" "Successfully configured base directory and files" "${POST_LOG_PATH}"
}

configure_config_files() {
    echo "Oh yah, the config files because you don't want to T.T"
    echo "Please wait, it's the best you could do -.-"
    sleep "${LONG_DELAY}"
    cp "${cryn_configs_path}/configs/back-end/node/jest-config.txt" "jest.config.js"
    echo "${italic}${reverse}jest.config.js configured in '/'${reset}"

    # update package.json for the scripts and jest testing
    configure_package_json

    sleep "${LONG_DELAY}"
    cp "${cryn_configs_path}/configs/back-end/actions/ci-yml.txt" ".github/workflows/ci.yml"
    echo "${italic}${reverse}ci.yml configured in '/.github/workflows'${reset}"
    echo
    echo "${bold}${italic}I configured them for you - (¬‿¬) you're welcome.${reset}"
    echo
    echo
    write_log "INFO" "${EXIT_CODE}" "Successfully set up config files" "${POST_LOG_PATH}"
}

wrap_up() {
    echo "API Structure:"
    ls -lR -I node_modules
    echo
    echo
    echo "Until next time chud (¬_¬)"
    write_log "INFO" "${EXIT_CODE}" "Finished script." "${POST_LOG_PATH}"
}

POST_LOG_PATH="./logs/post-processing.log"
ERRORS_LOG_PATH="./logs/errors.log"

create_log() {
    log_dir="logs/"
    if [ ! -d "${log_dir}" ]; then
        mkdir "logs/"
    else
        log_file=${1}
        touch "${log_file}"
    fi
}

EXIT_CODE=$?

write_log() {
    date=$(date '+%Y-%m-%d %H:%M:%S')
    log_header=${1}
    exit_status=${2}
    logged_message=${3}
    log_file=${4}
    echo "${date}, ${log_header}, ${exit_status} ${logged_message}" >> "${log_file}"
}

main() {
    magic_word_guard
    create_github_repo
    create_log "/logs/post-processing.log"
    create_log "logs/errors.log"
    write_log "INFO" "${EXIT_CODE}" "Choncc Initialized." "${POST_LOG_PATH}"
    write_log "INFO" "${EXIT_CODE}" "GitHub repository created." "${POST_LOG_PATH}"
    create_node_env
    print_dependencies_to_be_installed
    install_all_dependencies
    configure_base_files
    configure_config_files
    wrap_up
    write_log "INFO" "${EXIT_CODE}" "Completed Script." "${POST_LOG_PATH}"
    write_log "INFO" "${EXIT_CODE}" "Total runtime -> $SECONDS seconds." "${POST_LOG_PATH}"
}

main