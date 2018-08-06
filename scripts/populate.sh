while read p; do
	echo "# $p's Page\n" >> ../posts/$p.md
	echo $(sort -R images.md | head -n 1) >> ../posts/$p.md
	echo "\n<Enter a phrase describing the above image>" >> ../posts/$p.md
done < users.txt

