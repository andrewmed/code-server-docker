#wget https://github.com/microsoft/vscode-cpptools/releases/download/1.4.1/cpptools-linux.vsix
docker build -t code-server-docker --build-arg "UID=$(id -u)" --build-arg "USERNAME=$(whoami)" .
