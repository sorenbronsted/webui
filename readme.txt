This library contains the framework for web application at UFDS.
To use it get it with composer and make a symlink from your dart client to the webui directory.

The sample directory contains a simple demo of how you make an dart web application with this library.
To run this:
 1) Create and launch a "Dart commandline launch" where:
    - Dart script is sample/server.dart
    - Working directory is <your-instalation>/sample
    
 2) Create and launch a "Dartium launch" where:
    - Launch target url is "http://127.0.0.1:8080/" 
    - Source location is "/libwebui"
 
The sample application expects the sample directory to be top-level for server
