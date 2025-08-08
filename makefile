all:
	chmod -R a+r ./
	echo "Updated at $(shell date +%Y-%m-%d,\ %H:%M:%S), from $$(hostname)" >> update.log
	git add .
	git commit -m "Update personal website content at $(shell date +%Y-%m-%d,\ %H:%M:%S), from $$(hostname)"
	git push origin main
	echo "cd $(CURDIR) && make" | at 07:00 tomorrow