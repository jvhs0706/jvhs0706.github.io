all:
	chmod -R a+r ./
	git add .
	git commit -m "Update personal website content at `date +%Y-%m-%d`"
	git push origin main
	