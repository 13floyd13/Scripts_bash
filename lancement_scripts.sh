case "$1" in
    "ebook_to_nas")
        konsole -e ./ebook_to_nas.sh
        echo "$1"
    ;;
    "ebook_to_backup")
        konsole -e ./ebook_to_backup.sh
        echo "$1"
    ;;
    "papiers_to_backup")
        konsole -e ./papiers_to_backup.sh
        echo "$1"
    ;;
    "papiers_to_nas")
        konsole -e ./papiers_to_nas.sh
        echo "$1"
    ;;
    "photos_to_backup")
        konsole -e ./photos_to_backup.sh
        echo "$1"
    ;;
    "photos_to_nas")
        konsole -e ./photos_to_nas.sh
        echo "$1"
    ;;
    "autres_to_backup")
        konsole -e ./autres_to_backup.sh
        echo "$1"
    ;;
    "autres_to_nas")
        konsole -e ./autres_to_nas.sh
        echo "$1"
    ;;
    "projets_to_backup")
        konsole -e ./projets_to_backup.sh
        echo "$1"
    ;;
    "projets_to_nas")
        konsole -e ./projets_to_nas.sh
        echo "$1"
    ;;
    "films_to_nas")
        konsole -e ./films_to_nas.sh
        echo "$1"
    ;;
esac

