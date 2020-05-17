Simple plasmoid to show i3 workspaces.

```
$ mkdir build
$ cd build
$ cmake -DCMAKE_INSTALL_PREFIX=`kf5-config --prefix` -DCMAKE_BUILD_TYPE=Release -DLIB_INSTALL_DIR=lib -DKDE_INSTALL_USE_QT_SYS_PATHS=ON ../
$ make
$ sudo make install
```

You may need to install `extra-cmake-modules`

Testing:
```
$ kquitapp plasmashell
$ plasmashell &
```
