#!/usr/bin/env gawk

//{}# code here is executed by awk and by javascript
function main() {
    //# use if (null == 0) to put a language specific section inside a function
    print(null == 0 ? "Hello from awk!" : "Hello from JavaScript!")
}

/*/ # code here is only executed by awk
# one true awk doesn't accept this as a valid regex, which is why gawk is needed

BEGIN {
    main()
    exit
}

#*/ globalThis.print ??= console.log /* code here is only executed by js
#*/ main()
