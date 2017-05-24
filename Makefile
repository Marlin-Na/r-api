
all: content public

clean:
	rm -r content;
	rm -r public;

pull-source:
	git fetch source master;
	git subtree pull --prefix source source master --squash;

push-site:
	cd public;													\
		git init;													\
		git remote add origin git@github.com:Marlin-Na/r-api.git;	\
		git push origin --delete gh-pages;							\
		git add -A;													\
		git commit -m "auto commit";								\
		git branch -m master gh-pages;								\
		git push origin gh-pages;
	rm -rf public;

.PHONY: all clean pull-source


content: source build.R
	Rscript build.R;

public: content
	hugo;
