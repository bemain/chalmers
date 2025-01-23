import sys, urllib.request
from wordfreq import printTopMost, countWords, tokenize

def fetch_web_file(url: str) -> list[str]:
    response = urllib.request.urlopen(url)
    return response.read().decode("utf8").splitlines()

def main():
    stop_words: list[str] = []
    with open(sys.argv[1], encoding="utf-8") as stop_words_file:
        for line in stop_words_file:
            stop_words.append(line.strip())
    
    lines: list[str]
    if sys.argv[2].startswith(("https://", "http://")):
        lines = fetch_web_file(sys.argv[2])
    else:
        with open(sys.argv[2], encoding="utf-8") as input_file:
            lines = input_file.readlines()
    
    n: int = int(sys.argv[3])
    
    printTopMost(countWords(tokenize(lines), stop_words), n)


if __name__ == "__main__":
    main()