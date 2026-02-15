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
        print(e)

def clear_trash():
    try:
        query = "in:trash"
        all_messages = []
        display_next_page(all_messages, query)

        if len(all_messages) == 0:
                print(f"Categories are empty.")

        else:
            message_count = len(all_messages)
            print(f"There are {message_count} in Trash")
            user_confirmation = input(f"Are you sure you want to delete "
                                    f"selected emails? y/n: ")
            if user_confirmation.capitalize() == "Y":
                print(f"Deleting emails in Trash.")
                for i in all_messages:
                    (service.users().messages()
                    .delete(userId="me", id=i["id"]).execute())
                print("Emails in Trash deleted!")

    except HttpError as error:
        print(f"An error occurred: {error}")

def count_spam() -> int:
    try:
        spam = (service.users().messages()
                .list(userId="me", q="in:spam").execute())
        spam_count = spam["resultSizeEstimate"]
        spam_message = f"Total emails in spam (estimate): {spam_count}"
        print(spam_message)
    except HttpError as error:
        print(f"An error occurred: {error}")

def clear_spam():
    try:
        spam = (service.users().messages()
                .list(userId="me", q="in:spam").execute())
        
        messages = spam.get("messages", [])
        spam_count = spam["resultSizeEstimate"]
        if messages:
            print(f"There are {spam_count} emails to be deleted.")
            user_confirmation = input(f"Are you sure you want to delete "
                                      f"selected emails? y/n: ")
            if user_confirmation.capitalize() == "Y":
                print("Deleting emails in Spam.")
                for message in messages:
                    (service.users().messages()
                     .delete(userId="me", id=message["id"]).execute())
                print("Emails in Spam deleted!")
        else:
            print("Spam is empty or has been cleared! already")
    except HttpError as error:
        print(f"An error occurred: {error}")

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

def trash_categories():
    try:
        query = "category:promotions OR category:social"
        all_messages = []
        display_next_page(all_messages, query)

        if len(all_messages) == 0:
            print(f"Categories are empty.")

        else:
            message_count = len(all_messages)
            print(f"There are {message_count} in promos and social")
            user_confirmation = input(f"Are you sure you want to trash "
                                      f"selected emails? y/n: ")
            if user_confirmation.capitalize() == "Y":
                print(f"Trashing emails in promos and socials.")
                for i in all_messages:
                    (service.users().messages()
                     .trash(userId="me", id=i["id"]).execute())
                print("Emails trashed!")

    except HttpError as error:
        print(f"An error occurred: {error}")
    

def trash_emails_in_category(name, query):
    try:
        all_messages = []
        display_next_page(all_messages, query)

        if len(all_messages) == 0:
            print(f"Category {name} is empty.")

        else:
            message_count = len(all_messages)
            print(f"There are {message_count} in {name}")
            user_confirmation = input(f"Are you sure you want to delete "
                                      f"selected emails? y/n: ")
            if user_confirmation.capitalize() == "Y":
                print(f"Deleting emails in {name}.")
                for i in all_messages:
                    (service.users().messages()
                     .trash(userId="me", id=i["id"]).execute())
                print("Emails deleted!")

    except HttpError as error:
        print(f"An error occurred: {error}")


def select_category():
    CATEGORIES = [
        {"name": "Promos", "query": "category:promotions"},
        {"name": "Social", "query": "category:social"},
        {"name": "Updates", "query": "category:updates AND in:inbox"}
    ]

    CATEGORY_OPTIONS = (f"1. Promos\n"
                    f"2. Social\n"
                    f"3. Update\n"
                    f"4. Exit\n")
    print(CATEGORY_OPTIONS)
    try:
        user_choice = int(input("Please select a category: "))

        if user_choice == 1:
            trash_emails_in_category(CATEGORIES[0]["name"], CATEGORIES[0]["query"])
        elif user_choice == 2:
            trash_emails_in_category(CATEGORIES[1]["name"], CATEGORIES[1]["query"])
        elif user_choice == 3:
            print(f"Updates typically contain some important messages."
                  f"It is highly advised you move/save said messages before proceeding.")
            
            confirmation = input("Would you like to proceed? y/n: ")

            if confirmation.capitalize() == "Y":
                trash_emails_in_category(CATEGORIES[2]["name"], CATEGORIES[2]["query"])
            else:
                print("Returning to category select.")
        elif user_choice == 4:
            print("Returning to main selection.")
        else:
            print("Choose a valid option! T.T")

    except (HttpError, TypeError) as error:
        print(f"An error occurred: {error}")

def main():
    user_input = ""
    while user_input != 5:
        menu_options()
        user_input = get_user_input()
        if user_input == 1:
            trash_categories()

        elif user_input == 2:
            select_category()

        elif user_input == 3:
            count_spam()
            clear_spam()

        elif user_input == 4:        
            count_trash()
            clear_trash()

        elif user_input == 5:
            print("Bye bye!")
            
        else:
            print("Please select a valid option! T.T")
        time.sleep(3)
        os.system('cls' if os.name == 'nt' else 'clear')


if __name__ == "__main__":
    main()