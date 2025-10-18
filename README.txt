================================================================================
findar: Search arXiv papers with GitHub integration
================================================================================

Author: BlueDayDreeaming
Date: 18 October 2025
Version: 1.1.1

================================================================================
Description
================================================================================

findar searches arXiv (https://arxiv.org) for academic papers and automatically
finds associated GitHub repositories. It provides an integrated workflow for
discovering research papers and their code implementations.

Key Features:
  • Search arXiv papers by keywords
  • Automatically extract GitHub repositories from paper metadata
  • Compare multiple GitHub repos by star count
  • Display clickable links to papers, PDFs, DOIs, and GitHub repositories
  • Save results as Stata dataset for further analysis
  • Support both simplified and standard syntax

================================================================================
System Requirements
================================================================================

  • Stata version 16.0 or later
  • Windows or macOS (Linux is not supported)
  • Internet connection required for API access

================================================================================
Installation
================================================================================

From GitHub:

  . net install findar, from("https://raw.githubusercontent.com/BlueDayDreeaming/findar/main/")

Or manually:
  1. Download all files to your Stata ado directory
  2. Type: adopath (to see your ado directories)
  3. Place files in PLUS directory

================================================================================
Quick Start
================================================================================

Basic search (5 results):
  . findar deep learning

Search with more results:
  . findar machine learning, maxresults(10)

Display abstracts:
  . findar transformer attention, abstract

Detailed information:
  . findar neural networks, detail

Save results to dataset:
  . findar causal inference, saving(results) replace

Standard syntax:
  . findar, query("computer vision") maxresults(5)

================================================================================
Syntax
================================================================================

Simplified:
  findar keywords [, options]

Standard:
  findar, query(string) [options]

Options:
  query(string)         search query (required for standard syntax)
  maxresults(#)         maximum results (default: 10 for standard, 5 for 
                        simplified)
  detail                show detailed information
  abstract              display abstracts in simplified mode
  nogithub              disable GitHub search
  nogoogle              disable Google links
  saving(filename)      save results to dataset
  replace               overwrite existing dataset

================================================================================
Examples
================================================================================

See findar_example.do for comprehensive examples including:
  • Basic searches
  • Displaying abstracts
  • Detailed mode
  • Saving results to datasets
  • Accessing stored results

To run examples:
  . do findar_example.do

To view help:
  . help findar

================================================================================
Files Included
================================================================================

  findar.ado            Main program file
  findar.sthlp          Help file
  findar.pkg            Package installation file
  findar_example.do     Example do-file with multiple use cases
  findar_example.log    Log file from running examples
  README.txt            This file

================================================================================
Data Structure
================================================================================

When using the saving() option, the dataset includes:

Variables:
  arxiv_id              arXiv paper ID
  title                 Paper title
  authors               Comma-separated author list
  published             Publication date
  summary               Paper abstract
  comment               arXiv comment field (may contain GitHub URLs)
  doi                   Digital Object Identifier
  gh_source             Source where GitHub URL was found
  gh_repo               GitHub repository name (owner/repo)
  gh_url                Full GitHub repository URL
  gh_stars              Number of GitHub stars
  gh_lang               Primary programming language

================================================================================
Stored Results
================================================================================

r(count)              Number of papers found
r(arxiv_found)        Number with GitHub repos found
r(not_found)          Number without GitHub repos

================================================================================
GitHub Integration
================================================================================

The GitHub search feature:
  • Extracts repository URLs from arXiv metadata (comment and summary)
  • Queries GitHub API to get repository information
  • Compares multiple repos by star count when available
  • Displays repository statistics (stars, language)

Note: GitHub API has rate limits for unauthenticated requests. For large
searches, consider using the nogithub option.

================================================================================
Known Limitations
================================================================================

  • Linux/Unix systems are not supported (Windows and macOS only)
  • Requires internet connection to access arXiv and GitHub APIs
  • GitHub API rate limits may affect large searches
  • Corporate firewalls may block API access

================================================================================
Citation
================================================================================

If you use findar in your research, please cite:

  BlueDayDreeaming (2025). findar: Search arXiv papers with GitHub integration.
  Stata package. https://github.com/BlueDayDreeaming/findar

================================================================================
Support and Bug Reports
================================================================================

GitHub: https://github.com/BlueDayDreeaming/findar
Issues: https://github.com/BlueDayDreeaming/findar/issues

For bug reports, please include:
  • Stata version
  • Operating system
  • Command used
  • Error message (if any)
  • Expected behavior

================================================================================
License
================================================================================

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

================================================================================
Changelog
================================================================================

Version 1.1.1 (18oct2025)
  • Added system compatibility check (Windows/macOS only)
  • Code optimization and cleanup
  • Improved documentation

Version 1.0.0 (Initial release)
  • arXiv search functionality
  • GitHub integration
  • Multiple syntax support
  • Dataset export capability

================================================================================
