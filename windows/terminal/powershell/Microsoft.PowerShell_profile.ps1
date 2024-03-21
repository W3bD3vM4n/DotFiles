oh-my-posh.exe init pwsh --config "C:\Users\hr-aw\.dotfiles\terminal\powershell\catppuccin.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons

function psql {
    & "C:\Program Files\PostgreSQL\15\scripts\runpsql.bat"
}

#Vi mode
Set-PsReadLineOption -EditMode Vi

#Imports PSReadLine
Import-Module PSReadLine

#Tab - Gives a menu of suggestions
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

#UpArrow will show the most recent command
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

#DownArrow will show the least recent command
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

#During auto completion, pressing arrow key up or down will move the cursor to the end of the completion
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

#Shows tooltip during completion
Set-PSReadLineOption -ShowToolTips

#Gives completions/suggestions from historical commands
Set-PSReadLineOption -PredictionSource History

#disable the bell
Set-PSReadlineOption -BellStyle None
