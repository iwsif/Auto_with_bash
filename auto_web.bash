#! /usr/bin/bash


printf "Welcome..\n"
sleep 1
printf "This is a script written in pure bash\n"
sleep 1
printf "Starting...\n"
sleep 1

File="python_f.py"
touch $File
chmod 744 $File
answer_file="answer.txt"
error2_file="errors.txt"
touch $File
touch $answer_file
python3=$(printf "#! /usr/bin/python3\n\n\n\n\nuser_input=input()\nprint(user_input)\n" > $File)

name=$(uname --nodename)

if [ "$name" == "parrot" ] || ["$name" == "kali" ]  || [ "$name" == "ubuntu" ]; 
then 
    printf "Debian/ubuntu system  detected..\n"
    printf "Starting installation\n"
    sleep 1
    printf "Nginx or apache \n"
    printf "Type what you want to install..\n"
    sleep 1
    python3  $File > $answer_file 
    answer=$(cat $answer_file)
    if [ "$answer" == "${answer^^}" ]
    then 
        $answer=${answer,,}
    fi

    if [ "$answer" == "nginx" ]
    
    then 
        printf "Installing nginx\n"
        sleep 1
        install=$(sudo apt-get install nginx 2> $error2_file )
        if [ "$(cat $error2_file)" != "" ]
        then 
            printf "Nginx is installed...\n"
            sleep 1 
            printf "Activating + enabling nginx..\n"
            sleep 1
            sudo systemctl start nginx
            sudo systemctl enable nginx 
        elif [ "$(cat $error2_file)" == "" ]
        then 
            printf "Installed..."
            sleep 1
            sudo systemctl start nginx 
            sudo systemctl enable apache2 
            sleep 1
        fi
    elif [ "$(cat $answer_file)" == "apache" ]
    then 
        printf "Installing apache\n"
        sleep 1
        install=$(sudo apt-get install apache2 2> $error2_file)
        if [ "$(cat $error2_file)" != "" ]
        then 
            printf "Apache is installed..\n"
            printf "Bye Bye"
            sleep 1 
            exit 0
        elif [ "$(cat $error2_file)" == "" ]
        then
            printf "Installed!!\n"
            sleep 1
            printf "Enabling/activating server..\n"
            sleep 1
            sudo systemctl start apache2 
            sudo systemctl enable apache2
        fi 
    fi 
elif [ "$name" == "centos" ]
then 
    printf "System detected...\n"
    sleep 1
    printf "Nginx or apache?\n"
    python3 $File > $answer_file 
    if [ "$(cat $answer_file)" == "nginx" ]
    then 
        sleep 1
        printf  "Starting Nginx installation\n"
        sleep 1
        sudo systemctl start nginx 2> $error2_file 
        if [ $(cat $error2_file) == "" ]
        then 
            printf "Nginx is already installed\n"
            sleep 1
            sudo systemctl start nginx 
            sudo systemctl enable nginx  
            printf "Nginx started and enabled!!\n"
            sleep 1
            exit 0
        elif [ $(cat $error2_file) != "" ]
        then 
            sudo yum install nginx 
            printf "Installed!!"
            sleep 1
            sudo systemctl start nginx 
            sudo systemctl enable nginx 
        fi 
    elif [ "$(cat $answer_file)" == "apache" ]
    then 
        printf "Starting apache installation..\n"
        sleep 1
        sudo systemctl start httpd 2> $errors2_file
        if [ "$(cat $errors_file)" == "" ]
        then 
            printf "Apache is already installed\n"
            sleep 1
            sudo systemctl enable httpd
            exit 0
        elif [ "$(cat $errors_file)" != "" ]
        then 
            sudo yum install httpd
            printf "Installed!!\n"
            sleep 1
            sudo systemctl start httpd 
            sudo systemctl enable httpd 
        fi 
    fi 
fi 
rm -rf $File $error2_file answer_file


