#! /usr/bin/bash



printf "Git auto script VERSION 1.0.0\n"
sleep 1
printf "Starting..\n"
sleep 1
python_file=$(printf "#! /usr/bin/python3\n\n\nuser_input=input()\n\nprint(user_input)\n" > "tmp_file")
chmod 744 "tmp_file"
printf "Checking if system requirements are met\n"
sleep 1
result=$(whereis git) 

if [ "$result" == "git:"  ] 
then
    printf "Git is not installed!!\n"
    sleep 1
    printf "Starting installation\n"
    sleep 1
    sudo apt-get install git 
elif [ "$result" != "git:" ]
then
    printf "Git is already installed!!\n"
    sleep 1
fi 

printf "Starting configuration..\n"
sleep 1
printf "I need your username and your email\n"
sleep 1
printf "username:"
python3 "tmp_file" > "name.txt"
printf "email:"
python3 "tmp_file" > "email.txt"
sleep 1
printf "Checking  your name and your email..\n"
if [ "$(cat name.txt)" !=  "" ] && [ "$(cat email.txt)" !=  "" ]
then 
    printf "Starting configuration...\n"
    git config user.name "$(cat name.txt)"
    git config user.email "$(cat email.txt)"
    printf "Done!!\n"
    sleep 1 
    rm -rf "email.txt" "name.txt"
    printf "You want to select a specific editor for github interaction?\n"
    read -p "" editor
    if [ "$editor" == ${editor^^} ]
    then
        $editor = ${editor,,}
    fi 
    if [ "$editor" == "yes" ] 
    then 
        users_editor=$(printenv | grep $EDITOR) 
        if [ "$users_editor" == "" ]
        then
            printf "No editor detected at your env variables\n"
            printf "You want to set the editor for your default session\n"
            read -p ""variable
            if [ "$variable" == ${variable^^} ]
            then
                variable=${variable,,}
            fi
            if [ "$variable" == "yes" ]
            then
                printf "Type the editor you want(nano,vim,codium or code(vs studio))\n"
                read -p ""select_editor
                if [ "$select_editor" != "nano" ] || [ "$select_editor" == "vim" ] || [ "$select_editor" != "codium" ] || [ "$select_editor" != "code" ]
                then 
                    printf "Unsupported editor type...\n"
                    sleep 1 
                    printf "Exiting\n"
                    exit 0
                else
                    export $EDITOR=$select_editor
                    printf "Editor has been set for this session"
                    printf "Configuring your editor for github..."
                    git config core.editor $(printenv | grep $EDITOR) 
                    sleep 1 
                fi 
            fi
        fi
    else
        printf "Default editors are(vim,nano)\n"
        sleep 1
    fi 
     
    printf "Starting main_menu..\n"
    sleep 1 
    while true
    do
        printf "Main_menu\n"
        printf "Type 1 to get info about a github user(interaction with gitapi)\n"
        printf "Type 2 to start a local repo\n"
        printf "Type 3 to add file in your local repo\n"
        printf "Type 4 to commit changes....\n"
        printf "Type 5 to remove files from your local repo\n"
        printf "Type 'q' to exit!!\n"
        read -p "Type:" answer
        if [ "$answer" == "1" ]
        then 
            printf "Type the user you want to get info from git...\n"
            sleep 1 
            read -p "" user_name
            if [ "$user_name" != "" ]
            then 
                wget api.github.com/users/$user_name
                printf "File saved!!\n"
                sleep 1
                printf "Extracting info...\n"
                sleep 1
                touch "json_to_text"
                login=$(cat $user_name | jq -r .login)
                name=$(cat $user_name | jq -r .name)
                email=$(cat $user_name | jq -r .email)
                bio=$(cat $user_name | jq -r .bio)  
                company=$(cat $user_name | jq -r .company) 
                followers=$(cat $user_name | jq -r .followers)
                public_repos=$(cat $user_name | jq -r .public_repos)
                updated_at=$(cat $user_name | jq -r .updated_at)
                printf "Login:$login\nName:$name\nEmail:$email\nBio:$bio\nCompany:$company\nFollowers:$followers\nRepos(public):$public_repos\nUpdated:$updated_at\n"
                sleep 5
            fi 
        elif [ "$answer" = "2" ]
        then
            printf "Type the name for your local project\n"
            read -p "" local_repo
            sleep 1 
            mkdir $local_repo
            printf "Local repo created!!\n"
            sleep 1
            git init $local_repo
            printf "Type the url of your remote repo(it should end in .git)\n"
            read  -p "" remote_repo
            for i in $remote_repo
            do
                if [ "$(printf  "$i"  | tr "." " "| grep git$)" == "" ]
                then 
                    printf "Error...\n"
                    printf "Exiting\n"
                    sleep 1
                    exit 0
                fi 
            done                
            printf "Cloning your repo...\n"
            printf "Type your remote_repo name:"
            read -p "" remote_repo_name
            sleep 1
            git clone $remote_repo
            char="/"
            mv $remote_repo_name $local_repo
            if [ -d "$local_repo""$char""$remote_repo_name" ]
            then
                printf "Cloned repo moved in to your path.."
                sleep 1
                printf "Done\n"
                sleep 1
                continue
            else
                printf "Error\n"
                printf "Exiting...\n"
                sleep 1
                exit 0 
            fi 
        elif [ "$answer" == "3" ]
        then
            printf "File path:"
            read -p "" file_path
            if [ "$file_path" == "" ]
            then
                printf "No file selected\n"
                sleep 1
                printf "Returning to main_menu\n"
                sleep 1
                continue
            else
                if [ -f "$file_path" ]
                then
                    read  -p "Cloned repo path:" project
                    cp $file_path $project
                    printf "File copied to your local repo\n"
                    sleep 2
                    printf "Adding your file to local repo\n"
                    sleep 1
                    cd $project && git add $filename .
                    sleep 1
                    continue
                else 
                    printf "File doesnt exist...\n"
                    continue
                fi
            fi
        elif [ "$answer" == "4" ]
        then
            printf "Commiting changes...\n"
            sleep 1
            printf "Commit description:"
            read -p "" commit_description
            if [ "$commit_description" == "" ]
            then
                printf "I need a decription to commit the changes...\n"
                sleep 1
                printf "No changes made!!\n"
                sleep 1
                continue 
            else
                printf "File name:"
                read -p "" filename
                git commit -m $commit_description $filename

                sleep 2
                printf "Push changes to your remote repo(type yes or no):"
                read -p "" yes_or_no
                if [ "$yes_or_no" == "no" ]
                then
                    printf "ok..\n" 
                    sleep 1
                    continue
                else
                    printf "Adding remote repo...\n"
                    printf "Type remote repo url:"
                    read -p "" remote_url
                    sleep 1 
                    git remote add main $remote_url
                    sleep 1
                    git push origin main
                    sleep 1

                    continue
                fi
            fi
        elif  [ "$answer" == "5" ] 
        then
            printf "Which file you want to remove from your local repo?\n"
            read -p "" file_to_remove
            printf "Cloned repo absolute path:\n"
            read -p "" path
            cd $path && git rm  $file_to_remove
            read -p "Commit description:" description
            printf "Commiting changes..."
            sleep 1
            directory=$(pwd)
            if [ "$directory" !=  "$path" ]
            then
                cd $path
            fi
            git commit -a -m $description
            git push
            sleep 2
            printf "Removed!!"
            sleep 2
            continue 
        elif [ "$answer" == 'q' ]
        then
            printf "Exiting...\n"
            sleep 2
            exit 0
        else 
            printf "Wrong value...\n"
            sleep 1 
            continue 
        fi
    done 
else
    printf "Error exiting...\n"
    sleep 1 
    exit 0
fi 

rm -rf tmp_file email.txt name.txt
