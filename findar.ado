*! findar.ado version 1.1.5  16dec2025

program define findar, rclass
    version 16.0
    
    if "`c(os)'" == "Unix" {
        di as error "Error: findar is only supported on Windows and macOS."
        di as error "Linux systems are not supported."
        exit 199
    }
    
    * Test network connectivity first on macOS
    if "`c(os)'" == "MacOSX" {
        tempfile test_conn
        capture quietly copy "https://export.arxiv.org/api/query?search_query=all:test&max_results=1" `test_conn', replace
        if _rc != 0 {
            di as error "Network connectivity test failed (error: " _rc ")"
            di as txt _n "{bf:This appears to be a network/permissions issue on macOS.}"
            di as txt _n "Common solutions:"
            di as txt "1. Grant Stata network permissions:"
            di as txt "   System Preferences > Security & Privacy > Privacy > Full Disk Access"
            di as txt "   → Add Stata to the list"
            di as txt _n "2. Check firewall settings:"
            di as txt "   System Preferences > Security & Privacy > Firewall"
            di as txt "   → Turn off firewall temporarily to test"
            di as txt _n "3. Try in Terminal to verify network:"
            di as txt "   curl https://export.arxiv.org/api/query?search_query=all:test&max_results=1"
            di as txt _n "4. If using a VPN or proxy, try disabling it temporarily"
            di as txt _n "5. Restart Stata after granting permissions"
            exit _rc
        }
    }
    
    gettoken first rest : 0, parse(",")
    
    if usubstr(strtrim("`first'"), 1, 1) == "," {
        syntax, Query(string) [MAXResults(integer 10) DETail NOGIThub ABstract SAVE saving(string) replace NOGoogle]
    }
    else {
        local query `"`first'"'
        local simplified = 1
        if `"`rest'"' != "" {
            local 0 `"`rest'"'
            syntax [, MAXResults(integer 10) DETail NOGIThub ABstract SAVE saving(string) replace NOGoogle]
        }
        else {
            local maxresults = 5
        }
    }
    
    if ustrlen(strtrim(`"`query'"')) < 2 {
        di as error "Query too short or empty"
        di as txt _n "Usage examples:"
        di as txt `"  findar machine learning"'
        di as txt `"  findar deep learning, github detail"'
        di as txt `"  findar, query("neural network") maxresults(5)"'
        exit 198
    }
    
    if `maxresults' <= 0 | `maxresults' > 100 {
        di as error "maxresults() must be between 1 and 100"
        exit 198
    }
    
    * Handle save option: if save is specified without saving(), keep data in memory
    if "`save'" != "" & "`saving'" == "" {
        local save_to_memory = 1
    }
    else {
        local save_to_memory = 0
    }
    
    * Use HTTPS for better macOS compatibility
    local base_url "https://export.arxiv.org/api/query?"
    local query_encoded = subinstr("`query'", " ", "+", .)
    local search_query "search_query=all:`query_encoded'"
    local url "`base_url'`search_query'&start=0&max_results=`maxresults'"
    
    di as txt _n "{hline 80}"
    di as txt "arXiv Search + GitHub Integration"
    di as txt "{hline 80}"
    di as txt "Query: " as res "`query'"
    di as txt "Max results: " as res "`maxresults'"
    di as txt "GitHub search: " as res cond("`nogithub'"!="", "DISABLED", "ENABLED (default)")
    di as txt "{hline 80}"
    
    tempfile xml_file
    di as txt "Searching arXiv..."
    capture copy "`url'" `xml_file', replace
    
    if _rc != 0 {
        di as error _n "Cannot connect to arXiv API (error code: " _rc ")"
        
        if "`c(os)'" == "MacOSX" {
            di as txt _n "{bf:macOS Troubleshooting:}"
            di as txt "1. Check System Preferences > Security & Privacy > Privacy"
            di as txt "   → Ensure Stata has 'Full Disk Access' or 'Network' permission"
            di as txt _n "2. Check your firewall settings:"
            di as txt "   System Preferences > Security & Privacy > Firewall"
            di as txt "   → Allow incoming connections for Stata"
            di as txt _n "3. Try using HTTPS instead of HTTP:"
            di as txt "   The issue might be with HTTP connections on macOS"
            di as txt _n "4. Check your internet connection:"
            di as txt "   • Open Safari and visit: https://arxiv.org"
            di as txt "   • Try: ping export.arxiv.org (in Terminal)"
            di as txt _n "5. Proxy/VPN issues:"
            di as txt "   • If using VPN, try disconnecting temporarily"
            di as txt "   • Check proxy settings in System Preferences > Network"
        }
        
        di as txt _n "{bf:General troubleshooting:}"
        di as txt "• Internet connection active?"
        di as txt "• Can you access other websites?"
        di as txt "• Try again in a few moments (server might be busy)"
        di as txt _n "URL attempted:"
        di as txt "`url'"
        
        di as txt _n "{bf:Quick test:}"
        di as txt "Try accessing this URL in your browser:"
        di as txt "https://export.arxiv.org/api/query?search_query=all:test&max_results=1"
        
        exit _rc
    }
    
    * Parse XML - create dataset only if save/saving is specified
    findar_parse_xml "`xml_file'"
    local count = r(count)
    
    if `count' == 0 {
        di as txt "No papers found."
        exit
    }
    
    di as txt "Found " as res "`count'" as txt " papers."
    
    if "`nogithub'" == "" {
        di as txt _n "Starting GitHub search..."
        
        qui gen str50 gh_source = ""
        qui gen str200 gh_repo = ""
        qui gen str300 gh_url = ""
        qui gen long gh_stars = .
        qui gen str50 gh_lang = ""
        
        local from_arxiv = 0
        local not_found = 0
        
        forvalues i = 1/`count' {
            local paper_title = title[`i']
            local paper_comment = comment[`i']
            local paper_summary = summary[`i']
            
            local title_short = usubstr(`"`paper_title'"', 1, 55)
            di as txt _n "  [`i'/`count'] " `"`title_short'"' "..."
            
            local found_url = ""
            local found_source = ""
            
            capture {
                local all_urls = ""
                local all_sources = ""
                
                foreach field in comment summary {
                    if `"`paper_`field''"' != "" {
                        local temp_text "`paper_`field''"
                        local done = 0
                        local safety = 0
                        
                        while `done' == 0 & `safety' < 20 {
                            if ustrregexm(`"`temp_text'"', "https?://github\.com/[A-Za-z0-9_-]+/[A-Za-z0-9_.-]+") {
                                local url = ustrregexs(0)
                                local url = ustrregexra(`"`url'"', "[,\.\)\s]+$", "")
                                
                                if ustrregexm(`"`url'"', "^https?://github\.com/[A-Za-z0-9_-]+/[A-Za-z0-9_.-]+$") {
                                    local all_urls "`all_urls'|`url'"
                                    local all_sources "`all_sources'|`field'"
                                }
                                
                                local pos = ustrpos(`"`temp_text'"', "`url'")
                                if `pos' > 0 {
                                    local temp_text = usubstr(`"`temp_text'"', `pos' + ustrlen("`url'"), .)
                                }
                                else {
                                    local done = 1
                                }
                            }
                            else {
                                local done = 1
                            }
                            local ++safety
                        }
                    }
                }
                
                if `"`all_urls'"' != "" {
                    local all_urls = usubstr(`"`all_urls'"', 2, .)
                    local all_sources = usubstr(`"`all_sources'"', 2, .)
                    
                    local n_urls = 0
                    local temp = "`all_urls'"
                    while ustrpos("`temp'", "|") > 0 {
                        local ++n_urls
                        local pos = ustrpos("`temp'", "|")
                        local temp = usubstr("`temp'", `pos' + 1, .)
                    }
                    local ++n_urls
                    
                    if `n_urls' > 1 {
                        di as txt "    Found `n_urls' GitHub URLs, comparing stars..."
                        
                        local best_url = ""
                        local best_source = ""
                        local best_stars = -1
                        
                        forvalues j = 1/`n_urls' {
                            local temp_urls = "`all_urls'"
                            local temp_sources = "`all_sources'"
                            local url_j = ""
                            local source_j = ""
                            
                            forvalues k = 1/`j' {
                                local pipe_pos = ustrpos("`temp_urls'", "|")
                                if `pipe_pos' > 0 {
                                    if `k' == `j' {
                                        local url_j = usubstr("`temp_urls'", 1, `pipe_pos' - 1)
                                    }
                                    local temp_urls = usubstr("`temp_urls'", `pipe_pos' + 1, .)
                                }
                                else {
                                    local url_j = "`temp_urls'"
                                }
                                
                                local pipe_pos = ustrpos("`temp_sources'", "|")
                                if `pipe_pos' > 0 {
                                    if `k' == `j' {
                                        local source_j = usubstr("`temp_sources'", 1, `pipe_pos' - 1)
                                    }
                                    local temp_sources = usubstr("`temp_sources'", `pipe_pos' + 1, .)
                                }
                                else {
                                    local source_j = "`temp_sources'"
                                }
                            }
                            
                            local stars_j = 0
                            capture {
                                if ustrregexm("`url_j'", "github\.com/([A-Za-z0-9_-]+)/([A-Za-z0-9_.-]+)") {
                                    local owner = ustrregexs(1)
                                    local repo = ustrregexs(2)
                                    local api_url "https://api.github.com/repos/`owner'/`repo'"
                                    
                                    tempfile api_result
                                    quietly copy "`api_url'" `api_result', replace
                                    
                                    tempname fh_api
                                    file open `fh_api' using `api_result', read text
                                    local api_json = ""
                                    file read `fh_api' line
                                    while r(eof) == 0 {
                                        local api_json `"`api_json'`line'"'
                                        file read `fh_api' line
                                    }
                                    file close `fh_api'
                                    
                                    if ustrregexm(`"`api_json'"', `""stargazers_count":([0-9]+)"') {
                                        local stars_j = ustrregexs(1)
                                    }
                                }
                            }
                            
                            if `stars_j' > `best_stars' {
                                local best_stars = `stars_j'
                                local best_url "`url_j'"
                                local best_source "`source_j'"
                            }
                        }
                        
                        local found_url "`best_url'"
                        local found_source "`best_source'"
                        di as txt "    ✓ Best: `found_url' (`best_stars' stars)"
                    }
                    else {
                        local found_url = "`all_urls'"
                        local found_source = "`all_sources'"
                        di as txt "    ✓ Found in `found_source'"
                    }
                }
                
                if `"`found_url'"' != "" {
                    qui replace gh_source = "arxiv_`found_source'" in `i'
                    qui replace gh_url = `"`found_url'"' in `i'
                    capture findar_fetch_repo_info `"`found_url'"' `i'
                    local ++from_arxiv
                    continue, break
                }
            }
            
            if "`found_url'" == "" {
                local ++not_found
            }
        }
        
        di as txt _n "{hline 80}"
        di as txt "GitHub Search Results:"
        di as txt "  Found from arXiv metadata: " as res "`from_arxiv'"
        di as txt "  Not found:                 " as res "`not_found'"
        local success_rate = round(100 * `from_arxiv' / `count', 0.1)
        di as txt "  Success rate:              " as res "`success_rate'%" 
        di as txt "{hline 80}"
    }
    
    if "`simplified'" != "" & "`detail'" == "" {
        di as txt _n "{hline 80}"
        if "`nogithub'" == "" {
            di as txt "Top `maxresults' results (arXiv | PDF | DOI | GitHub)"
        }
        else {
            di as txt "Top `maxresults' results (arXiv | PDF | DOI)"
        }
        di as txt "{hline 80}"
        forvalues i = 1/`count' {
            local disp_title = title[`i']
            local title_short = usubstr(`"`disp_title'"', 1, 60)
            capture local disp_id = arxiv_id[`i']
            capture local disp_doi = doi[`i']

            di as txt _n "[" as res "`i'" as txt "] " as res `"`title_short'"'
            
            local links `"{browse "https://arxiv.org/abs/`disp_id'":arXiv} {browse "https://arxiv.org/pdf/`disp_id'.pdf":PDF}"'
            if "`disp_doi'" != "" {
                local links `"`links' {browse "https://doi.org/`disp_doi'":DOI}"'
            }
            
            if "`nogithub'" == "" {
                capture local gh_url_value = gh_url[`i']
                if _rc == 0 & "`gh_url_value'" != "" {
                    capture local gh_stars_value = gh_stars[`i']
                    if _rc == 0 & "`gh_stars_value'" != "." & "`gh_stars_value'" != "" {
                        local links `"`links' {browse "`gh_url_value'":GitHub(`gh_stars_value'stars)}"'
                    }
                    else {
                        local links `"`links' {browse "`gh_url_value'":GitHub}"'
                    }
                }
            }
            
            di as txt "Links: " `"`links'"'
            
            if "`abstract'" != "" {
                local disp_summary = summary[`i']
                if `"`disp_summary'"' != "" {
                    di as txt _n "{ul:Abstract:}"
                    findar_display_abstract `"`disp_summary'"'
                }
            }

            if `i' < `count' di as txt "{hline 80}"
        }
        di as txt "{hline 80}"
    }
    
    if "`detail'" != "" {
        di as txt _n "{hline 80}"
        di as txt "Detailed Results"
        di as txt "{hline 80}"
        
        forvalues i = 1/`count' {
            local disp_title = title[`i']
            local disp_authors = authors[`i']
            local disp_published = published[`i']
            
            di as txt _n "[" as res "`i'" as txt "] " as res `"`disp_title'"'
            di as txt "Authors: " as res `"`disp_authors'"'
            di as txt "Published: " as res `"`disp_published'"'
            
            local disp_arxiv_id = arxiv_id[`i']
            local arxiv_br `"{browse "https://arxiv.org/abs/`disp_arxiv_id'":arXiv}"'
            
            local google_br ""
            if "`nogoogle'" == "" & "`nogithub'" == "" {
                findar_url_encode `"`disp_title'"'
                local title_encode = r(encoded)
                if "`title_encode'" != "" {
                    local google_url "https://www.google.com/search?q=`title_encode'+github"
                    local google_br `"{browse "`google_url'":Google}"'
                }
            }
            
            local github_br ""
            if "`nogithub'" == "" {
                capture local gh_url_value = gh_url[`i']
                if _rc == 0 & "`gh_url_value'" != "" {
                    local gh_repo_name = gh_repo[`i']
                    capture local gh_stars_value = gh_stars[`i']
                    if _rc == 0 & "`gh_stars_value'" != "." & "`gh_stars_value'" != "" {
                        local gh_lang_name = gh_lang[`i']
                        local github_br `"{browse "`gh_url_value'":GitHub(`gh_repo_name'_★`gh_stars_value'_`gh_lang_name')}"'
                    }
                    else {
                        local github_br `"{browse "`gh_url_value'":GitHub(`gh_repo_name')}"'
                    }
                }
            }
            
            di as txt _n "Links: " `"`arxiv_br'"' _skip(2) `"`google_br'"' _skip(2) `"`github_br'"'
            
            if `i' < `count' di as txt "{hline 80}"
        }
        di as txt "{hline 80}"
    }
    
    if "`saving'" != "" {
        save "`saving'", `replace'
        di as txt _n "Data saved to file: " as res "`saving'"
    }
    else if `save_to_memory' == 1 {
        di as txt _n "Data saved to memory (use {stata browse:browse} to view)"
    }
    else {
        * User didn't request save, clear the dataset
        clear
    }
    
    return scalar count = `count'
    if "`nogithub'" == "" {
        return scalar arxiv_found = `from_arxiv'
        return scalar not_found = `not_found'
    }
end

cap program drop findar_url_encode
program define findar_url_encode, rclass
    version 16.0
    args input_string
    
    * Try using Mata first (more efficient)
    capture mata: st_local("encoded", urlencode(st_local("input_string")))
    if _rc == 0 & "`encoded'" != "" {
        return local encoded "`encoded'"
        exit
    }
    
    * Fallback: Simple URL encoding for common characters
    local result = "`input_string'"
    local result = subinstr("`result'", " ", "%20", .)
    local result = subinstr("`result'", "&", "%26", .)
    local result = subinstr("`result'", "=", "%3D", .)
    local result = subinstr("`result'", "+", "%2B", .)
    local result = subinstr("`result'", "#", "%23", .)
    local result = subinstr("`result'", "?", "%3F", .)
    local result = subinstr("`result'", "/", "%2F", .)
    local result = subinstr("`result'", ":", "%3A", .)
    local result = subinstr("`result'", "@", "%40", .)
    local result = subinstr("`result'", "(", "%28", .)
    local result = subinstr("`result'", ")", "%29", .)
    local result = subinstr("`result'", ",", "%2C", .)
    
    return local encoded "`result'"
end

cap program drop findar_display_abstract
program define findar_display_abstract
    version 16.0
    args abstract_text
    
    local remaining = `"`abstract_text'"'
    local line_width = 75
    
    while ustrlen(`"`remaining'"') > 0 {
        if ustrlen(`"`remaining'"') <= `line_width' {
            di as res "  " `"`remaining'"'
            local remaining = ""
        }
        else {
            local cut_pos = `line_width'
            local found_space = 0
            
            forvalues pos = `line_width'(-1)1 {
                if usubstr(`"`remaining'"', `pos', 1) == " " {
                    local cut_pos = `pos'
                    local found_space = 1
                    continue, break
                }
            }
            
            if `found_space' == 0 local cut_pos = `line_width'
            
            local line = usubstr(`"`remaining'"', 1, `cut_pos')
            di as res "  " `"`line'"'
            local remaining = usubstr(`"`remaining'"', `cut_pos' + 1, .)
            local remaining = ustrtrim(`"`remaining'"')
        }
    }
end

cap program drop findar_parse_xml
program define findar_parse_xml, rclass
    version 16.0
    args xml_file
    
    clear
    gen str50 arxiv_id = ""
    gen str500 title = ""
    gen strL summary = ""
    gen str1000 authors = ""
    gen str30 published = ""
    gen strL comment = ""
    gen str100 doi = ""
    
    tempname fh
    file open `fh' using "`xml_file'", read text
    local content = ""
    file read `fh' line
    while r(eof) == 0 {
        * Skip XML declaration line which may cause parsing issues
        if !ustrregexm(`"`line'"', "^<\?xml") {
            local content `"`content'`line'"'
        }
        file read `fh' line
    }
    file close `fh'
    
    local pos = 1
    local count = 0
    
    while `pos' > 0 {
        local pos = ustrpos(`"`content'"', "<entry>", `pos')
        if `pos' > 0 {
            local end_pos = ustrpos(`"`content'"', "</entry>", `pos')
            if `end_pos' > `pos' {
                local ++count
                local len = `end_pos' - `pos' + 8
                local entry = usubstr(`"`content'"', `pos', `len')
                findar_parse_one_entry `count' `"`entry'"'
                local pos = `end_pos' + 8
            }
            else {
                local pos = 0
            }
        }
    }
    
    qui drop if arxiv_id == ""
    qui count
    return scalar count = r(N)
end

cap program drop findar_parse_one_entry
program define findar_parse_one_entry
    version 16.0
    args row entry_xml
    
    qui set obs `row'
    
    local entry_clean = ustrregexra(`"`entry_xml'"', "&amp;", "&")
    local entry_clean = ustrregexra(`"`entry_clean'"', "&lt;", "<")
    local entry_clean = ustrregexra(`"`entry_clean'"', "&gt;", ">")
    local entry_clean = ustrregexra(`"`entry_clean'"', "&quot;", `"""')
    local entry_clean = ustrregexra(`"`entry_clean'"', "&apos;", "'")
    
    if ustrregexm(`"`entry_clean'"', "<id>http://arxiv.org/abs/([^<]+)</id>") {
        qui replace arxiv_id = ustrregexs(1) in `row'
    }
    
    if ustrregexm(`"`entry_clean'"', "<title>([^<]+)</title>") {
        local t = ustrregexs(1)
        local t = ustrregexra(`"`t'"', "\n", " ")
        local t = ustrregexra(`"`t'"', "  +", " ")
        local t = strtrim(`"`t'"')
        qui replace title = `"`t'"' in `row'
    }
    
    if ustrregexm(`"`entry_clean'"', "<summary>(.+)</summary>") {
        local s = ustrregexs(1)
        local s = ustrregexra(`"`s'"', "\n", " ")
        local s = ustrregexra(`"`s'"', "  +", " ")
        local s = strtrim(`"`s'"')
        if ustrlen(`"`s'"') > 2000 local s = usubstr(`"`s'"', 1, 2000)
        qui replace summary = `"`s'"' in `row'
    }
    
    local authors_list = ""
    local p = 1
    while `p' > 0 {
        local p = ustrpos(`"`entry_clean'"', "<name>", `p')
        if `p' > 0 {
            local e = ustrpos(`"`entry_clean'"', "</name>", `p')
            if `e' > `p' {
                local name = usubstr(`"`entry_clean'"', `p' + 6, `e' - `p' - 6)
                if `"`authors_list'"' == "" {
                    local authors_list = `"`name'"'
                }
                else {
                    local authors_list = `"`authors_list', `name'"'
                }
                local p = `e' + 7
            }
            else {
                local p = 0
            }
        }
    }
    qui replace authors = `"`authors_list'"' in `row'
    
    if ustrregexm(`"`entry_clean'"', "<published>([^<]+)</published>") {
        qui replace published = ustrregexs(1) in `row'
    }
    
    if ustrregexm(`"`entry_clean'"', `"<arxiv:comment[^>]*>([^<]+)</arxiv:comment>"') {
        local c = ustrregexs(1)
        local c = ustrregexra(`"`c'"', "\n", " ")
        local c = strtrim(`"`c'"')
        qui replace comment = `"`c'"' in `row'
    }

    if ustrregexm(`"`entry_clean'"', "<arxiv:doi>([^<]+)</arxiv:doi>") {
        local d = ustrregexs(1)
        local d = strtrim(`"`d'"')
        qui replace doi = `"`d'"' in `row'
    }
    else if ustrregexm(`"`entry_clean'"', "<doi>([^<]+)</doi>") {
        local d = ustrregexs(1)
        local d = strtrim(`"`d'"')
        qui replace doi = `"`d'"' in `row'
    }
end

cap program drop findar_fetch_repo_info
program define findar_fetch_repo_info
    version 16.0
    args github_url row
    
    if !ustrregexm("`github_url'", "github\.com/([A-Za-z0-9_-]+)/([A-Za-z0-9_.-]+)") exit
    
    local owner = ustrregexs(1)
    local repo = ustrregexs(2)
    local full = "`owner'/`repo'"
    
    qui replace gh_repo = `"`full'"' in `row'
    
    local api_url "https://api.github.com/repos/`full'"
    tempfile result
    capture quietly copy "`api_url'" `result', replace
    if _rc != 0 exit
    
    tempname fh
    capture file open `fh' using `result', read text
    if _rc != 0 exit
    
    local json = ""
    file read `fh' line
    while r(eof) == 0 {
        local json `"`json'`line'"'
        file read `fh' line
    }
    file close `fh'
    
    if ustrregexm(`"`json'"', `""stargazers_count":([0-9]+)"') {
        local stars = ustrregexs(1)
        qui replace gh_stars = `stars' in `row'
    }
    
    if ustrregexm(`"`json'"', `""language":"([^"]+)""') {
        local lang = ustrregexs(1)
        qui replace gh_lang = `"`lang'"' in `row'
    }
end

