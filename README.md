# lambda-calculus-translation-boe_asbury
Co-written by @joshuaboe

This is an experimental Racket program that compiles lamda calculus expressions into C++ programs.
The method 'compile' takes in a string representation of a LC expression. The
expression is wrapped with the necessary C++ include statements and the main definition,
and then the expression is parsed. In the end, the full C++ program is displayed into
stdout, which can then be compiled and run as a C++ file.

## Grammar:

  LC	 	=	 	num
 	 	    |	 	id
 	    	|	 	(/ id => LC)
 	    	|	 	(LC LC)
 	     	|	 	(+ LC LC)
 	    	|	 	(* LC LC)
 	     	|	 	(ifleq0 LC LC LC)
 	    	|	 	(println LC)
            
## Examples:

### Example LC input: 
```
((((/ x => (/ y => (/ z => (* x (+ y z))))) 4 ) 3) 2)
```

### Example C++ output:
```
#include <iostream>

int main(int argc, char* argv[]){
    [=](int x) -> decltype(auto) {
        return ([=](int y) -> decltype(auto) {
            return ([=](int z) -> decltype(auto) {
                return ((x * (y + z)));
            });
        });
    }(4)(3)(2);
}
```

### Expected Result:
```
20
```

## TODO

This project is still in development and has plenty of room to grow.
Typechecking will remain a challenge for expressions such as ifleq0 or println


