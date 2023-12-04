#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct FileInfo
{
    int numberOfLines;
    int numberOfWinningNumbers;
    int numberOfNumbersYouHave;
};

void skipCard(FILE *fptr)
{
    char ch;
    while (ch != ':')
    {
        ch = fgetc(fptr);
    }
}

void skipCount(FILE *fptr, int count)
{
    char ch;
    for (int i = 0; i < count; i++)
    {
        ch = fgetc(fptr);
    }
}

struct FileInfo getFileInfo(FILE *fptr)
{
    struct FileInfo info = {0, 0, 0};
    char ch = fgetc(fptr);
    if (ch == EOF)
    {
        printf("Early abort - EOF\n");
        return info;
    }
    skipCard(fptr);
    int charCount = 0;
    while (ch != '|')
    {
        charCount++;
        ch = fgetc(fptr);
    }
    info.numberOfWinningNumbers = (charCount - 2) / 3;

    charCount = 0;
    while (ch != '\n')
    {
        charCount++;
        ch = fgetc(fptr);
    }
    info.numberOfNumbersYouHave = (charCount - 1) / 3;

    rewind(fptr);

    while (ch != EOF)
    {
        if (ch == '\n')
            info.numberOfLines++;
        ch = fgetc(fptr);
    }

    rewind(fptr);

    return info;
}

int getInt(char str[4])
{
    char num[2];
    if (str[1] == ' ')
    {
        num[0] = str[2];
    }
    else
    {
        num[0] = str[1];
        num[1] = str[2];
    }
    return atoi(num);
}

int getScore(int num)
{
    if (num <= 1)
        return num;
    int res = 1;
    for (int i = 1; i < num; i++)
    {
        res *= 2;
    }
    return res;
}

int main()
{
    FILE *fptr = fopen("input.txt", "r");

    // get info about the file

    struct FileInfo info = getFileInfo(fptr);

    // parse file for numbers

    int winningNumbers[info.numberOfLines][info.numberOfWinningNumbers];
    int numbersYouHave[info.numberOfLines][info.numberOfNumbersYouHave];

    for (int i = 0; i < info.numberOfLines; i++)
    {
        skipCard(fptr);

        // get winning numbers
        for (int j = 0; j < info.numberOfWinningNumbers; j++)
        {
            char num[4] = {fgetc(fptr), fgetc(fptr), fgetc(fptr), '\0'};
            winningNumbers[i][j] = getInt(num);
        }

        skipCount(fptr, 2);

        // get your numbers
        for (int j = 0; j < info.numberOfNumbersYouHave; j++)
        {
            char num[4] = {fgetc(fptr), fgetc(fptr), fgetc(fptr), '\0'};
            numbersYouHave[i][j] = getInt(num);
        }

        skipCount(fptr, 1);
    }

    fclose(fptr);

    // task 1

    int winningNumbersCount = 0;
    int task1Result = 0;

    for (int i = 0; i < info.numberOfLines; i++)
    {
        winningNumbersCount = 0;

        for (int j = 0; j < info.numberOfNumbersYouHave; j++)
        {
            for (int k = 0; k < info.numberOfWinningNumbers; k++)
            {
                if (numbersYouHave[i][j] == winningNumbers[i][k])
                {
                    winningNumbersCount++;
                }
            }
        }

        task1Result += getScore(winningNumbersCount);
    }

    printf("Task 1: %i\n", task1Result);

    // task 2

    long numberOfCopies = info.numberOfLines;
    long copiesPerLine[info.numberOfLines];
    memset(copiesPerLine, 0, info.numberOfLines * sizeof(long));

    for (int i = 0; i < info.numberOfLines; i++)
    {
        copiesPerLine[i] += 1;

        winningNumbersCount = 0;

        for (int j = 0; j < info.numberOfNumbersYouHave; j++)
        {
            for (int k = 0; k < info.numberOfWinningNumbers; k++)
            {
                if (numbersYouHave[i][j] == winningNumbers[i][k])
                {
                    winningNumbersCount++;
                }
            }
        }

        for (int j = 1; j <= winningNumbersCount; j++)
        {
            if ((i + j) <= info.numberOfLines)
            {
                copiesPerLine[i + j] += copiesPerLine[i];
            }
        }
    }

    long task2Result = 0;

    for (int i = 0; i < info.numberOfLines; i++)
    {
        task2Result += copiesPerLine[i];
    }

    printf("Task 2: %li\n", task2Result);

    return 0;
}