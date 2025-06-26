# `academic-cv-tools`

This is a small python module to parse `.tex` and `.bib` files
from the `academic-cv` LaTeX template and output the `json` data 
used to generate some of the pages in 
[Prof A Frangi's GitHub Pages](https://affrangi.github.io) site,
which is based on the 
[`al-folio`](https://github.com/alshedivat/al-folio) theme.

Files processed include:
- `resume/education.tex`
- `resume/experience.tex`
- `resume/fellowships.tex`
- `resume/funding.tex`
- `resume/honors.tex`
- `bib/books.bib`
- `bib/inbooks.bib`
- `bib/journals.bib`
- `bib/outreach.bib`
- `bib/patents.bib`
- `bib/reports.bib`
- `bib/supervision.bib`

## Setup

```bash
cd academic-cv-tools
sudo apt-get update
sudo apt-get install python3-pip python3-venv
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
chmod +x compile.sh
```

Then, use with `./compile.sh` to process the files. More details
below.

## Config

The configuration file is `input/config.json`. Its structure is
something like:

```json
{
    "bibliography": [
        {
            "file": "journals.bib",
            "category": "journals"
        },
        {
            "file": "books.bib",
            "category": "books"
        },
        {
            "file": "inbooks.bib",
            "category": "chapters"
        }
    ],
    "education": "education.tex",
    "experience": "experience.tex",
    "scholarships_and_fellowships": "fellowships.tex",
    "funding": "funding.tex",
    "awards": "honors.tex",
    "alumni": "pub_supervision.bib"
}
```

All the fields are optional, to allow for partial processing. For
the `bibliography` field, you can specify multiple files
and categories as you wish. The category is added to each entry
in the output bibliography file, so you can filter entries by
category later on.

## Manual usage

1. Clone the repo: 

    ```bash
    git clone https://github.com/bfrangi/academic-cv-tools.git
    ```

2. Change to the `academic-cv-tools` directory:

    ```bash
    cd academic-cv-tools
    ```
3. Place the files you want to process in the `/input/` folder.
4. Edit the config file `config.json` to specify the files
   you want to process as shown above. 
5. Run the script to process the files and generate the output:

    ```bash
    ./compile.sh
    ```

## GitHub Action

You can use this tool in a GitHub Action on the LaTeX 
repo to automatically process the files and generate the 
output. [Here](./update-academic-pages.yaml) is an example
of a GitHub Action workflow file that does this.

For this to work, you need to set the following
[GitHub secrets](https://docs.github.com/en/actions/how-tos/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository)
in your LaTeX repository:
- `PAT`: A personal access token with write access to the GitHub Pages repository.

You will also need to set the following
[GitHub variables](https://docs.github.com/en/actions/how-tos/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables#creating-configuration-variables-for-a-repository):
- `GIT_NAME`: Your GitHub username (if not set, defaults to "CV Auto Bot").
- `GIT_EMAIL`: Your GitHub email address (if not set, defaults to the Actions Bot email).
- `PAGES_REPO`: The name of the GitHub Pages repository in the format `<username>/<repo-name>`. This variable is mandatory for the action to work.

And you will need to make sure your LaTeX repo has the `config.json` and 
the `basics.json` (this last one is optional) files stored in its root 
directory.
