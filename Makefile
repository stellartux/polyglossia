.PHONY: clean
clean:
	rm -r o/*

o/%.sml_compiled: %
	mkdir -p $(dir $@)
	mlton -output $@ $<

o/%.c_compiled: %
	mkdir -p $(dir $@)
	cc -xc -o $@ $<

o/%.lisp_compiled: %
	mkdir -p $(dir $@)
	sbcl --script --load "$<" --eval "(save-lisp-and-die \"$@\" :toplevel #'main :executable T)" >> /dev/null
