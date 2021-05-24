# plenv plugin

This plugin looks for [plenv](https://github.com/tokuhirom/plenv), a Simple
 Perl version management system, and loads it if it's found.

The primary job of this plugin is to provide `plenv_prompt_info` which can be
 added to your theme to include Perl version information into your prompt.

To use it, add `plenv` to the plugins array in your zshrc file:

```zsh
plugins=(... plenv)
```

## Functions

- `current_perl`: The version of Perl currently being used.
- `plenv_prompt_info`: Displays the Perl version in use by plenv; or the global
   Perl version, if plenv wasn't found. Adding information to your prompt.
   Format: `<perl version>`.
