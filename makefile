all:
	chmod -R a+r ./
	git add .
	git commit -m "Update personal website content at `date +%Y-%m-%d`"
	git push origin main
	echo "Latest update: `date +%Y-%m-%d`" > latest_update.log
