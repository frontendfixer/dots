#For Linux - on the old machine:

codium --list-extensions > vscode-extensions.list
On the new machine:

cat vscode-extensions.list | xargs -L 1 codium --install-extension
