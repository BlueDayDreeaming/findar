{smcl}
{* *! version 1.0  18oct2025}{...}
{title:Title}

{p2colset 5 21 23 2}{...}
{p2col :{cmd:findar_test} {hline 2}}Test network connectivity for findar{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 20 2}
{cmd:findar_test}


{title:Description}

{pstd}
{cmd:findar_test} performs a series of network connectivity tests to diagnose 
issues with the {cmd:findar} command. This is particularly useful for macOS 
users experiencing connection problems.

{pstd}
The test checks:

{phang2}
1. HTTP connection to arXiv API{p_end}
{phang2}
2. HTTPS connection to arXiv API{p_end}
{phang2}
3. GitHub API connectivity{p_end}


{title:Remarks}

{pstd}
If tests fail on macOS, common solutions include:

{phang2}
• Grant Stata network permissions in System Preferences{p_end}
{phang2}
• Check firewall settings{p_end}
{phang2}
• Disable VPN temporarily{p_end}
{phang2}
• Restart Stata after making permission changes{p_end}


{title:Example}

{phang2}{cmd:. findar_test}


{title:Author}

{pstd}
BlueDayDreeaming{break}
GitHub: https://github.com/BlueDayDreeaming/findar
