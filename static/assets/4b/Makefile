FONT_PATH := ../../fonts

.PHONY: all
all: graph.svg

graph.svg: graph.typ
	typst compile --font-path $(FONT_PATH) graph.typ graph.svg
