# C.R.Y.N

## Commands-Run-You-Nap

C.R.Y.N. is a set of bash scripts I came up with to deal with recurring directory setups for projects or assignments.

## Features

### choncc.sh

A script written to create Express.js applications, installing the required build dependencies and dev dependencies, and creating the API project structure. This script also configures jest.config.js for jest testing and the scripts for package.json.

### styling.sh

A separate shell script file that contains several escape codes for text formatting and styling.

## Requirements

Before you actually use these scripts yourself, please make sure to have these installed:

- **Node.js:** LTS version recommended. You can download it from [nodejs.org](https://nodejs.org/).
- **npm:** (installed with Node.js)
- **gh cli:** GitHub CLI. You can download it from [cli.github.com](https://cli.github.com/) if not installed.
- **jq:** SED for JSON data. You can install it from here at [jqlang.org](https://jqlang.org/download/)

## Installation

1. **Clone the repository into a directory.**

    ```bash
    git clone git@github.com:jilagannn/cryn.git
    ```

    or

    ```bash
    git clone https://github.com/jilagannn/cryn.git
    ```

## Usage

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
