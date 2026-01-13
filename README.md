# profile.bash

Personal macOS-friendly Bash profile that sets up colour helpers, a rich prompt, shortcuts, and a few fun extras for everyday development.

![screenshot](assets/screenshot.png)

## Highlights

- Prompt with command duration, exit status, git branch, and virtualenv awareness (`prompt.bash`).
- Colour palette exports and background helpers for scripts (`colour.bash`).
- Quality-of-life aliases for macOS, Python, Git, Node.js, and Homebrew workflows (`alias.bash`, `path.bash`).
- Handy functions, including `config` for editing dotfiles and the daily `onthisday` easter egg (`functions.bash`).
- Optional Java/C build helpers and OpenGL runners (`compile.bash`).

## Requirements

- Bash 5+ (default on macOS 12+, works elsewhere with minor tweaks).
- Common BSD userland tools (`grep`, `sed`, `perl`) and optional extras: `neofetch`, `tree`, `gcc`, `javac`.
- macOS Terminal (or iTerm) if you want the bundled `Mariana.terminal` theme.

## Quick Start

```bash
PROFILE=~/github/profile.bash
git clone https://github.com/mightbesimon/profile.bash.git "$PROFILE"

# Optional: apply the matching terminal theme
open "$PROFILE/assets/Mariana.terminal" 2> /dev/null

# Silence the login message and source the profile
touch ~/.hushlogin
[ -f ~/.bash_profile ] || touch ~/.bash_profile
printf '\nexport PROFILE=%s\nsource "$PROFILE/profile.bash"\n' "$PROFILE" >> ~/.bash_profile
source ~/.bash_profile
```

That will reload your shell with the new prompt, colours, and aliases. Use a different `PROFILE` path if you prefer another location.

## Updating & Removal

- Pull the latest changes at any time with `update` (alias for `git -C $PROFILE pull`).
- To remove the profile, delete the clone and remove the `PROFILE` lines from `~/.bash_profile`. There is also an `install/uninstall.bash` script if you prefer an automated cleanup.

## Customising

- Edit `alias.bash` or `functions.bash` to add your own shortcuts.
- Adjust environment variables, default editors, or prompt pieces in `profile.bash` and `prompt.bash`.
- Add language-specific paths in `path.bash`; Homebrew and common IDEs are pre-configured.

## Repository Layout

```
profile.bash/           Main entry point sourced from your shell
alias.bash              Aliases and shell helpers
colour.bash             ANSI colour exports
compile.bash            Optional compile/run helpers for C/Java/OpenGL
functions.bash          Utility functions (`config`, `onthisday`, etc.)
path.bash               PATH and Homebrew environment setup
prompt.bash             Prompt rendering and timing hooks
install/                Simple install/uninstall scripts
assets/                 Screenshot, terminal theme, colour notes
```

Enjoy the prompt! PRs and tweaks welcome.
