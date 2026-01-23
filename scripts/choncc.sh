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

  if ! npm i "$package" "$flags" > /dev/null 2>&1; then
    echo "${bold}${red}Failed to install $package T.T${reset}"
    exit 1
  fi
}

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

# start node environment
echo "${bold}${reverse}${lime_green}Alright, starting Node.js ⇒${reset}"
npm init -y > /dev/null 2>&1
echo "${reverse}Node initialized.${reset}"
echo 
sleep 1

# express in build and in development dependencies
echo "${italic}${underline}Installing build and dev dependencies.${reset}"
echo "${reverse}${bold}Express (goated docs btw) (っ◕‿◕)っ.${reset}"
install_package "express"
install_package "@types/express" --save-dev 
sleep 1

# typescript in development dependencies
echo "${bold}${reverse}${green}TypeScript, the mother of all Types (⚆ _ ⚆).${reset}"
install_package "typescript" --save-dev
install_package "ts-node" --save-dev
install_package "@types/node" --save-dev
sleep 1

# jest in development dependencies
echo "${bold}${reverse}${red}Pain... erm I mean Jest... ╥﹏╥${reset}"
install_package "jest" --save-dev
install_package "ts-jest" --save-dev
install_package "@types/jest" --save-dev
sleep 1

# supertest in development dependencies
echo "${bold}${reverse}${yellow}SuperTest ƪ(˘⌣˘)ʃ${reset}"
install_package "supertest" --save-dev
install_package "@types/supertest" --save-dev
sleep 1

# morgan
echo "${bold}${reverse}${green}Morgan '(ᗒᗣᗕ)՞${reset}"
install_package "morgan"
install_package "@types/morgan" --save-dev
sleep 1
echo
echo "Build and dev dependencies installed O=('-'Q)"
echo

# jest configuration
echo "Oh yah, the config files because you don't want to T.T"
echo "Please wait, it's the best you could do -.-"
sleep 2
cat > jest.config.js << EOF
module.exports = {
    preset: "ts-jest",
    testEnvironment: "node",
    testMatch: ["**/*.test.ts"],
    collectCoverageFrom: [
        "src/**/*.ts",
        "!src/server.ts", // this excludes server startup files
        "!src/types/**/*.ts", // this excludes type definitions
    ],
};
EOF
echo "${italic}${reverse}jest.config.js configured in '/'${reset}"

# update package.json for the scripts and jest testing
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

sleep 2
cat > .github/workflows/ci.yml << EOF
name: Node.js CI

on:
    push:
        branches: [main, development]
    pull_request:
        branches: [main, development]

jobs:
    build:
        runs-on: ubuntu-latest

        steps:
            - uses: actions/checkout@v2
            - name: Use Node.js
              uses: actions/setup-node@v2
              with:
                  node-version: "20.x"
            - run: npm install
            - run: npm test
EOF
echo "${italic}${reverse}ci.yml configured in '/.github/workflows'${reset}"
echo
echo "${bold}${italic}I configured them for you - (¬‿¬) you're welcome.${reset}"

# make project directory
echo
echo "Creating API project directory ⇒"
mkdir -p test/ src/api/v1
sleep 2
echo "${italic}${reverse}API structure created => 'src/api/v1', 'test/'${reset}"
sleep 2
touch src/app.ts src/server.ts
echo "${italic}${reverse}Base files created => 'src/app.ts', 'src/server.ts'${reset}"
echo
echo "Creating base Express API ⇒"
cat > src/app.ts << 'EOF'
import express, { Express } from "express";
import morgan from "morgan";

// Initialize Express application
const app: Express = express();

// Setup Morgan
app.use(morgan("combined"));

// Define a route
app.get("/", (req, res) => {
    res.send("Hello, World!");
});

export default app;
EOF
sleep 1
echo "${italic}${reverse}Basic express app created for 'src/app.ts'${reset}"
cat > src/server.ts << 'EOF'
import app from "./app";
import { Server } from "http";

const PORT: string | number = process.env.PORT || 3000;

const server: Server = app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

export { server };
EOF
sleep 1
echo "${italic}${reverse}Server component created on 'src/server.ts'${reset}"
echo
echo
echo "API Structure:"
ls -lR -I node_modules
echo
echo
echo "Until next time chud (¬_¬)"
echo "Total runtime -> $SECONDS seconds"
