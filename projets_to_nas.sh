#!/bin/bash
REPERTOIRE_SOURCE="/home/martin/Documents/Projets/"
REPERTOIRE_DESTINATION="Sherlock@192.168.1.18:/var/services/homes/Sherlock/Drive/Projets"
SSH="Sherlock@192.168.1.18"
REPERTOIRE_COMPTE_RENDU="/home/martin/Documents/Projets/Scripts/CR_scripts/CR_projets_to_nas/"
script_name=$(cut -d '/' -f 2- <<<"$0")
script_name=$(cut -d '.' -f 1 <<<"$script_name")
today="`date +"%d-%m-%Y"`"
output_previous="/${script_name}_${today}_previous_Nas.log"
output="/${script_name}_${today}_Nas.log"

#Test connexion SSH
ssh "$SSH" exit

if [ "$?" -ne 0 ]; then
    echo "Echec de la connexion SSH"
    notify-send -u critical "Echec de la connexion SSH sur le script $0"
    exit
fi

#On demande le lancement du script
zenity --question --no-wrap\
    --text="Souhaitez vous lancer le script pour synchroniser votre dossier Projets sur votre Nas ?" 2> /dev/null

#Si on clique sur le bouton Annuler
if [ "$?" -eq 1 ]; then
    #On quitte le script
    exit
fi

#Sinon on continue avec le dry run du rsync
#touch $output_previous
rsync -acivhP --info=progress2 --stats --dry-run --delete "$REPERTOIRE_SOURCE" "$REPERTOIRE_DESTINATION" | tee -a "$output_previous" 

FILE="$output_previous" 

#On indique le retour du dry-run dans une pop up et on demande si on continue
zenity --text-info --no-wrap\
       --title="Info dry-run" \
       --filename=$FILE 2> /dev/null


case $? in
    0)
        rsync -chav --info=progress2 --stats --delete "$REPERTOIRE_SOURCE" "$REPERTOIRE_DESTINATION" | tee -a "$output"
   
        if [ "$?" -ne 0 ]; then
            notify-send -u critical "Echec du rsync sur le script $0"
        else
            notify-send -u critical "Réussite du script $0"
        fi
	;;
    1)
        echo "Arrêt du script!"
	;;
    -1)
        echo "Une erreur inattendue est survenue."
	;;
esac
#on envoie les logs dans le repertoire prévu
mv $output $REPERTOIRE_COMPTE_RENDU
mv $output_previous $REPERTOIRE_COMPTE_RENDU

sleep 60