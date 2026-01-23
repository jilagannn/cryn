#!/bin/bash

echo "You are actually a lazy chud. Whats the magic word?"
read -r word
capitalized_input="${word^}"

while [ "$capitalized_input" != "Please" ]
do 
    clear
	echo "Guess you actually have to work. I don't think we want to stay here forever waiting for a simple word..."
    read -r word
    capitalized_input="${word^}"
done
echo
echo "Fine, I'll configure your project directory for you..."
echo
echo "Stealing template from Dave. Poor Dave."
echo "Stole template."
echo

read -r -p "Name the repo please: " repo_name
echo "Sigh... I guess I'm creating the repo named: ${repo_name} "
echo
gh repo create "$repo_name" -p DaveRRC/BED-template -c --private
echo
echo "Repo created (could've been more creative though)."
echo "Also cloned repository locally (this is why i'm the goat)."
echo
sleep 2
echo "Moving our cwd to the cloned repo (thank me later ^.^)."
cd "${repo_name}" || exit
echo
sleep 2

# start node environment
echo "Alright, starting Node.js"
sleep 1
npm init -y > /dev/null
echo
echo "Node initialized."
echo 
sleep 3

# express in build and in development dependencies
echo "Installing Express for you (goated docs btw)."
npm i express
npm i @types/express --save-dev
echo
sleep 2
echo "Express acquired."
echo
sleep 3

# typescript in development dependencies
echo "Installing TypeScript, the mother of all Types."
npm i typescript ts-node @types/node --save-dev
echo
sleep 2
echo "TypeScript has been installed."
echo
sleep 3

# jest in development dependencies
echo "Installing pain I mean Jest."
echo
npm i jest ts-jest @types/jest --save-dev
echo
sleep 2
echo "Well that took long. Ignore those errors, nothingburger. Anyways, Jest installed......"
echo
sleep 6

# supertest in development dependencies
echo "Installing SuperTest 🦸🏻‍♀️"
npm i supertest @types/supertest --save-dev
echo
sleep 2
echo "Superman has arrived."
echo
sleep 2

# morgan
echo "Installing Morgan(a)."
npm i morgan 
npm i @types/morgan --save-dev
echo
echo "Morgan(a) installed - LEAGUE MENTIONED."
echo 
sleep 2

echo "Oh yah, configuring jest.config because you don't want to -.-"
echo "Please wait, it's the best you could do :c"
sleep 3
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
echo "Configured jest.config.js. You're welcome, you're welcome."
sleep 3
echo
