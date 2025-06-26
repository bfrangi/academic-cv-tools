#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (reset)

# Print result
print_result() {
    if [ -f "$SCRIPT_DIR/output/$1" ]; then
        echo -e "$2   └─ ${GREEN}done${NC}."
    else
        echo -e "$2   └─ ${YELLOW}skipped${NC}."
    fi
}

# Get the directory of the current script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Info
echo -e "Running ${CYAN}academic-cv-tools${NC} to compile your academic data!"
echo ""
echo -e "→ ${BLUE}Processing resume data...${NC}"

# Make sure the output directory exists and is empty
mkdir -p $SCRIPT_DIR/output/
rm -rf $SCRIPT_DIR/output/*

# Process the cv data
echo "   ├─ Processing education data..."
python3 "$SCRIPT_DIR/src/process_education.py" "$SCRIPT_DIR/input/config.json"
print_result "education.json" "   │"
echo "   ├─ Processing experience data..."
python3 "$SCRIPT_DIR/src/process_experience.py" "$SCRIPT_DIR/input/config.json"
print_result "experience.json" "   │"
echo "   ├─ Processing honors and awards data..."
python3 "$SCRIPT_DIR/src/process_honors_awards.py" "$SCRIPT_DIR/input/config.json"
print_result "honors.json" "   │"
echo "   └─ Processing scholarships and fellowships data..."
python3 "$SCRIPT_DIR/src/process_scholarships_fellowships.py" "$SCRIPT_DIR/input/config.json"
print_result "fellowships.json" "    "

# Join the cv data
echo -e "→ ${BLUE}Joining resume data...${NC}"
python3 "$SCRIPT_DIR/src/join.py" \
    "$SCRIPT_DIR/input/basics.json" \
    "$SCRIPT_DIR/output/experience.json" \
    "$SCRIPT_DIR/output/education.json" \
    "$SCRIPT_DIR/output/fellowships.json" \
    "$SCRIPT_DIR/output/honors.json"
print_result "resume.json" ""

# Process the funding data
echo -e "→ ${BLUE}Processing funding data...${NC}"
python3 "$SCRIPT_DIR/src/process_funding.py" "$SCRIPT_DIR/input/config.json"
print_result "funding.json" ""

# Process the publications data
echo -e "→ ${BLUE}Processing publications data...${NC}"
python3 "$SCRIPT_DIR/src/process_publications.py" "$SCRIPT_DIR/input/config.json"
print_result "publications.bib" ""

# Process the alumni data
echo -e "→ ${BLUE}Processing alumni data...${NC}"
python3 "$SCRIPT_DIR/src/process_alumni.py" "$SCRIPT_DIR/input/config.json"
print_result "alumni.json" ""

# Clean up the output directory
echo -e "→ ${BLUE}Cleaning up...${NC}"
rm -rf \
    "$SCRIPT_DIR/output/experience.json" \
    "$SCRIPT_DIR/output/education.json" \
    "$SCRIPT_DIR/output/fellowships.json" \
    "$SCRIPT_DIR/output/honors.json"
echo -e "   └─ ${GREEN}done${NC}."

# Final message
echo ""
echo "Academic CV data processing complete!"
echo "Output files are located in the output directory: $SCRIPT_DIR/output/."
echo -e "${CYAN}Please save them somewhere else, or they will be deleted on the next execution of this script.${NC}"
