#Pantheon


###The Rebirth of a Desktop U.I.

####The project has been moved to https://github.com/athairus/phoenix

This is a "rebirth" of the RetroArch Phoenix project that was deprecated.
This project currently serves as a RetroArch frontend, but will soon become its own Libretro implentation, with an all-in-one graphical interface that focuses on desktop use. This project draws heavy influence from the [OpenEmu](http://openemu.org/) frontend, please show them some love for their hard work if you are running OS X. 
This project will provide a lot of the functionality that they have provided, which includes supporting shaders, configuring controllers, and playing games on your favorite emulator core.

There will be two versions; one (the final version) will be our frontend that will target the Libretro api, for tight integration with the latest Qt technology. The other (current) version will be using RetroArch as a backend and will simply be a launcher. This frontend is free as in freedom and beer. If you wish to help with the frontend in any way, please feel free to contact us. This frontend is gets worked on almost daily and so features will soon be piling in.

This project is not officially supported by the Libretro Team and so please do not ask them questions about this frontend, I am happy to answer any questions that you may have.

The official version of RetroArch is located at this [site](http://www.libretro.com/). 

####How it works:

The frontend is built with [Qt 5.2.1](http://qt-project.org/downloads) and uses QML for designing the user interface and so, utilizes Javascript and C++. I use [pyotherside](http://thp.io/2011/pyotherside/) as an alternative to PyQt5 in order to provide scripting capabilities that are written in [Python 3.3](http://www.python.org/download/releases/3.3.3/). The frontend will work on Linux, OSX, and Windows.

####Things that still need to be completed:

1. Rewrite Python functions in C++
2. Add controller mapping from within the frontend.
3. Make Rating system work.

####Meet The Developers:

My name is Lee and I am the creator of this project. I go by the name of Druage and you can contact me at Druage@gmx.com.

"athairus" joined the team in early May and is currently working on UI and feature design. Contact me at (my name here) at (gmail) 

The other developer goes the name of TheCanadianBacon, and he is the reason for why this frontend is going to become its own Libretro frontend.

####Coding Style:

Since this project is written using Qt's framework, we will follow the Qt C++ Coding Style [Guide](http://qt-project.org/wiki/Qt_Coding_Style). 

Some of the differences are that else statements should be on their own line and not on the same line as a preceeding if statement.

``` c++ 
    // Wrong!
    if (x == 1) {
    } else {
    }
       
    // Right!
    if (x == 1) {
    }
    else {
    }
```
Also case blocks in switch statements should be indented 4 spaces from the switch keyword.

``` c++    
    // Wrong!
    switch(1) {
    case 1:
        doSomething();
        break;
    default;
        // ...
    }
       
    // Right!
    switch(1) {
        case 1:
            doSomething();
            break;
        default:
            // ...
    }
```
Private variables are declared with two leading underscore. While protected variables are declared with a single leading underscore.

``` c++
    // Right!
    class Library {
    
    protected:
        int _counter;
        
    private:
        int __counter;
        
    }
    
    
```

Futhermore, do not use #define statements unless you have a very good reason. Use the const keyword instead.

Lastly, instead of defining variables in camelCase, use only lowercase letters separated by a_single_space. 

Only functions are in camel case.

``` c++
    // Wrong!
    #define MAX_SIZE = 600;
    
    // Right!
    const int MAX_SIZE = 600;
    
    // Wrong! 
    int someCounter = 20;
    
    // Right!
    int some_counter = 20;
```
