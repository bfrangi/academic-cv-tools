def parse_args() -> dict:
    """Parse command line arguments."""
    import argparse
    import sys

    parser = argparse.ArgumentParser(description="Academic CV Tools CLI")

    parser.add_argument(
        "config",
        type=str,
        help="Path to the JSON config file specifying the sources to parse.",
    )

    variables = vars(parser.parse_args(sys.argv[1:]))

    if not variables["config"].endswith(".json"):
        raise ValueError("Config file must be a .json file.")

    return variables
