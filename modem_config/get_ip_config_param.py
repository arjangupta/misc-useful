import sys

def main():
    input_str = input()

    if not len(sys.argv) == 2:
        print(101)
        return
    
    # TODO: Get the second sys.argv arg
    # TODO: Check if it's a string called address, prefix, gateway, or dns
    # TODO: Go +2 after the length of the search result, get the rest of the input str and output it
    #       TODO: in the case of dns, get the rest until the comma

if __name__ == "__main__":
    main()