# findar: Search arXiv papers with GitHub integration

[![Stata](https://img.shields.io/badge/Stata-16.0%2B-blue)](https://www.stata.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS-lightgrey)](https://github.com/BlueDayDreeaming/findar)

Search arXiv papers and automatically find associated GitHub repositories with a single command.

## Features

- 🔍 **Search arXiv** - Query academic papers from arXiv.org
- 🐙 **GitHub Integration** - Automatically find associated GitHub repositories
- ⭐ **Smart Comparison** - Compare multiple repos by star count
- 📊 **Export Results** - Save results as Stata dataset
- 🔗 **Clickable Links** - Direct links to papers, PDFs, DOIs, and repos
- 🎯 **Flexible Syntax** - Simple keywords or detailed query options

## Installation

```stata
net install findar, from("https://raw.githubusercontent.com/BlueDayDreeaming/findar/main/")
```

Or download and place in your Stata ado directory.

## Requirements

- Stata 16.0 or later
- Windows or macOS (Linux not supported)
- Internet connection

## Quick Start

### Basic Search
```stata
findar deep learning
```

### Search with Options
```stata
findar machine learning, maxresults(10)
```

### Display Abstracts
```stata
findar transformer attention, abstract
```

### Detailed Information
```stata
findar neural networks, detail
```

### Save Results
```stata
findar causal inference, saving(results) replace
```

## Syntax

### Simplified Syntax
```stata
findar keywords [, options]
```

### Standard Syntax
```stata
findar, query(string) [options]
```

### Options

| Option | Description |
|--------|-------------|
| `query(string)` | Search query (required for standard syntax) |
| `maxresults(#)` | Maximum number of results (default: 10) |
| `detail` | Display detailed information |
| `abstract` | Show paper abstracts |
| `nogithub` | Disable GitHub search |
| `save` | Keep results in memory (v1.1.5+) |
| `saving(filename)` | Save results to file |
| `replace` | Overwrite existing dataset |

## Examples

See [`findar_example.do`](findar_example.do) for comprehensive examples.

```stata
* Basic search
findar deep learning

* More results
findar machine learning, maxresults(20)

* With abstracts
findar transformer attention, abstract

* Detailed mode
findar reinforcement learning, detail

* Save to memory (new in v1.1.5)
findar computer vision, maxresults(10) save

* Save to file
findar computer vision, saving(cv_papers) replace

* Standard syntax
findar, query("natural language processing") maxresults(5)
```

## Output Variables

When using `saving()`, the dataset includes:

| Variable | Description |
|----------|-------------|
| `arxiv_id` | arXiv paper ID |
| `title` | Paper title |
| `authors` | Author list |
| `published` | Publication date |
| `summary` | Abstract |
| `doi` | Digital Object Identifier |
| `gh_repo` | GitHub repository (owner/repo) |
| `gh_url` | GitHub URL |
| `gh_stars` | Star count |
| `gh_lang` | Programming language |

## Stored Results

| Result | Description |
|--------|-------------|
| `r(count)` | Number of papers found |
| `r(arxiv_found)` | Papers with GitHub repos |
| `r(not_found)` | Papers without repos |

## How It Works

1. **Query arXiv API** - Searches arXiv for matching papers
2. **Extract GitHub URLs** - Scans paper metadata for GitHub links
3. **Fetch Repo Info** - Queries GitHub API for repository details
4. **Compare & Rank** - When multiple repos found, compares by stars
5. **Display Results** - Shows formatted output with clickable links

## Screenshots

### Basic Search
```
--------------------------------------------------------------------------------
arXiv Search + GitHub Integration
--------------------------------------------------------------------------------
Query: deep learning
Max results: 5
GitHub search: ENABLED (default)
--------------------------------------------------------------------------------
Searching arXiv...
Found 5 papers.

[1] Opening the black box of deep learning
Links: arXiv PDF DOI GitHub(★1234)
```

### Detailed Mode
```
[1] Neural Network Architectures
Authors: John Doe, Jane Smith
Published: 2024-01-15

Links: arXiv  PDF  GitHub(repo_name_★5678_Python)
```

## Known Limitations

- Linux/Unix not supported (Windows and macOS only)
- GitHub API rate limits apply (60 requests/hour unauthenticated)
- Requires internet connection
- Corporate firewalls may block API access

## Help

```stata
help findar
```

## Citation

If you use findar in your research, please cite:

```
BlueDayDreeaming (2025). findar: Search arXiv papers with GitHub integration.
Stata package. https://github.com/BlueDayDreeaming/findar
```

## Support

- 📝 [Documentation](findar.sthlp)
- 🐛 [Issue Tracker](https://github.com/BlueDayDreeaming/findar/issues)
- 💬 [Discussions](https://github.com/BlueDayDreeaming/findar/discussions)

## License

[MIT License](LICENSE)

## Authors

**Yujun Lian**
- Affiliation: Sun Yat-sen University, Guangzhou, China
- Email: arlionn@163.com

**Chucheng Wan**
- Affiliation: Sun Yat-sen University, Guangzhou, China
- Email: chucheng.wan@outlook.com

## Changelog

### Version 1.1.5 (2025-10-18)
- Added `save` option to keep results in memory
- Fixed macOS connectivity issues (HTTPS support)
- Added XML declaration skip for better parsing
- Improved data handling (auto-clear when not saving)
- Removed diagnostic tool (findar_test)

### Version 1.1.4 (2025-10-18)
- HTTPS support for macOS compatibility
- XML parsing improvements

### Version 1.1.1 (2025-10-18)
- Added system compatibility check (Windows/macOS only)
- Code optimization and cleanup
- Improved documentation
- Added comprehensive examples

### Version 1.0.0 (Initial Release)
- arXiv search functionality
- GitHub integration
- Multiple syntax support
- Dataset export capability
