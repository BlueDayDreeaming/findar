********************************************************************************
* findar_example.do
* Example usage of the findar command
* Author: BlueDayDreeaming
* Date: 18oct2025
********************************************************************************

clear all
set more off

log using findar_example.log, replace text

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
* Example 7: Save results to dataset
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 7: Save results to dataset"
display as text "{hline 80}"

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
* Example 8: Check stored results
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 8: Stored results"
display as text "{hline 80}"

findar bayesian inference, maxresults(3)

display as text _n "Stored results:"
display as text "  Papers found: " as result r(count)
display as text "  GitHub repos found: " as result r(arxiv_found)
display as text "  Not found: " as result r(not_found)

********************************************************************************
* Example 9: Search for specific topics
********************************************************************************

display as text _n(2) "{hline 80}"
display as text "Example 9: Specific research topics"
display as text "{hline 80}"

* Natural language processing
display as text _n "Topic: Natural Language Processing"
findar natural language processing, maxresults(2)

* Time series analysis  
display as text _n "Topic: Time Series"
findar time series forecasting, maxresults(2)

********************************************************************************
* Cleanup
********************************************************************************

capture erase findar_results.dta

display as text _n(2) "{hline 80}"
display as text "All examples completed successfully!"
display as text "{hline 80}"

log close
