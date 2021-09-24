# Name and Forget

This script allow you to give folder structure and tags into your filename.
It will move it after the structure is created.


File names must accord to 
    @context=folder1=folder2=folder3#(tag1)#(tag2).txt

which lead to the structure

└── context

    └── folder1

        └── folder2

            └── folder3

                └── 2021
                
                    └── @context=folder1=folder2=folder3#(tag1)#(tag2).txt

tag is needed https://github.com/jdberry/tag

The final name is the current name of the file : the goal is to have access to **path** and **tags** in name.
