#!/bin/bash

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
echo "Stole template."
echo

read -r -p "Name the repo please: " repo_name
echo "Sigh... (⌣́_⌣̀) I guess I'm creating the repo named: ${repo_name} "
echo
gh repo create "$repo_name" -p DaveRRC/BED-template -c --private
echo
echo "Repo created (could've been more creative though)."
echo "Also cloned repository locally (this is why i'm the goat)."
echo
echo "Moving our cwd to the cloned repo (thank me later ^.^)."
cd "${repo_name}" || exit
echo
sleep 2

# start node environment
echo "Alright, starting Node.js ⇒"
npm init -y > /dev/null
echo
echo "Node initialized."
echo 
sleep 2

# express in build and in development dependencies
echo "Installing Express for you (goated docs btw) (っ◕‿◕)っ."
npm i express
npm i @types/express --save-dev
echo
echo "Express acquired (っ◕‿◕)っ."
echo
sleep 2

# typescript in development dependencies
echo "Installing TypeScript, the mother of all Types (⚆ _ ⚆)."
npm i typescript ts-node @types/node --save-dev
echo
echo "TypeScript has been installed \(•◡•)/"
echo
sleep 2

# jest in development dependencies
echo "Installing pain erm I mean Jest...╥﹏╥"
echo
npm i jest ts-jest @types/jest --save-dev
echo
echo "Well that took long. Ignore those errors, nothingburger. Anyways, Jest installed......╥﹏╥"
echo
sleep 3

# supertest in development dependencies
echo "Installing SuperTest ƪ(˘⌣˘)ʃ"
npm i supertest @types/supertest --save-dev
echo
echo "Superman has arrived ƪ(˘⌣˘)ʃ."
echo
sleep 2

# morgan
echo "Installing Morgan(a) ⇒"
npm i morgan 
npm i @types/morgan --save-dev
echo
echo "Morgan(a) installed - LEAGUE MENTIONED '(ᗒᗣᗕ)՞."
echo 
sleep 2

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
echo "jest.config.js configured in '/'"
echo
echo "Configured jest.config.js. You're welcome, (¬‿¬) you're welcome."
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
echo "package.json configured in '/'"
sleep 2

# make project directory
echo
echo "Creating API structure ⇒"
mkdir -p test/ src/api/v1
sleep 2
echo "API structure created."
echo
echo "Creating base files ⇒"
sleep 2
touch src/app.ts src/server.ts
echo "Base files created."
echo
echo
echo
echo "API Structure:"
tree -h -I node_modules/
echo
echo
echo "Until next time chud (¬_¬)"
echo "Total runtime ⇒ $SECONDS seconds"
