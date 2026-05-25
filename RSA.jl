using Oscar

function text_to_int(msg::String)
    msg = uppercase(msg)
    result = ZZ(0)
    for (i, ch) in enumerate(msg)
        if ch == ' '
            digit = ZZ(26)
        elseif 'A' <= ch <= 'Z'
            digit = ZZ(Int(ch) - Int('A'))
        else
            error("Character '$ch' not supported.")
        end
        result += digit * ZZ(27)^(i - 1)  
    end
    return result
end


function int_to_text(n::ZZRingElem)
    chars = Char[]
    while n > 0
        r = Int(n % 27)
        if r == 26
            push!(chars, ' ')
        else
            push!(chars, Char(r + Int('A')))
        end
        n = div(n, 27)
    end
    return String(chars)
end

function generate_rsa_keys(p_bits = 96, q_bits = 96)
    p = next_prime(rand(ZZ(2)^(p_bits-1) : ZZ(2)^p_bits - 1))
    q = next_prime(rand(ZZ(2)^(q_bits-1) : ZZ(2)^q_bits - 1))
    while q == p
        q = next_prime(rand(ZZ(2)^(q_bits-1) : ZZ(2)^q_bits - 1))
    end

    N   = p * q
    phi = (p - 1) * (q - 1)
    e   = ZZ(65537)
    @assert gcd(e, phi) == 1 "Bad prime pair, try again."
    d   = invmod(e, phi)

    println("\n=== YOUR RSA KEY PAIR ===")
    println("N (publish in Excel) = ", N)
    println("e (publish in Excel) = ", e)
    println("─────────────────────────")
    println("d (KEEP SECRET)      = ", d)
    println("p (KEEP SECRET)      = ", p)
    println("q (KEEP SECRET)      = ", q)
    println("=========================\n")

    # Also print max message length for this N
    max_chars = floor(Int, log(27, Float64(N))) 
    println("Your key can encrypt up to ~$max_chars characters (A-Z + space).\n")

    return (N=N, e=e, d=d, p=p, q=q)
end

function encrypt(message::String, N::BigInt, e::Int)
    m = text_to_int(message)
    if m >= N
        error("Message too long for this key! Use fewer than $(floor(Int, log(27, Float64(N)))) characters.")
    end
    c = powermod(ZZ(m), e, ZZ(N))
    println("Ciphertext (post to Teams): ", c)
    return c
end

function decrypt(ciphertext::BigInt, N::BigInt, d::BigInt)
    m = powermod(ZZ(ciphertext), ZZ(d), ZZ(N))
    msg = int_to_text(m)
    println("Decrypted message: \"", msg, "\"")
    return msg
end

function eve_attack(N::BigInt, e::Int, ciphertext::BigInt)
    t = @elapsed factors = factor(N)

    # fac_list = collect(keys(factors))
    # p = fac_list[1]
    # q = fac_list[2]
    fac_list = [p for (p, _) in factors]
    p, q = fac_list[1], fac_list[2]

    println("Factored in $(round(t, digits=3)) seconds!")
    println("Found p = ", p)
    println("Found q = ", q)

    phi      = (p - 1) * (q - 1)
    d_hacked = invmod(e, phi)
    println("Recovered d = ", d_hacked)

    m = powermod(ZZ(ciphertext), ZZ(d_hacked), ZZ(N))
    println("\nEve decrypted: \"", int_to_text(m), "\"")
end

alice = generate_rsa_keys(100,100)

N = 806948837875126562664428038909353676212613124076947935852619
e = 65537
d = 797541801969659472411965719580625279893558085196876299343073

# ===================ENCRYPTION=====================
c = encrypt("CANT GET ME", 806948837875126562664428038909353676212613124076947935852619, 65537)

# ==================DECRYPTION======================
decrypt(667745581070374050183651630988816251853738000355493911171368, 806948837875126562664428038909353676212613124076947935852619, 797541801969659472411965719580625279893558085196876299343073)

# ==================EAVESDROPPING===================
eve_attack(806948837875126562664428038909353676212613124076947935852619, 65537, 667745581070374050183651630988816251853738000355493911171368)