NOTE:  readme.txt template -- do not remove empty entries, but you may
                              add entries for additional authors
------------------------------------------------------------------------------

Package name:   findar

DOI:  

Title: findar - Search arXiv papers and discover GitHub repositories

Author 1 name: Chucheng Wan
Author 1 from: Sun Yat-sen University, Guangzhou, China
Author 1 email: chucheng.wan@outlook.com

Author 2 name: Yile Zhang
Author 2 from: Sun Yat-sen University, Guangzhou, China
Author 2 email: zhangyle5@mail2.sysu.edu.cn

Author 3 name: Xinyi Huang
Author 3 from: Sun Yat-sen University, Guangzhou, China
Author 3 email: huangxy577@mail2.sysu.edu.cn

Author 4 name: Qin Qin
Author 4 from: Sun Yat-sen University, Guangzhou, China
Author 4 email: qinq25@mail2.sysu.edu.cn

Author 5 name: Xinyi Yi
Author 5 from: Sun Yat-sen University, Guangzhou, China
Author 5 email: 3031727931@qq.com

Help keywords: findar, arXiv, GitHub, search, citation, bibliography, research

File list: findar.ado findar.sthlp findar_example.do findar_example.log

Notes: findar searches arXiv (https://arxiv.org) for academic papers and 
automatically discovers associated GitHub repositories. It provides an 
integrated workflow for finding research papers and their code implementations.
The command displays paper information including titles, authors, abstracts, 
arXiv IDs, and GitHub repository details (stars, forks, language). Search 
results can be saved as Stata datasets (using 'save' option for memory or 
'saving()' option for file) for further analysis. Citations can be exported 
in BibTeX format.

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

GitHub: https://github.com/BlueDayDreeaming/findar
