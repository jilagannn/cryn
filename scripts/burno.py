"""This module defines the burno script.

This module utilizes the gmail API to delete or trash emails in
categories such as Promos, Updates, Social, Spam, or Trash.
"""

__author__ = "Jheyrus Ilagan"
__version__ = "2.13.2026"

import os
import time

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

# Scope for full access
SCOPES = ["https://mail.google.com/"]

# Delete messages in batches of this size (max. 1000).
BATCH_SIZE = 500

creds = None
# The file token.json stores the user's access and refresh tokens, and 
# is created automatically when the authorization flow completes for 
# the first time.
if os.path.exists("configs/gmail/token.json"):
    creds = Credentials.from_authorized_user_file("configs/gmail/token.json", 
                                                SCOPES)
# If there are no (valid) credentials available, let the user log in.
if not creds or not creds.valid:
    if creds and creds.expired and creds.refresh_token:
        creds.refresh(Request())
    else:
        flow = InstalledAppFlow.from_client_secrets_file(
            "configs/gmail/credentials.json", SCOPES
        )
        creds = flow.run_local_server(port=0)
    # Save the credentials for the next run
    with open("configs/gmail/token.json", "w") as token:
        token.write(creds.to_json())

service = build("gmail", "v1", credentials=creds)

def menu_options() -> str:
    MENU_OPTIONS = (f"1. Delete all mail (Promos, Socials - excluding Updates)\n"
                    f"2. Delete all mail from category\n"
                    f"3. Clear Spam\n"
                    f"4. Clear Trash\n"
                    f"5. Exit\n")
    return print(MENU_OPTIONS)

def get_user_input() -> int:
    try:
        user_input = int(input(f"So what do we want to do today?\n"
                            f"Select the corresponding number: "))
        return user_input
    except (TypeError, ValueError) as e:
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"An error occurred: {e}")
        print("Restarting operations.")

def user_confirmation(message):
    user_confirmation = ""
    while user_confirmation != "n" and user_confirmation != "y":
        user_confirmation = input(f"{message}\nEnter y/n: ").lower()
        if user_confirmation != "n" and user_confirmation != "y":
            print("Please enter y for yes or n for no! >:(")

    return user_confirmation

def display_next_page(all_messages, query):
    results = (service.users().messages()
            .list(userId="me", q=query, maxResults=BATCH_SIZE).execute())
    messages = results.get("messages", [])
    token = results.get("nextPageToken")
    all_messages.extend(messages)
    while "nextPageToken" in results:
        results = (service.users().messages()
                   .list(userId="me", q=query, 
                         maxResults=BATCH_SIZE, pageToken=token).execute())
        all_messages.extend(messages)

def clear_trash():
    try:
        query = "in:trash"
        trash_messages = []
        display_next_page(trash_messages, query)

        if len(trash_messages) == 0:
            print(f"Trash is empty.")
            print("Returning to selection!")

        else:
            message_count = len(trash_messages)
            print(f"There are {message_count} in Trash")
            user_choice = user_confirmation(f"Are you sure you want to delete "
                                            f"emails in trash?")
            if user_choice == "y":
                print(f"Deleting emails in Trash.")
                for i in trash_messages:
                    (service.users().messages()
                    .delete(userId="me", id=i["id"]).execute())
                print("Emails in Trash deleted!")
            else:
                print("Returning to selection.")

    except (HttpError, TypeError, ValueError) as error:
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"An error occurred: {error}")
        print("Restarting operations.")

def clear_spam():
    try:
        query = "in:spam"
        spam_messages = []
        display_next_page(spam_messages, query)

        if len(spam_messages) == 0:
            print("Spam is empty.")
            print("Returning to selection!")

        else:
            message_count = len(spam_messages)
            print(f"There are {message_count} in Spam")
            user_choice = user_confirmation(f"Are you sure you want to delete "
                                            f"emails in spam?")
            if user_choice == "y":
                print(f"Deleting emails in Spam.")
                for i in spam_messages:
                    (service.users().messages()
                    .delete(userId="me", id=i["id"]).execute())
                print("Emails in Spam deleted!")
            else:
                print("Returning to selection.")

    except (HttpError, TypeError, ValueError) as error:
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"An error occurred: {error}")
        print("Restarting operations.")

def trash_categories():
    try:
        query = "category:promotions OR category:social"
        all_messages = []
        display_next_page(all_messages, query)

        if len(all_messages) == 0:
            print("Categories are empty.")
            print("Returning to selection!")

        else:
            message_count = len(all_messages)
            print(f"There are {message_count} in promos and social")
            user_choice = user_confirmation(f"Are you sure you want to delete "
                                            f"emails in selected categories?")
            if user_choice == "y":
                print(f"Trashing emails in promos and socials.")
                for i in all_messages:
                    (service.users().messages()
                     .trash(userId="me", id=i["id"]).execute())
                print("Emails trashed!")
            else:
                print("Returning to selection.")

    except (HttpError, TypeError, ValueError) as error:
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"An error occurred: {error}")
        print("Restarting operations.")
    

def trash_emails_in_category(name, query):
    try:
        selected_category_messages = []
        display_next_page(selected_category_messages, query)

        if len(selected_category_messages) == 0:
            print(f"Category {name} is empty.")
            print("Returning to selection!")

        else:
            message_count = len(selected_category_messages)
            print(f"There are {message_count} in {name}")
            user_choice = user_confirmation(f"Are you sure you want to delete "
                                            f"emails in {name}?")
            if user_choice == "y":
                print(f"Deleting emails in {name}.")
                for i in selected_category_messages:
                    (service.users().messages()
                     .trash(userId="me", id=i["id"]).execute())
                print(f"Emails in {name} trashed!")
            else:
                print("Returning to selection.")

    except (HttpError, TypeError, ValueError) as error:
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"An error occurred: {error}")
        print("Restarting operations.")

def select_category():
    CATEGORIES = [
        {"name": "Promos", "query": "category:promotions"},
        {"name": "Social", "query": "category:social"},
        {"name": "Updates", "query": "category:updates AND in:inbox"}
    ]

    CATEGORY_OPTIONS = (f"\n1. Promos\n"
                    f"2. Social\n"
                    f"3. Update\n"
                    f"4. Exit\n")
    print(CATEGORY_OPTIONS)
    try:
        user_choice = ""
        while user_choice != 4:
            user_choice = int(input("Please select a category: "))

            if user_choice == 1:
                trash_emails_in_category(CATEGORIES[0]["name"], CATEGORIES[0]["query"])
            elif user_choice == 2:
                trash_emails_in_category(CATEGORIES[1]["name"], CATEGORIES[1]["query"])
            elif user_choice == 3:
                print(f"Updates typically contain some important messages."
                        f"It is highly advised you move/save said messages before proceeding.")
                
                update_prompt = user_confirmation("Would you like to proceed? y/n: ")

                if update_prompt == "y":
                    trash_emails_in_category(CATEGORIES[2]["name"], CATEGORIES[2]["query"])
                else:
                    print("Returning to category select.")
            elif user_choice == 4:
                print("Returning to main selection.")
            else:
                print("Choose a valid option! T.T")

    except (HttpError, TypeError, ValueError) as error:
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"An error occurred: {error}")
        print("Restarting operations.")

def main():
    try:
        user_input = ""
        while user_input != 5:
            menu_options()
            user_input = get_user_input()

            if user_input == 1:
                trash_categories()

            elif user_input == 2:
                select_category()

            elif user_input == 3:
                clear_spam()

            elif user_input == 4:        
                clear_trash()

            elif user_input == 5:
                print("Bye bye!")
                
            else:
                print("Please select a valid option! T.T")

            time.sleep(3)
            os.system('cls' if os.name == 'nt' else 'clear')

    except (HttpError, TypeError, ValueError) as error:
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"An error occurred: {error}")
        print("Restarting operations.")


if __name__ == "__main__":
    main()