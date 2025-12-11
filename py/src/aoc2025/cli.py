from importlib.metadata import entry_points
from os import environ
from pathlib import Path
from sys import argv

from natsort import natsorted


def main():
    args = set(argv)
    days = entry_points(group="aoc2025.days")
    days = [day for day in days if day.name in args] or days
    for day in natsorted(days, key=lambda day: day.name):
        day, parts = day.name, day.load()
        print(f"Day {day}")
        input = (
            Path(environ.get("AOC2025_DATADIR") or ".") / f"day{day}.txt"
        ).read_text()
        for part in parts:
            output = part(input)
            if isinstance(output, tuple):
                for part in output:
                    print(part)
            else:
                print(output)
        print()
