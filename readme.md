# Conducting a Phishing Campaign Simulation using Azure, GoPhish, and MailHog


	**Disclaimer: This phishing simulation is for educational purposes only and aims to improve cybersecurity awareness.** 

No personal data is collected. Tools used are open-source and referrenced.

This guide walks you through the steps to perform a phishing simulation using **GoPhish** on **Azure** virtual machines with **MailHog** as an SMTP server.
This simulation includes a personally created web page to be hosted on an Azure VM to serve as a landing page to mimic.
This also includes a personally created email template to be used to simulate a phishing email.

Configuration to use Gmail SMTP server with Google App Password is provided optionally for the purpose of studying security controls
and protocols of commonly used email services like gmail. When conducting such testing the appropriate permissions must acquired.

	**Phishing is illegal and unethical, and engaging in such activities outside a controlled environment can result in severe consequences.**


## Prerequisites
Before proceeding, make sure you have the following:
- **Azure** account with proper permissions.
- **GoPhish** installed and running.
- **MailHog** installed and running.
- **Google Account** with 2FA enabled for App Passwords.
- basic powershell and linux command line knowledge.

## Steps

### 1. **Set Up Azure Virtual Machine to run GoPhish**

   - **Set Up Azure Active Directory (Azure AD):**
     - Log into the [Azure portal](https://portal.azure.com/).
     - Go to **Create Resource** and then **Create Virtual Machine**.
	 - Name: GoPhish
	 - Resource Group: GoPhish_rg
	 - Size: Standard DS1_v2 (1 vCPU, 3.5 GB RAM).
	 - Region: Choose a nearby region.
	 - OS: Select a basic OS image (Windows or Linux).
	 - Networking: Default VNet, subnet, and public IP. (Allow inbound rules for port, 22,80,443,3333,1025,8025).
	 - Authentication: Password (Windows) or SSH key (Linux).

### 2. **Set Up Azure Virtual Machine to run as web host**

   - **Set Up Azure Active Directory (Azure AD):**
     - Go to **Create Resource** and then **Create Virtual Machine**.
	 - Name: web-host
	 - Resource Group: same group as GoPhish VM.
	 - Size: Standard DS1_v2 (1 vCPU, 3.5 GB RAM).
	 - Region: Choose a nearby region.
	 - OS: Select a basic OS image (Windows or Linux).
	 - Networking: Default VNet, subnet, and public IP. (Allow inbound rules for port, 22,80,443).
	 - Authentication: Password (Windows) or SSH key (Linux).

### 3. **Set up web host**
   
   - **Connect to your Azure web-host VM**
     - SSH into your Virtual Machine.

   - **Run web_setup script from GoPhishDemo repository**
	 - In your home directory, create a script. (e.g. nano setup.sh).
     - Copy web_setup.sh script from [el1s3k GitHub page](https://github.com/el1s3k/GoPhishDemo).
     - Paste into your script (e.g. nano setup.sh) and save it. 
	 - Change the permissions of the script to be executable. (e.g. chmod +x setup.sh).
	 - Run script. (./setup.sh)
	 
   - **VM IP prompt**
	 - The script would prompt to input VM localhost IP.

   - **Verify DemoNET web page is hosted**
	 - Go to http://localhost_ip. (e.g. http://111.111.111.111).
	
### 4. **Set up GoPhish and MailHog**
   
   - **Connect to your Azure GoPhish VM**
     - SSH into your Virtual Machine.

   - **Run phish_setup script from GoPhishDemo repository**
	 - In your home directory, create a script. (e.g. nano setup.sh).
     - Copy phish_setup.sh script from [el1s3k GitHub page](https://github.com/el1s3k/GoPhishDemo).
     - Paste into your script (e.g. nano setup.sh) and save it. 
	 - Change the permissions of the script to be executable. (e.g. chmod +x setup.sh).
	 - Run script. (./setup.sh)
	 
   - **GoPhish prompt**
	 - The script would prompt to input download link for GoPhish [GoPhish GitHub page](https://github.com/gophish/gophish/releases/download/v0.12.1/gophish-v0.12.1-linux-64bit.zip).

   - **MailHog prompt**
	 - The script would prompt to input download link for MailHog [MailHog GitHub page](https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64).

### 3. **Run GoPhish and MailHog**

   - **Create screen sessions**
	 - GoPhish and MailHog would need to run simultaneously. Use screen sessions to do so.
	 - Use command screen -S <name of session> to create a new session. (screen -S mailhog)
	 
   - **Run MailHog**	
	 - Navigate to ~/mailhog and Mailhog script. (cd ~/mailhog) (sudo ./Mailhog_linux_amd64).
	 - **By default MailHog uses port: 8025 for it's web interface and port: 1025 for SMTP**
	 - Access MailHog web interface using local host ip and port. (e.g. http://111.111.111.111:8025)
	 
   - **Detach from mailhog session**
     - Use command ctrl+a then press d.
	 
   - **Run GoPhish**
	 - Navigate to ~/gophish and run gophish script. (cd ~/gophish) (sudo ./gophish)
	 - **GoPhish would generate default username admin and default password string**
	 - **By default GoPhish uses port: 3333 for it's web interface and port: 80 web page**
	 - Access GoPhish web interface using local host ip and port. (e.g. https://111.111.111.111:3333)
	 - Login to the web interface using default credentials and change password.
	 
	**DO NOT FORGET TO SET ALLOW INBOUND RULES FOR PORTS 3333, 1025, and 8025 on your VM to access web interfaces**

### 4. **Design and Launch the Campaign**
   Now you are ready to design the phishing campaign and launch it.

   - **Create user/group:**
     - You can import an email list using .csv file or manually.

   - **Configure the Email Template:**
     - Go to **Email Templates** and either choose an existing template or create a new one.
     - For a realistic simulation, customize the template to reflect a legitimate-looking email, such as a password reset request or security warning.

   - **Configure the Landing Page:**
     - Select or create a landing page that simulates a login page or form that would capture user credentials.

   - **Configure the Sending Profiles:**
     - Go to **Sending Profiles**.

   - **Create a New Phishing Campaign:**
     - Go to the **Campaigns** tab in GoPhish and click on **New Campaign**.
     - Fill in the **Campaign Name**, **Email Subject**, and **Email Body**. You can design a realistic email using GoPhish’s email editor.
     - Choose the **Landing Page** that simulates a phishing site. GoPhish provides templates, or you can create your own landing page.
     - Select the **Group** you created.

### 5. **Launch the Simulation**
   - Click **Launch Campaign** in GoPhish.
   - Monitor the campaign for how many users open the email, click the link, and submit information on the landing page.

### 6. **Monitor and Analyze Results**
   - After the simulation is launched, GoPhish provides a dashboard to track the results.
   - You can see metrics such as:
     - Number of emails delivered.
     - Number of users who clicked on the phishing link.
     - Number of users who submitted their credentials.

   - Analyze the results and generate reports to share with your security team for further action.

### 7. **Report and Remediation**
   After the campaign concludes:
   - Create a report of the results within GoPhish and export it.
   - Identify areas where users fell for the phishing attack and provide training or remediation for those users to prevent future incidents.

### 8. **Configure Google App Pass Integration (Optional for testing using gmail smtp)
   To use Google App Pass (or Google Workspace) for sending phishing emails, you need to set up OAuth2 credentials.

   - **Create App Password:**
     - Login to your google acccount and make sure 2FA is enabled.
     - Navigate to App Passwords and create an app password for GoPhish.
     - A password string would be generated, copy and save it for GoPhish Sender Profile Configuration.

   - **Configure GoPhish with Google App Pass:**
     - Open GoPhish and navigate to `Sending Profiles`.
     - For username enter your google account and for password enter the **app password string** not your google account password.
     - For smtp enter smtp.gmail.com:465

---

## Conclusion
With GoPhish, Azure, and MailHog you can effectively simulate phishing attacks to help identify security awareness gaps within your organization. 
By following the steps above, you can create realistic phishing campaigns to test employee awareness and readiness against phishing attempts.
Make sure to ***follow ethical guidelines*** when running simulations and ***inform*** the relevant teams within your organization before conducting a phishing campaign. 


---

## References
- [GoPhish Official Documentation](https://github.com/gophish/gophish)
- [Google App Password support thread](https://support.google.com/accounts/answer/185833?hl=en)
- [MailHog Official Documentation](https://github.com/mailhog/MailHog)
- [Microsoft Azure](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-azure)
