# uc

A simple text-based way to keep track of useful commands. All this script does is read from a text file that contains a list of useful commands.

## TODO

Category matching is bugged right now and doesn't work.

## Usage

```shell
# Print entire text file
uc
# Print first line that contains the search as a substring
uc <search>
# Print first category that contains the search as a substring within the category name
uc -c <search>
```

Matching is only case-sensitive if `<search>` contains a capital.

## Useful commands list format

The format is a text document. The commands are sorted by category. Within the category, each command has its own line and has the following format:

- Starts with a TAB
- Short description of command
- Some more TABs for padding
- The command itself

```text
Category A
    Description of command A1:          do-command-a1
    Description of command A2:          do-command-a2 -o /path/to/output

Category B
    Description of command B1:          do-command-b1 start --rightnow -Abc
```

## Where to store your useful commands list

The script checks in the following locations, ordered by priority:

1. $XDG_DATA_HOME/uc/useful_commands
2. /home/$USER/.local/share/uc/useful_commands
3. /home/$USER/.useful_commands
4. /home/$USER/useful_commands
