# C.R.Y.N

## Commands-Run-You-Nap

C.R.Y.N. is a set of bash scripts I came up with to deal with recurring directory setups for projects or assignments, or daily tasks I am too lazy to do.

## Features

### choncc.sh

A script written to create Express.js applications, installing the required build dependencies and dev dependencies, and creating the API project structure. This script also configures jest.config.js for jest testing and the scripts for package.json.

### burno.py

A script written that utilizes Google's gmail api to trash and delete selected emails, primarily in the promotions, social, and updates categories.

### styling.sh

A separate shell script file that contains several escape codes for text formatting and styling.

## Requirements

Before you actually use these scripts yourself, please make sure to have these installed:

- **Node.js:** LTS version recommended. You can download it from [nodejs.org](https://nodejs.org/).
- **npm:** (installed with Node.js)
- **gh cli:** GitHub CLI. You can download it from [cli.github.com](https://cli.github.com/) if not installed.
- **jq:** SED for JSON data. You can install it from here at [jqlang.org](https://jqlang.org/download/)
- **python:** Programming language. Download from here (preferably stable release) at [python.org](https://www.python.org/downloads/source/)

## Installation

1. **Clone the repository into a directory.**

    ```bash
    git clone git@github.com:jilagannn/cryn.git
    ```

    or

    ```bash
    git clone https://github.com/jilagannn/cryn.git
    ```

### Extended

1. **For scripts that use python, make sure to set your current directory as the cloned repository.**

    ```bash
    cd path/to/cryn
    ```

2. **Initialize a python virtual environment.**

    ```bash
    python3 -m venv .venv
    ```

3. **Activate virtual environment.**

    ```bash
    # bash
    source .venv/bin/activate
    ```

4. **Install requirements with pip.**

    ```bash
    pip install -r configs/python-venv/requirements.txt
    ```

## Usage

### choncc

1. **Navigate to the directory you want to use the script in.**

    ```bash
    cd path/to/target/directory
    ```

2. **Execute the script.**

    Reference the path to the script in your current working directory:

    ```bash
    path/to/script/scriptname.sh
    ```

    example:

    ```bash
    home/user/Documents/cryn/scripts/choncc.sh
    ```

### burno

To use burno, you must generate an OAuth 2.0 client id with google cloud:

1. **Follow the steps provided:**

    - OAuth 2.0 client id generation at [google.com](https://developers.google.com/workspace/guides/create-credentials#oauth-client-id).

2. **Download your client id secret and rename it to "credentials.json"**

3. **Move your credentials.json into configs/gmail/:**

    ```bash
    # example path
    /home/user/Documents/cryn/configs/gmail/your-credentials.json
    ```

After creating one, the script should be ready for use:

1. **Ensure your current working directory is in cryn.**

    ```bash
    # bash
    pwd #Output: home/user/path/to/cryn or something similar
    ```

2. **Execute the script:***

    ```bash
    python3 scripts/burno.py
    ```

3. **Login through google SSO and allow access (should only be one time until generated token expires).**

4. **Follow the prompts.**
