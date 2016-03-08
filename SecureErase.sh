#!/bin/bash 
#file="/mnt/146d4d65-7f37-4fc2-98e0-bcd20c6f505c/Other/"
file=$1

#check for files
#if [ -f "$file" ]
#then
#	echo "$file file found."
#else
#	echo "$file file not found."
#fi

#echo -en "\ec" #thanks @Jonathon Reinhart.
# -e    Enable interpretation of of backslash escapes
# -n    Do not output a new line

#clear terminal
echo -en "\ec"
echo "====================================================================="
echo "				SECURE ERASE SCRIPT"
echo "====================================================================="
echo $'\n'
read -r -p "Are you sure you want to continue? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
	#Check if a directory is passed as a parameter
	if [[ $# -eq 0 ]] ; then
		echo "====================================================================="
		echo "No directory supplied"
		echo "====================================================================="
		exit 0
	fi

	if [[ $# -eq 1 ]] ; then
	#since the parameter is passed, check if the directory exits - will error if it is a file
	if [ -d "$file" ] ; then
		echo "====================================================================="		
		echo "Directory found:"
		echo "$file "
		echo "====================================================================="
		echo "Directory Contents:"
		echo $'\n'
		
		#ls -lH $1

		#numberoffiles=$(find /$1/. -exec echo {} \; | wc )
		#numberoffiles=$(find /$1/. -type f \; | wc -l)

		#count only the number of files  (this excludes the folder(s) count
		numberoffiles=$(find /$1/. -type f | wc -l)
		#(find /$1/. -type f)
		echo "number of files found: " $numberoffiles
			read -r -p "Would you like to see these file names? <y/N> " prompt
			if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]; then
				(find /$1/. -type f )
			fi
		echo "====================================================================="
		echo $'\n'

		#Verify if you want to erase these files
		read -r -p "Are you sure you want to continue? <y/N> " prompt
		if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]; then
			#find, shred and then delete all the files
			find /$1/ -type f -exec shred -vz {} \; -exec rm {} \;

			#find and then delete all the directories
			find /$1/  -exec rmdir {} \;
			#and delete the original parent directory to which you pointed
			rmdir $1
			echo -en "\ec"  #clear the terminal
			echo "====================================================================="
			echo "			SECURE ERASE HAS BEEN COMPLETED"
			echo "====================================================================="

		else
			echo "====================================================================="
			echo "			SECURE ERASE HAS BEEN ABORTED"
			echo "====================================================================="
		fi
	else
	echo "$file Directory not found."
	fi
fi

	
else
echo "Operation canceled"
exit 1
fi




#find . -exec echo {} \;



spinner()
{
    local pid=$1
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}
