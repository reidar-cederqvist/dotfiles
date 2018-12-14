#!/bin/bash

mkdir -p ~/.config/powerline
cat <<-'EOF' > ~/.config/powerline/config.json
{
    "ext": {
        "shell": {
            "theme": "default_leftonly"
        }
    }
}
EOF
powerline-daemon --replace 
