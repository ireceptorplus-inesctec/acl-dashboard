perm_name=""
while true
do
	echo "Insert a name for the permission"

	read perm_name

	if [ ${#perm_name} -le 0 ]
	then
		printf "\n!!!!! Please insert a non-empty name !!!!!\n\n"
		continue
	fi

	printf "\n"

	if [ ${#perm_name} -gt 0 ]
	then
		break
	fi
done

resources=$(curl -sX GET \
    -H "Authorization: Bearer $1" \
    "https://ireceptorplus.inesctec.pt/auth/admin/realms/iReceptorPlus/clients/$2/authz/resource-server/resource")

cont=0
while [ "$(echo $resources | jq ".[$cont]")" != null ]
do
    name=$(echo $resources | jq ".[$cont].name" | tr -d '"')
    echo "$(($cont + 1)). $name"

    ((cont++))
done

re='^[0-9]+$'

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

sel_resource_id=$(echo $resources | jq ".[$(($answer - 1))]._id" | tr -d '"')

policies=$(curl -sX GET \
    -H "Authorization: Bearer $1" \
    "https://ireceptorplus.inesctec.pt/auth/admin/realms/iReceptorPlus/clients/$2/authz/resource-server/policy?permission=false")

cont=0
while [ "$(echo $policies | jq ".[$cont]")" != null ]
do
    name=$(echo $policies | jq ".[$cont].name" | tr -d '"')
    echo "$(($cont + 1)). $name"

    ((cont++))
done

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

sel_policy_id=$(echo $policies | jq ".[$(($answer - 1))].id" | tr -d '"')

request_body=$(cat <<EOF
{
    "decisionStrategy": "AFFIRMATIVE",
    "logic": "POSITIVE",
    "name": "$perm_name",
    "policies": [
        "$sel_policy_id"
    ],
    "resources": [
        "$sel_resource_id"
    ],
    "type": "resource"
}
EOF
)

curl -sX POST \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $1" \
    -d "$request_body" \
    "https://ireceptorplus.inesctec.pt/auth/admin/realms/iReceptorPlus/clients/$2/authz/resource-server/permission/resource"