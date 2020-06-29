while read p; do
	echo "# $p's Page\n" >> ../posts/$p.md
	echo $(sort -R images.md | head -n 1) >> ../posts/$p.md
	echo "\n<Enter a phrase describing the above image>" >> ../posts/$p.md
done < users.txt

# Add all the users to Git-Training
while read u; do
	echo $u
	curl -X PUT -H "Authorization: token $(cat token)" "https://github.mmm.com/api/v3/orgs/Git-Training/memberships/$u"
done < users.txt

repo_num=$1
# Create the repo
curl -H "Authorization: token $(cat token)" "https://github.mmm.com/api/v3/orgs/Git-Training/repos" -d "{\"name\":\"training-$repo_num\"}"

# Create the team, add it to the repo
curl -H "Authorization: token $(cat token)" "https://github.mmm.com/api/v3/orgs/Git-Training/teams" -d "{\"name\":\"training-$repo_num\",\"repo_names\":[\"training-$repo_num\"]}"

# Get members url for the team
url=`curl -H "Authorization: token $(cat token)" "https://github.mmm.com/api/v3/orgs/Git-Training/teams/training-$repo_num" | jq -r .members_url | cut -d{ -f1`
# Add all the users to the team
while read u; do
	echo $u
	curl -X PUT -H "Authorization: token $(cat token)" "$url/$u"
done < users.txt
