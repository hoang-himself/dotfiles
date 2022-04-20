#!/bin/sh

echo '1. Copy the runcoms you need into ".devcontainer" folder'
echo 'Example: Copy "bash_aliases" to ".devcontainer/bash_aliases"'
echo '2. Make ".bashrc" source this file'
echo 'YOU MUST USE ABSOLUTE PATH HERE'
echo 'Example: RUN echo "[ -f /workspace/.devcontainer/bash_aliases ] && . /workspace/.devcontainer/bash_aliases" >>~/.bashrc'
echo 'You can copy the contents to "$HOME" too, but you will have to rebuild the container every time you update the runcoms'
