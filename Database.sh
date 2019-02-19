#!/bin/bash
LC_ALL=C
shopt -s extglob
PS3="  "
function displayNewMenu(){
	PS3="select choice: "
	select choice in "Create Table" "Insert Table" "Update Table"   "Delete row" "Delete Table" "Back to Main Menu"
	do
	case $choice in
	"Create Table") 
	printf "Please enter your Table name: "
		read nameTable     
             if [[ -d $nameTable ]]; then
			    echo "$nameTable is already a directory."
		       elif [[ -f $nameTable ]]; then
			    echo "$nameTable is already a file"
                       elif   [ ${#nameTable} -eq 0 ];then
			  echo "You forgot to insert table name"
			elif [ ${#nameTable} -gt 25 ];then
	                  echo "Maximum Lengh of name 25 characters"
	                elif echo "${nameTable}" | egrep -q '[0-9]';then
	                  echo "Please don't use numbers"
                        elif echo ${nameTable}| egrep -q "[[:space:]]";then
                          echo "You can create one table only, please don't enter any spaces."
	                else
                          cd ~/Desktop
                          if [[ -d Database ]];then
                             cd ~/Desktop/Database/
							 if [[ -d $name  ]];then
             	                  createTable $name $nameTable
								   displayNewMenu
                           elif [  -d $dir ];then
                             cd ~/Desktop/Database/
                             createTable $dir $nameTable
							 displayNewMenu
                          else
                             echo "waiting your database is missing you can create another"
         	             startFunction
                          fi 
                        else echo "waiting your  databases is missing you can create another"
         	             startFunction
                           fi
			fi
	;;
	"Insert Table")      PS3="Insert a Table: "
	                      cd ~/Desktop
                        if [[ -d Database ]];then
                             cd ~/Desktop/Database/
							 if [[ -d $name  ]];then
             	                 insertIntoTable $name
                                  displayNewMenu
                            elif [  -d $dir ];then
                             cd ~/Desktop/Database/
                             	 insertIntoTable $dir
								   displayNewMenu
                           else
                             echo "Database not found, please create a Database."
         	                 startFunction
                          fi 
                        else echo "waiting your  databases is missing you can create another"
         	             startFunction
                        fi
	
	;;
	"Update Table") PS3="Update a Table: "
	          cd ~/Desktop
			if [[ -d Database ]];then
					cd ~/Desktop/Database/
					if [[ -d $name  ]];then
						updateTable $name
						displayNewMenu
				elif [  -d $dir ];then
					cd ~/Desktop/Database/
					echo "hello"
						updateTable $dir
						displayNewMenu
				else
					echo "waiting your database is missing you can create another"
					startFunction
				fi 
			else echo "waiting your  databases is missing you can create another"
				startFunction
			fi
	;;
	"Delete row")
	        cd ~/Desktop
			if [[ -d Database ]];then
					cd ~/Desktop/Database/
					if [[ -d $name  ]];then
					    deleteRowTable $name
						displayNewMenu
				elif [  -d $dir ];then
					cd ~/Desktop/Database/
					    deleteRowTable $dir
						displayNewMenu
				else
					echo "waiting your database is missing you can create another"
					startFunction
				fi 
			else echo "waiting your  databases is missing you can create another"
				startFunction
			fi
	
	
	;;
	"Delete Table")
	        cd ~/Desktop
			if [[ -d Database ]];then
					cd ~/Desktop/Database/
					if [[ -d $name  ]];then
					    deleteTable $name
						displayNewMenu
				elif [  -d $dir ];then
					cd ~/Desktop/Database/
					    deleteTable $dir
						displayNewMenu
				else
					echo "waiting your database is missing you can create another"
					startFunction
				fi 
			else echo "waiting your  databases is missing you can create another"
				startFunction
			fi
	
	
	;;
	"Back to Main Menu") reset
         	startFunction
	;;
	*) echo $REPLY is not one of the choices.
	;;
	esac
	done
}
function updateTable() {
	cd ~/Desktop/Database/$1
        clear
	select table in *; do test -n "$table" && break; echo ">>> Invalid Selection"; done;
	NumbOfFields=`sed -n '1p' $table|awk -F: '{print NF}'`
        cat $table
        for((i=0;i==0;i++))
        do
        read -p "Please enter your `sed -n '1p' $table|awk -F: '{print $1}'` to select a record to update: " pk
        case $pk in
	@()) echo Nothing Entered.
	((i--))
	continue;
	;;
	esac
        done
        NumbOfFields=`sed -n '1p' $table|awk -F: '{print NF}'`
        if record=`sed -n '4,$p' $table|awk -F: '{print $1}'| grep $pk`
        then
        `sed -i /$pk/'d' $table`
        input[0]=$pk;
        for((i=2;i<=NumbOfFields;i++))
		do
		read -p "Please enter your `sed -n '1p' $table|awk -v i=$i -F: '{print $i}'`: " input[i]
		case ${input[i]} in
			@()) echo Nothing Entered.
			((i--))
			continue;
		;;
		esac
		dataType=`sed -n '2p' $table|awk -v i=$i -F: '{print $i}'`
		case $dataType in
			"string")
			case ${input[i]} in
			*[0-9:]*)
			echo "Only string is allowed for the `sed -n '1p' $table|awk -v i=$i -F: '{print $i}'`."
			((i--));
			continue;
		        ;;
		        esac
		        ;;
		        "int")
			case ${input[i]} in
			*[a-zA-Z:]*)
			echo "Only integers allowed for the `sed -n '1p' $table|awk -v i=$i -F: '{print $i}'`."
			((i--));
			continue;
			;;
			esac
		esac
		if ((i==1))
		then
			if sed -n '4,$p' $table|awk -F: '{print $1}'| grep ${input[i]};
			then
			clear
			echo "The `sed -n '1p' $table|awk -v i=$i -F: '{print $i}'` you entered is already taken."
			((i=0));
			continue;
			fi
		fi
	done
	(IFS=: ; echo "${input[*]}") >> $table;
        else 
        echo "The `sed -n '1p' $table|awk -F: '{print $1}'` you entered wasn't found."
        fi
}


function deleteTable(){
    if [ -z "$(ls -A ~/Desktop/Database/$dir)" ]||[ -z "$(ls -A ~/Desktop/Database/$name)"; then
		       echo "Database is empty"
		       echo "waiting your database is empty you can create tables" 
	 	        displayNewMenu
	else 
				cd ~/Desktop/Database/$1
				clear
				select table in *; do test -n "$table" && break; echo ">>> Invalid Selection"; done;
				rm -r $table

     fi
}
function deleteRowTable(){
       if [ -z "$(ls -A ~/Desktop/Database/$dir)" ]||[ -z "$(ls -A ~/Desktop/Database/$name)" ]; then
		       echo "Database is empty"
		       echo "waiting your database is empty you can create tables" 
	 	        displayNewMenu
	else 
				cd ~/Desktop/Database/$1
				clear
				select table in *; do test -n "$table" && break; echo ">>> Invalid Selection"; done;
				cat  $table
						   select choice in "First Record" "Last record" "All Records" "by Unique Idendifier"
							do
							case $choice in
							"First Record") sed -i  '4d' $table  
							 return
							;;
							"Last Record") sed -i '$d' $table
							  return
							;;
							"All Records") sed -i '4,$d' $table
							  return
							;;
							"by Unique Idendifier") 
							echo "Please write first column you want to delete."
			             	read deleteName
							 if sed -n '4,$p' $table|awk -F: '{print $1}'| grep -x  $deleteName ;
								then
									sed -i -e  /$deleteName/'d' $table
									else   echo  $deleteName " is not found " 
								break;
								fi
								return
							;;
							*) 
							;;
							esac
							done

     fi
}
function startFunction(){
	PS3="select choice of your options:  "
	select choice in "Create Database" "Delete Database" "View Database" "Manipulate Database" "Exit"
		do
		case $choice in
		"Create Database") 
	     	printf "Please enter your Database Name: "
		    read name
                 if [[ -d $name ]]; then
			    echo "$name is already a directory."
		       elif [[ -f $name ]]; then
			    echo "$name is already a file."
                       elif   [ ${#name} -eq 0 ];then
			  echo "You forgot to insert Database Name."
			elif [ ${#name} -gt 25 ];then
	                  echo "Max Lengh of name is 25 characters."
	                elif echo "$name" | egrep -q '[0-9]'; then
	                  echo "Please don't use numbers"
                     #condition space
                        elif echo ${name}| egrep -q "[[:space:]]";then
                          echo "You can create one database only, please don't use spaces. "
                         
	                else
                          cd ~/Desktop
                          mkdir Database
                          cd ~/Desktop/Database
	                     mkdir $name
						reset
						displayNewMenu
			fi
		;;
		"Delete Database")
		            cd ~/Desktop/
                    if [[ -d Database ]];then
						cd ~/Desktop/Database
						if [ -z "$(ls -A ~/Desktop/Database/)" ]; then
							echo "You don't have any databases "
						else 
						ls ~/Desktop/Database
						echo "Please enter the Name of Database you wan't do delete."
						read namedelete
							
							if [[ ! -d $namedelete ]]; then
								echo $namedelete "is not found "
							else 
									rm -r $namedelete
									 startFunction
							fi
						fi 
					else echo "Database not found."
                   fi
			     startFunction
		;;
		"View Database") viewDatabase
		                 startFunction
		;;
		"Manipulate Database") ManipulateDatabase
		                      startFunction
		;;
		"Exit") exit
		;;
		*) echo $REPLY is not one of the choices.
		;;
		esac
		done 
 
}
function viewDatabase(){
	PS3="View Database:"
  cd ~/Desktop/
  if [[ -d Database ]];then
     cd ~/Desktop/Database/
         if [ -z "$(ls -A ~/Desktop/Database/)" ]; then
	     echo "Empty"
	     echo "waiting your database is missing you can create another"
	     startFunction
	     else
		 PS3="select Database:"
	      echo "Please select Database:"
	       select dir in *; do test -n "$dir" && break;echo ">>> Invalid Selection"; done
	       if [[ -d $dir ]];then
		   cd ~/Desktop/Database/$dir
		   if [ -z "$(ls -A ~/Desktop/Database/$dir)" ]; then
		       echo "Empty"
		       echo "waiting your database is empty you can create tables" 
	 	        displayNewMenu
		  else 
		     PS3="select file:"
		      select file in *; do test -n "$file" && break;echo ">>> Invalid Selection"; done
		      cat $file
		      echo "this is all of selected database"
		  fi
                else echo "you don't have database"
                startFunction     
	     fi 
        fi
   else echo "you don't have database"
         startFunction
  fi
}
function ManipulateDatabase(){
  cd ~/Desktop/
  if [[ -d Database ]];then
     cd ~/Desktop/Database/
         if [ -z "$(ls -A ~/Desktop/Database/)" ]; then
	     echo "Empty"
	     echo "waiting your database is missing you can create another"
	     startFunction
	     else
	      echo "Please select a Database:"
	       select dir in *; do test -n "$dir" && break;echo ">>> Invalid Selection"; done
	       if [[ -d $dir ]];then
		   cd ~/Desktop/Database/$dir
		   if [ -z "$(ls -A ~/Desktop/Database/$dir)" ]; then
		       echo "Empty"
		       echo "waiting your database is empty you can create tables" 
	 	        displayNewMenu
		  else 
             echo "there are all tables on this Database"   && ls 
		      echo "this is all of selected database"
                      displayNewMenu 
                      
		  fi
                else echo "you don't have database"
                startFunction     
	     fi 
        fi
   else echo "you don't have database"
         startFunction
  fi

}
function checkDatatype() {
   PS3="select choice of datatypes: "
   select choice in string int 
	do
	   case $choice in
	   string) echo string 
            return   
	   ;;
	   int) echo int
             return 
	   ;;
	  *) 
	  ;;
	  esac
	done
}
function createTable() {
        res=();
        nameCo=();
        cd ~/Desktop/Database/$1;
        echo "numbers of Columns";
	    read numOfColumns;
        if   [ ${#numOfColumns} -eq 0 ];then
            echo "you forget insert Numbers of columns"
        elif [[ $numOfColumns =~ ^[0-9]*[.][0-9]*$ ]];then
          echo "Number is float, please insert Integer Number"
          elif [[ $numOfColumns =~ ^[a-zA-Z]*$ ]];then
		    echo "this is string "
        else 
		   i=2;
        if [ $i -gt $numOfColumns ]
		then
		echo "You can't create table when Numbers of colums are less than two"
		else
		for ((i = 1; i <= numOfColumns; i++))
		do
			printf "Enter Column" $i "Name: "
			read nameCo[i];
				if [ ${#nameCo[${i}]} -eq 0 ];then
				echo "You forgot to insert a Column Name."
					((i--));
					continue;
				elif echo ${nameCo[${i}]} | egrep -q '[0-9:]'; then
						echo "Please don't use numbers or : for Column Names.";
							((i--));
							continue;
				elif echo ${nameCo[${i}]}| egrep -q "[[:space:]]";then
					echo "Please enter a Column Name without any spaces";
					((i--));
					continue;
				elif [ ${#nameCo[${i}]} -gt 15 ];then
					echo "Max Length of name 15 Characters."
					((i--));
					continue;
				
				else 
				   if [ $i -eq 2 ] || [ $i -gt 2 ]  ;then 
						if [ ${nameCo[${i}]} == ${nameCo[(${i}-1)]} ];then
							echo   ${nameCo[${i}]} " is already  found"
							((i--));
							continue;
						fi
				   fi
				res[i]=$(checkDatatype) 
				touch $2 
				fi
		done  
				(IFS=: ; echo "${nameCo[*]}") > $2;
				(IFS=: ; echo  "${res[*]}") >> $2;  
				echo  "------------------------------" >> $2
		fi
        fi
}

function insertIntoTable() {
       if [ -z "$(ls -A ~/Desktop/Database/$dir)" ]||[ -z "$(ls -A ~/Desktop/Database/$name)" ]; then
		       echo "Database is empty"
		       echo "waiting your database is empty you can create tables" 
	 	        displayNewMenu
	else 
				cd ~/Desktop/Database/$1
				clear
				select table in *; do test -n "$table" && break; echo ">>> Invalid Selection"; done;
				NumbOfFields=0
				NumbOfFields=`sed -n '1p' $table|awk -F: '{print NF}'`
				clear
				sed -n '2p' $table
				for((i=1;i<=NumbOfFields;i++))
					do
					read -p "Please enter your `sed -n '1p' $table|awk -v i=$i -F: '{print $i}'`: " input[i]
					case ${input[i]} in
					@()) echo Nothing Entered.
					((i--))
					continue;
                                        ;;
					esac
					dataType=`sed -n '2p' $table|awk -v i=$i -F: '{print $i}'`
					case $dataType in
						"string")
						case ${input[i]} in
						*[0-9:]*)
						echo "Only string is allowed for the `sed -n '1p' $table|awk -v i=$i -F: '{print $i}'`."
						((i--));
						continue;
					;;
					esac
					;;
					"int")
						case ${input[i]} in
						*[a-zA-Z:]*)
						echo "Only integers allowed for the `sed -n '1p' $table|awk -v i=$i -F: '{print $i}'`."
						((i--));
						continue;
						;;
						esac
					esac
					if ((i==1))
					then
						if awk -F: '{print $1}' $table | grep ${input[i]};
						then
						clear
						echo "The `sed -n '1p' $table|awk -v i=$i -F: '{print $i}'` you entered is already taken."
						((i=0));
						continue;
						fi
					fi
				done
				(IFS=: ; echo "${input[*]}") >> $table;
   fi
}

if [ $# -gt 0 ];then
	  echo "please run file without any argments."
	  exit
  else 
     startFunction
fi


