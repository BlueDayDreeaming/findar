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
    di as txt "Test 1: Simple HTTP connection"
    di as txt "{hline 80}"
    
    tempfile test1
    capture copy "http://export.arxiv.org/api/query?search_query=all:test&max_results=1" `test1', replace
    
    if _rc == 0 {
        di as result "✓ HTTP connection successful"
    }
    else {
        di as error "✗ HTTP connection failed (error: " _rc ")"
        if "`c(os)'" == "MacOSX" {
            di as txt _n "{bf:macOS Error " _rc " typically means:}"
            if _rc == 2 {
                di as txt "  • File not found / Network permissions denied"
                di as txt "  • Stata doesn't have permission to access the network"
                di as txt "  • Firewall is blocking the connection"
            }
            di as txt _n "{bf:Solutions:}"
            di as txt "1. System Preferences > Security & Privacy > Privacy"
            di as txt "   → Full Disk Access → Add Stata"
            di as txt "2. System Preferences > Security & Privacy > Firewall"
            di as txt "   → Allow Stata or disable firewall temporarily"
            di as txt "3. Restart Stata after making changes"
        }
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
