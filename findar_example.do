********************************************************************************
* findar_example.do
* Example usage of the findar command
* Author: BlueDayDreeaming
* Date: 18oct2025
* Version: 1.1.5
********************************************************************************

clear all
set more off

log using findar_example.log, replace text

display as text "{hline 80}"
display as text "findar - Search arXiv papers and discover GitHub repositories"
display as text "Version 1.1.5"
display as text "{hline 80}"

********************************************************************************
* Example 1: Basic search using simplified syntax
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 1: Basic search - simplified syntax (5 results)"
display as text "{hline 80}"

findar deep learning

********************************************************************************
* Example 2: Search with specified number of results
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 2: Search with 3 results"
display as text "{hline 80}"

findar machine learning, maxresults(3)

********************************************************************************
* Example 3: Display abstracts
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 3: Display abstracts"
display as text "{hline 80}"

findar transformer attention, maxresults(2) abstract

********************************************************************************
* Example 4: Detailed mode
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 4: Detailed information mode"
display as text "{hline 80}"

findar reinforcement learning, maxresults(2) detail

********************************************************************************
* Example 5: Search without GitHub integration
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 5: Disable GitHub search"
display as text "{hline 80}"

findar neural networks, maxresults(2) nogithub

********************************************************************************
* Example 6: Standard syntax with query option
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 6: Standard syntax"
display as text "{hline 80}"

findar, query("computer vision") maxresults(2)

********************************************************************************
* Example 7: Save results to memory (new in v1.1.5)
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 7: Save results to memory"
display as text "{hline 80}"

clear
findar deep learning, maxresults(5) save

* Display the saved data
display as text _n "Dataset in memory:"
describe

display as text _n "First 3 results:"
list title arxiv_id in 1/3, clean noobs abbreviate(50)

display as text _n "GitHub information (if any):"
list title gh_repo gh_stars if gh_url != "", clean noobs abbreviate(30)

********************************************************************************
* Example 8: Save results to dataset file
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 8: Save results to file"
display as text "{hline 80}"

clear
findar causal inference, maxresults(5) saving(findar_results) replace

* Display the saved data
display as text _n "Saved dataset structure:"
describe

display as text _n "First 5 results:"
list title arxiv_id published in 1/5, clean noobs

display as text _n "GitHub information:"
list title gh_repo gh_stars gh_lang if gh_url != "", ///
    clean noobs abbreviate(30)

********************************************************************************
* Example 9: Combine detail and save options
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 9: Combine detail + save to memory"
display as text "{hline 80}"

clear
findar graph neural network, maxresults(2) detail save

display as text _n "Data structure:"
describe, short

display as text _n "Saved papers:"
list title authors in 1/2, clean noobs abbreviate(40)

********************************************************************************
* Example 10: Check stored results
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 10: Stored results"
display as text "{hline 80}"

findar bayesian inference, maxresults(3)

display as text _n "Stored results:"
display as text "  Papers found: " as result r(count)
display as text "  GitHub repos found: " as result r(arxiv_found)
display as text "  Not found: " as result r(not_found)

********************************************************************************
* Example 11: Search for specific topics
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 11: Specific research topics"
display as text "{hline 80}"

* Natural language processing
display as text _n "Topic: Natural Language Processing"
findar natural language processing, maxresults(2)

* Time series analysis  
display as text _n "Topic: Time Series"
findar time series forecasting, maxresults(2)

********************************************************************************
* Example 12: Combine detail + abstract + save
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 12: Comprehensive example (detail + abstract + save)"
display as text "{hline 80}"

clear
findar BERT language model, maxresults(2) detail abstract save

display as text _n "Data structure:"
describe, short

********************************************************************************
* Example 13: Search without saving (default behavior)
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 13: Quick search without saving data"
display as text "{hline 80}"

findar quantum computing, maxresults(2)

display as text _n "Check if data exists:"
capture describe
if _rc {
    display as text "  No data in memory (expected behavior)"
}
else {
    display as text "  Data exists in memory"
}

********************************************************************************
* Cleanup
********************************************************************************

capture erase findar_results.dta

display as text _n(2) "{hline 80}"
display as text "All examples completed successfully!"
display as text "For more information: help findar"
display as text "{hline 80}"

log close
