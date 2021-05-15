.PHONY: install
install: brew asdf copy-files

.PHONY: brew
brew: 
	./brew.sh
asdf: 
	./asdf.sh
copy-files: 
	./copy-files.sh
