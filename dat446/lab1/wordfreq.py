def tokenize(lines: list[str]) -> list[str]:
    words = []
    for line in lines:
        line = line.lower()

        start = 0
        end = 0
        while start < len(line):   
            if line[start].isspace():
                # Blanksteg
                end += 1

            elif line[start].isdigit():
                # Siffror
                while end < len(line) and line[end].isdigit():
                    end += 1
                words.append(line[start:end])
                

            elif line[start].isalpha():
                # Bokstäver
                while end < len(line) and line[end].isalpha():
                    end += 1
                words.append(line[start:end])
            
            else:
                # Tecken
                words.append(line[start])
                end += 1
            
            start = end            
    
    return words

def countWords(words: list[str], stopWords: list[str]) -> dict[str, int]:
    frequencies = {}

    for word in words:
        if word in stopWords:
            continue
        
        if not word in frequencies.keys():
            frequencies[word] = 0
        frequencies[word] += 1

    return frequencies

def printTopMost(frequencies: dict[str, int], n: int) -> str:
    frequencies = sorted(frequencies.items(), key=lambda x: x[1], reverse=True)
    
    for item in frequencies[:n]:
        print(item[0].ljust(20) + str(item[1]).rjust(5))
