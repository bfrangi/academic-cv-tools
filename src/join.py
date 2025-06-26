import json
import os
import sys

from lib.files import output_dir


def merge_json_files(file_list):
    merged = {}
    for file_path in file_list:
        if not os.path.exists(file_path):
            continue
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
            merged.update(data)
    return merged


def main():
    if len(sys.argv) < 2:
        print("Usage: python join.py file1.json file2.json ...")
        sys.exit(1)
    files = sys.argv[1:]
    merged = merge_json_files(files)

    # Save the merged output to another file
    if merged:
        output_file = f"{output_dir()}/resume.json"
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(merged, f, indent=2, ensure_ascii=False)


if __name__ == "__main__":
    main()
