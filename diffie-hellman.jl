using Oscar

p = 23
F = GF(p)

g = F(5)   
for x in F
    println(x)
end
a = 6      
b = 15     

A = g^a
B = g^b

println("A = ", A)
println("B = ", B)

K_alice = B^a
K_bob   = A^b

println("Shared key (A) = ", K_alice)
println("Shared key (B)   = ", K_bob)