.PHONY: build

build:
	mkdir -p build
	echo '<pre>Hello world!</pre>' > build/index.html
	ln -s index.html build/index2.html
