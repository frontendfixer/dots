For Linux

On the old machine:

code --list-extensions > vscode-extensions.list
On the new machine:

cat vscode-extensions.list | xargs -L 1 code --install-extension
