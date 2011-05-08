
export VERSION=1.4.0.1
export TOOLCHAIN_PREFIX=arm-none-eabi-

default: bin/RUU_signed.nbh

clean: 
	$(MAKE) -C lk htcleo clean
	rm -rf lk/build-htcleo
	rm -rf bin/nbgen
	rm -rf bin/lk.bin
	rm -rf bin/os.nb.payload
	rm -rf bin/os.nb
	rm -rf bin/RUU_signed.nbh

bin/nbgen:
	gcc -std=c99 nbgen.c -o bin/nbgen

bin/RUU_signed.nbh: bin/nbgen
	$(MAKE) -C lk htcleo DEBUG=1
	cp lk/build-htcleo/lk.bin bin/
	cd bin ; ./nbgen os.nb
	cd bin ; ./yang -F RUU_signed.nbh -f os.nb -t 0x400 -s 64 -d PB8110000 -c 11111111 -v CLK$(VERSION) -l WWE

partition:
	rm -rf lk/build-htcleo/target/htcleo/init.*
	rm -rf bin/RUU_signed.nbh
	$(MAKE)
