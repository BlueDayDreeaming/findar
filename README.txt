NOTE:  readme.txt template -- do not remove empty entries, but you may
                              add entries for additional authors
------------------------------------------------------------------------------

Package name:   findar

DOI:  

Title: findar - Search arXiv papers and discover GitHub repositories

Author 1 name: BlueDayDreeaming
Author 1 from: 
Author 1 email: 

Author 2 name:  
Author 2 from:  
Author 2 email: 

Author 3 name:  
Author 3 from:  
Author 3 email: 

Author 4 name:  
Author 4 from:  
Author 4 email: 

Author 5 name:  
Author 5 from:  
Author 5 email: 

Help keywords: findar, arXiv, GitHub, search, citation, bibliography, research

File list: findar.ado findar.sthlp findar_example.do findar_example.log findar_test.ado findar_test.sthlp

Notes: findar searches arXiv (https://arxiv.org) for academic papers and 
automatically discovers associated GitHub repositories. It provides an 
integrated workflow for finding research papers and their code implementations.
The command displays paper information including titles, authors, abstracts, 
arXiv IDs, and GitHub repository details (stars, forks, language). Search 
results can be saved as Stata datasets (using 'save' option for memory or 
'saving()' option for file) for further analysis. Citations can be exported 
in BibTeX format. Includes a diagnostic tool (findar_test) for troubleshooting 
network connectivity issues on macOS.

Key features:
  • Search arXiv papers by keywords
  • Automatically extract GitHub repositories from paper metadata
  • Display GitHub repository statistics (stars, forks, language)
  • Save results as dataset (to memory or file)
  • Export BibTeX citations
  • Cross-platform support with macOS-specific optimizations (HTTPS)

Internet connection required. Stata 16.0 or higher required.
Supported platforms: Windows, macOS (not available on Linux).

Installation: net install findar, from(https://raw.githubusercontent.com/BlueDayDreeaming/findar/main/)

For help: help findar
For examples: do findar_example.do
For macOS troubleshooting: help findar_test

GitHub: https://github.com/BlueDayDreeaming/findar
