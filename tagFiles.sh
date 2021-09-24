#!/bin/bash
#OIFS="${IFS}"
#IFS='\n'
# file names must accord to 
#     @job=3eme=geometry=ds=fichier#(thales)#(geometry).txt
#
# which lead to the structure
# 
# .
# ├── @job=3eme=geometry=ds=fichier#(triangle)#(tableur).txt
# └── job
#     └── 3eme
#         └── geometry
#             └── ds
#                 └── fichier
#                     └── 2021
#                         └── @job=3eme=geometry=ds=fichier#(triangle)#(tableur).txt
#
#
# and the tags tringale and tableur
#
#
# tag is needed https://github.com/jdberry/tag
#
# the final name is the current name of the file 
# the goal is to have access to path within name and to tags
#
#

function check(){
    if [[ $1 = $2 ]];then
        return 0
    else
        return 1
    fi
}

function debug(){
    return 0
    #echo $1
}

function debugFalse(){
    return 0
}

cd ~/Desktop/burn#$1
for file in *
do
    if [ -d $file ]
    then
        break
    fi
    debug "==> working on $file"
    #processe with path for storing the file
    
    debug ":: getting context"
    context=$(echo $file | sed 's/@\([^=]*\).*/\1/g')
    #verify if context exists really
    if $(check "${file}" "${context}")
    then 
        context="divers"
    fi
    debug "    $context"
    
    debug ":: getting folders"
folders=$(echo $file | sed 's/@[^=]*\([^\+(#]*\).*/\1/g; s/=/\//g')
    # verify if folders exists really
    if $(check "${file}" "${folders}")
    then 
        folders=""
    fi
    # verify if year given
    if [[ ! $folders =~ .*[0-9]{4}.* ]]
    then
        folders=$folders"/"$(date +%Y)    
    fi
    debug "    $folders"

    debug ":: getting path"
    newpath=$context$folders
    #verify if folders exists really
    debug "path is now $newpath"
    if [ -e $newpath ];then
        debug "existing"  
    else
        debug "creating $newpath"
        mkdir -p $newpath
    fi
    
    # tag part
    debug ":: processing with tags"
    taglist=$(echo $file | sed 's/[^#\]*\(#.*\)/\1/g;s/#//g')
    debug $taglist
    while [[ $taglist == *"("* ]]
    do
        currentTag=$(echo $taglist | sed 's/(\([^)]*\)).*/\1/g')
        debug $currentTag
        tag -a $currentTag $file
        taglist=$(echo $taglist | sed 's/([^)]*)\(.*\)/\1/g')
    done
    cp $file $newpath
done

#cd -

#IFS=$OIFS
