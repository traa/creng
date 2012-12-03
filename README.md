Creng 0.3.5
=====

###Ruby gem for simple chrome extension development###

The aim of project to make development of chrome extensions more simple, giving to user time-tested tools and development patterns.
It includes last versions of following frameworks/libs:
 * RequireJS
 * Underscore.js
 * jQuery
 * Cajon


[Installation](https://github.com/traa/creng/wiki/Installation)



### Usage ###

Project initialization
------------
    creng init <projectname>
This command creates dir with name of <projectname> and generates skeleton of application by creatin in it files, needed for first build of extension. 
Also, it fetches last versions of libraries, needed to correct work of extension. So now, you can start your development in **dev** folder.



Project build
------------
    creng build
Must be executed in root of <projectname> folder. It builds entire project to **build** folder, executing following actions:
 * Automatically managing frameworks dependencies (vendor/content folder frameworks will be added to content scripts in manifest file, vendor/background to background file (if it exists), vendor/ - to both)
 * Auto-wrap code into define statements (no more same code constructions needed for work of RequireJS)
 * Creng keeps an eye on "web_accessible_resources" for you (automatically manage it, so no more routine with writing all files)
 * Easy background page management, just remove it and creng will build extension without it. Want to use [event](http://developer.chrome.com/extensions/event_pages.html) background page? Simply rename background_persistent.html to background.html and build it!
 * Tracking of build version, auto-incrementation after every build x.x.x.buildversion
 * Handling of options page, just create **options.html** in **html** folder to start working with it.
 * And more to come! It's just an early version of gem, so i plan to constantly increase number of features
