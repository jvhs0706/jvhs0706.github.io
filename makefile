all:
	chmod -R a+r ./
	git add .
	echo "Latest update: `date +%Y-%m-%d, %H:%M:%S`" > latest_update.log
	git commit -m "Update personal website content at `date +%Y-%m-%d, %H:%M:%S`"
	git push origin main
