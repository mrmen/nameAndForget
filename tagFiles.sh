#!/bin/bash
#OIFS="${IFS}"
#IFS="\n"

function check(){
    if [[ $1 = $2 ]];then
        return 0
    else
        return 1
    fi
}

function debug(){
    return 0
}

function debugFalse(){
    return 0
}

cd $1
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
    folders=$(echo $file | sed 's/@[^=]*\([^\+(]*\).*/\1/g; s/=/\//g')
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
    taglist=$(echo $file | sed 's/[^(]*\(([^#]*)\)#.*/\1/g')
    while [[ $taglist == *"("* ]]
    do
        currentTag=$(echo $taglist | sed 's/(\([^)]*\)).*/\1/g')
        debug $currentTag
        tag -a $currentTag $file
        taglist=$(echo $taglist | sed 's/([^)]*)\(.*\)/\1/g')
    done
done

cd -

#IFS=$OIFS