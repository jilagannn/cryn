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
