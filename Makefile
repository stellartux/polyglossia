.PHONY: test
test:
	julia test.jl hello-world

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
	sbcl --load "$<" --eval "(save-lisp-and-die \"$@\" :toplevel #'main :executable T)" >> /dev/null

o/%.d_compiled: %
	mkdir -p $(dir $@)
	gdc $< -o $@

o/%.nim_compiled: %
	mkdir -p $(dir $@)
	nim compile "--out:$@" --hints:off $<

o/proquint_c: proquint/proquint_c.js
	$(CC) -xc -DPROQUINT_MAIN=main -o $@ $<
