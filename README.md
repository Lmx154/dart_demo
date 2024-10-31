# Dart Demo website

# Linux install for Dart + Flutter
This guide is for installing Dart and Flutter on a Linux machine. The guide is for Fedora 40. Things such as package managers and path variables may differ on other distributions, but the general steps should be the same.
## 1. Download the latest version of Flutter SDK from the official website.
## 2. Download Flutter + Dart dependencies.(Fedora 40)
```sudo dnf install -y git curl unzip xz zip mesa-libGLU```
## 3. Extract the downloaded file to a directory of your choice. (Preferably /opt/)
```sudo tar xf ~/Downloads/flutter_linux_3.24.4-stable.tar.xz -C /opt/```
## 4. Add the Flutter binary to your PATH.
```export PATH="$PATH:/opt/flutter/bin"```
## 5. Run the following command to check if Flutter is installed correctly.
```flutter doctor```
