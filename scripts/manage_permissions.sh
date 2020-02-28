code="9b42f553-d4e0-465b-90ea-1ee4034c47d4.47c0dda9-16e7-44d9-9766-818c02c6dcfa.d308109f-44c1-467f-ae47-54f91012c103"

access_token=$(curl -sX POST \
    -H "Accept: application/json" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=password&username=$1&password=$2&client_id=admin-cli" \
    "https://ireceptorplus.inesctec.pt/auth/realms/master/protocol/openid-connect/token" | jq '.access_token')

access_token=$(echo "$access_token" | tr -d '"')

# echo $access_token > access_token.txt

client="7a17dce2-9119-4146-b4b9-93caa6c2779a"

permissions=$(curl -sX GET \
	-H "Authorization: Bearer $access_token" \
	"https://ireceptorplus.inesctec.pt/auth/admin/realms/iReceptorPlus/clients/$client/authz/resource-server/permission")

rm permissions.json
echo "[" > permissions.json
cont=0
while [ "$(echo $permissions | jq ".[$cont]")" != null ]
# FOREACH PERMISSION
do
	perm=$(echo $permissions | jq ".[$cont]")
	perm_id=$(echo $perm | jq ".id" | tr -d '"')
	perm_name=$(echo $perm | jq ".name" | tr -d '"')
	
	echo "---PERMISSION $(($cont + 1))---"
	echo "id: $perm_id"
	echo "name: $perm_name"

	policy=$(curl -sX GET \
		-H "Authorization: Bearer $access_token" \
		"https://ireceptorplus.inesctec.pt/auth/admin/realms/iReceptorPlus/clients/$client/authz/resource-server/policy/$perm_id/associatedPolicies" | jq ".[0]")

	policy_id=$(echo $policy | jq ".id" | tr -d '"')
	policy_name=$(echo $policy | jq ".name" | tr -d '"')

	echo "	--POLICY--"
	echo "	id: $policy_id"
	echo "	name: $policy_name"
	
	resource=$(curl -sX GET \
		-H "Authorization: Bearer $access_token" \
		"https://ireceptorplus.inesctec.pt/auth/admin/realms/iReceptorPlus/clients/$client/authz/resource-server/policy/$perm_id/resources" | jq ".[0]")

	resource_id=$(echo $resource | jq "._id" | tr -d '"')
	resource_name=$(echo $resource | jq ".name" | tr -d '"')
	echo "	--RESOURCE--"
	echo "	id: $resource_id"
	echo "	name: $resource_name"
	printf "\n"

	if [ $cont -eq 0 ]
	then
		echo "	{"                 >> permissions.json
	else
		echo "	,{"                 >> permissions.json
	fi
	echo "		\"id\": \"$perm_id\"," >> permissions.json
	echo "		\"name\": \"$perm_name\"," >> permissions.json
	echo "		\"policy\": {" >> permissions.json
	echo "			\"id\": \"$policy_id\"," >> permissions.json
	echo "			\"name\": \"$policy_name\"" >> permissions.json
	echo "		}," >> permissions.json
	echo "		\"resource\": {" >> permissions.json
	echo "			\"id\": \"$resource_id\"," >> permissions.json
	echo "			\"name\": \"$resource_name\"" >> permissions.json
	echo "		}" >> permissions.json
	echo "	}" >> permissions.json

	((cont++))
done
echo "]" >> permissions.json

re='^[0-9]+$'
# ANSWER A 0 E WHILE A TRUE
answer=0
while true
do
	echo "1. ADD NEW PERMISSION"
	echo "2. DELETE PERMISSION"

	read answer

	if ! [[ $answer =~ $re ]]
	then
		printf '\n!!!!! Please insert a number !!!!!\n\n'
		continue
	fi

	if [ $answer -lt 1 ] || [ $answer -gt 2 ]
	then
		printf "\n!!!!! Please insert a number between 1 and $cont !!!!!\n\n"
		continue
	fi

	printf "\n"

	if [ $answer -ge 1 ] && [ $answer -le 2 ]
	then
		break
	fi
done

if [ $answer -eq 1 ]
then
	# NEW PERMISSION
	./create_permission.sh $access_token $client
fi

if [ $answer -eq 2 ]
then
	# DELETE PERMISSION
	./delete_permission.sh $access_token $client
fi
