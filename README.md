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
## 6. Install Flutter Linux Dependencies.
```sudo dnf install ninja-build cmake clang gtk3-devel```

# Running website
## 1. Clone the repository.
```git clone https://github.com/Lmx154/dart_demo_web.git```
## 2. Open your IDE/ Editor in the project directory.
```zed .``` or ```code .```
## 3. Run the following command to start the web server.
```flutter run -d web-server```
