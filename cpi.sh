 #!/bin/bash
 
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
else
    #Update and Upgrade
    echo "Updating and Upgrading"
    yum update && sudo yum upgrade -y
 
    sudo yum install dialog
    cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
    options=(1 "LAMP Stack" off
            2 "Essential Utilities - NCDU/HTOP/Terminator" off
           
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear
    for choice in $choices
        do
            case $choice in
                1)
                    #Install LAMP stack
                    echo "Installing Apache"
                    sudo yum install httpd -y
                    sudo systemctl start httpd.service
                    
 
                    echo "Installing Mysql Server"
                    sudo yum install mariadb-server mariadb -y
                    sudo systemctl start mariadb
                    sudo mysql_secure_installation
                    sudo systemctl enable mariadb.service
 
                    echo "Installing PHP"
                    sudo yum install php php-mysql -y
 
                    echo "Installing Phpmyadmin"
                    yum install phpmyadmin -y
 
                    echo "Cofiguring apache to run Phpmyadmin"
                    echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
 
                    echo "Restarting Apache Server"
                    sudo systemctl restart httpd.service 
                    ;;
                2)
                    #Install Essential Utilities
                    echo "Installing Essential Utilities"
                    yum install -y ncdu && yum install -y htop && yum install  -y terminator
                    ;;
 
               
        esac  
    done
fi
