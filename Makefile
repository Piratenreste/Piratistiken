BVINPUT = BV.txt
INPUT = \
	LV-BB.txt \
	LV-BE.txt \
	LV-BW.txt \
	LV-BY.txt \
	LV-HB.txt \
	LV-HE.txt \
	LV-HH.txt \
	LV-LSA.txt \
	LV-MV.txt \
	LV-NDS.txt \
	LV-NRW.txt \
	LV-RP.txt \
	LV-SH.txt \
	LV-SL.txt \
	LV-SN.txt \
	LV-TH.txt \
	OUTSIDE.txt
DATEFILES = \
	ltw.txt \
	btw.txt \
	euw.txt \
	bpt.txt

Mitgliederentwicklung-nach-LVs.png: output-tmp.png
	pngcrush -brute -l 9 "$<" "$@"

output-tmp.png: mitglieder.csv plotscript
	gnuplot plotscript

mitglieder.csv: $(INPUT) plot-stacked.rb sort.rb Makefile
	./plot-stacked.rb `./sort.rb $(INPUT)` > $@

plotscript: $(BVINPUT) $(INPUT) mitglieder.csv plot-script.rb sort.rb Makefile $(DATEFILES)
	./plot-script.rb `awk '{ d = $$1; if (m < $$18) m = $$18 }; END { print m, d }' mitglieder.csv` $(BVINPUT) `./sort.rb $(INPUT)` > $@

.PHONY: diff clean
diff:
	netstiff -W netstiff update

clean:
	$(RM) plotscript mitglieder.csv Mitgliederentwicklung-nach-LVs.png output-tmp.png
