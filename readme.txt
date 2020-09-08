Head start
==========

This library contains the framework for web application.

The sample directory contains a simple demo of how you make an dart web application with this library.
To run this:
 1) Create and launch a "Dart commandline launch" where:
    - Dart script is example/server.dart
    - Working directory is <your-instalation>/example
    
 2) Create and launch a "Dartium launch" where:
    - Launch target url is "http://127.0.0.1:8080/" 

The sample application expects the example directory to be top-level for server


Using the library
=================
This library is a classic MVC framework to make single page apps and it makes use of webcomponents
especially custom elements and html imports (http://webcomponents.org).

The basic layer is Controller, ObjectStore and View where the view gets updates from the ObjectStore and
when input changes in the View it is written back to the ObjectStore. Event from the user is sent to the
Controller, which provide handles that react on these events.
Beside the MVC components 2 other elements exists namely EventBus, Address and Rest. Controllers har hook the
EventBus, so controllers can publish events and listen for events from toher controllers. The Address object
is a singleton which listen to changes in the browsers location object and publishes them on the Eventbus.
Controllers can also change the location via the Address object and there by control the flow off the
client.

The library also has standard implementation of List view from where you can delete items on the list, create
new items and edit an item. DefaultListCtrl, DefaultListView, DefaultDetailCtrl and DefaultDetailView provide
provide basis for the functionality.

The view part are snippets of html which managed at use user defined hook in the main html file (index.html).
To make these snippets available for the framework html imports are used. In the head section use:
   <link id="PersonListImport" rel="import" href="/view/PersonList.html">

To integrate the view with the ObjectStore custom elements is used and they are:

<table is='x-table' ...>
<th is='x-th' link='' type='date|datetime|time|decimal|integer|boolean' decimals='' sortable ...>
<input is='x-input' x-type='date|datetime|time|decimal|integer|boolean' decimals='' ...>
<select is='x-select' optioname='' ...>
<textarea is='x-textarea' ...>
<div is='x-list' ...>
<form is='x-form' ...>

See example on how to use them

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


