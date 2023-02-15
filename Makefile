.PHONY: build

build:
	mkdir -p build/2023/02/05
	mkdir -p build/2023/02/05/environconfig
	wget -O build/2023/02/05/index.html https://pypi.org/simple
	wget -O build/2023/02/05/environconfig/index.html https://pypi.org/simple/environconfig/
