*! findar_test.ado - Network connectivity test for findar
*! version 1.0  18oct2025

program define findar_test
    version 16.0
    
    di as txt _n "{hline 80}"
    di as txt "findar Network Connectivity Test"
    di as txt "{hline 80}"
    
    di as txt _n "System Information:"
    di as txt "  OS: " as res "`c(os)'"
    di as txt "  Machine: " as res "`c(machine_type)'"
    di as txt "  Stata version: " as res "`c(stata_version)'"
    
    di as txt _n "{hline 80}"
    di as txt "Test 1: HTTP connection (legacy)"
    di as txt "{hline 80}"
    
    tempfile test1
    capture copy "http://export.arxiv.org/api/query?search_query=all:test&max_results=1" `test1', replace
    
    if _rc == 0 {
        di as result "✓ HTTP connection successful"
    }
    else {
        di as txt "○ HTTP connection failed (error: " _rc ")"
        di as txt "  Note: This is expected on macOS. findar uses HTTPS instead."
    }
    
    di as txt _n "{hline 80}"
    di as txt "Test 2: HTTPS connection"
    di as txt "{hline 80}"
    
    tempfile test2
    capture copy "https://export.arxiv.org/api/query?search_query=all:test&max_results=1" `test2', replace
    
    if _rc == 0 {
        di as result "✓ HTTPS connection successful"
        
        * Try to read the file
        tempname fh
        capture file open `fh' using `test2', read text
        if _rc == 0 {
            file read `fh' line
            file close `fh'
            di as result "✓ File reading successful"
            di as txt "  First line: " as res substr("`line'", 1, 60) "..."
        }
    }
    else {
        di as error "✗ HTTPS connection failed (error: " _rc ")"
    }
    
    di as txt _n "{hline 80}"
    di as txt "Test 3: GitHub API connection"
    di as txt "{hline 80}"
    
    tempfile test3
    capture copy "https://api.github.com/repos/microsoft/vscode" `test3', replace
    
    if _rc == 0 {
        di as result "✓ GitHub API connection successful"
    }
    else {
        di as error "✗ GitHub API connection failed (error: " _rc ")"
    }
    
    di as txt _n "{hline 80}"
    di as txt "Summary"
    di as txt "{hline 80}"
    
    if _rc == 0 {
        di as result _n "✓ All tests passed! findar should work properly."
        di as txt _n "You can now try:"
        di as txt "  findar machine learning"
    }
    else {
        di as error _n "✗ Network connectivity issues detected."
        di as txt _n "Please follow the troubleshooting steps above."
        di as txt _n "If issues persist:"
        di as txt "  • Check with your system administrator"
        di as txt "  • Verify firewall/antivirus settings"
        di as txt "  • Try from a different network"
    }
    
    di as txt _n "{hline 80}"
    
end
