tell application "Google Chrome"
	activate
	
	set quizID to display dialog "ID of the Quizlet set:" default answer "123456789" with title "Save Terms and Defs | Gravity Bot" buttons {"Abort", "Continue"} default button 2 cancel button 1
	set quizID to text returned of quizID
	
	set numTerms to display dialog "Number of terms in the Quizlet set:" default answer "99" with title "Save Terms and Defs | Gravity Bot" buttons {"Abort", "Continue"} default button 2 cancel button 1
	set numTerms to text returned of numTerms
	
	set termsList to {}
	set defsList to {}
	
	repeat with defIndex from 0 to numTerms - 1
		tell front window's active tab to set definition to execute javascript "document.querySelectorAll('a.SetPageTerm-definitionText span')[" & defIndex & "].innerHTML;"
		
		tell front window's active tab to set term to execute javascript "document.querySelectorAll('a.SetPageTerm-wordText span')[" & defIndex & "].innerHTML;"
		
		set end of termsList to term
		set end of defsList to definition
		
		set defIndex to defIndex + 1
	end repeat
	
	tell front window to make new tab at after (get active tab) with properties {URL:"https://quizlet.com/" & quizID & "/gravity"}
	
	display dialog "Click \"Get Started\" to continue to the settings page. Once there, select \"Hard\" as the difficulty level. Look at the options in the dropdown and chose the option that represents the definition. (If you encounter any issues, try the other option" with title "Instructions for Settings Pane | Gravity Bot"
	
	--delay 10
	
	repeat while true
		
		tell application "System Events" to set activeApp to name of first application process whose frontmost is true
		set activeTab to get URL of active tab of first window
		
		if ("Google Chrome" is in activeApp) and ("quizlet.com/" & quizID & "/gravity" is in activeTab) then
			
			tell front window's active tab to set term to execute javascript "document.getElementsByClassName('TermText notranslate')[0].innerHTML;"
			
			if term is not missing value then
				
				repeat with cardIndex from 1 to numTerms
					if term = (item cardIndex of termsList) then
						--display dialog "went through"
						tell front window's active tab to execute javascript "document.getElementsByClassName('GravityTypingPrompt-input')[0].value = '" & item cardIndex of defsList & "';"
						--tell application "System Events" to keystroke item cardIndex of defsList
						tell application "System Events" to keystroke space
						tell application "System Events" to keystroke return
						delay 0.1
					end if
				end repeat
			end if
		end if
	end repeat
	
end tell
