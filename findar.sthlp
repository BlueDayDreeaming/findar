{smcl}
{* *! version 1.1.5  16dec2025}{...}
{viewerjumpto "Syntax" "findar##syntax"}{...}
{viewerjumpto "Description" "findar##description"}{...}
{viewerjumpto "Options" "findar##options"}{...}
{viewerjumpto "Examples" "findar##examples"}{...}
{viewerjumpto "Stored results" "findar##results"}{...}
{viewerjumpto "Author" "findar##author"}{...}
{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{cmd:findar} {hline 2}}Search arXiv papers with GitHub 
integration{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Simplified syntax

{p 8 15 2}
{cmd:findar} {it:keywords} [{cmd:,} {it:options}]


{pstd}
Standard syntax

{p 8 15 2}
{cmd:findar}{cmd:,} {opt q:uery(string)} [{it:options}]


{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt q:uery(string)}}search query string (required in standard 
syntax){p_end}
{synopt :{opt maxr:esults(#)}}maximum number of results; default is 
{cmd:maxresults(10)} for standard syntax, {cmd:maxresults(5)} for 
simplified{p_end}
{synopt :{opt det:ail}}display detailed information including authors 
and publication dates{p_end}
{synopt :{opt abs:tract}}display paper abstracts in simplified 
mode{p_end}
{synopt :{opt nogit:hub}}disable GitHub repository search{p_end}
{synopt :{opt nogoo:gle}}disable Google search links in detailed 
mode{p_end}
{synopt :{opt save}}keep results in memory as dataset{p_end}
{synopt :{opt saving(filename)}}save results to Stata dataset 
file{p_end}
{synopt :{opt replace}}overwrite existing dataset (use with 
saving()){p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:findar} searches arXiv (https://arxiv.org) for academic papers 
and automatically finds associated GitHub repositories. It provides an 
integrated workflow for discovering research papers and their 
implementations.

{pstd}
The command supports two syntax styles:

{phang2}
{bf:Simplified syntax:} Type keywords directly: 
{cmd:findar machine learning}

{phang2}
{bf:Standard syntax:} Use the query() option: 
{cmd:findar, query("machine learning")}

{pstd}
Key features:

{phang2}
• Searches arXiv API for academic papers{p_end}
{phang2}
• Automatically extracts GitHub URLs from paper metadata{p_end}
{phang2}
• Compares multiple GitHub repositories by star count{p_end}
{phang2}
• Displays clickable links to papers, PDFs, DOIs, and GitHub 
repos{p_end}
{phang2}
• Optionally saves results as Stata dataset{p_end}

{pstd}
{bf:System Requirements:}

{phang2}
• Stata version 16.0 or later{p_end}
{phang2}
• Windows or macOS (Linux is not supported){p_end}
{phang2}
• Internet connection required{p_end}


{marker options}{...}
{title:Options}

{phang}
{opt query(string)} specifies the search query. Required when using 
standard syntax. The query can contain multiple keywords, which will be 
searched across all fields (title, abstract, authors, etc.) in arXiv.

{phang}
{opt maxresults(#)} specifies the maximum number of results to return. 
Must be between 1 and 100. Default is 10 for standard syntax and 5 for 
simplified syntax.

{phang}
{opt detail} displays detailed information including authors, 
publication dates, and additional links. Without this option, the 
simplified syntax shows a concise format with just titles and links.

{phang}
{opt abstract} displays paper abstracts when using simplified syntax. 
Abstracts are automatically word-wrapped for readability.

{phang}
{opt nogithub} disables the automatic GitHub repository search. By 
default, {cmd:findar} searches for GitHub repositories mentioned in 
paper metadata.

{phang}
{opt nogoogle} disables Google search links in detailed mode.

{phang}
{opt save} keeps the search results in memory as a Stata dataset. Use 
this option when you want to browse or analyze the results after the 
search completes. Without this option or {opt saving()}, the results 
are displayed but not stored.

{phang}
{opt saving(filename)} saves the search results to a Stata dataset 
file (.dta). The dataset includes variables for paper titles, authors, 
arXiv IDs, abstracts, GitHub URLs, star counts, and more. Use 
{cmd:describe} or {cmd:browse} to explore the saved data.

{phang}
{opt replace} allows overwriting an existing dataset file when using 
{opt saving()}. This option is ignored when using {opt save} alone.


{marker examples}{...}
{title:Examples}

{pstd}
Basic search using simplified syntax (5 results by default)

{phang2}{cmd:. findar deep learning}

{pstd}
Search with more results

{phang2}{cmd:. findar machine learning, maxresults(10)}

{pstd}
Search with detailed information

{phang2}{cmd:. findar neural networks, detail}

{pstd}
Display abstracts in simplified mode

{phang2}{cmd:. findar transformer attention, abstract}

{pstd}
Search without GitHub integration

{phang2}{cmd:. findar reinforcement learning, nogithub}

{pstd}
Standard syntax with query option

{phang2}{cmd:. findar, query("computer vision") maxresults(5)}

{pstd}
Keep results in memory for browsing

{phang2}{cmd:. findar deep learning, maxresults(10) save}{p_end}
{phang2}{cmd:. browse}{p_end}
{phang2}{cmd:. list title arxiv_id in 1/5}

{pstd}
Save results to dataset file

{phang2}{cmd:. findar causal inference, maxresults(20) ///}{p_end}
{phang3}{cmd:saving(causal_papers) replace}

{pstd}
Access saved data

{phang2}{cmd:. use causal_papers, clear}{p_end}
{phang2}{cmd:. list title arxiv_id gh_repo gh_stars in 1/5}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:findar} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(count)}}number of papers found{p_end}
{synopt:{cmd:r(arxiv_found)}}number of papers with GitHub repos found 
in arXiv metadata{p_end}
{synopt:{cmd:r(not_found)}}number of papers without GitHub 
repos{p_end}


{pstd}
When {opt saving()} is used, the following variables are stored in the 
dataset:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Variables}{p_end}
{synopt:{cmd:arxiv_id}}arXiv paper ID{p_end}
{synopt:{cmd:title}}paper title{p_end}
{synopt:{cmd:authors}}comma-separated list of authors{p_end}
{synopt:{cmd:published}}publication date{p_end}
{synopt:{cmd:summary}}paper abstract{p_end}
{synopt:{cmd:comment}}arXiv comment field (may contain GitHub 
links){p_end}
{synopt:{cmd:doi}}Digital Object Identifier{p_end}
{synopt:{cmd:gh_source}}source where GitHub URL was found{p_end}
{synopt:{cmd:gh_repo}}GitHub repository name (owner/repo){p_end}
{synopt:{cmd:gh_url}}full GitHub repository URL{p_end}
{synopt:{cmd:gh_stars}}number of GitHub stars{p_end}
{synopt:{cmd:gh_lang}}primary programming language of 
repository{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}
{bf:GitHub Integration:}

{pstd}
The GitHub search feature extracts repository URLs from arXiv paper 
metadata (comment and summary fields). When multiple GitHub repositories 
are found for a single paper, {cmd:findar} automatically queries the 
GitHub API to compare star counts and selects the most popular 
repository.

{pstd}
{bf:Rate Limits:}

{pstd}
The GitHub API has rate limits for unauthenticated requests. If you 
search for many papers, you may encounter temporary rate limiting. 
Consider using the {opt nogithub} option for large searches, or space 
out your queries.

{pstd}
{bf:Network Requirements:}

{pstd}
{cmd:findar} requires internet access to query the arXiv API 
(export.arxiv.org) and optionally the GitHub API (api.github.com). 
Corporate firewalls or proxy settings may affect functionality.


{marker author}{...}
{title:Authors}

{pstd}
Chucheng Wan (chucheng.wan@outlook.com){break}
Yile Zhang (zhangyle5@mail2.sysu.edu.cn){break}
Xinyi Huang (huangxy577@mail2.sysu.edu.cn){break}
Qin Qin (qinq25@mail2.sysu.edu.cn){break}
Xinyi Yi (3031727931@qq.com){break}
GitHub: https://github.com/BlueDayDreeaming/findar


{marker also_see}{...}
{title:Also see}

{pstd}
arXiv API documentation: {browse "https://arxiv.org/help/api/"}

{pstd}
GitHub repository: 
{browse "https://github.com/BlueDayDreeaming/findar"}
