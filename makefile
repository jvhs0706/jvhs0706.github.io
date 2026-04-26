.PHONY: all publish schedule cv-build cv-sync cv-clean

CV_PATH ?= cv
CV_MAIN_TEX ?= resume.tex
CV_BUILD_PDF ?= resume.pdf
CV_SITE_PDF ?= haochen-sun-cv.pdf
CV_LATEX ?= xelatex

all: publish schedule

publish: cv-sync
	chmod -R a+r ./
	echo "Updated at $(shell date +%Y-%m-%d,\ %H:%M:%S), from $$(hostname)" >> update.log
	git add -A
	@if git diff --cached --quiet; then \
		echo "No changes to commit."; \
	else \
		git commit -m "Update personal website content at $(shell date +%Y-%m-%d,\ %H:%M:%S), from $$(hostname)"; \
		git push origin main; \
	fi

schedule:
	echo "cd $(CURDIR) && make all" | at 07:00 tomorrow

cv-build:
	@if [ ! -f "$(CV_PATH)/$(CV_MAIN_TEX)" ]; then \
		echo "Missing $(CV_PATH)/$(CV_MAIN_TEX)"; \
		exit 1; \
	fi
	cd "$(CV_PATH)" && "$(CV_LATEX)" -interaction=nonstopmode -halt-on-error "$(CV_MAIN_TEX)" && "$(CV_LATEX)" -interaction=nonstopmode -halt-on-error "$(CV_MAIN_TEX)"

cv-sync: cv-build
	cp "$(CV_PATH)/$(CV_BUILD_PDF)" "$(CV_SITE_PDF)"
	$(MAKE) cv-clean

cv-clean:
	rm -f "$(CV_PATH)"/*.aux "$(CV_PATH)"/*.log "$(CV_PATH)"/*.out "$(CV_PATH)"/*.toc "$(CV_PATH)"/*.pdf