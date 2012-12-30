.PHONY: all clean install build
all: build doc

J=4

BINDIR ?= /usr/bin
SBINDIR ?= /usr/sbin
DESTDIR ?= /

export OCAMLRUNPARAM=b

setup.bin: setup.ml
	@ocamlopt.opt -o $@ $< || ocamlopt -o $@ $< || ocamlc -o $@ $<
	@rm -f setup.cmx setup.cmi setup.o setup.cmo

setup.data: setup.bin
	@./setup.bin -configure

build: setup.data setup.bin
	@./setup.bin -build -j $(J)

doc: setup.data setup.bin
	@./setup.bin -doc -j $(J)

install: setup.bin
	@./setup.bin -install

test: setup.bin build
	@./setup.bin -test

reinstall: setup.bin
	@ocamlfind remove mmap || true
	@ocamlfind remove xenctrl || true
	@./setup.bin -reinstall

uninstall:
	@ocamlfind remove mmap || true
	@ocamlfind remove xenctrl || true

clean:
	@ocamlbuild -clean
	@rm -f setup.data setup.log setup.bin