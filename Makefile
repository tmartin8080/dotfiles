.PHONY: install
install: brew git asdf copy-files

.PHONY: brew
brew:
	./brew.sh
asdf:
	./asdf.sh
git:
	./git.sh
copy-files:
	./copy-files.sh
