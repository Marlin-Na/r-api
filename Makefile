
all: content public

clean:
	rm -r content;
	rm -r public;

pull-source:
	git fetch source master;
	git subtree pull --prefix source source master --squash;

.PHONY: all clean pull-source


content: source
	Rscript build.R;

public: content
	hugo;
