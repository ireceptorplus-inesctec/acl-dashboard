cont=0
while [ "$(jq ".[$cont]" permissions.json)" != null ]
do
    name=$(jq ".[$cont].name" permissions.json | tr -d '"')
    echo "$(($cont + 1)). $name"

    ((cont++))
done
re='^[0-9]+$'
# ANSWER A 0 E WHILE A TRUE
answer=0
while true
do
    read answer

    if ! [[ $answer =~ $re ]]
    then
        printf '\n!!!!! Please insert a number !!!!!\n\n'
        continue
    fi

    if [ $answer -lt 1 ] || [ $answer -gt $cont ]
    then
        printf "\n!!!!! Please insert a number between 1 and $cont !!!!!\n\n"
        continue
    fi

    printf "\n"

    if [ $answer -ge 1 ] && [ $answer -le $cont ]
    then
        break
    fi
done

chosen_perm_id=$(jq ".[$(($answer - 1))].id" permissions.json | tr -d '"')


curl -X DELETE \
    -H "Authorization: Bearer $1" \
    "https://ireceptorplus.inesctec.pt/auth/admin/realms/iReceptorPlus/clients/$2/authz/resource-server/permission/$chosen_perm_id"

echo "Permission $(jq ".[$(($answer - 1))].name" permissions.json | tr -d '"') deleted"