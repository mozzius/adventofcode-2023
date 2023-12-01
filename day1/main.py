nums = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

with open("input.txt") as file:
    sum = 0
    for row in file:
        line = row.strip("\n")
        first = ""
        for i in range(len(line)):
            if (first):
                break
            char = line[i]
            if char.isdigit():
                first = char
                break
            else:
                for j in range(len(nums)):
                    num = nums[j]
                    print(num, line[i:i+len(num)])
                    if num == line[i:i+len(num)]:
                        first = str(j+1)
                        break
        last = ""
        for i in range(len(line)-1, -1, -1):
            if (last):
                break
            char = line[i]
            if char.isdigit():
                last = char
                break
            else:
                for j in range(len(nums)):
                    num = nums[j]
                    if num == line[i-len(num)+1:i+1]:
                        last = str(j+1)
                        break
        if first != "" and last != "":
            sum += int(first + last)
        
    print(sum)
