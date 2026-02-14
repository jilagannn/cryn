"""This module defines the burno script.

This module utilizes the gmail API to delete or trash emails in
categories such as Promos, Updates, Social, Spam, or Trash.
"""

__author__ = "Jheyrus Ilagan"
__version__ = "2.13.2026"

import os.path

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
    MENU_OPTIONS = (f"1. Delete all mail\n"
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
    except TypeError as e:
        print(e)

def get_labels() -> None:
    try:
        # Call the Gmail API
        results = service.users().labels().list(userId="me").execute()
        labels = results.get("labels", [])

        if not labels:
            print("No labels found.")
            return
        print("Labels:")
        for label in labels:
            print(label["name"])

    except HttpError as error:
        print(f"An error occurred: {error}")

def count_trash() -> int:
    try:
        trash = (service.users().messages()
                 .list(userId="me", q="in:trash").execute())
        trash_count = trash["resultSizeEstimate"]
        trash_message = f"Total emails in trash (estimate): {trash_count}"
        print(trash_message)
    except HttpError as error:
        print(f"An error occurred: {error}")

def clear_trash():
    try:
        trash = (service.users().messages()
                 .list(userId="me", q="in:trash").execute())
        messages = trash.get("messages", [])
        trash_count = trash["resultSizeEstimate"]
        if messages:
            print(f"There are {trash_count} emails to be deleted.")
            user_confirmation = input(f"Are you sure you want to delete "
                                      f"selected emails? y/n: ")
            if user_confirmation.capitalize() == "Y":
                print("Deleting emails in Trash.")
                for message in messages:
                    (service.users().messages()
                     .delete(userId="me", id=message["id"]).execute())
                print("Emails in Trash deleted!")
        else:
            print("Trash is empty or has been cleared! already")
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

def trash_category_emails(name, query):
    try:
        all_messages = []
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
        {"name": "Promos", "query": "category:promotions AND in:inbox"},
        {"name": "Social", "query": "category:social AND in:inbox"},
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
            trash_category_emails(CATEGORIES[0]["name"], CATEGORIES[0]["query"])
        elif user_choice == 2:
            trash_category_emails(CATEGORIES[1]["name"], CATEGORIES[1]["query"])
        elif user_choice == 3:
            print(f"Updates typically contain some important messages."
                  f"It is highly advised you move/save said messages before proceeding.")
            
            confirmation = input("Would you like to proceed? y/n: ")

            if confirmation.capitalize() == "Y":
                trash_category_emails(CATEGORIES[2]["name"], CATEGORIES[2]["query"])
            else:
                print("Returning to category select.")
        elif user_choice == 4:
            print("Returning to main selection.")
        else:
            print("Choose a valid option! T.T")

    except (HttpError, TypeError) as error:
        print(f"An error occurred: {error}")

def main():
    # get_labels()
    select_category()
    count_spam()
    clear_spam()
    count_trash()
    clear_trash()

if __name__ == "__main__":
    main()