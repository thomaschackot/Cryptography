
# ================== CIPHERTEXT ==================

ciphertext = " "
println(ciphertext)

# ================== FREQUENCY ANALYSIS ==================
function frequency_analysis(text::String)
    counts = Dict{Char, Int}()
    
    # Count frequency of each character
    for c in text
        counts[c] = get(counts, c, 0) + 1
    end
    
    # Sort characters by frequency (highest to lowest)
    sorted_chars = sort(collect(keys(counts)), 
                        by = c -> counts[c], 
                        rev = true)
    
    # Print only the sorted characters
    println("=== SYMBOLS SORTED BY FREQUENCY (Most to Least Common) ===")
    for char in sorted_chars
        display = (char == ' ') ? "␣(space)" : "'$char'"
        println(display)
    end
    
    return sorted_chars   # Returns array of characters in frequency order
end

# ================== DECRYPTION FUNCTION ==================
function decrypt(ciphertext::String, mapping::Dict{Char,Char})
    result = ""
    for c in ciphertext
        result *= get(mapping, c, '?')   # ? = not mapped yet
    end
    return result
end

# ====================== MAPPING ======================

freq = frequency_analysis(ciphertext)

mapping = Dict{Char,Char}()


mapping[' '] = ' '
mapping['R'] = 'E'
mapping['L'] = 'T'
mapping['I'] = 'A'
mapping['X'] = 'O'
mapping['V'] = 'I'
mapping['D'] = 'N'
mapping['K'] = 'S'
mapping['Q'] = 'H'
mapping['T'] = 'R'
mapping['G'] = 'D'
mapping['E'] = 'L'
mapping['Z'] = 'C'
mapping['M'] = 'U'
mapping['U'] = 'M'
mapping['F'] = 'W'
mapping['N'] = 'F'
mapping['Y'] = 'G'
mapping['P'] = 'Y'
mapping['J'] = 'P'
mapping['A'] = 'B'
mapping['S'] = 'V'
mapping['O'] = 'K'
mapping['B'] = 'J'
mapping['C'] = 'X'
mapping['H'] = 'Q'
mapping['W'] = 'Z'

plaintext = decrypt(ciphertext, mapping)

println("\n=== YOUR CURRENT DECRYPTION ===")
println(plaintext)
println("\nUpdate the 'mapping' dictionary and re-run until the message is readable.")