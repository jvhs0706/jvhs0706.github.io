.PHONY: all publish schedule cv-submodule-add cv-submodule-init cv-submodule-update cv-build cv-sync cv-clean cv-publish publish-with-cv

CV_SUBMODULE_URL ?= https://git@git.overleaf.com/65cdb29a6fbe79e16de89b3f
CV_SUBMODULE_PATH ?= cv
CV_MAIN_TEX ?= resume.tex
CV_BUILD_PDF ?= resume.pdf
CV_SITE_PDF ?= haochen-sun-cv.pdf
CV_LATEX ?= xelatex

all: publish schedule

publish:
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

cv-submodule-add:
	git submodule add "$(CV_SUBMODULE_URL)" "$(CV_SUBMODULE_PATH)"

cv-submodule-init:
	git submodule update --init --recursive

cv-submodule-update:
	git submodule update --remote --merge "$(CV_SUBMODULE_PATH)"

cv-build:
	cd "$(CV_SUBMODULE_PATH)" && "$(CV_LATEX)" -interaction=nonstopmode -halt-on-error "$(CV_MAIN_TEX)" && "$(CV_LATEX)" -interaction=nonstopmode -halt-on-error "$(CV_MAIN_TEX)"

cv-sync: cv-build
	cp "$(CV_SUBMODULE_PATH)/$(CV_BUILD_PDF)" "$(CV_SITE_PDF)"
	$(MAKE) cv-clean

cv-clean:
	rm -f "$(CV_SUBMODULE_PATH)"/*.aux "$(CV_SUBMODULE_PATH)"/*.log "$(CV_SUBMODULE_PATH)"/*.out "$(CV_SUBMODULE_PATH)"/*.toc "$(CV_SUBMODULE_PATH)"/*.pdf

cv-publish:
	@if [ ! -e "$(CV_SUBMODULE_PATH)/.git" ]; then \
		echo "Submodule $(CV_SUBMODULE_PATH) is not initialized. Run: make cv-submodule-init"; \
		exit 1; \
	fi
	git -C "$(CV_SUBMODULE_PATH)" add -A
	@if git -C "$(CV_SUBMODULE_PATH)" diff --cached --quiet; then \
		echo "No submodule changes to commit in $(CV_SUBMODULE_PATH)."; \
	else \
		git -C "$(CV_SUBMODULE_PATH)" commit -m "Update CV content at $(shell date +%Y-%m-%d,\ %H:%M:%S), from $$(hostname)"; \
		git -C "$(CV_SUBMODULE_PATH)" push; \
	fi

publish-with-cv: cv-publish publish