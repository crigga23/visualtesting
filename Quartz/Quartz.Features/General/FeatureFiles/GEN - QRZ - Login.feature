# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Title:                   # GEN - QRZ - Login
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Author:                  # Christopher D Hughes
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Date:                    #           11 SEP-15
#                          # UPDATED: (27-NOV-15)
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# Revised by:			   # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Automation Test Notes:   # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Manual Test Notes:       # 
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Test Prerequisites:      # Email Tokens:
#                          #   A valid corporate username and password should be available, then...
#                          #   the following login tokens should be requested via http://tu-server-typ:9093/ using these corporate details
#                          #   and recieved by email just before testing commences...
#                          #   - #1: roles: admin  
#                          #   - #2: roles: gss  
#                          #   - #3: roles: admin  
#                          #   - #4: roles: admin
#                          #   - #5: roles: admin
#                          #   IMPORTANT: Tokens files (.tkn) recieved as email attachments should then be copied to the folder '\Typhoon\webserver\token\'
#                          # ------------------------------------------------------------------------------------------------------------------------
#                          # Expired Token:
#                          #   An expired token should be available from folder '\Automation-Quartz\AutomationQuartz\Data\Login Token\Expired Token'
#                          #   IMPORTANT: The Expired Token file (.tkn) should then be copied to folder '\Typhoon\webserver\token\'
#                          #   NOTE: Expired token login details should be available from '\Automation-Quartz\AutomationQuartz\Data\Login Token\Expired Token\Expired Token Login Details.txt' 
#                          # ------------------------------------------------------------------------------------------------------------------------
#                          # Clarity Plugin:
#                          #   After Quartz Dashboard msi has been installed, the latest v4.0.x Clarity Plugin needs to be installed (which will be used to check 'gss' access rights)...
#                          #   \\tu-server-build\GSSAutomationTest\WEAT_4_0\
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Tools Required:	       # Access to the Quartz token generation server http://tu-server-typ:9093/ to request tokens via email
#                          # Access to the latest Clarity Plugin (V4.0.x) \\tu-server-build\GSSAutomationTest\WEAT_4_0
# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Major Update History:    # (27-NOV-15):
#                          # - Email roles requested are now admin and gss
#                          # - Clarity Plugin needs to be installed to test gss access rights
#                          # - Test added for 'I'm a Developer' link removal
#                          # - Check added to QRZ-03 to ensure previous 'I'm a Developer' login credentials do not work
#                          # - Test added to check 'How do I get a token file?' Login page link 
#                          # - QRZ-02 scenario changed to check that login credentials can be re-used
#                          # - QRZ-02 Access rights notes updated for gss
#                          # - QRZ-05 changed to use pre-existing expired token, rather than via email
# -------------------------#-------------------------------------------------------------------------------------------------------------------------

# -------------------------#-------------------------------------------------------------------------------------------------------------------------
# Basis:                   # /Typhoon/Platform/EAP/Specifications/Quartz EAP Software Specification
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-124)                 # The software will require all users to login using a corporate user name and password.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-125)                 # The software will have a separate page for logging in.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-126)                 # Once logged in the user will have access to the dashboard. 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-127)                 # The software will have a logout option available on the main dashboard.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-128)                 # The software will display the currently logged in user on the main dashboard.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-129)                 # The software will display all available applications.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-130)                 # The user will be able to browse to all available plug-ins.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-131)                 # The software will be able to make any plug-in unavailable/disabled when required.
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-321)                 # The software will allow users to login using corporate or token credentials
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-322)                 # The software will allow users to select an available plug-in that they want to use 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-323)                 # The software will provide access to the dashboard once a plug-in has been selected
# ---------------------------------------------------------------------------------------------------------------------------------------------------
# (SS-144)                 # The software will filter the application list using user login credentials.
# ---------------------------------------------------------------------------------------------------------------------------------------------------


@ignore
Feature: GEN - QRZ - Login
	In order to successfully login to Quartz
	I want to use various login details
	So that I can access only Quartz pages that I have been given rights to access


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Background:
	Given Typhoon is started
		And Quartz console has been launched within a Chrome browser
		# http://localhost:9090 
		And the Login page is then displayed
		# http://localhost:9090/Home/Login
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario: QRZ-01 - Login (Corporate User - no Token)
	Given the following valid login 'Credentials' are available...
		| Credentials            |
		| Corporate username |
		| Password           |
	When a login is attempted with the available credentials
	# No Token should be used in this attempt and the corporate username should be entered without domain prefix
	Then the Login is successful
		# Access Rights: will vary depending on what has been assigned to this user on the Quartz authentication server
		And the current corporate username will be on display within the Quartz dashboard
		And the session can be Logged out of 
		# which will return the user to the initial login page (http://localhost:9090/Home/Login)
		And the user can Log in again using the same credentials 
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------		
Scenario Outline: QRZ-02 - Login (Corporate User - Token Required)
	When a login is attempted with corporate 'Username' 'Password' and 'Token' details from <Quartz Token Request Email Number>
	# The token received via email must have been copied to the folder \Typhoon\webserver\token\
	# The token entered into the login page must be the token string without the .tkn extension
	Then the initial Login is successful
		And the <Expected Access Rights> are granted
		# Access Rights: admin
		#   Full Tuning Controls - Full access to 'Console' pages: Tune, Manual Calibration, Instrument Setup, Vacuum, Quad Setup, Detector Setup, Scope Mode, Source Pressure Test, IMS Pressure Test, Health Status.
		#   Tools                - access to 'Property Viewer' and 'Wrens Notebook'. 
		#
		# Access Rights: gss
		#   Install, Maintain and Diagnose Instrument Systems - Access to 'Clarity' Diagnostics / All Results / Audit pages
		#   Tuning Controls                                   - no access to 'Console' pages
		#   Tools                                             - no access 
		And no additional Quartz Tuning Contol pages / Tools pages can be accessed other than those explicitely granted access to
		And the current corporate username will be on display within the Quartz dashboard
		And the session can be Logged out of 
		# which will return the user to the initial login page (http://localhost:9090/Home/Login)
		And the user can Log in again using the same credentials 
		And the <Expected Access Rights> are granted
			
			Examples: 
			| Quartz Token Request Email Number | Expected Access Rights |
			| #1                                | admin                  |
			| #2                                | gss                    |
		

# ---------------------------------------------------------------------------------------------------------------------------------------------------		
Scenario Outline: QRZ-03 - Login (Incorrect Credentials)
	When a login is attempted with some incorrect <Credentials> based on 'Quartz Token Request Email Number #3'
	Then the Login is unsuccessful
		And an 'Invalid login credentials' message is shown on the browser
			Examples: Incorrect details
			| Credentials                                             |
			| Incorrect username, Correct password,   Correct token   |
			| Correct username,   Incorrect password, Correct token   |
			| Correct username,   Correct password,   Incorrect token |
		
			Examples: Some blank details
			| Credentials                                             |
			| Blank username,     Correct password,   Correct token   |
			| Correct username,   Blank password,     Correct token   |
			# Credentials with a blank Token field are tested in QRZ-02

			Examples: All blank details
			| Credentials                                             |
			| Blank username,     Blank password,     Blank token     |
			
			Examples: Previous 'I'm a Developer' Login details
			| Credentials                                             |
			| Username: typhoon,  Password: analysis, Blank token     |
			# These were the login credentials for the removed 'I'm a Developer' login link, which should no longer work

		
# ---------------------------------------------------------------------------------------------------------------------------------------------------		
Scenario: QRZ-04 - Login (after an Incorrect Login)
	Given that an incorrect login has been previously attempted
		And an 'Invalid login credentials' message is shown on the browser
	When a new login is attempted with 'Username' 'Password' and 'Token' details from 'Quartz Token Request Email Number #4'
	Then the Login will be successful
		And 'admin' access rights will be granted
		# Access Rights: admin
		#   Full Tuning Controls - Full access to 'Console' pages: Tune, Manual Calibration, Instrument Setup, Vacuum, Quad Setup, Detector Setup, Scope Mode, Source Pressure Test, IMS Pressure Test, Health Status.
		#   Tools                - access to 'Property Viewer' and 'Wrens Notebook'. 
		And no additional Quartz Tuning Contol pages / Tools pages can be accessed other than those explicitely granted access to
		And the current corporate username will be on display within the Quartz dashboard
		And the session can be Logged out of 
		# which will return the user to the initial login page (http://localhost:9090/Home/Login)


# ---------------------------------------------------------------------------------------------------------------------------------------------------		
Scenario: QRZ-05 - Login (Token Expiration)
	Given that an 'Expired Token' is available in folder '\Typhoon\webserver\token\'
	# See 'Test Prerequisites' feature file header for details
	# Expired token file should be '55058372-fe5a-43b0-b0c9-8de0e7a5d02e.tkn'
	When a login is attempted with the Expired token login details 'Username' 'Password' and 'Token'
	# See 'Test Prerequisites' feature file header for details 
	# The Expired Token Login credentials should be...
	# - Username: ukcdhkm
	# - Password: twyONM4tVf
	# - Token:    55058372-fe5a-43b0-b0c9-8de0e7a5d02e
	Then the Login is unsuccessful
		And an 'Invalid login credentials' message is shown on the browser
		And a further login attempt will still be unsuccessful
		And an 'Invalid login credentials' message is shown on the browser


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-06 - Login ('I'm a Developer' Not Available)
	When the <Login Page> is inspected 
	Then there is no 'I'm a Devloper' link available
		
		Examples:  
		| Login Page                       |
		| http://localhost:9090/Home/Login |
		| http://localhost:9090/loginfail  |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
Scenario Outline: QRZ-07 - Login ('How do I get a token file?' Link)
	When the <Login Page> is inspected 
	Then there should be a link available 'How do I get a token file?'  
		And clicking on the 'How do I get a token file?' link opens a 'How To Get A Token' dialog with appropriate text
		# Current 'How To Get A Token' dialog text:
		# -----------------------------------------
		#   If you can connect to the corporate network by direct or VPN connection, 
		#   open a browser and fill in your corp log in credentials on the form at this site 
		#   http://tu-server-typ:9092/.
		# 
        #   If you cannot connect to the corporate network send a blank email with your 
		#   Corporate log in ID in the subject line to qtr@waters.com.
		#
		#  In either case you will receive a token that is valid for 1 month by email. Copy 
		#  the token into the webserver/token folder and log in using the user name and 
		#  password provided by email in the format provided.
		
		And the 'How To Get A Token' dialog can be successfully closed
		And the previous <Login Page> will be shown
			
			Examples:  
			| Login Page                       |
			| http://localhost:9090/Home/Login |
			| http://localhost:9090/loginfail  |


# ---------------------------------------------------------------------------------------------------------------------------------------------------
#END