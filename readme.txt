This library contains the framework for web application at UFDS.
To use it get it with pub from http://dev.ufds.lan/git/webui.git

The sample directory contains a simple demo of how you make an dart web application with this library.
To run this:
 1) Create and launch a "Dart commandline launch" where:
    - Dart script is sample/server.dart
    - Working directory is <your-instalation>/sample
    
 2) Create and launch a "Dartium launch" where:
    - Launch target url is "http://127.0.0.1:8080/" 
    - Source location is "/libwebui"
 
The sample application expects the sample directory to be top-level for server

Adressing in the client
=======================

The URL address of the browser is used to navigate the client. When the url address changes the Address instance
broadcast this change to all controllers registered on the EventBus. How the url is composed is up the developer
unless you want to use the DefaultListCtrl, -ListView, -DetailCtrl and -DetailView.

The DefaultListCtrl has the following url will active the controller:

/#list/<class-name> = lists all objects for <class-name>

The DefaultDetailCtrl has the following url will active the controller:

/#detail/<class-name>/id = edit an object with id for <class-name>
/#detail/<class-name>/new = will show an blank form for <class-name>

You can put additional arguments on the URL and make them available for the controller.


