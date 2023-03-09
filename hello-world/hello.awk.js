function main() {
    print("Hello from \x1b[30mAwk\x1b[m and \x1b[33mJavaScript\x1b[m!");
}

/*/ # code visible to Awk
# one true awk doesn't accept this as a valid regex, which is why gawk is needed

BEGIN {
    print "Hello from \x1b[30mAwk\x1b[m!"
    main()
    exit
}

# code visible to JavaScript

#*/var print;/*
#*/if (print) {/*
#*/  print("Hello from \x1b[33mqjs\x1b[m!");/*
#*/} else if (this == undefined) {/*
#*/  print = console.log;/*
#*/  print("Hello from \x1b[33mdeno\x1b[m!");/*
#*/} else if (!this.display) {/*
#*/  print = console.log;/*
#*/  print("Hello from \x1b[33mnode\x1b[m!");/*
#*/} else {/*
#*/  this.console = { log: print = function(s) { display(s); newline(); }};/*
#*/  print("Hello from \x1b[33mguile\x1b[m!");/*
#*/}/*
#*/main();
