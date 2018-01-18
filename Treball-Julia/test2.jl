
x = 2
typeof(x)
y = 12.0
typeof(y)

function foo(x::Int64)
    println("the value is $x")
end

foo(x)
foo(y)