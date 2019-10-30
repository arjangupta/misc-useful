import sys

def main():
    input_str = input()

    search_str = '/Modem/'
    
    if len(sys.argv) > 1 and sys.argv[1] == '-b':
        search_str = '/Bearer/'

    search_result = input_str.find(search_str)

    if search_result == -1:
        # Substring '/Modem/' not found
        print(101)
        return

    # Get whatever is after the '/Modem/' and try to convert it to int
    mmcli_index = int(input_str[(search_result + len(search_str)):])
    
    # Print modem index value
    print(mmcli_index)
    return

if __name__ == '__main__':
    main()