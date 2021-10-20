#!/bin/bash

#Script pour faire un backup de dossier de cours
#il récupère le dossier cours et le copie dans un dossier spécifique
#systeme de double sauvegarde effectué pour avoir une version nouvelle et la version avant le dernier script
#le backup est envoyé sur Google Drive
#la taille max du dossier ne peut exeder 500 mo
#si pas de différence depuis la dernière sauvegarde, pas de script


#directory to save
dir_save=~/Cours  

#directory backup
dir_backup=~/GDrive/backup_lp

#directory name
dir_name=backup_version_

# size max for the directory
size_max=500000000

#size of directory to save
size_dir_save=$(du -s $dir_save | grep -Eo [0-9]+)
echo "Size directory to save = $size_dir_save"

#verification size < size_max
if [ $size_dir_save -gt $size_max ]
then
    notify-send -u critical "ERROR notification" "Taille dossier $dir_save > taille max $size_max"
    exit 1 # end of script
fi

#get the last number of backup
number_last_backup=$(ls -t $dir_backup | head -n 1 | grep -Eo [0-9]+)
#ls -t for the list sort by created date
#head -n 1 display the first line of result
# grep -E for interpret expression like regex -o Print only the matched (non-empty) parts of a matching line, with each such part on a separate output line.
backup_name=$(ls -t $dir_backup | head -n 1)
echo "last backup: $backup_name"

#test for compare difference between dir_save and the backup
difference=$(diff -r $dir_save $dir_backup/$backup_name)
if [ "$difference" = "" ]
    then
    notify-send -u critical "Notification" "Pas de différence depuis la dernière sauvegarde, arrêt du script"
    exit 1 #end script
else
    echo $difference
fi

#incrémenter le numéro#
number_new_backup=$(($number_last_backup+1))

#concatenation to dir_name and number_new_backup
dir_new_name=$dir_name
dir_new_name+=$number_new_backup


#Create a new directory #
new_directory=$(mkdir $dir_backup/$dir_new_name)
echo "new directory: $dir_new_name"

#copy the directory_save to directory backup#
cp -R $dir_save $dir_backup/$dir_new_name

#number of backup to delete
number_to_delete=$(($number_new_backup-2))

#directory to delete
dir_to_delete=$dir_name
dir_to_delete+=$number_to_delete
echo "directory deleted: $dir_to_delete"

#delete the directory n-2#
rm -Rf $dir_backup/$dir_to_delete
echo "salut"

#push directory_backup to Google Drive
drive push $dir_backup

#send notification when the job is done
notify-send -u critical "WELL DONE" "backup_script done, files send to Google Drive"


#améliorations futures:

# faire le Yes automatique pour le drive push


