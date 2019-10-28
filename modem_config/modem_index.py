import sys

def main():
    input_str = input()
    search_str = '/Modem/'
    search_result = input_str.find(search_str)

    if search_result == -1:
        # Substring "/Modem/" not found
        print(101)
        return
    elif search_result + len(search_str) == len(input_str):
        # /Modem/ is the end of the input string'
        print(102)
        return

    modem_index = input_str[search_result + len(search_str)]
    
    # Print modem index value
    print(modem_index)
    return


if __name__ == '__main__':
    main()