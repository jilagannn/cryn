# C.R.Y.N

## Commands-Run-You-Nap

C.R.Y.N. is a set of bash scripts I came up with to deal with recurring directory setups for projects or assignments.

## Lineup

### choncc.sh

A script written to create Express.js applications, installing the required build dependencies and dev dependencies, and creating the API project structure. This script also configures jest.config.js for jest testing and the scripts for package.json.

### styling.sh

A separate shell script file that contains several escape codes for text formatting and styling.

## How To Use

1. **Clone the repository into a directory.**

    ```bash
    git clone git@github.com:jilagannn/cryn.git
    ```

    or

    ```bash
    git clone https://github.com/jilagannn/cryn.git
    ```

2. **Navigate to the directory you want to use the script in.**

    ```bash
    cd path/to/target/directory
    ```

3. **Execute the script:**

    ```bash
    ./scriptname.sh
    ```

    example:

    ```bash
    ./choncc.sh
    ```

## Programs needed

### gh cli

1. Check if installed:

    ```bash
    gh --version
    ```

2. If nothing, install here:

    ```plaintext
    https://cli.github.com/
    ```

### Node.js / NPM

1. Check of installed:

    Npm:

    ```bash
    npm --v
    ```

    Node:

    ```bash
    node -v
    ```

2. If nothing, install here:

    ```plaintext
    https://nodejs.org/en
    ```

### jq

1. Check if installed:

    ```bash
    jq -V
    ```

2. If nothing, install here:

    ```plaintext
    https://jqlang.org/download/
    ```
