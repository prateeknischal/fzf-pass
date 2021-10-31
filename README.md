# pass fuzzy finder

A [pass](https://www.passwordstore.org/) extension to fuzzy search passwords
using [fzf](https://github.com/junegunn/fzf).

## Description

`pass ff` supercharges `pass` password finder by using fuzzy search using `fzf`
and then copying it to the clip board ready to rock if a single match is found.
In case more than one matches are found, it will present the list of passwords
that matches using the `fzf` UI and the required one can be selected which will
then be copied to the clip board.

## Usage

```bash
pass ff 0.0.1 - A pass(1) extension that provides fuzzy
        search on the password list using fzf(1)

Usage:
pass ff [-h] [-nc] [pass-name]
    Provide the capability of fuzzy search from the password list
    using fzf(1).

Options:
    -n, --no-copy   Print the password instead of writing to clipboard
    -v, --version   Print the version and exit
    -h, --help      Print this help message and exit
```

## Examples and screenshots

```bash
$ pass ff example
```
[![asciicast](https://asciinema.org/a/448380.svg)](https://asciinema.org/a/448380)

## Installation

### Requirements
* [`fzf`](https://github.com/junegunn/fzf)

```bash
$ cd /tmp
$ git clone https://github.com/prateeknischal/fzf-pass.git
$ cd fzf-pass
$ cp ff.bash ~/.password-store/.extensions/ff.bash

# In case the extensions are not enabled,
$ echo "export PASSWORD_STORE_ENABLE_EXTENSIONS=yes" >> ~/.bash_profile
$ source ~/.bash_profile
```
