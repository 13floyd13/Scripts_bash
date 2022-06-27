#!/bin/bash
REPERTOIRE_SOURCE="/home/martin/Documents/Papiers/"
REPERTOIRE_DESTINATION="/media/martin/backup/Papiers/"
REPERTOIRE_COMPTE_RENDU="/home/martin/Documents/Projets/Scripts/CR_scripts/CR_papiers_to_backup/"
today="`date +"%d-%m-%Y"`"
script_name=$(cut -d '/' -f 2- <<<"$0")
script_name=$(cut -d '.' -f 1 <<<"$script_name")
output_previous="/${script_name}_${today}_previous.log"
output="/${script_name}_$today.log"


# Détecter la présence du volume de destination et interrompre l'opération si nécessaire
if [ ! -e "$REPERTOIRE_DESTINATION" ]
then
echo "Attention, le disque de sauvegarde n'est pas présent"
exit
fi

#On demande le lancement du script
zenity --question --no-wrap\
    --text="Souhaitez vous lancer le script pour synchroniser votre dossier Papiers sur votre disque de backup ?" 2> /dev/null

#Si on clique sur le bouton Annuler
if [ "$?" -eq 1 ]; then
    #On quitte le script
    exit
fi


#Sinon on continue
rsync -acivhP --info=progress2 --stats --dry-run --delete $REPERTOIRE_SOURCE $REPERTOIRE_DESTINATION | tee -a "$output_previous"

FILE="$output_previous"

zenity --text-info \
       --title="Info dry-run" \
       --filename=$FILE 2> /dev/null


case $? in
    0)
        # -c, –checksum demande à rsync d’utiliser la somme de contrôle, au lieu de la date ou de la taille du fichier,
        #     pour vérifier si ce fichier a été modifié. En effet, par défaut, 
        #     rsync détermine quels fichiers diffèrent entre les systèmes en vérifiant l’heure de modification et la taille de chaque fichier. 
        #     Si la date ou la taille diffère entre les systèmes, il transfère le fichier. 
        #     Cela ne nécessite donc que de la lecture d’informations sur les fichiers, ce qui est rapide pour RSYNC ! 
        #     Mais cette méthode pourrait manquer des modifications inhabituelles qui ne touchent ni à la date, ni à la taille du fichier. 
        #     Par contre, si -c ou –checksum est invoqué, RSYNC effectue une vérification plus lente mais complète, ce qui réduit le risque de manquer des fichiers modifiés.

        # -h, –human-readable demander à rsync d’afficher les résultats chiffrés dans un format plus lisible

        # -a, –archive est à utiliser dans la plupart des cas. C’est un raccourci de tous ces paramètres -rlptgoD. 
        #     Cette commande demande à rsync de faire un transfert récursif (il rentre dans tous les dossiers) et conserve tout ce qu’il trouve ou presque. 

        # -P est un raccourci qui demande à rsync d’exécuter –partial et –progress. Son but est d’améliorer la continuité des longs transferts qui risqueraient d’être interrompus.
        #     –partial : empêche rsync de supprimer tout fichier partiellement transféré quand un processus est interrompu. 
        #         En effet, parfois il est préférable de conserver les fichiers partiellement transférés, 
        #         car leur utilisation ultérieure pourrait accélérer la fin du transfert du fichier, lorsque celui-ci reprendra.
        #     –progress : cette option demande à rsync de, si possible, afficher les informations de progression du transfert, 
        #         pour vous assurer que le transfert ne s’est pas interrompu.
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

mv $output $REPERTOIRE_COMPTE_RENDU
mv $output_previous $REPERTOIRE_COMPTE_RENDU


sleep 60
