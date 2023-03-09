#/usr/bin/make

PHONY=clean cover

clean:
	rm -rf blib _build cover_db \#*\#
	rm -f Build MYMETA.json MYMETA.yml *~

cover:
	bash t/bin/coverage
