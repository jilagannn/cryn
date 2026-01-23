#!/bin/bash

# shellcheck source=scripts/styling.sh
# source https://www.bashsupport.com/manual/inspections/
source ./scripts/styling.sh

# if anything fails -> exit
set -eou pipefail

echo "You are actually a lazy chud. Whats the magic word? ( ﾟヮﾟ)"
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
echo "Fine (ㆆ _ ㆆ), I'll configure your project directory for you..."
echo
echo "Stealing template from Dave. Poor Dave."
echo "${italic}Stole template.${reset}"
echo

echo "Name the repo please: "
echo "${bold}${red}(alphanumeric + hypens, underscores, and periods are allowed)${reset}"
read -r repo_name
echo
if [[ $repo_name =~ ^[a-zA-Z0-9._-]+$ ]]; then
    gh repo create "$repo_name" -p DaveRRC/BED-template -c --private
else
    echo "${red}Im pretty lenient when it comes to names but lets stay within the means here (ㆆ_ㆆ)... run the script again T.T${reset}"
    exit
fi
echo "Sigh... (⌣́_⌣̀) I guess I'm creating the repo named: ${repo_name} "

echo
echo "Repo created (could've been more creative though)."
echo "Also cloned repository locally (this is why i'm the goat)."
echo
echo "Moving our cwd to the cloned repo (thank me later ^.^)."
cd "${repo_name}" || exit
echo

# start node environment
echo "${bold}${reverse}${green_v2}Alright, starting Node.js ⇒${reset}"
npm init -y > /dev/null
echo
echo "${reverse}Node initialized.${reset}"
echo 
sleep 1

# express in build and in development dependencies
echo "${bold}${reverse}Installing Express for you (goated docs btw) (っ◕‿◕)っ.${reset}"
npm i express
npm i @types/express --save-dev
echo
echo "${reverse}Express acquired (っ◕‿◕)っ.${reset}"
echo
sleep 1

# typescript in development dependencies
echo "${bold}${reverse}${green}Installing TypeScript, the mother of all Types (⚆ _ ⚆).${reset}"
npm i typescript ts-node @types/node --save-dev
echo
echo "${reverse}TypeScript has been installed \(•◡•)/${reset}"
echo
sleep 1

# jest in development dependencies
echo "${bold}${reverse}${red}Installing pain erm I mean Jest...╥﹏╥${reset}"
echo
npm i jest ts-jest @types/jest --save-dev
echo
echo "Well that took long. Ignore those errors, nothingburger."
echo "${reverse}Anyways, Jest installed......╥﹏╥${reset}"
echo
sleep 3

# supertest in development dependencies
echo "${bold}${reverse}${yellow}Installing SuperTest ƪ(˘⌣˘)ʃ${reset}"
npm i supertest @types/supertest --save-dev
echo
echo "Superman has arrived ƪ(˘⌣˘)ʃ."
echo
sleep 1

# morgan
echo "${bold}${reverse}${green}Installing Morgan(a) ⇒${reset}"
npm i morgan 
npm i @types/morgan --save-dev
echo
echo "Morgan(a) installed - LEAGUE MENTIONED '(ᗒᗣᗕ)՞."
echo 
sleep 1

# jest configuration
echo "Oh yah, configuring jest.config because you don't want to -.-"
echo "Please wait, it's the best you could do :c"
sleep 2
echo
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
echo
echo "${bold}${italic}You're welcome, (¬‿¬) you're welcome.${reset}"
sleep 2
echo

# update package.json for the scripts and jest testing
echo "Updating package.json ⇒"
sleep 2
jq '
.scripts["test:watch"] = "jest --watch" |
.scripts.test = "jest" |
.scripts["test:coverage"] = "jest --coverage" |
.scripts.build = "tsc" |
.scripts.start = "ts-node src/server.ts" |
.directories.test = "test"
' package.json > placeholder.json && mv placeholder.json package.json 
echo
echo "${italic}${reverse}package.json configured in '/'${reset}"
sleep 2

# make project directory
echo
echo "Creating API structure ⇒"
mkdir -p test/ src/api/v1
sleep 2
echo "${italic}${reverse}API structure created.${reset}"
echo
echo "Creating base files ⇒"
sleep 2
touch src/app.ts src/server.ts
echo "${italic}${reverse}Base files created => 'src/app.ts', 'src/server.ts${reset}"
echo
echo "Creating basic express app ⇒"
cat > src/app.ts << 'EOF'
import express, { Express } from "express";

// Initialize Express application
const app: Express = express();

// Define a route
app.get("/", (req, res) => {
    res.send("Hello, World!");
});

export default app;
EOF
sleep 1
echo "${italic}${reverse}Basic express app created for 'src/app.ts'${reset}"
echo
echo "Creating server component"
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
ls -lR
echo
echo
echo "Until next time chud (¬_¬)"
echo "Total runtime ⇒ $SECONDS seconds"
