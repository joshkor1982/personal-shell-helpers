#!/bin/bash
set -euo pipefail
# SET A NEW LINE AS AN INTERNAL FIELD SEPERATOR FOR AN ARRAY
MAIN_FUNCTION() {
IFS=$'\n'
read -p  "ENTER YOUR GITLAB NAME: " gitlab_name

# FIND ALL REPOS AND PUT THEM IN A VARIABLE
export repo_list=$(curl -s https://github.com/${gitlab_name}/ \
    | grep /"${gitlab_name}"/ \
    | grep "<a href" \
    | awk '{print $2}' \
    | sed 's/.*"\(.*\)"[^"]*$/\1/' \
    | awk -F "/" '{print $3}')
    
# PLACE THE LIST IN A NUMBERED ARRAY TO REFERENCE
repo_array=( "${repo_list}" )
echo "----------------------------------------------------------------------"
echo " REPOSITORY LIST TO CLONE"
echo "----------------------------------------------------------------------"
#PRINT THE VARIABLES STARTING WITH LINE 0
printf '%s\n' "${repo_list[@]}" | nl -v 0 -n ln
echo 
echo "ENTER (A) TO CLONE ALL REPOS"
echo "----------------------------------------------------------------------"
read -p "ENTER YOUR REPO YOU WANT TO CLONE: " selected_repo

#SELECT AN ARRAY INDEX NUMBER THAT COORESPONDS TO A REPOSITORY IN THE REPO LIST
if [[ "${selected_repo}" == "A" ]]; then
    for repo in ${repo_array[@]} ; do
        if ! command  ls | grep "${repo}" > /dev/null ; then
            git clone https://github.com/$gitlab_name/$repo
        else
            echo "REPOSITORY ALREADY EXISTS, RETURNING TO MAIN MENU"
            sleep 3
            MAIN_FUNCTION
        fi
    done
else
    git clone https://github.com/${gitlab_name}/${repo_array[${selected_repo}]}/
fi

}
MAIN_FUNCTION
