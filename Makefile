.PHONY: cowsayd

cowsayd: main.cr
	crystal build -p -o $@ $^

clean:
	rm -f cowsayd
