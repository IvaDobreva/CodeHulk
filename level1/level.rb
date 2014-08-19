def create_dictionary(enc, dec)
  dict = {}
  enc.split(//).each_with_index do |c, index|
    dict[c] = dec[index]
  end
  dict
end

def decode_msg(dictionary,oldMsg)
  decodedMsg = ""
  oldMsg.each_char do |c|
    decodedMsg += dictionary[c]
  end
  decodedMsg
end

encoded = "wvEr2JmJUs2JRr:7WOmFBAo98w?bIS
0s2E:7-f/-G/N-.f7jN:Mi:.CDfGX7tn!

ys6vs6h7ys6vs6h7KEH4Ea2Jr17JddEvJs2E7saaJa2srUE,7RlExh73sa2sxvah7ys6DDD"

decoded = "Identification: bSfzH-p?lIhEkY
Date: 07/08/2057 12:34:56.789 CGT

Mayday! Mayday! Requesting immediate assistance, over! Bastards! May..."

encodedMsg = "wvEr2JmJUs2JRr:7a1AJvvHvAmRRWsxWsFAvJvAJAaoE88A2?s2AxJ1?29
0s2E:7-f/-G/N-.f7jN:MC:ifDCGN7tn!

0Esx7bsx2?8Jr1a,
SR47sxE7?ExEW67rR2JmJEv72?s27s8876R4x7WsaE7sxE7WE8Rr172R74aD

SR4xa7aJrUExE86,
!?E7OosUE7B48Ia"

dictionary = {}
dictionary = create_dictionary(encoded, decoded)
puts decode_msg(dictionary, encodedMsg)
