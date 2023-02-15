.PHONY: build

build:
	mkdir -p build
	echo '<pre>Hello world!</pre>' > build/index.html
	ln -s build/index.html build/index2.html
