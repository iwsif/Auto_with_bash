#! /usr/bin/bash 



printf "mariadb_script(VERSION 1.0.0)\n"
sleep 1
printf "Starting..\n"
sleep 1 

mysql_start=$(sudo systemctl start mysql 2> error.txt)
mariadb_start=$(sudo systemctl start mariadb 2> error2.txt)
python_file="python_file.py"
printf "#!/usr/bin/python3\n\n\n\nuser_input = input()\n\nprint(user_input)" > $python_file
chmod 744 $python_file 
answer_file="answer"
touch $answer_file 

if [ "$(cat error2.txt)"  == "" ] && [ "$(cat error.txt)" == "" ]
then 
    printf "Mariadb and mysql is already installed!!\n"
    sleep 1
    sudo systemctl start mysql 
    sudo systemctl start mariadb 
    sudo systemctl enable mysql 
    sudo systemctl enable mariadb 
    sleep 1
    printf "Mariadb and mysql started and enabled!!\n"
    printf "Create database backup?\n"
    python3 $python_file > $answer_file 
    if [ "$(cat $answer_file)"  == "no" ]
    then 
        printf "Bye Bye!!\n"
        sleep 1
    elif  [ "$(cat $answer_file)" == "yes" ]
    then 
        printf "Type the database name:"
        python3 $python_file > $answer_file 
        database_name=$(cat $answer_file)
        back_up="db_backup.sql"
        sudo mysqldump $database_name $back_up 
        printf  "Created >> $back_up"
        sleep 1
    fi  
elif [ "$(cat error.txt)" != "" ] && [ "$(cat error2.txt) " != "" ] 
then 
    printf "Installing mysql..\n"
    sudo apt-get install mysql 
    sleep 1 
    sudo systemctl start mysql 
    printf "Installing mariadb\n"
    sudo apt-get install mariadb-server
    sleep 1
    sudo systemctl start mariadb-server 
    printf "Mariadb started\n"
    sleep 1
    printf "Starting secure installation script..\n"
    sudo mysql_secure_installation
elif [ "$(cat error.txt)" == ""  ] && [ "$(cat error2.txt)" != "" ]
then 
    printf "Installing mariadb\n"
    sudo apt-get install mariadb-server 
    printf "Done..\n"
    sleep 1 
fi 
rm -rf $python_file "error2.txt" "error.txt" $answer_file

