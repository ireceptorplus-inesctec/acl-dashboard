resource_name=""
while true
do
	echo "Insert a name for the resource"

	read resource_name

	if [ ${#resource_name} -le 0 ]
	then
		printf "\n!!!!! Please insert a non-empty name !!!!!\n\n"
		continue
	fi

	printf "\n"

	if [ ${#resource_name} -gt 0 ]
	then
		break
	fi
done

owner_name=""
while true
do
	echo "Insert a name of the owner"

	read owner_name

	if [ ${#owner_name} -le 0 ]
	then
		printf "\n!!!!! Please insert a non-empty name !!!!!\n\n"
		continue
	fi

	printf "\n"

	if [ ${#owner_name} -gt 0 ]
	then
		break
	fi
done

type="study"

request_body=$(cat <<EOF
{
    "name": "$resource_name",
    "type": "$type",
    "ownerManagedAccess": true,
    "owner": "$owner_name"
}
EOF
)

pat=$(curl -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d 'grant_type=client_credentials&client_id=turnkey&client_secret=0ed88b46-ed70-4af9-ba19-1b98d33319a8' \
    "https://ireceptorplus.inesctec.pt/auth/realms/iReceptorPlus/protocol/openid-connect/token" | jq ".access_token" | tr -d '"')

curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $pat" \
    -d "$request_body" \
    "https://ireceptorplus.inesctec.pt/auth/realms/iReceptorPlus/authz/protection/resource_set"
