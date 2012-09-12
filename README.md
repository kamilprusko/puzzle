# Puzzle!

A jigsaw puzzle game intended for more demanding players :-)

[![](http://kamilprusko.org/files/puzzle/puzzle-main-window-small.png)](http://kamilprusko.org/files/puzzle/puzzle-main-window.png)


### Features

  * Piece snapping
  * You can connect *wrong* pieces together and detach with Right Mouse Button


### Dependencies

  * [GTK+](http://www.gtk.org/) at least 3.0.0
  * [Clutter](http://www.clutter-project.org/) at least 1.0
  * [Vala](http://live.gnome.org/Vala) at least 0.15
  * [Python](http://www.python.org) (for compilation only) at least 2.6


### Install

To install, run

    ./waf configure --prefix="/usr"
    ./waf build
    sudo ./waf install --progress

You can change installation prefix by adding --prefix=... option to
configure.

You can change destdir by adding --destdir=... option to install.

See ./waf --help for complete list of options.


Compiler selection

Note that if you are compiling on win32, WAF will look for MSVC
(MicroSoft Visual C) by default and give up on finding a C/C++
compiler if not found.  If you do not have MSVC installed but instead
have MinGW or CygWin GCC, you have to tell WAF to look for GCC in the
configure stage:

1. waf configure --check-c-compiler=gcc --check-cxx-compiler=g++

