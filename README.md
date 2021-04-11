# lambda-calculus-translation-boe_asbury
lambda-calculus-translation-boe_asbury created by GitHub Classroom

We wrote a racket program that compiles lamda calculus expressions into C++ programs.
The method 'compile' takes in a string representation of a LC expression. The
expression is wrapped with the necessary C++ include statements and the main definition,
and then the expression is parsed. In the end, the full C++ program is displayed into
stdout, which can then be copied and pasted and compiled and ran in a C++ file.

A difficulty we ran into was determining when to add semicolons.
In some instances, an expressions such as println or a function call may make up the 
entirety of an expression and thus needs a semicolon to terminate the line. Other times,
those expressions may be a part of a larger expression (such as within an ifleq0) and 
will not compile if semicolons follow them. We decided that one way to approach this
would be to add new 'statement' definitions to the grammar that end in semicolons.
With statements, we could distinguish instances when the expressions were the
outermost part of the expression and thus should be terminated with a semicolon.

However, we did not modify the grammar in our project. We decided our compiler would
only include semicolons in two places: after the return statement of a lambda expression
and at the end of the main.

We also did not end up implementing type checking. For example, if an int and a non-int
are added together within the LC, C++ code will be generated but will fail to compile.

###Example LC input: 
```
((((/ x => (/ y => (/ z => (* x (+ y z))))) 4 ) 3) 2)
```

###Example C++ output:
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

###Expected Result:
```
20
```


