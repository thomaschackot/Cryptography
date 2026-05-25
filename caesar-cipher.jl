function Caesar_cipher(s, k)
    result = ""
    for c in s
        if(isuppercase(c))
            result *= Char(mod(Int(c) - Int('A') + k, 26) + Int('A')) 
        elseif(islowercase(c))
            result *= Char(mod(Int(c) - Int('a') + k, 26) + Int('a')) 
        end
    end
    return result
end

S = "ALGEBRA"

# =========ENCRYPTION=============
println(Caesar_cipher(S, 13))

# ========DECRYPTION=============
println(Caesar_cipher("NYTROEN",-13)) 