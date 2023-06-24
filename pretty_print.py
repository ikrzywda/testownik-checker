#!/usr/bin/env python3

import re
import sys
from enum import Enum
from pathlib import Path
from typing import Dict, List, Optional, Tuple

HEADER_REGEX_PATTERN = r"^X+([01]+)$"


class ExpressionType(Enum):
    Header = "H"
    Descriptor = "X"
    QuestionTrue = "1"
    QuestionFalse = "0"


COLOR_ESCAPE = "\033[0m"
ExpressionColoring: Dict[ExpressionType, str] = {
    ExpressionType.Header: "\033[1;37;40m",
    ExpressionType.Descriptor: "\033[1;34;40m",
    ExpressionType.QuestionTrue: "\033[1;32;40m",
    ExpressionType.QuestionFalse: "\033[1;31;40m",
}


def parse_question_from_string(raw_question: str) -> List[Tuple[ExpressionType, str]]:
    if not raw_question:
        return None

    lines = raw_question.splitlines()
    header = lines[0]
    match = re.match(HEADER_REGEX_PATTERN, header)

    header = "H" + header

    if not match or len(lines[0]) != len(lines):
        return None

    return [(ExpressionType(token), line) for token, line in zip(header, lines)]


def parse_question(path: Path) -> Dict[ExpressionType, str]:
    with open(path, "r", encoding="utf-8-sig") as question_file:
        raw_question = question_file.read()
        return parse_question_from_string(raw_question)


def pretty_print_question(question: Optional[List[Dict[ExpressionType, str]]]):
    if not question:
        exit(1)
    for truth_value, answer in question:
        print(rf"{ExpressionColoring[truth_value]}{answer}{COLOR_ESCAPE}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: pretty_print.py <path_to_question>")
        exit(1)
    path = Path(sys.argv[1])
    question = parse_question(path)
    pretty_print_question(question)
