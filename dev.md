## dev

gba games can be written in c, or assembly... or something slightly more modern like c++. I'd like to use the hihg level c++ lib like [butano](https://github.com/GValiente/butano).

## setup
development can be done locally on windows, however it involves building with 'devkitpro', which is a bit of a hackjob on windows. I have a debian linux vm setup with this installed, and development can be done on windows in vs code thru a remote ssh session to the vm for compilation/syntax highlighting purposes.

I have a buildscript written that can execute on the linux box and
1) compile the code with cmake
2) copy the rom artifact to an smb share

then on windows I can run the rom locally with mgba
```
$ cd //devshare-smb/gba/out
$ mgba rom_out.gba
```

I'll have to document this setup process a bit better.

## todo
1) write a project setup script which...
    - creates a butano app based on the butano template
    - prompts user for rom name and other params
    - populates the make file with proper lib dirs
    - copies lib common/include/headers into project
    - generate a buildscript configured to properly compile project with max vm cores and copy artifacts to configured smb share

