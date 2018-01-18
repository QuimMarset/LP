
mountains.exe:
		antlr -gt mountains.g
		dlg -ci parser.dlg scan.c
		g++ -w -o mountains -I /usr/include/pccts/ mountains.c scan.c err.c


clean:
	rm *.exe
	rm *.dlg
