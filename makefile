all:
	chmod -R a+r ./
	git add .
	echo "Latest update: $(shell date +%Y-%m-%d,\ %H:%M:%S), from $$(hostname)" > latest_update.log
	git commit -m "Update personal website content at $(shell date +%Y-%m-%d,\ %H:%M:%S), from $$(hostname)"
	git push origin main
