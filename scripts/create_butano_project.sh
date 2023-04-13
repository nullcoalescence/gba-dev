#! /bin/bash

# verify config file exists
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
config_path="$script_dir/config"
if [ ! -f $config_path ];
then
	echo "Config file is missing!"
	echo "Create a file called 'config' at:"
	echo "$script_dir/config"
	exit -1
fi

# config
. config

# intro
echo "** butano project setup script **"

echo "!! Be sure to populate the config file"
echo $config_path

echo ""
read -p "Press [any key] to begin..."
echo ""

# find the butano root folder, then verify .makfile exists will give us a good enough idea if butano is installed
echo "Verifying butano lib exists on disk"

if [ ! -d $butano_root_dir ];
then
	echo "ERROR: 'butano_root_dir' does not exist: $butano_root_dir"
	echo "Verify the value in the config file, or clone the repo to that dir"
	exit -1
else
	echo "butano dir exists"
fi

makfile_path="$butano_root_dir/butano/butano.mak"
if [ ! -f $makfile_path ];
then
	echo "ERROR: butano_root_dir does not include .mak file"
	echo "Verify the value in the config file, or clone the repo to that dir"
	exit -1
else
	echo "butano files look good"
	echo ""
fi

# create project directory
read -p "Enter a name for the project: " proj_name
mkdir $proj_name
echo "Created $proj_name"

# copy butano template
echo "Copying butano template: $butano_root_dir/template..."
cp -r "$butano_root_dir/template/." $proj_name
echo "Copied."

# configure makefile
echo ""

rom_name=$proj_name
butano_dir="$butano_root_dir/butano"

echo "Adjusting makefile..."
echo "ROMTITLE:	$rom_name"
echo "LIBBUTANO: $butano_dir"

makefile="$proj_name/Makefile"
sed -i "s|LIBBUTANO   :=  ../butano|LIBBUTANO   :=  $butano_dir|" $makefile
sed -i "s|ROM TITLE|$rom_name|" $makefile

echo "Adjusted makefile"

# Copy over other stuff from butano
echo ""
echo "Copying over common (graphics, headers, src)..."

echo "graphics..."
cp -r "$butano_root_dir/common/graphics/." "$proj_name/graphics"

echo "header files..."
cp -r "$butano_root_dir/common/include/." "$proj_name/include"

echo "src files..."
cp -r "$butano_root_dir/common/src/." "$proj_name/src"

echo "Copied common files."

# create c_cpp_properties file for vs intellisense
echo ""
echo "Creating .vscode/c_cpp_properties.json' to configure vs code's intellisense"

echo "Creating dir"
mkdir "$proj_name/.vscode"

echo "Downloading json from github to temp dir"
#tmp_dir=$(mktemp -d)
wget -P "$proj_name/.vscode" https://raw.githubusercontent.com/nullcoalescence/gba-dev/main/configs/.vscode/c_cpp_properties.json
#cp "$tmp_dir/c_cpp_properties.json" "$proj_name/.vscode"
#rm -r $temp_dir

echo "Copied"
echo "Done"

# finished
echo "Created project!!"
echo "Complile with 'make -j#', replacing # with number of cores"
