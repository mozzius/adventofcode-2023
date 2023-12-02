import fs from "node:fs/promises";

const file = await fs.readFile("input.txt");

const lines = file.toString().split("\n");

let sumOfCorrectIds = 0;

const MAX = {
  red: 12,
  green: 13,
  blue: 14,
} as const;

// part 1

for (const line of lines) {
  const [game, grabs] = line.split(":") as [string, string];
  const id = Number(game.slice("Game ".length));
  if (
    grabs
      .split(";")
      .map((x) =>
        x
          .trim()
          .split(", ")
          .every((grab) => {
            const [count, color] = grab.split(" ") as [
              string,
              "red" | "green" | "blue"
            ];
            return Number(count) <= MAX[color];
          })
      )
      .every(Boolean)
  ) {
    sumOfCorrectIds += id;
  }
}

console.log("Part 1:", sumOfCorrectIds);

// part 2

let sumOfMinimumPowers = 0;

for (const line of lines) {
  const [, grabs] = line.split(":") as [string, string];
  const minSet = {
    red: 0,
    green: 0,
    blue: 0,
  };

  grabs.split(";").forEach((x) =>
    x
      .trim()
      .split(", ")
      .forEach((grab) => {
        const [count, color] = grab.split(" ") as [
          string,
          "red" | "green" | "blue"
        ];
        minSet[color] = Math.max(minSet[color], Number(count));
      })
  );

  sumOfMinimumPowers += minSet.red * minSet.green * minSet.blue;
}

console.log("Part 2:", sumOfMinimumPowers);

// part 2
