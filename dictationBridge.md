# Get That Dictation Going: an introduction to DictationBridge

## Meet DictationBridge

Welcome to DictationBridge, a screen reader extension that allows you to use your computer  by talking to it. With DictationBridge, a screen reader of your choice and a speech-recognition  software of your choice, you will discover how enjoyable it is to dictate emails, surf the web, keep in touch with friends, write professional documents in your job and other possibilities.

### What is dictation?

Dictation allows you to "speak" to your computer. Simply put, dictation lets you write text, run programs, and perform tasks all by speaking to your computer.

So is dictation better than typing? It depends. There are people who prefer to type text on a keyboard, while some prefer to dictate via a microphone. One use case of dictation is if you need to rely on speaking to your computer because you cannot type well due to health issues.

So what do you need to dictate text? First, you need a microphone (a built-in or an external microphone), and a program that can understand what you are saying. This program is called speech-recognition software because it determines what you have said and then tells the computer what to do. For blind and visually impaired people, an additional program to read screen content, called a screen reader is essential. But how can all these - microphone, dictation software, and your screen reader - come together to help you speak to your computer effectively? This is where DictationBridge comes in.

### What is DictationBridge?

DictationBridge extends the capabilities of your screen reader by allowing it to read information from your dictation software. This means that as you speak to your computer, your computer will talk back to you in real-time. In some configurations, DictationBridge also allows you to command your screen reader using your Dictation software. Because DictationBridge is running as an add on, you won’t need to start a program each time you wish to use it. It will simply run in the background each time you launch your screen reader, and bridge the gap between your screen reader and dictation software.

### Feature highlights

* Echo back of dictated text in Dragon and Windows Speech Recognition (WSR).
* Speech only support of the WSR correction box.
* Support to control NVDA from Dragon and WSR.
* A verbal notification of the microphone status when using Dragon. WSR has this feature built-in therefore no support needs to be created.
* Command NVDA by voice from Dragon or WSR.

And much more.

Note: DictationBridge does not control the quality of your dictation. If you are getting errors in the text you dictate, or your dictation software isn’t picking up your commands, you’ll need to look at factors like training your dictation software, and the placement and quality of your microphone. See the tips section for helpful tips when dictating text and performing other speech commands.

### The people behind DictationBridg

DictationBridge was made possible thanks to the work of Lucy Greco, Pranav Lal, Matt Campbell, Chris Hofstader, Derek Riemer, San Francisco lighthouse for the Blind and Visually Impaired and countless supporters. See the contributions section for a full list of sponsors and people who made this project possible.

Copyright and license notice: DictationBridge is copyright 2016-2018 Three Mouse Technologies, inc and project contributors, released under GPL version 2. DictationBridge documentation is licensed under Creative Commons 3 license with attributions section included (see https://creativecommons.org/licenses/by/3.0/us/ for details). Microsoft Windows, Windows API and Windows Speech recognition are copyright Microsoft Corporation. Dragon (formerly Dragon Naturally Speaking) suite is copyright Nuance Communications, inc. NonVisual desktop Access (NVDA) is copyright 2006-2018 NV Access Limited. JAWS for Windows is copyright 1995-2018 Freedom Scientific, LLC (part of VFO since 2016).

### We want to hear from you

We at the DictationBridge project believe that user feedback is essential when it comes to making the product better. If you have issues, or would like to suggest something for a future version of DictationBridge, you are more than welcome to send us feedback using methods outlined in contact information section at the end of this guide.

Note: due to the different terms used to refer to  screen reader extensions, this guide will refer to both NVDA add-ons and JAWS scripts as "scripts".

The rest of this guide will explain how to get up and running with DictationBridge, how to use it, and some tips and tricks for maximizing the performance of the powerful software combination that is DictationBridge, your screen reader, and your Dictation solution.

## Install and get ready to dictate

Before you can dictate and perform commands with help from DictationBridge, you need to make sure your computer meets the requirements listed below, as well as install needed software such as screen readers, dictation software, and of course, DictationBridge.

### What it takes to use DictationBridge

* A computer running Windows 7, 8, 8.1 or 10, including server versions.
* A microphone (built-in or external, including USB, Bluetooth and others). An external microphone coupled with an external sound card is best for maximizing recognition accuracy.
* A sound output device (such as speakers, wired or wireless headsets and so on).
* A screen reader of your choice (at the time of this writing, DictationBridge supports NVDA 2017.4 and JAWS 17 or any later versions of these screen readers).
* A speech-recognition  solution  (Windows Speech Recognition or Dragon version 15 or higher).

### Installing screen readers

* JAWS for Windows: Visit [Freedom Scientific website](http://www.freedomscientific.com) to download a copy of latest version of JAWS.
* NVDA: Visit [NV Access website](http://www.nvaccess.org) to download the latest version of NVDA.

### Installing DictationBridge

To download the latest version of DictationBridge, visit the [DictationBridge website](http://www.dictationbridge.com) and select the download link. Be sure to download the appropriate installer for your screen reader (JAWS or NVDA). After downloading the appropriate installer for your screen reader, follow the installation instructions for the screen reader of your choice.

For JAWS for Windows:

1. Navigate to where you have saved the DictationBridge installer and press ENTER on the installer.
2. Choose the installer language and press ENTER on the button titled "OK".
3. Once the introductory screen opens, press ENTER on the Next button.
4. Choose the installation method. You can choose between "full" (scripts and documentation and can be uninstalled from Programs and Features), "just scripts", and "custom". After making a choice, press ENTER on the Next button.
5. Select the JAWS version and language you are using, then select where you'd like DictationBridge to be installed (current user or for all users). For JAWS version/language, check the version you want to use by checking the relevant checkbox. After making your choice, press ENTER on the Next button.
6. You are now asked to select the folder where DictationBridge should be installed. You can accept the default or specify a different location by typing the path or browsing to a folder. Once you make a choice, press ENTER on the Next button.
7. Review the choices you have  made so far during the installation, then press ENTER on the Install button.
8. After a few moments, the installation will complete, at which point you can press ENTER on the Finish button. Be sure to restart JAWS.

For NvDA installed on your computer:

1. Navigate to where you have saved the DictationBridge installer (an NVDA add-on with a .nvda-addon extension) and press ENTER on the installer.
2. Say "yes" if NVDA asks if you would like to install the add-on.
3. If you are upgrading from a prior version of DictationBridge, NVDA will ask if you would like to upgrade. Say "yes".
4. After a few moments NVDA will ask you to restart. Select "yes" to restart NVDA.

For a portable version of NVDA:

1. Press NVDA+N to open the NVDA menu. By default, the NVDA key is the numpad or extended insert key.
2. Select Tools, then Manage Add-ons.
3. From the Add-ons Manager, select "install", then navigate to the location where you have saved the DictationBridge add-on file and press ENTER.
4. Say "yes" if NVDA asks if you would like to install the add-on,
5. If upgrading from a prior version of the add-on, say "yes".
6. After a few moments, you'll be returned to the Add-ons Manager. Press Escape to close this window, then say "yes" if asked to restart NVDA.

Once installed, a new menu item under NVDA menu/Tools will be added that is used to copy files needed to perform NVDA commands via Dragon.

### Installing and enabling speech-recognition software

DictationBridge supports Windows Speech Recognition and Dragon (formerly called Dragon Naturally Speaking).

Follow these steps to enable Windows Speech Recognition (WSR):

1. Press Windows key to \open the  Start menu (Start screen in Windows 8 and 8.1).
2. Enter "speech recognition", and select "Windows Speech Recognition" from the dsearch results and press ENTER. The setup window opens.
3. Once in the Setup Speech Recognition window, press ENTER on the "Next" button.
4. Select the type of the microphone you will use and select "Next".
5. After reviewing the instruction screen, select "next".
6. If you speak English, dictate the following phrase: "Peter dictates to his computer. He prefers it to typing, and particularly prefers it to pen and paper." Note that you'll be asked to dictate a different phrase for languages other than English.
7. If everything is okay, the Setup window will present the completion screen where you can exit the setup process or continue with training.
8. To control microphone status and perform other WSR management functions, press Windows+B to go to the notification area (also known as the system tray), select Speech Recognition entry, press Applications key and select the item you want.

For Dragon:

1. Purchase and download Dragon. A customized downloader for your serial number will be generated.
2. Locate the downloader and press ENTER to begin the setup download.
3. Once the download completes, you'll be greeted with a setup screen. Press ENTER on Next button. In case you are using programs such as Microsoft Outlook, you'll need to exit them before continuing.
4. Review the license information and select "I accept" radio button and press ENTER on Next.
5. Enter your user name, organization (optional), and enter the serial number and press ENTER on the Next button.
Note:
You may not be able to copy and paste the serial number into the Dragon setup program. You will have to enter it manually. The serial number is a long string of characters separated by dashes. You will have to enter each set of characters into its own edit box.
6. Select the region to be used for dictation and text-to-speech. If you speak English, choose the region you live in or "All English regions". Also, if you want to choose installation folder and other options, check "Advanced" checkbox. After making a selection, press ENTER on Next button.
7. If you did not check the  "Advanced" checkbox, you're now asked to install Dragon, otherwise you are asked to select where Dragon should be installed. If so, choose the folder, then press ENTER on Next button, then press ENTER on Install button.
8. After a few moments the completion screen will be displayed. Press ENTER on the Finish button.

### Preparing DictationBridge and dictation software to work together

Once the speech-recognition software is installed, follow the below steps to let DictationBridge work with it.

For Windows Speech recognition: For the best experience, set Windows Speech Recognition to sleep rather then turn off when you say, "stop listening" or "go to sleep".

For Dragon: Configure Dragon to display the  Dragon Bar icon on the system tray, enable screen reader  menus and use of the word "click" for clicking and HTML elements, and to use the  spelling box if you need to correct a mistake. Also, it is recommended that you configure a profile. Follow steps in feature overview chapter for details.

Congratulations! You are now ready to dictate to your computer using DictationBridge, your screen reader, and a dictation software. If you want to get going with it, be sure to read the quick start guide (the next section). If you want to learn more about some additional features, browse the "DictationBridge Overview" section later in this guide. If you need advanced functionality such as entering custom commands for Dragon, check out "Advanced Topics" section. Have questions about DictationBridge features discussed in this guide? Don't forget to check out "Frequently Asked Questions" section. Let's get going with dictation!

## Tasting DictationBridge: a quick start guide

If you want to get a hands-on introduction to DictationBridge, or want a taste of what DictationBridge can do for you, don't skip this section. We will help you get started with DictationBridge by going through some tasks with you, including how to start a program, write a simple document, correcting a spelling mistake and so on.

### Some tips regarding dictation

* Think of speech-recognition  software as a friend. Just as you can know about your friend by talking, speech-recognition  software wil understand you better if you use it more.
* For improved accuracy, we recommend going through additional training sessions with the dictation software of your choosing.
* Speak clearly.
* If you are dictating text into documents, be sure to hear what the screen reader reads so you can catch mistakes and correct them.

### Listen to me

To start dictating text or issuing commands via voice, you need to tell your speech-recognition  software to listen to you. This can be done by saying, "listen to me" or "start listening". If you want the dictation software to stop listening to you, you can say, "go to sleep" or "stop listening".

### start a program

To start a program, say, "start program". For example, to start Notepad, say, "start Notepad".

### Dictating text

If you want to dictate text, open a program such as Notepad and start speaking what you want written. For example, say, "start Notepad", then once Notepad opens, say, "Testing comma, one comma, two comma, three". The screen reader should say, "Testing, one, two, three".

#### Entering punctuation and starting new lines

You may have noticed that the example  text above includes the word "comma". This is necessary so you can enter punctuations such as commas, full stops, parentheses and so on. For example, if you want to insert a period (.), say, "full stop" or "period". When you want to start a new paragraph, say, "new paragraph", and the appropriate paragraph marker will be inserted into the document.
Note:
The words that you say to insert punctuations into your document very by region. If you use British English, the you are more likely to use the word "full stop" to insert a period symbol. However, if you have US English set as a language, then you are more likely to say "period" to insert the period punctuation mark.
### Correcting mis recognized text

Sometimes,  the speech-recognition program may make a mistake and recognize what you have said incorrectly. If you do spot mistakes, move the cursor to the mistake, then say, "correct that". A list of suggestions will appear, and listen to the suggestions carefully. Say the number that corresponds to the intended word, then confirm your selection (typically by saying, "OK"). The word will be corrected.

### Click something

Still in Notepad, once you are happy with your dictated text, say, "click File", then say, "Save". The "Save as" dialog will be shown. Alternatively, you can say, "click File", then say, "Exit". If Notepad offers to save the file, either say "save" or "don't save".

### Press keyboard keys

If you need to press a keyboard combination via voice, you can say, "press key combination" where key combination refers to the keys you want to press. For example, to open Run dialog, say, "press Windows R".

### Screen reader commands

You can perform certain screen reader commands with your chosen dictation software. See the advanced topics section for details on steps for supported dictation software.

Once the dictation software is prepared, you can say phrases such as, "current time" or "open JAWS menu". See screen reader voice commands section in overview section for commands for each screen reader.

This is just a taste of what DictationBridge, dictation software, and your screen reader can do. The next section will tell you all about features of DictationBridge, including dictating punctuation, performing tasks such as writing and replying to emails and browsing the web, and performing screen reader commands via voice.

## Using DictationBridge

This section delves deeper into dictationBridge.

### Starting and stopping DictationBridge

DictationBridge is a script for your screen reader; therefore, it will start or stop when you run or quit your  screen reader, respectivley. For example, if you want to control your computer after you log onto the computer, go to the  settings area of your screen reader (Settings Center in JAWS, for example) and ask your screen reader to start after you log onto the computer. Also, you need to tell the dictation software to also come up when you log onto the computer. Once you follow these steps and next time you log on, your computer will be ready to listen to you.

#### For NVDA users: disabling DictationBridge for a while

If you are using recent versions of NVDA, you can temporarily stop DictationBridge from starting when NVDA starts. This can be done in two ways: via NVDA's exit dialog and choosing "Restart with add-ons disabled" or disabling DictationBridge add-on altogether from Add-ons Manager (NVDA 2016.3 or later). If you used Add-ons Manager method, be sure to enable DictationBridge when you are ready to use it. Note that you'll need to restart NVDA in order to enable or disable DictationBridge from Add-ons Manager.

### Improving dictation accuracy

It is important to correct misrecognitions and to ensure that the speech-recognition software learns correctly from your corrections. The procedures for doing this very between Windows speech-recognition and Dragon. In general, if an error occurs, do your best to correct it via speech. That is, use speech commands to navigate to the error and then use the speech-recognition program's correction facilities to fix the error. This allows the speech-recognition to track the correction. 

You can also use extra  training features  provided by the dictation software to improve dictation accuracy:

* Windows Speech Recognition: After you go through speech first setup steps, go to speech tutorial and go through additional training.
* Dragon: you can use training dialogs in Dragon 14 and earlier to practice dictating text and thus allow it to become accustomed to your speaking style. This is done by training a voice profile so Dragon can understand you better. See the next section on how to do this.

#### For Dragon 14 and earlier: training a profile

Load Dragon and (unless you already have a profile established) you will be prompted to create a new user profile. Give your profile a name consisting of one word which will serve to remind you of exactly which profile it is in case you have more than one. Tab to and activate the Next button. 

You will then go through a series of dialogs requesting information about you and your speech characteristics. Provide the information requested in each dialog, Tab to Next and press Enter.

Once all information has been provided a dialog will appear displaying all the information you have provided. If the information is correct activate the control to create your profile. 

Once the profile is created a dialog will appear providing information about positioning the microphone. Once the microphone is properly positioned activate the Next button. 

The next two dialogs require you to speak into the microphone. The first one checks the volume of your speech. Activate the Start Volume Check button and speak whatever you like. You can count to ten and that might be sufficient. If you count to ten and Dragon has not indicated that the volume is sufficient count to ten again and repeat until a ding is heard. If Dragon indicates you can go to the next step activate the Next button. 

This will bring you to the quality check.  In the quality check Dragon is listening for background noise in your environment. Again, you can say whatever you like during the quality check but leave small amounts of silence between whatever words you speak. If all goes well you will hear a ding and a dialog will appear indicating you can go to the next step in the training process. Do this by activating the Next button

### Dictating commands and text

You can dictate commands and text. You can perform commands such as opening programs ("Start something"), click somewhere ("click someplace"), press a keyboard key ("press Windows key" or "press Alt+F4"), and if configured correctly, perform screen reader commands ("JAWS window" or "current focus").

For text dictation in places such as word processors and the like, speak to your computer. For example, if you say the words, "this is a test", whatever you say will be entered into a document. Be sure to listen to what the screen reader says and correct mistakes if any.

#### Hear what you said

When you dictate text, DictationBridge will ask the screen reader to echo back or read what you said as text is entered. For example, when you type the words, "this is a test", JAWS and NVDA will say, "this is a test". When you insert a new line or a new paragraph, JAWS and NVDA will say, "new line" or "new paragraph", and the cursor will move as well.

#### Dictating punctuation

Suppose you want to type the words, "testing, one, two, three". Unless you dictate punctuation, the dictation software will see that you tried to write "testing one two three". In order to insert punctuation, you need to say, "testing comma one comma two comma three" so commas (,) can be entered. Use the screen reader's settings to set how much punctuation your screen reader announces.

Note: in Dragon, a setting is available to guess the punctuation  you want to enter by keeping watch of how much you pause. If this setting is enabled, you don't have to enter punctuation marks when you dictate text.

Following are common punctuation marks and their dictation equivalents:

* Period (.): period or full stop
* Comma (,): comma
* Exclamation (!): Exclaim
* Elipsis (...): elipsis
* Opening and closeing parentheses: open paren, close paren
* Quotation mark ("): quote or quotation
* Colon (:): colon

See the manual for your dictation software for more information on entering punctuation.

### Screen reader commands

You can use DictationBridge coupled with windows speech-recognition or Dragon  to perform screen reader commands such as reading the window  title, web browsing commands like "next heading" etc.

#### Windows Speech Recognition

To configure Windows Speech Recognition to accept screen reader commands, you need to install the WSR Macros utility, prepare the custom macros, and start speaking commands.

First, install the WSR Macros utility by visiting the [Windows Speech Recognition Macros download page](https://www.microsoft.com/en-us/download/details.aspx?id=13045), then follow the prompts from the web browser (say, pressing Alt+N in Internet Explorer) to open or save, then install the utility. When the installation is finished, a new folder named Speech Macros" will be created in your documents folder. If the folder does not exist, you need to create it manually before proceeding to the next step.

Next, prepare the macro file. Go to the NVDA menu, Tools, DictationBridge, then select an option that asks you to copy the macro file. Say yes when asked to confirm. If successful, a file named "dictationBridge.WSRMac" will be placed in your Documents folder under the "Speech Macros" subfolder.

Once the macro file is copied to the right location, you need to sign the newly copied macro file. Go to the system tray, locate the macros utility icon, then open the context menu, go to the option titled "Security" and select "Sign Speech Macros". If you are asked to create a new certificate, say "yes" to create a new certificate. Then, select the macro file, and answer "yes" when asked to create a certificate if you did not create a certificate before. After a few prompts and answering "yes" at a User Account Control prompt (if enabled), the certificate will be created and the macro file will be signed. You can then use Windows Speech Recognition to issue screen reader commands.)

Also, to add custom commands, open the macro file and enter the following exactly as shown:

	<listenFor>what you want the screen reader to do</listenFor>

Once you add custom commands, go through the steps above and sign the macro file once again. You will need to create a new certificate. You will need to create a new certificate each time you modify the dictationBridge macro file.

#### Dragon

To configure Dragon to accept screen reader commands, you need to allow Dragon to find the commands file. This can be done automatically or manually.

For NVDA users, this can be done by going to the NVDA menu, Tools, then selecting the option titled "Install Dragon commands" item. When asked to confirm, say Yes, then if User Account Control appears, say Yes to continue. Note that you need to restart NVDA before issuing NvDA commands.

For JAWS users, locate the Dragon commands XML file, then copy it to the Dragon installation folder (typically sysdrive\Program Files (or Program Files (x86) on 64-bit systems)\Nuance\Dragon).

#### JAWS dictation commands

Following are JAWS commands available via DictationBridge:

| Function | Keyboard command | Say this |
| ------ | ------- | ------- |
| Open JAWS window or interface | JAWS Key+J | JAWS window |

#### NVDA dictation commands

Following are NVDA commands available via DictationBridge:

| Function | Keyboard command | Say this |
| ------ | ------- | ------- |
| Open NVDA menu | NvDA+N | NVDA menu |
| Input help mode | NvDA+1 | Input help|
| Toggle speak typed characters | NVDA+2 | Toggle speaking typed characters |
| Toggle speak typed words | NVDA+3 | Toggle speaking typed words |
| Toggle speak command keys | NVDA+4 | Toggle speaking command keys |
| Toggle report dynamic content changes | NVDA+5 | Toggle speaking screen content changes |
| Current time | NvDA+F12 | What is the time |
| Current date | NvDA+F12 twice quickly | What is the date |
| Battery status | NVDA+Shift+B | Battery status |
| Title | NvDA+T | Title |
| Status bar | NVDA+End (NVDA+Shift+End in laptop layout) | Say status bar |
| Command passthrough | NVDA+F2 | Send keystroke to program |
| Application module information | Control+NVDA+F1 | App information |
| Toggle sleep mode \ NVDA+Shift+S (NVDA+Shift+Z in laptop layout) | Toggle sleep mode |
| Announce selected text if any | NVDA+Shift+Up arrow (NVDA+Shift+S in laptop layout) | Say selection |
| Say all (for texts and others where you can use cursor keys to navigate) | NVDA+Down arrow (NVDA+A in laptop layout) | Say all |
| Announce focused control | NVDA+Tab | Speak focus |
| Announce navigator object | NVDA+Numpad 5 (NVDA+Shift+O in laptop layout) | Current navigator object |
| Navigator object location | NvDA+Numpad delete (NVDA+Delete in laptop layout) | Where is navigator object |
| Switch navigator object to system focus | NVDA+Numpad minus (NVDA+Backspace in laptop layout) | Move to focused object |
| Move system focus to navigator object | NVDA+Shift+Numpad minus (NVDA+Shift+Backspace in laptop layout) | Focus to navigator object |
| Move to next object | NVDA+Numpad 6 (NVDA+Shift+Right arrow in laptop layout) | Next object |
| Move to previous object | NVDA+Numpad 4 (NVDA+Shift+Left arrow in laptop layout) | Previous object |
| Move inside a child object (for example, inside lists) | NVDA+Numpad 2 (NVDA+Shift+Down arrow in laptop layout) | First child object |
| Move to the parent object (for example, moving from list items to the list) | NVDA+Numpad 8 (NVDA+Shift+Up arrow in laptop layout) | Parent object |
| Activate object (for example, clicking) | NVDA+Numpad Enter (NVDA+Enter in laptop layout) | Activate object |
| Review start of text via review cursor | Shift+Numpad 7 (NVDA+Control+Home in laptop layout) | Review text start |
| Review end of text via review cursor | Shift+Numpad 9 (NVDA+Control+End in laptop layout) | End of review text |
| Previous line via review cursor | Numpad 7 (NVDA+Up arrow in laptop layout ) | Review previous line |
| Current line via review cursor | Numpad 8 (NVDA+Shift+Period (.) in laptop layout) | Speak review line |
| Next line via review cursor | Numpad 9 (NVDA+Down arrow in laptop layout ) | Review next line |
| Previous word via review cursor | Numpad 4 (NVDA+Control+Left arrow in laptop layout ) | Review previous word |
| Current word via review cursor | Numpad 5 (NVDA+Control+Period (.) in laptop layout) | Speak review word |
| Next word via review cursor | Numpad 6 (NVDA+Control+Right arrow in laptop layout ) | Review next word |
| Previous character via review cursor | Numpad 1 (NVDA+Left arrow in laptop layout ) | Review previous character |
| Current character via review cursor | Numpad 2 (NVDA+Period (.) in laptop layout) | Speak review character |
| Next character via review cursor | Numpad 3 (NVDA+Right arrow in laptop layout ) | Review next character |
| Start of line via review cursor | Shift+Numpad 1 (NVDA+Home in laptop layout) | Review start of line |
| End of line via review cursor | Shift+Numpad 3 (NVDA+End in laptop layout) | Review end of line |
| Review cursor selection start mark | NVDA+F9 | begin selection |
| Copy review cursor selection to clipboard | NVDA+F10 | copy review text |
| Say all via review cursor | Numpad plus (NVDA+Shift+A in laptop layout) | Review say all |
| Next review mode (i.e. switching from object review to screen review) | NVDA+Numpad 7 (NVDA+Page up in laptop layout)| Next review mode |
| Previous review mode (i.e. switching from screen review to object review) | NVDA+Numpad 1 (NVDA+Page down in laptop layout) | previous review mode |
| Toggle focus moves navigator object | NVDA+7 | Toggle navigator object follows focus |
| Toggle caret moves review cursor | NVDA+6 | Toggle review cursor follows caret | 
| Toggle mouse tracking | NvDA+M | Toggle mouse tracking |
| Move mouse pointer to navigator object | NVDA+Numpad divide (NVDA+Shift+M in laptop layout) | Move Mouse to navigator |
| Move navigator object to control under mouse pointer | NVDA+Numpad multiply (NVDA+Shift+N in laptop layout) | Move navigator to mouse |
| Left mouse button click | Numpad divide (NVDA+left bracket in laptop layout) | Left mouse click |
| Left mouse button lock/unlock | Shift+Numpad divide (NVDA+Control+Left bracket in laptop layout) | Toggle left mouse button lock |
| Right mouse button click | Numpad multiply (NVDA+right bracket in laptop layout) | Right mouse click |
| Right mouse button lock/unlock | Shift+Numpad multiply (NVDA+Control+Right bracket in laptop layout) | Toggle right mouse button lock |
| Open general settings dialog | NVDA+Control+G | Open general settings |
| Open synthesizer dialog | NVDA+Control+S | Open synthesizer settings |
| Open voice settings dialog | NVDA+Control+V | Open voice settings |
| Open keyboard settings dialog | NVDA+Control+K | Open keyboard settings |
| Open object presentation dialog | NVDA+Control+O | Open object presentation settings |
| Open browse mode dialog | NVDA+Control+B | Browse mode options |
| Edit configuration profiles | NVDA+Control+P | Edit profiles |
| Save configuration | NVDA+Control+C | Save configuration |
| Revert to saved configuration | NVDA+Control+R | Revert to saved settings |
| Toggle speech mode | NVDA+S | Toggle speech mode |
| Next synth settings ring setting | NVDA+Control+Right arrow (NVDA+Control+Shift+Right arrow in laptop layout) | Nexte synth setting |
| Toggle audio ducking | NVDA+Shift+D | Toggle speech ducking |
| Change braille tethering between focus and review cursor | NVDA+Control+T | Change braille tethering |
| Cycle through progress bar output options | NVDA+U | Toggle progress bar output |
| Toggle browse and focus modes in web browsers and alike | NVDA+Space | Toggle browse mode |
| Switch to browse mode document (e.g. moving away from a dialog to the web document) | NVDA+Control+Space | Switch to browse mode document |
| Begin interaction with math content | NVDA+Alt+M | Interact with math |
| Reload add-ons and other plugins including DictationBridge | NVDA+Control+F3 | reload plugins |

### Microphone status

As you dictate text and issue commands via voice, it is helpful to be notified about whether your microphone is active or not. DictationBridge will alert you of microphone changes if appropriate. For Windows Speech Recognition, a set of sounds will indicate whether the computer is listening to you, not listening, or sleeping (waiting to listen to you), and microphone status will be shown on the system tray. This is not the case for Dragon unless the Dragon Bar is present on the system tray, and for this, the screen reader will announce microphone status when it changes.

## Frequently asked questions

This section provides answers to frequently asked questions about DictationBridge, dictation in general and other topics not covered in this guide.

Q. How much does DictationBridge cost?

Absolutely free.

Q. Is the training dialog for Windows Speech Recognition accessible via speech and/or braille?

Yes, you can review the text to be dictated in the training dialog via speech.

Q. How can I check microphone status via Windows Speech Recognition?

Press Windows+B to go to the notification area. If Windows Speech Recognition is active, one of the items will be Windows Speech Recognition along with its status (listening, sleeping, off).

Q. I don't hear what I have  dictated.

This might be due to one of the following:

* DictationBridge is not installed.
* If using NVDA, the DictationBridge add-on might be disabled.
* Your microphone might be turned off or muted.
* In certain cases, text echo back will not work, and developers are working toward a solution.

Q. How can I correct spelling mistakes?

This procedure is dependent on your speech-recognition solution of choice. Please consult its documentation.

Q. How can I improve dictation accuracy?

Accuracy when dictating is a function of a number of things that are too extensive to go into here. In summary, consider the following points.
*Speak like a news caster.
* Your speech input to the speech-recognition solution must be clear and noise free.
*The words you use should be in the speech-recognition solution's vocavulary.
*You have trained the vocabulary, entering carefully chosen words.


Q. I cannot seem to insert punctuations as I dictate.

You need to tell the dictation software to insert punctuation such as periods (full stop), commas and others by dictating the punctuation name. For example, to insert a period, end the dictating phrase with the words, "full stop" e.g. "hello full stop" to have the text "hello." inserted into the document. See the section, "inserting punctuation" in the Overview section for a complete list of common punctuations and their dictation forms, or consult the documentation for WSR or Dragon for punctuations and equivalent dictation forms.

Q. How can I start a new paragraph?

Say, "new paragraph". See the section, "dictating text instructions" in Overview section for details, or consult WSR or Dragon manuals for a complete list of phrases for inserting new paragraphs and such.

Q. I'm a user of Windows 10 and have enabled Cortana. Can Cortana help in dictating text?

Cortana is a personal digital assistant from Microsoft. At this time, Cortana cannot help you with lengthy dictation.

Q. Why is it that I cannot perform screen reader commands with Windows Speech Recognition?

Windows Speech Recognition does not have an easy to use way to add additional commands. This must be done by using what is called "WSR macros", a text file containing WSR commands and actions. See preparing the dictation software section under screen reader commands section for details.

Q. What should I do to use screen reader commands via Dragon?

You will need to ask DictationBridge to do this for you, or you can do this manually. See the preparation steps listed in "Dragon and screen reader commands" for details.

Q. How can I contribute to ongoing development of DictationBridge?

There are numerous ways you can help with development of DictationBridge:

* Reporting bugs and providing suggestions.
* Financial donations.
* Help with programming.
* Improving documentation.
* Translations.

## Credits and contact information

### How to contact the DictationBridge project

The DictationBridge project was made possible thanks to support from a community of users and organizations. If you have feedback regarding DictationBridge, or have suggestions to make it even better, please contact us using the below methods.

* Email: DictationBridge discussion list.
* Website: http://www.dictationbridge.com
* Social media links: @DictationBridge on Twitter
* GitHub: https://github.com/dictationbridge

### The team behind DictationBridge

* Project visionary: Lucia "Lucy" Greco (University of California, Berkeley)
* Project champion and community relations: Chris Hofstader
* DictationBridge core: Matthew Campbell (3 Mouse Technologies, SeroTech and Microsoft)
* DictationBridge NVDA add-on: Pranav Lal, Derek Riemer
* dictationBridge project manager: Pranav Lal
* DictationBridge JAWS scripts: Austin Hicks, Sean Pharaoh, Tim Burgess
* Website coordinator: Amanda Rush
* Documentation: Erin Lauridsen, Sue Martin, Joseph Lee

### Sponsors

The DictationBridge project would like to thank the following individuals and organizations for sponsoring this project:

* Lighthouse for the Blind and Visually Impaired of San Francisco
* Abdulaziz Alshmasi
* Patrick Kelly
