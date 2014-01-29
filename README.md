# RetroarchPhoenix


##Rebirth of a desktop U.I. ![Icon](https://raw.github.com/Druage/RetroarchPhoenix/master/resources/images/phoenix.png) 



This is a "rebirth" of the RetroArch Phoenix project that was deprecated. 
This is to provide RetroArch with an all-in-one graphical interface that focuses on desktop use. 
RGUI is a great interface for your console and t.v. This project is so far a clone of the 
[OpenEmu](http://openemu.org/) frontend. Please show support for their hard work. 
This project will provide a lot of the functionality that they have provided, and more. 
Furthermore, this project is not affiliated with the official 
[RetroArch](https://github.com/libretro/RetroArch) developers. 
However I did like the Phoenix part. You can contact me at Druage@gmx.com.

To run this program you need [Python 3.3](http://www.python.org/download/releases/3.3.3/) installed and [PyQt 5.2](http://www.riverbankcomputing.com/software/pyqt/download5), ~~<b>5.1</b> may work though.~~ <i>You need 5.2 for QtQuick.Layouts.</i>
Then just run the main.py. I am still ironing out the bugs and I have only tested this latest build on Windows 8.1, I will test it for Linux in a few days

~~Also for win32 users, place a retroarch-megapack in the root directory and rename it to retroarch_v1.0~~ <i>Not needed anymore.</i>

###Things that still need to be completed.

~~1. Qml Signals need to be directed to C++ or Python~~ Solved.

~~2. Make search bar filter data models.~~ Solved.

3. Have game artwork scrubber work.
4. Make shader button work.
5. Make Rating system work.
6. Work on sold theme. I'm currently working on that.

###Future Goals:
1. Add advanced settings. <i> Currently in development. </i>
2. Have RetroArch pass OpenGL video and sound to QML Window.
2. Get some sleep.
