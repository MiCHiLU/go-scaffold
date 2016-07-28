PROJECT=go-scaffold
#PLATFORMS=darwin/386 darwin/amd64 freebsd/386 freebsd/amd64 freebsd/arm linux/386 linux/amd64 linux/arm netbsd/386 netbsd/amd64 netbsd/arm openbsd/386 openbsd/amd64 plan9/386 plan9/amd64 windows/386 windows/amd64
PLATFORMS=darwin/amd64 windows/386
LOCALES=ja

.PHONY: all clean test

go: bin/$(PROJECT)

VERSION=$(shell git describe --tag)
PROJECT_SINCE=$(shell date -u -j -f %Y-%m-%d%H%M%S `git log --pretty=format:"%ad" --date=short|tail -1`000000 +%s)
AUTO_COUNT_SINCE=$(shell echo $$(((`date -u +%s`-$(PROJECT_SINCE))/(24*60*60))))
AUTO_COUNT_LOG=$(shell git log --since=midnight --oneline|wc -l|tr -d " ")
PROJECTDIR=src/$(PROJECT)
LOCALEDIR=$(PROJECTDIR)/locale
BABEL=$(shell which pybabel)

GO=$(wildcard $(PROJECTDIR)/*.go)
MAPPING=$(wildcard $(LOCALEDIR)/*go.mapping)
POT=$(MAPPING:.mapping=.pot)
PO=$(foreach locale,$(LOCALES),$(foreach po,$(POT:.pot=.po),$(subst $(LOCALEDIR),$(LOCALEDIR)/$(locale)/LC_MESSAGES,$(po))))
MO=$(PO:.po=.mo)
LOCALE=$(MO:.mo=.mogo)

.SUFFIXES: .mapping .pot
.mapping.pot:
	$(BABEL) extract -k GetText -o $@ -F $< $(PROJECTDIR)
	@for locale in $(LOCALES); do\
		subcommand=init;\
		if [ -e $(dir $@)$$locale/LC_MESSAGES/$(notdir $(basename $@)).po ]; then\
			subcommand=update;\
		fi;\
		cmd="$(BABEL) $$subcommand -D $(notdir $*) -i $@ -d $(LOCALEDIR) -l $$locale";\
		echo $$cmd;\
		$$cmd;\
	done

.SUFFIXES: .po .mo
.po.mo:
	$(BABEL) compile -d $(LOCALEDIR) -D $(notdir $*)

.SUFFIXES: .mo .mogo
.mo.mogo:
	./bin/go-bindata -func=Mo -nomemcopy -out=$@ -pkg=ja $<
	mkdir -p  $(LOCALEDIR)/ja
	cp $@ $(LOCALEDIR)/ja/ja.go

$(POT): $(GO) $(MAPPING)
$(PO): $(POT)
$(MO): $(POT)
$(LOCALE): $(MO)

bin/$(PROJECT): $(GO) $(LOCALE)
	go fmt $(PROJECT)
	go install -tags version_embedded -ldflags "-X main.name=$(PROJECT) -X main.minorVersion=$(AUTO_COUNT_SINCE).$(AUTO_COUNT_LOG) -X main.version=$$(git describe --always --dirty=+) -X \"main.buildAt='$$(LANG=en date -u +'%b %d %T %Y')'\"" $(PROJECT)
	go test -test.short $(PROJECT)

test:
	go test $(PROJECT)

race: bin/$(PROJECT)
	go install -race $(PROJECT)

all: $(GO) $(LOCALE) test
	make clean
	@failures="";\
	for platform in $(PLATFORMS); do\
	  echo building for $$platform;\
	  GOOS=$${platform%/*} GOARCH=$${platform#*/} go install -tags version_embedded -ldflags "-X main.name=$(PROJECT) -X main.minorVersion=$(AUTO_COUNT_SINCE).$(AUTO_COUNT_LOG) -X main.version=$$(git describe --always --dirty=+) -X \"main.buildAt='$$(LANG=en date -u +'%b %d %T %Y')'\"" $(PROJECT) || failures="$$failures $$platform";\
	done;\
	if [ "$$failures" != "" ]; then\
	  echo "*** FAILED on $$failures ***";\
	  exit 1;\
	fi
	@if [[ "$(PLATFORMS)" =~ .*darwin_amd64.* ]]; then\
		cd bin && mkdir -p darwin_amd64 && cp -p $(PROJECT) darwin_amd64 ;\
	fi
	@cd bin && zip -FS $(PROJECT)-$(VERSION)-unix.zip [dfl]*/$(PROJECT)
	@if [[ "$(PLATFORMS)" =~ .*windows.* ]]; then\
		cd bin && zip -FS $(PROJECT)-$(VERSION)-win.zip windows_*/$(PROJECT).exe ;\
	fi

clean:
	rm -f $(POT) $(MO) $(LOCALE) ./bin/$(PROJECT)* ./bin/*/$(PROJECT)* ./bin/*.zip

setup:
	pip install -r packages.txt
	cd $(shell go env GOROOT)/src &&\
	for platform in $(PLATFORMS); do\
	  GOOS=$${platform%/*} GOARCH=$${platform#*/} ./make.bash ;\
	done;\
