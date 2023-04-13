# new project

## note
- this can be done many different ways. I'm just documenting what I have configured...feel free to install devkitpro on windows if you don't want to bother with a vm for example. my setup involves 3 parts:
    1. a debian linux box with the devkitpro toolchain installed that is respoonsible for compiling the code
    2. my windows pc that connects with visual studio code over a remote ssh session to write code on the linux box
    3. an smb share accessible by my buildscripts to move assets around (the rom artifact, art, music files, etc)

- `$butano_lib$` refers to the path to the butano library is on your disk
- `$working_dir$` refers to the directory where your rom's code will be
- give the linux vm a lot of cores if you are virtualizing, cmake likes that


## want to start making a rom? here's what you gotta do to get something that compiles.
### the following steps are executed on the linux vm
0. install the pre-reqs (git, devkitpro toolchain, etc) - [read this](https://gvaliente.github.io/butano/getting_started.html)
1. clone the `butano` repo to a directory
    ```
    git clone https://github.com/GValiente/butano $butano_lib$
    ```
2. create a working directory to develop your rom in and cd into it
    ```
    mkdir $working_directory$
    cd $working_directory$
    ```
3. copy the `template` folder in from the butano repo into your working directory
    ```
    cp -r $butano_lib$/template/. $working_directory$
    ```
4. open the `Makefile` and...
    - set `LIBBUTANO` to the path to the butano folder INSIDE your butano dir: `$butano_lib/butano` - its got to be the folder with `butano.mak` in it
    - set `ROMTITLE` to whatever you want
5. compile (the number after `j` refers to the number of cpu cores you are giving cmake - give that mf a lot)
    ```
    make -j4
    ```
6. you can then copy that rom to the device you want to run it on, install `mgba` emulator, and run it with `mgba out.gba`

this compiles the template... but lets do a bit more while we are here and add the non-library included, but still necessary stuff

7. bring over the `butano/common` stuff into your project
    - graphics: 
        ```
        cp -r $butano_lib$/common/graphics/. $working_directory$/graphics
        ```
    - c++ headers: 
        ```
        cp -r $butano_lib$/common/include/. $working_directory$/include
        ```
    - c++ files:
        ```
        $ cp -r $butano_lib$/common/src/. $working_directory$/src`
        ```

8. [on your windows dev box] connect vs code to the linux vm thru remote-ssh session

lets configure vs code so it doesn't go crazy with errors

9. in vs code `> c/c++: edit configurations (json)` to gen a vs code c++ config file
10. open `.vscode/c_cpp_properties.json` and replace its contents with:
```
{
    "configurations": [
        {
            "name": "Linux",
            "includePath": [
                "${workspaceFolder}/src/**",
                "${workspaceFolder}/build/**",
                "${workspaceFolder}/include/**",
                "/home/ben/gbadev/butano_lib/butano/include/**",
                "/home/ben/gbadev/butano_lib/butano/src/**",
                "/opt/devkitpro/**",
                "/opt/devkitpro/libgba/include/**",
                "/opt/devkitpro/libtonc/include/**",
                "/opt/devkitpro/devkitARM/include/**",
                "/opt/devkitpro/devkitARM/arm-none-eabi/include/**"
            ],
            "defines": [
                "_DEBUG",
                "UNICODE",
                "_UNICODE"
            ],
            "browse": {
                "path": [
                    "${workspaceFolder}/src/**",
                    "${workspaceFolder}/build/**",
                    "${workspaceFolder}/include/**",
                    "/home/ben/gbadev/butano_lib/butano/include/**",
                    "/home/ben/gbadev/butano_lib/butano/src/**",
                    "/opt/devkitpro/**",
                    "/opt/devkitpro/libgba/include/**",
                    "/opt/devkitpro/libtonc/include/**",
                    "/opt/devkitpro/devkitARM/include/**",
                    "/opt/devkitpro/devkitARM/arm-none-eabi/include/**"
                ]
            },
            "cStandard": "c17",
            "cppStandard": "gnu++17",
            "intelliSenseMode": "windows-gcc-arm",
        }
    ],
    "version": 4
}
```
*note*

struggled getting this working for awhile, vs intellisense would trip out on header files. don't think everything in `includePath` or `browse` is necessary (I'll narrow that down later), the main thing ended up being `> C/C++: Change Configuration Provider` to `None`, or effectively removing that line from this file.

